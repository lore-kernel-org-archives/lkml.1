Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZEQPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZEQPmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEQPlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:41:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42885 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZEQPls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:41:48 -0400
Subject: Re: [PATCH mmotm] fsnotify: don't slow everything down
From: Eric Paris <eparis@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0905171445290.18657@blonde.anvils>
References: <Pine.LNX.4.64.0905171445290.18657@blonde.anvils>
Content-Type: text/plain
Date: Sun, 17 May 2009 11:38:17 -0400
Message-Id: <1242574698.5212.35.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 14:52 +0100, Hugh Dickins wrote:
> Two little fixes to mmotm's fsnotify-parent-event-notification.patch:
> 
> Why is copying or building a kernel tree using twice as much system time
> as before?  Lots of time spent in __fsnotify_update_child_dentry_flags()
> when it shouldn't even get called.  Fix | to & in __fsnotify_parent().

I can't believe I didn't find that one in my testing, obviously it
doesn't hurt anything but performance.

> And it's probably a bad idea to have DCACHE_FSNOTIFY_PARENT_WATCHED
> sharing the same d_flags bit as DCACHE_COOKIE: though the COOKIE bit has
> prior claim, change it to keep the NOTIFY_PARENT_WATCHED bits together.

If people feel strongly I can come up with a system to reuse the inotify
flag now....  I planned on dropping the old inotify flag in a couple
releases when I finally evict inotify entirely, it would be a
performance hit, but I have a feeling a minimal one.  In any case, when
I push these patches along I'll probably move the new flag rather than
_COOKIE since long term they won't be 'together'

Acked-by: Eric Paris <eparis@redhat.com>


> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  fs/notify/fsnotify.c   |    2 +-
>  include/linux/dcache.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- mmotm/fs/notify/fsnotify.c	2009-05-14 11:27:38.000000000 +0100
> +++ linux/fs/notify/fsnotify.c	2009-05-17 13:31:23.000000000 +0100
> @@ -84,7 +84,7 @@ void __fsnotify_parent(struct dentry *de
>  	bool send = false;
>  	bool should_update_children = false;
>  
> -	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
> +	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
>  		return;
>  
>  	spin_lock(&dentry->d_lock);
> --- mmotm/include/linux/dcache.h	2009-05-14 11:27:39.000000000 +0100
> +++ linux/include/linux/dcache.h	2009-05-17 13:31:23.000000000 +0100
> @@ -183,7 +183,7 @@ d_iput:		no		no		no       yes
>  #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
>  #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0040 /* Parent inode is watched by some fsnotify listener */
>  
> -#define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
> +#define DCACHE_COOKIE		0x0080	/* For use by dcookie subsystem */
>  
>  extern spinlock_t dcache_lock;
>  extern seqlock_t rename_lock;

