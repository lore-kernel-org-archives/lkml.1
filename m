Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbXL0LWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbXL0LWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXL0LWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:22:40 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28585 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXL0LWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:22:39 -0500
X-Greylist: delayed 2643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2007 06:22:39 EST
Date: Thu, 27 Dec 2007 13:38:20 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: + proc-remove-useless-checks-in-proc_register.patch added to -mm tree
Message-ID: <20071227103820.GA6213@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, Andrew, please, drop this patch. Fixing yet another race in
proc would be done by suppying PDE's with valid ->proc_fops before
proc_register(), so this patch would be effectively reverted.

>      proc-remove-useless-checks-in-proc_register.patch

> Subject: proc: remove useless checks in proc_register()
> From: Alexey Dobriyan <adobriyan@sw.ru>
> 
> Before proc_register() all PDEs are created by proc_create() which doesn't set
> ->proc_iops and ->proc_fops -- they're NULL.  So those branches in
> proc_register() are always taken.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/proc/generic.c |   15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff -puN fs/proc/generic.c~proc-remove-useless-checks-in-proc_register fs/proc/generic.c
> --- a/fs/proc/generic.c~proc-remove-useless-checks-in-proc_register
> +++ a/fs/proc/generic.c
> @@ -526,19 +526,14 @@ static int proc_register(struct proc_dir
>  	dp->low_ino = i;
>  
>  	if (S_ISDIR(dp->mode)) {
> -		if (dp->proc_iops == NULL) {
> -			dp->proc_fops = &proc_dir_operations;
> -			dp->proc_iops = &proc_dir_inode_operations;
> -		}
> +		dp->proc_fops = &proc_dir_operations;
> +		dp->proc_iops = &proc_dir_inode_operations;
>  		dir->nlink++;
>  	} else if (S_ISLNK(dp->mode)) {
> -		if (dp->proc_iops == NULL)
> -			dp->proc_iops = &proc_link_inode_operations;
> +		dp->proc_iops = &proc_link_inode_operations;
>  	} else if (S_ISREG(dp->mode)) {
> -		if (dp->proc_fops == NULL)
> -			dp->proc_fops = &proc_file_operations;
> -		if (dp->proc_iops == NULL)
> -			dp->proc_iops = &proc_file_inode_operations;
> +		dp->proc_fops = &proc_file_operations;
> +		dp->proc_iops = &proc_file_inode_operations;
>  	}
>  
>  	spin_lock(&proc_subdir_lock);

