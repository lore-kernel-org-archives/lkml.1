Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbYB1BFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbYB1BFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbYB1BFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:05:25 -0500
Received: from namei.org ([69.55.235.186]:47786 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760137AbYB1BFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:05:23 -0500
Date: Thu, 28 Feb 2008 12:04:49 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
 attribute.
In-Reply-To: <1204144786-3502-9-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <Xine.LNX.4.64.0802281157170.27221@us.intercode.com.au>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1204144786-3502-9-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David P. Quigley wrote:

> +#ifdef CONFIG_SECURITY
> +static inline void nfs_fattr_alloc(struct nfs_fattr *fattr, gfp_t flags)
> +{
> +	fattr->label = kzalloc(NFS4_MAXLABELLEN, flags);
> +	if (fattr->label == NULL)
> +		panic("Can't allocate security label.");
> +	fattr->label_len = NFS4_MAXLABELLEN;
> +}

A panic here seems like overkill, and also possibly a DoS vector.  I 
suggest having the calling code handle the allocation failure gracefully.

> +
> +#define	nfs_fattr_fini(fattr)	_nfs_fattr_fini(fattr, __FILE__, __LINE__, __func__)
> +static inline void _nfs_fattr_fini(struct nfs_fattr *fattr,
> +		const char *file, int line, const char *func)
> +{
> +	if ((fattr)->label == NULL) {
> +		if (fattr->label_len != 0) {
> +			printk(KERN_WARNING
> +					"%s:%d %s() nfs_fattr label available (%d)\n",
> +					file, line, func,
> +					fattr->label_len);
> +		}
> +	} else {
> +		if (fattr->label_len == NFS4_MAXLABELLEN)
> +			printk(KERN_WARNING
> +					"%s:%d %s() nfs_fattr label unused\n",
> +					file, line, func);
> +		else if (fattr->label_len != (strlen(fattr->label) + 1))
> +			printk(KERN_WARNING
> +				"%s:%d %s() nfs_fattr label size mismatch (label_len %d, strlen %d)\n",
> +				file, line, func,
> +				fattr->label_len, strlen(fattr->label) + 1);
> +
> +		kfree(fattr->label);
> +		fattr->label = NULL;
> +		fattr->label_len = 0;
> +	}
> +}
> +#else
> +#define	nfs_fattr_alloc(fattr, flags)
> +#define	nfs_fattr_fini(fattr)
> +#endif

Perhaps introduce a debug configuration option for this code.


- James
-- 
James Morris
<jmorris@namei.org>
