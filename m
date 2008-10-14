Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbYJNN2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbYJNN2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYJNN2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:28:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYJNN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:28:24 -0400
Date: Tue, 14 Oct 2008 09:28:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
Message-ID: <20081014132823.GA18474@infradead.org>
References: <cover.1223869200.git.zohar@localhost.localdomain> <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  int vfs_permission(struct nameidata *nd, int mask)
>  {
> -	return inode_permission(nd->path.dentry->d_inode, mask);
> +	int retval;
> +
> +	retval = inode_permission(nd->path.dentry->d_inode, mask);
> +	if (retval)
> +		return retval;
> +	return integrity_inode_permission(NULL, &nd->path,
> +					  mask & (MAY_READ | MAY_WRITE |
> +						  MAY_EXEC));
>  }
>  
>  /**
> @@ -306,7 +314,14 @@ int vfs_permission(struct nameidata *nd, int mask)
>   */
>  int file_permission(struct file *file, int mask)
>  {
> -	return inode_permission(file->f_path.dentry->d_inode, mask);
> +	int retval;
> +
> +	retval = inode_permission(file->f_path.dentry->d_inode, mask);
> +	if (retval)
> +		return retval;
> +	return integrity_inode_permission(file, NULL,
> +					  mask & (MAY_READ | MAY_WRITE |
> +						  MAY_EXEC));

Please don't add anything here as these two wrappers will go away.
Please only make decisions based on what you get in inode_permission().

>  }
>  
>  /*
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 32477e8..349d548 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -683,6 +683,9 @@ struct inode {
>  #ifdef CONFIG_SECURITY
>  	void			*i_security;
>  #endif
> +#ifdef CONFIG_INTEGRITY
> +	void			*i_integrity;
> +#endif

Sorry, but as said before bloating the inode for this is not an option.
Please use something like the MRU approach I suggested in the last
review round.

