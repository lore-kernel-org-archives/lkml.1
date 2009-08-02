Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZHBUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZHBUI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZHBUI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:08:56 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:48894 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbZHBUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:08:55 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 16:08:55 EDT
X-IronPort-AV: E=Sophos;i="4.43,309,1246831200"; 
   d="scan'208";a="33946476"
Message-ID: <4A75F00D.7010400@inria.fr>
Date: Sun, 02 Aug 2009 21:59:09 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jsquyres@cisco.com, rostedt@goodmis.org
Subject: Re: [PATCH v3] ummunotify: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>	<20090722111538.58a126e3.akpm@linux-foundation.org>	<adad47smsb5.fsf@cisco.com>	<20090722124208.97d7d9d7.akpm@linux-foundation.org>	<adaeis53d2m.fsf_-_@cisco.com>	<20090727165329.4acfda1c.akpm@linux-foundation.org>	<adaws5szswf.fsf@cisco.com> <adaskgcptsz.fsf_-_@cisco.com>
In-Reply-To: <adaskgcptsz.fsf_-_@cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
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

Hello Roland,

I like the interface but I have a couple questions:

1) Why does userspace have to register these address ranges? I would
have just reported all invalidation evens and let user-space check which
ones are interesting. My feeling is that the number of invalidation
events will usually be lower than the number registered ranges, so
you'll report more events through the file descriptor, but userspace
will do a lot less ioctls.

2) What happens in case of fork? If father+child keep reading from the
previously-open /dev/ummunotify, each event will be delivered only to
the first reader, right? Fork is always a mess in HPC, but maybe there's
something to do here.

3) What's userspace supposed to do if 2 libraries need such events in
the same process? Should each of them open /dev/ummunotify separately?
Doesn't matter much for performance, just wondering.

thanks,
Brice

