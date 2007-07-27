Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbXG0JZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbXG0JZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbXG0JZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:25:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3153 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027AbXG0JZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:25:44 -0400
Date: Fri, 27 Jul 2007 13:25:35 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/bus/pci IOCTL breakage
Message-ID: <20070727092534.GB6924@localhost.sw.ru>
References: <20070726.190751.66179795.davem@davemloft.net> <20070726.230435.68159913.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726.230435.68159913.davem@davemloft.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:04:35PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 26 Jul 2007 19:07:51 -0700 (PDT)
> 
> > Two ways to fix:
> > 
> > 1) Make the PROC wrapper call ->unlocked_ioctl() or ->ioctl()
> >    as a fallback of ->compat_ioctl is NULL.
> > 
> > 2) Make proc_bus_pci_operations provide a .compat_ioctl method,
> >    but then we'll need to audit the entire tree for cases like
> >    this and make the same fix.
> > 
> > Because it's easier to validate that all cases are covered,
> > I think #1 is the preferred fix.
>
> Here is my suggested fix.
> 
> It is important to only provide the compat_ioctl method
> if the downstream de->proc_fops does too, otherwise this
> utterly confuses the logic in fs/compat_ioctl.c and we
> end up doing the right thing.

Indeed, my patch broke cases where .compat_ioctl was not supplied and
ioctl was done with compat_sys_ioctl(). 

> To be honest, the other unlocked_ioctl fallback scheme in
> this file should be scrutinized for similar problems.

I checked on test module all (3 + 3 + 1) x 2 combinations of available
methods and ioctl/compat_ioctl accesses. Regression were only in
compat_sys_ioctl(2) part. And your patch fixes all of them.

> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -386,6 +386,19 @@ static const struct file_operations proc_reg_file_ops = {
>  	.release	= proc_reg_release,
>  };
>  
> +#ifdef CONFIG_COMPAT
> +static const struct file_operations proc_reg_file_ops_no_compat = {
> +	.llseek		= proc_reg_llseek,
> +	.read		= proc_reg_read,
> +	.write		= proc_reg_write,
> +	.poll		= proc_reg_poll,
> +	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
> +	.mmap		= proc_reg_mmap,
> +	.open		= proc_reg_open,
> +	.release	= proc_reg_release,
> +};
> +#endif
> +
>  struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
>  				struct proc_dir_entry *de)
>  {
> @@ -413,8 +426,15 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
>  		if (de->proc_iops)
>  			inode->i_op = de->proc_iops;
>  		if (de->proc_fops) {
> -			if (S_ISREG(inode->i_mode))
> -				inode->i_fop = &proc_reg_file_ops;
> +			if (S_ISREG(inode->i_mode)) {
> +#ifdef CONFIG_COMPAT
> +				if (!de->proc_fops->compat_ioctl)
> +					inode->i_fop =
> +						&proc_reg_file_ops_no_compat;
> +				else
> +#endif
> +					inode->i_fop = &proc_reg_file_ops;
> +			}
>  			else
>  				inode->i_fop = de->proc_fops;
>  		}

Looks good, thanks David.

