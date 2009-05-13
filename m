Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbZEMXJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbZEMXJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZEMXIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:08:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbZEMXIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:08:49 -0400
Date: Wed, 13 May 2009 16:08:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/1] fs: fix lock imbalance in do_remount_sb()
Message-Id: <20090513160820.981917ca.akpm@linux-foundation.org>
In-Reply-To: <1242242472-20598-1-git-send-email-jirislaby@gmail.com>
References: <1242242472-20598-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 21:21:12 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Commit "Push BKL down into do_remount_sb()" pushed un/lock_kernel
> into do_remount_sb but forgets to unlock it on fail paths. Fix
> that.
> 

argh, how many times must we teach ourselves this lesson?  Perhaps we
can convert this function to have a single `return' to prevent
relapses?

> ---
>  fs/super.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index e4a0c5b..a64f362 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -548,18 +548,24 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
>  		if (force)
>  			mark_files_ro(sb);
> -		else if (!fs_may_remount_ro(sb))
> +		else if (!fs_may_remount_ro(sb)) {
> +			unlock_kernel();
>  			return -EBUSY;
> +		}
>  		retval = vfs_dq_off(sb, 1);
> -		if (retval < 0 && retval != -ENOSYS)
> +		if (retval < 0 && retval != -ENOSYS) {
> +			unlock_kernel();
>  			return -EBUSY;

Strange that the code drops the vfs_dq_off() return value on the floor.
`man(2) mount' lists a great pile of possible errnos.

> +		}
>  	}
>  	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
>  
>  	if (sb->s_op->remount_fs) {
>  		retval = sb->s_op->remount_fs(sb, &flags, data);
> -		if (retval)
> +		if (retval) {
> +			unlock_kernel();
>  			return retval;
> +		}


>  	}
>  	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
>  	unlock_kernel();

