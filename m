Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbXHTPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbXHTPRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbXHTPRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:17:45 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:50719 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbXHTPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:17:44 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Refine FAT chmod checks
References: <Pine.LNX.4.64.0708201500490.30570@fbirervta.pbzchgretzou.qr>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 21 Aug 2007 00:17:38 +0900
In-Reply-To: <Pine.LNX.4.64.0708201500490.30570@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Mon\, 20 Aug 2007 15\:03\:04 +0200 \(CEST\)")
Message-ID: <87ps1i6xrh.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> when a vfat filesystem is mounted without the quiet option, chown fails, 
> but chmod still succeeds. I think that is wrong.

Could you explain why this is wrong more?

Thanks.

> [fs/fat/]: Refine FAT chmod checks
>
> Prohibit mode changes in non-quiet mode that cannot be stored reliably
> with the on-disk format.
>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
> ---
>  fs/fat/file.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 43 insertions(+), 4 deletions(-)
>
> Index: linux-2.6.22/fs/fat/file.c
> ===================================================================
> --- linux-2.6.22.orig/fs/fat/file.c
> +++ linux-2.6.22/fs/fat/file.c
> @@ -155,6 +155,42 @@ out:
>  	return err;
>  }
>  
> +static int check_mode(const struct msdos_sb_info *sbi, mode_t mode)
> +{
> +	mode_t req = mode & ~S_IFMT;
> +
> +	/*
> +	 * Of the r and x bits, all (subject to umask) must be present. Of the
> +	 * w bits, either all (subject to umask) or none must be present.
> +	 */
> +
> +	if (S_ISREG(mode)) {
> +		req &= ~sbi->options.fs_fmask;
> +
> +		if ((req & (S_IRUGO | S_IXUGO)) !=
> +		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_fmask))
> +			return -EPERM;
> +
> +		if ((req & S_IWUGO) != 0 &&
> +		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_fmask))
> +			return -EPERM;
> +	} else if (S_ISDIR(mode)) {
> +		req &= ~sbi->options.fs_dmask;
> +
> +		if ((req & (S_IRUGO | S_IXUGO)) !=
> +		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_dmask))
> +			return -EPERM;
> +
> +		if ((req & S_IWUGO) != 0 &&
> +		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_dmask))
> +			return -EPERM;
> +	} else {
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +}
> +
>  int fat_notify_change(struct dentry *dentry, struct iattr *attr)
>  {
>  	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
> @@ -186,16 +222,19 @@ int fat_notify_change(struct dentry *den
>  	if (((attr->ia_valid & ATTR_UID) &&
>  	     (attr->ia_uid != sbi->options.fs_uid)) ||
>  	    ((attr->ia_valid & ATTR_GID) &&
> -	     (attr->ia_gid != sbi->options.fs_gid)) ||
> -	    ((attr->ia_valid & ATTR_MODE) &&
> -	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
> +	     (attr->ia_gid != sbi->options.fs_gid)))
>  		error = -EPERM;
> -
>  	if (error) {
>  		if (sbi->options.quiet)
>  			error = 0;
>  		goto out;
>  	}
> +
> +	if (error == 0 && (attr->ia_valid & ATTR_MODE))
> +		if ((error = check_mode(sbi, attr->ia_mode)) != 0 &&
> +		    sbi->options.quiet)
> +			error = 0;

This test is really here? error is always "0", and anybody doesn't
check after that.

>  	error = inode_setattr(inode, attr);
>  	if (error)
>  		goto out;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
