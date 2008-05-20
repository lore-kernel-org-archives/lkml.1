Return-Path: <linux-kernel-owner+w=401wt.eu-S1765624AbYETMFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765624AbYETMFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbYETMFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:05:18 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:63025 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbYETMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:05:16 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [git pull] VFS patches 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080426020221.GF5882@ZenIV.linux.org.uk>
References: <20080426020221.GF5882@ZenIV.linux.org.uk>
Date: Tue, 20 May 2008 21:04:38 +0900
Message-ID: <13375.1211285078@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Al,

I have a question about the commit you made last month.
When an application issues sys_oldumount(), ->umount_begin() will not be
called because the flag is 0. Is this behaviour intended?
And it it better to put the paranthesis around (flags & MNT_FORCE).


Junjiro Okajima


Al Viro:
> 	Tonight's pile: getting ->umount_begin() back to sanity, race fixes
> around execve(), general cleanups.  Please, pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
> 
> Shortlog:
> 
> Al Viro (5):
>       restore sane ->umount_begin() API
	:::
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 0505fb6..f48f981 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1061,10 +1061,11 @@ static int do_umount(struct vfsmount *mnt, int flags)
>  	 * about for the moment.
>  	 */
>  
> -	lock_kernel();
> -	if (sb->s_op->umount_begin)
> -		sb->s_op->umount_begin(mnt, flags);
> -	unlock_kernel();
> +	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
> +		lock_kernel();
> +		sb->s_op->umount_begin(sb);
> +		unlock_kernel();
> +	}
>  
>  	/*
>  	 * No sense to grab the lock for this test, but test itself looks
