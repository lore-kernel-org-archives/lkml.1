Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYEPNOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYEPNOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYEPNOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:14:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25692 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbYEPNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:14:01 -0400
Message-ID: <482D87B5.4090200@nokia.com>
Date: Fri, 16 May 2008 16:10:13 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH take 2] UBIFS - new flash file system
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <20080516104002.GA6962@infradead.org>
In-Reply-To: <20080516104002.GA6962@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 May 2008 13:13:54.0314 (UTC) FILETIME=[B0E83EA0:01C8B756]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.

Christoph Hellwig wrote:
> General comment:
> 
>  - not supporting a flash page size different from the system page
>    size is a horrible thing for people trying to use the same storage
>    on multiple systems.  For a block based filesystem that alone would
>    be enough reason not to merge it.  For a flash filesystem I'm not
>    entirely sure given that flash isn't moved between systems all that
>    often.

We are working on that.  It will be added next week probably.

> VFS/VM interaction comments:
> 
>  - splitting most of the mount code out to build.c is rather odd.
>    Most filesystems have this in super.c

We will get rid of build.c and move everything to super.c.

>  - calling convention for mount_ubifs is nasty because it doesn't
>    clean up it's own errors.  You might think it's easier to do
>    all that in ubifs_umount but beeing in the process of untangling
>    that mess for xfs I'd recomment against it.  Unless there's
>    a very good reason for it functions should always clean up
>    the resources they allocated in the error case.

Ok

>  - ubifs_get_sb would benefit from splitting out a ubifs_fill_super
>    routine that allocates a new sb when it's actually needed.

Ok

>  - why do you do the commit_on_unmount in your own ->shutdown_super
>    instead of the normal ->put_super?  If there's a good reason
>    this at least needs a big comment explaining why.

It is in ->shutdown_super to be outside BKL.  Will add comment.

>  - ubifs_lookup doesn't really need to use d_splice_alias unless
>    you want to support nfs exporting

Well we would like to support nfs one day, so maybe we could just
leave it?

>  - in ubifs_new_inode you inherit the inode flags from the parent.
>    This probably wants splitting out in a helper that documents
>    explicitly what flags are inherited and what not.  Given that
>    you store the general indoe flags settable by chattr in there
>    it seems like a bad idea to inherit them by default.

Ok

>  - the read dir implementation won't ever support nfs exporting
>    due to having to keep per open file state.  Nor would it support
>    thing like checkpoint and restart.

We could get rid of the per-open-file state if we could come up
with a scheme that would make fpos unique.  At the moment it is
not unique because it is the name hash, but we could perhaps
allocate a unique number to each colliding entry.  We will
think some more about this.

>  - just opencode you mmap routine, there's nothing helpful
>    in generic_file_mmap if you set your own vm_ops.

Ok

>  - ubifs_trunc should never be called on anything but a regular
>    file, so the check for it seems superflous.  Having it after
>    the S_ISREG is rather odd too even if you want to have
>    an assertation.

Ok

>  - please implement the unlocked_ioctl file operation instead of
>    the old ioctl operation that comes with the BKL locked.

Ok

> 
> Misc comments:
> 
>  - ubifs_bg_thread shouldn't set a nice level, especially when it's the
>    default one anyway.

Ok

>  - the mainoop of ubifs_bg_thread looks a bit odd either, when you
>    first to an interruotible sleep and then possible one while you
>    still have TASK_RUNNING set.  Also the need_bgt flag is not needed
>    because the thrad is only woken up to perform it's action.
>    In the end the main loop should look something like:
> 
> 	while (1) {
> 		if (kthread_should_stop())
> 			break;
> 		if (try_to_freeze())
> 			continue;
> 
> 		run_bg_commit(c);
> 
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		schedule();
> 		__set_current_state(TASK_RUNNING);
> 	}

Ok

> 
> 			
> 
> 
> Same comments on naming in the code:
> 
>  - bgt is not very descriptive for your kernel thread.  These are per
>    defintion in the background, so just call them thread or
>    <somethinginformative>_thread.  In this case it would probably
>    be commit_thread.

Ok

>  - any chance you could spell out journal instead of jrn?  jrn always
>    sounds like joern with the wovel eaten by a mailer.. :)

It is named after Jœrn not journal ;-)

How about jnl after Janelle? It uses the same number of characters.

