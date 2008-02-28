Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbYB1BVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbYB1BVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYB1BVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:21:03 -0500
Received: from namei.org ([69.55.235.186]:48222 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbYB1BVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:21:01 -0500
Date: Thu, 28 Feb 2008 12:20:30 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
In-Reply-To: <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <Xine.LNX.4.64.0802281212320.27221@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David P. Quigley wrote:

> +int inode_setsecurity(struct inode *inode, struct iattr *attr)
> +{
> +	const char *suffix = security_maclabel_getname() 
> +				+ XATTR_SECURITY_PREFIX_LEN;
> +	int error;
> +
> +	if (!attr->ia_valid & ATTR_SECURITY_LABEL)
> +		return -EINVAL;

Do you mean:

	if (!(attr->ia_valid & ATTR_SECURITY_LABEL))

?

>  			mode &= ~S_ISGID;
>  		inode->i_mode = mode;
>  	}
> +#ifdef CONFIG_SECURITY
> +	if (ia_valid & ATTR_SECURITY_LABEL)
> +		inode_setsecurity(inode, attr);
> +#endif

You're not checking the return value of inode_setsecurity().

Why not just rely on inode_setsecurity() to perform the check, then you 
can lose the #ifdefs in the core code & make it a noop for 
!CONFIG_SECURITY.


> +#ifdef CONFIG_SECURITY
> +	if (ia_valid & ATTR_SECURITY_LABEL) {
> +		char *key = (char *)security_maclabel_getname();
> +		vfs_setxattr_locked(dentry, key,
> +			attr->ia_label, attr->ia_label_len, 0);
> +		/* Avoid calling inode_setsecurity()
> +		 * via inode_setattr() below
> +		 */
> +		attr->ia_valid &= ~ATTR_SECURITY_LABEL;
> +	}
> +#endif
> +

Similarly, make this a function which is compiled away for 
!CONFIG_SECURITY.

> +		if (!error) {
> +#ifdef CONFIG_SECURITY
> +			fsnotify_change(dentry, ATTR_SECURITY_LABEL);
> +#endif
>  			fsnotify_xattr(dentry);

Put the #ifdef inside fsnotify_change() and only process 
ATTR_SECURITY_LABEL if CONFIG_SECURITY.


> +#ifdef CONFIG_SECURITY
> +#define ATTR_SECURITY_LABEL  65536
> +#endif

I don't think there's any harm in always defining this.


-- 
James Morris
<jmorris@namei.org>
