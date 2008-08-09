Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYHISxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYHISxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 14:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYHISxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 14:53:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYHISxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 14:53:40 -0400
Date: Sat, 9 Aug 2008 14:53:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20080809185340.GC22905@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218221761.4444.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		if (integrity_inode_alloc(inode)) {
> +			if (inode->i_sb->s_op->destroy_inode)
> +				inode->i_sb->s_op->destroy_inode(inode);
> +			else
> +				kmem_cache_free(inode_cachep, (inode));
> +			return NULL;
> +		}
> +

Please factor this and the lsm failure case out into a single
out_free_inode goto label.


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
> @@ -306,7 +314,14 @@ int vfs_permission(struct nameidata *nd,
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

Please put your hook into inode_permission.  Note that in inode
permission and lots of callers there is no path available so don't pass
it.  Please pass the full MAY_FOO mask for new interfaces and do
filtering that won't break if new ones are introduced.


> +#ifdef CONFIG_INTEGRITY
> +	void			*i_integrity;
> +#endif

Sorry, but I don't think we can bloat the inode even further for this.

> +/*
> + * integrity.h

don't bother to mention the filename in the top of file comment.

