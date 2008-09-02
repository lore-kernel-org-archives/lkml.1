Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYIBX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYIBX1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYIBX1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:27:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbYIBX07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:26:59 -0400
Date: Tue, 2 Sep 2008 16:26:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix return value of proc_reg_open() in "too late"
 case
Message-Id: <20080902162624.cd9f6d7f.akpm@linux-foundation.org>
In-Reply-To: <20080830053412.GB25179@x200.localdomain>
References: <20080830053412.GB25179@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 09:34:12 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> If ->open() wasn't called, returning 0 is misleading and, theoretically,
> oopsable:
> 1. remove_proc_entry clears ->proc_fops, drops lock,
> 2. ->open "succeeds",
> 3. ->release oopses, because it assumes ->open was called (single_release()).
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  fs/proc/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -350,7 +350,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
>  	if (!pde->proc_fops) {
>  		spin_unlock(&pde->pde_unload_lock);
>  		kfree(pdeo);
> -		return rv;
> +		return -EINVAL;
>  	}
>  	pde->pde_users++;
>  	open = pde->proc_fops->open;

Can this code path ever actually be executed?  afacit if ->proc_fops is
ever NULL, the caller (proc_get_inode) would have already oopsed:

#ifdef CONFIG_COMPAT
				if (!de->proc_fops->compat_ioctl)
					inode->i_fop =
						&proc_reg_file_ops_no_compat;
				else
#endif
					inode->i_fop = &proc_reg_file_ops;

