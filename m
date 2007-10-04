Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbXJDRfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbXJDRfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbXJDRfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:35:38 -0400
Received: from uni20mr.unity.ncsu.edu ([152.1.2.39]:52519 "EHLO
	uni20mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbXJDRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:35:37 -0400
Message-ID: <47052458.2090600@ncsu.edu>
Date: Thu, 04 Oct 2007 13:35:20 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Casey Dahlin <cjdahlin@ncsu.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Code style fix for open_exec
References: <47045299.2000601@ncsu.edu> <20071004070857.GB21481@infradead.org>
In-Reply-To: <20071004070857.GB21481@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.313940, Antispam-Data: 2007.10.4.101133
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Oct 03, 2007 at 10:40:25PM -0400, Casey Dahlin wrote:
>   
>> From d2a6c5d29dc34cfea892124ab72b4eb55d2f8a80 Mon Sep 17 00:00:00 2001
>> From: Casey Dahlin <cjdahlin@ncsu.edu>
>> Date: Wed, 3 Oct 2007 22:01:49 -0400
>> Subject: [PATCH] Code style fix for open_exec
>>
>> Fix a horribly mangled 5 level indent and severe abuse of goto in the 
>> open_exec
>> function.
>>     
>
> While the function is not nice your version makes it even worse.
>   
    Ouch :) I don't think I did so bad.
> Try this one instead which has been in my pending testing tree for a while:
>   
Pretty much all of the stylistic changes were recommended to me already 
off list by Joe Perches. I have that in my branch now, and was waiting 
on any further feedback before resubmitting. There's a couple of things 
here though (particularly the unlikelys) that are worth having. This is 
the better code.
>
>
> Index: linux-2.6/fs/exec.c
> ===================================================================
> --- linux-2.6.orig/fs/exec.c	2007-09-16 20:29:01.000000000 +0200
> +++ linux-2.6/fs/exec.c	2007-09-16 20:29:56.000000000 +0200
> @@ -669,41 +669,55 @@ EXPORT_SYMBOL(setup_arg_pages);
>  
>  #endif /* CONFIG_MMU */
>  
> +/**
> + * open_exec - open file for execution
> + * @name:	filename to open
> + *
> + * Open the file pointed to by @filename in the current namespace
> + * for execution.  Error out if the file is not a regular file or
> + * this mount does not allow executing files on it.
> + */
>  struct file *open_exec(const char *name)
>  {
>  	struct nameidata nd;
> -	int err;
>  	struct file *file;
> +	int err;
>  
> -	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd, FMODE_READ|FMODE_EXEC);
> -	file = ERR_PTR(err);
> +	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd,
> +				FMODE_READ|FMODE_EXEC);
> +	if (unlikely(err))
> +		goto out;
>  
> -	if (!err) {
> -		struct inode *inode = nd.dentry->d_inode;
> -		file = ERR_PTR(-EACCES);
> -		if (!(nd.mnt->mnt_flags & MNT_NOEXEC) &&
> -		    S_ISREG(inode->i_mode)) {
> -			int err = vfs_permission(&nd, MAY_EXEC);
> -			file = ERR_PTR(err);
> -			if (!err) {
> -				file = nameidata_to_filp(&nd, O_RDONLY);
> -				if (!IS_ERR(file)) {
> -					err = deny_write_access(file);
> -					if (err) {
> -						fput(file);
> -						file = ERR_PTR(err);
> -					}
> -				}
> -out:
> -				return file;
> -			}
> -		}
> -		release_open_intent(&nd);
> -		path_release(&nd);
> +	err = -EACCES;
> +	if (unlikely(nd.mnt->mnt_flags & MNT_NOEXEC))
> +		goto out_path_release;
> +	if (unlikely(!S_ISREG(nd.dentry->d_inode->i_mode)))
> +		goto out_path_release;
> +
> +	err = vfs_permission(&nd, MAY_EXEC);
> +	if (unlikely(err))
> +		goto out_path_release;
> +
> +	file = nameidata_to_filp(&nd, O_RDONLY);
> +	if (unlikely(IS_ERR(file))) {
> +		err = PTR_ERR(file);
> +		goto out;
> +	}
> +
> +	err = deny_write_access(file);
> +	if (unlikely(err)) {
> +		fput(file);
> +		goto out;
>  	}
> -	goto out;
> -}
>  
> +	return file;
> +
> + out_path_release:
> +	release_open_intent(&nd);
> +	path_release(&nd);
> + out:
> +	return ERR_PTR(err);
> +}
>  EXPORT_SYMBOL(open_exec);
>  
>  int kernel_read(struct file *file, unsigned long offset,
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

