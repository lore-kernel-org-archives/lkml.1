Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYAJHwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYAJHwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYAJHwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:52:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbYAJHwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:52:14 -0500
Date: Wed, 9 Jan 2008 23:51:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Steven <stevenaaus@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: ufs: fix symlink creation on ufs2
Message-Id: <20080109235148.d5896897.akpm@linux-foundation.org>
In-Reply-To: <20080102204649.GA16373@rain>
References: <20080102204649.GA16373@rain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008 23:47:04 +0300 Evgeniy Dushistov <dushistov@mail.ru> wrote:

> If create symlink on UFS2 filesystem under Linux,
> it looks wrong under other OSes, because of max symlink length
> field was not initialized properly, and data blocks were not
> used to save short symlink names.
> 
> Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
> Cc: Steven <stevenaaus@yahoo.com>
> 
> ---
> 
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 0072cb3..14605c0 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -131,6 +131,8 @@ static void ufs_print_super_stuff(struct super_block *sb,
>  		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
>  		       (unsigned long long)
>  		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
> +		printk(KERN_INFO"  fs_maxsymlinklen: %u\n",
> +		       usb3->fs_un2.fs_44.fs_maxsymlinklen);

I assume this needs conversion via fs32_to_cpu() before we print it.

>  	} else {
>  		printk(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
>  		printk(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
> @@ -1060,8 +1062,8 @@ magic_found:
>  	uspi->s_bpf = uspi->s_fsize << 3;
>  	uspi->s_bpfshift = uspi->s_fshift + 3;
>  	uspi->s_bpfmask = uspi->s_bpf - 1;
> -	if ((sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) ==
> -	    UFS_MOUNT_UFSTYPE_44BSD)
> +	if ((sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) == UFS_MOUNT_UFSTYPE_44BSD ||
> +	    (sbi->s_mount_opt & UFS_MOUNT_UFSTYPE) == UFS_MOUNT_UFSTYPE_UFS2)
>  		uspi->s_maxsymlinklen =
>  		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
>  

