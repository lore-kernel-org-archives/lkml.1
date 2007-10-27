Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbXJ0IbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbXJ0IbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 04:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXJ0IbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 04:31:07 -0400
Received: from mx28.mail.ru ([194.67.23.67]:34739 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXJ0IbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 04:31:05 -0400
Date: Sat, 27 Oct 2007 12:30:11 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       satyam@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 106/327] ufs: Fix mount check in ufs_fill_super()
Message-ID: <20071027083011.GA21273@rain>
Mail-Followup-To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
	satyam@infradead.org, linux-kernel@vger.kernel.org
References: <200710170626.l9H6QrYD006747@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710170626.l9H6QrYD006747@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:26:53PM -0700, akpm@linux-foundation.org wrote:
> From: Satyam Sharma <satyam@infradead.org>
> 
> The current code skips the check to verify whether the filesystem was
> previously cleanly unmounted, if (flags & UFS_ST_MASK) == UFS_ST_44BSD or
> UFS_ST_OLD.  This looks like an inadvertent bug that slipped in due to
> parantheses in the compound conditional to me, especially given that
> ufs_get_fs_state() handles the UFS_ST_44BSD case perfectly well.  So, let's
> fix the compound condition appropriately.
> 

I wonder on what type of UFS do you test this patch?
NetBSD and FreeBSD do not use "fs_state", they use "fs_clean" flag,
only Solaris does check like this: fs_state + fs_time == FSOK.

That's why parentheses was like that.

At now with linux-2.6.24-rc1-git1, I get: fs need fsck,
but NetBSD's fsck says that's all ok.

I suggest revert this patch.

> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> Cc: Evgeniy Dushistov <dushistov@mail.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ufs/super.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff -puN fs/ufs/super.c~ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super fs/ufs/super.c
> --- a/fs/ufs/super.c~ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super
> +++ a/fs/ufs/super.c
> @@ -933,19 +933,20 @@ magic_found:
>  		goto again;
>  	}
>  
> -	sbi->s_flags = flags;/*after that line some functions use s_flags*/
> +	/* Set sbi->s_flags here, used by ufs_get_fs_state() below */
> +	sbi->s_flags = flags;
>  	ufs_print_super_stuff(sb, usb1, usb2, usb3);
>  
>  	/*
>  	 * Check, if file system was correctly unmounted.
>  	 * If not, make it read only.
>  	 */
> -	if (((flags & UFS_ST_MASK) == UFS_ST_44BSD) ||
> -	  ((flags & UFS_ST_MASK) == UFS_ST_OLD) ||
> -	  (((flags & UFS_ST_MASK) == UFS_ST_SUN || 
> -	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
> -	  (flags & UFS_ST_MASK) == UFS_ST_SUNx86) && 
> -	  (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time))))) {
> +	if ((((flags & UFS_ST_MASK) == UFS_ST_44BSD)	||
> +	     ((flags & UFS_ST_MASK) == UFS_ST_OLD)	||
> +	     ((flags & UFS_ST_MASK) == UFS_ST_SUN)	||
> +	     ((flags & UFS_ST_MASK) == UFS_ST_SUNOS)	||
> +	     ((flags & UFS_ST_MASK) == UFS_ST_SUNx86))	&&
> +	    (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time)))) {
>  		switch(usb1->fs_clean) {
>  		case UFS_FSCLEAN:
>  			UFSD("fs is clean\n");
> _

-- 
/Evgeniy

