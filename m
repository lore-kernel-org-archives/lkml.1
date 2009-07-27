Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbZG0Xxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbZG0Xxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZG0Xxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:53:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZG0Xxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:53:34 -0400
Date: Mon, 27 Jul 2009 16:53:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, jsquyres@cisco.com, rostedt@goodmis.org
Subject: Re: [PATCH v2] ummunotify: Userspace support for MMU notifications
Message-Id: <20090727165329.4acfda1c.akpm@linux-foundation.org>
In-Reply-To: <adaeis53d2m.fsf_-_@cisco.com>
References: <ada3a8oobis.fsf@cisco.com>
	<20090722111538.58a126e3.akpm@linux-foundation.org>
	<adad47smsb5.fsf@cisco.com>
	<20090722124208.97d7d9d7.akpm@linux-foundation.org>
	<adaeis53d2m.fsf_-_@cisco.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 15:56:17 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
> and follow-up messages, libraries using RDMA would like to track
> precisely when application code changes memory mapping via free(),
> munmap(), etc.  Current pure-userspace solutions using malloc hooks
> and other tricks are not robust, and the feeling among experts is that
> the issue is unfixable without kernel help.
> 
> We solve this not by implementing the full API proposed in the email
> linked above but rather with a simpler and more generic interface,
> which may be useful in other contexts.  Specifically, we implement a
> new character device driver, ummunotify, that creates a /dev/ummunotify
> node.  A userspace process can open this node read-only and use the fd
> as follows:
> 
>  1. ioctl() to register/unregister an address range to watch in the
>     kernel (cf struct ummunotify_register_ioctl in <linux/ummunotify.h>).
> 
>  2. read() to retrieve events generated when a mapping in a watched
>     address range is invalidated (cf struct ummunotify_event in
>     <linux/ummunotify.h>).  select()/poll()/epoll() and SIGIO are
>     handled for this IO.
> 
>  3. mmap() one page at offset 0 to map a kernel page that contains a
>     generation counter that is incremented each time an event is
>     generated.  This allows userspace to have a fast path that checks
>     that no events have occurred without a system call.
> 
> Thanks to Jason Gunthorpe <jgunthorpe@obsidianresearch.com> for
> suggestions on the interface design.  Also thanks to Jeff Squyres
> <jsquyres@cisco.com> for prototyping support for this in Open MPI, which
> helped find several bugs during development.
> 
> ...
>
> +config UMMUNOTIFY
> +       tristate "Userspace MMU notifications"
> +       select MMU_NOTIFIER
> +       help
> +         The ummunotify (userspace MMU notification) driver creates a
> +         character device that can be used by userspace libraries to
> +         get notifications when an application's memory mapping
> +         changed.  This is used, for example, by RDMA libraries to
> +         improve the reliability of memory registration caching, since
> +         the kernel's MMU notifications can be used to know precisely
> +         when to shoot down a cached registration.

Does `select' dtrt here if UMMUNOTIFY=m?  I never trust it...

<searches in vain for ummunotify.txt>

Oh well :(

A little test app would be nice - I assume you have one.  We could toss
in in the tree as a how-to-use example, and people could perhaps turn
it into a regression test - perhaps the LTP people would take it.

>
> ...
>
> +			if (test_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags)) {
> +				clear_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);
> +			} else {
> +				set_bit(UMMUNOTIFY_FLAG_HINT, &reg->flags);

It's a shame that change_bit() didn't return the old (or new) value.



The overall userspace interface seems a bit klunky, but I can't really
suggest anything better.  Netlink delivery?
