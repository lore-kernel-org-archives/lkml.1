Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZA0Uxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZA0Uxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZA0Uxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:53:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbZA0Uxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:53:41 -0500
Date: Tue, 27 Jan 2009 12:52:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: hannes@cmpxchg.org, davej@redhat.com, rjw@sisk.pl, hannes@saeurebad.de,
       krzysztof.h1@wp.pl, harvey.harrison@gmail.com,
       stefanr@s5r6.in-berlin.de, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH] fbmem: copy_from/to_user() with mutex held (v3)
Message-Id: <20090127125255.ea9c0d40.akpm@linux-foundation.org>
In-Reply-To: <1232443676-7037-1-git-send-email-righi.andrea@gmail.com>
References: <1232443676-7037-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 10:27:56 +0100
Andrea Righi <righi.andrea@gmail.com> wrote:

> Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
> ioctl().
> 
> fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
> fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
> copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
> deadlock.
> 
> NOTE: it doesn't push down the fb_info->lock in each own driver's
> fb_ioctl(), so there're still potential deadlocks somewhere.
> 

Looks good to me.

> ...
>
>  static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> -__acquires(&info->lock)
> -__releases(&info->lock)

Should the __acquires/__releases annotation be relocated to
do_fb_ioctl()?  I've never actually got down and understood those
things.


