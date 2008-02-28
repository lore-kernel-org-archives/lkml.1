Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbYB1BMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbYB1BMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbYB1BMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:12:21 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:45766 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbYB1BMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:12:20 -0500
X-Greylist: delayed 2140 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 20:12:20 EST
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
	attribute.
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Xine.LNX.4.64.0802281157170.27221@us.intercode.com.au>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204144786-3502-9-git-send-email-dpquigl@tycho.nsa.gov>
	 <Xine.LNX.4.64.0802281157170.27221@us.intercode.com.au>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 19:47:53 -0500
Message-Id: <1204159673.24345.15.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 12:04 +1100, James Morris wrote:
> On Wed, 27 Feb 2008, David P. Quigley wrote:
> 
> > +#ifdef CONFIG_SECURITY
> > +static inline void nfs_fattr_alloc(struct nfs_fattr *fattr, gfp_t flags)
> > +{
> > +	fattr->label = kzalloc(NFS4_MAXLABELLEN, flags);
> > +	if (fattr->label == NULL)
> > +		panic("Can't allocate security label.");
> > +	fattr->label_len = NFS4_MAXLABELLEN;
> > +}
> 
> A panic here seems like overkill, and also possibly a DoS vector.  I 
> suggest having the calling code handle the allocation failure gracefully.
> 

Good point, I'll put this on the list. I think I remember you mentioned
something about this before but it must have slipped through the cracks.

> > +
> > +#define	nfs_fattr_fini(fattr)	_nfs_fattr_fini(fattr, __FILE__, __LINE__, __func__)
> > +static inline void _nfs_fattr_fini(struct nfs_fattr *fattr,
> > +		const char *file, int line, const char *func)
> > +{
> > +	if ((fattr)->label == NULL) {
> > +		if (fattr->label_len != 0) {
> > +			printk(KERN_WARNING
> > +					"%s:%d %s() nfs_fattr label available (%d)\n",
> > +					file, line, func,
> > +					fattr->label_len);
> > +		}
> > +	} else {
> > +		if (fattr->label_len == NFS4_MAXLABELLEN)
> > +			printk(KERN_WARNING
> > +					"%s:%d %s() nfs_fattr label unused\n",
> > +					file, line, func);
> > +		else if (fattr->label_len != (strlen(fattr->label) + 1))
> > +			printk(KERN_WARNING
> > +				"%s:%d %s() nfs_fattr label size mismatch (label_len %d, strlen %d)\n",
> > +				file, line, func,
> > +				fattr->label_len, strlen(fattr->label) + 1);
> > +
> > +		kfree(fattr->label);
> > +		fattr->label = NULL;
> > +		fattr->label_len = 0;
> > +	}
> > +}
> > +#else
> > +#define	nfs_fattr_alloc(fattr, flags)
> > +#define	nfs_fattr_fini(fattr)
> > +#endif
> 
> Perhaps introduce a debug configuration option for this code.

In what way? We can change them to respond to the NFS/NFSD debug
variables that are set through proc, or did you have something else in
mind?

> 
> 
> - James

