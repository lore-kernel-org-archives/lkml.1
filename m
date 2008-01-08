Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYAHFpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYAHFpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYAHFph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:45:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35385 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYAHFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:45:37 -0500
Date: Mon, 7 Jan 2008 21:45:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, shaggy@us.ibm.com, sandeen@redhat.com,
       jmoyer@redhat.com
Subject: Re: [PATCH] eCryptfs: Fix dentry handling on create error, unlink,
 and inode destroy
Message-Id: <20080107214517.ebf5a5bd.akpm@linux-foundation.org>
In-Reply-To: <20080108052542.GX10989@localhost.austin.ibm.com>
References: <20080108052542.GX10989@localhost.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 23:25:42 -0600 Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -120,22 +120,9 @@ ecryptfs_do_create(struct inode *directory_inode,
>  	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
>  					     ecryptfs_dentry, mode, nd);
>  	if (rc) {
> -		struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
> -		struct ecryptfs_inode_info *inode_info =
> -			ecryptfs_inode_to_private(ecryptfs_inode);
> -
> -		printk(KERN_WARNING "%s: Error creating underlying file; "
> -		       "rc = [%d]; checking for existing\n", __FUNCTION__, rc);
> -		if (inode_info) {
> -			mutex_lock(&inode_info->lower_file_mutex);
> -			if (!inode_info->lower_file) {
> -				mutex_unlock(&inode_info->lower_file_mutex);
> -				printk(KERN_ERR "%s: Failure to set underlying "
> -				       "file; rc = [%d]\n", __FUNCTION__, rc);
> -				goto out_lock;
> -			}
> -			mutex_unlock(&inode_info->lower_file_mutex);
> -		}
> +		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
> +		       "rc = [%d]\n", __FUNCTION__, rc);
> +		goto out_lock;
>  	}
>  	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
>  				directory_inode->i_sb, 0);

Will this cause an undesirable log storm if the underlying fs runs out of
space?
