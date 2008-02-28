Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYB1Qc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYB1Qc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYB1QcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:32:17 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:39661 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbYB1QcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:32:16 -0500
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Xine.LNX.4.64.0802281212320.27221@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <Xine.LNX.4.64.0802281212320.27221@us.intercode.com.au>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:07:55 -0500
Message-Id: <1204214875.24345.61.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 12:20 +1100, James Morris wrote:
> On Wed, 27 Feb 2008, David P. Quigley wrote:
> 
> > +int inode_setsecurity(struct inode *inode, struct iattr *attr)
> > +{
> > +	const char *suffix = security_maclabel_getname() 
> > +				+ XATTR_SECURITY_PREFIX_LEN;
> > +	int error;
> > +
> > +	if (!attr->ia_valid & ATTR_SECURITY_LABEL)
> > +		return -EINVAL;
> 
> Do you mean:
> 
> 	if (!(attr->ia_valid & ATTR_SECURITY_LABEL))
> 
> ?

Yep that is what it should be.

> 
> >  			mode &= ~S_ISGID;
> >  		inode->i_mode = mode;
> >  	}
> > +#ifdef CONFIG_SECURITY
> > +	if (ia_valid & ATTR_SECURITY_LABEL)
> > +		inode_setsecurity(inode, attr);
> > +#endif
> 
> You're not checking the return value of inode_setsecurity().
> 
> Why not just rely on inode_setsecurity() to perform the check, then you 
> can lose the #ifdefs in the core code & make it a noop for 
> !CONFIG_SECURITY.

I'm not clear as to what you are suggesting here. are you saying put the
#ifdef CONFIG_SECURITY around inode_setsecurity and make the case where
CONFIG_SECURITY isn't set an empty static inline function?

> 
> 
> > +#ifdef CONFIG_SECURITY
> > +	if (ia_valid & ATTR_SECURITY_LABEL) {
> > +		char *key = (char *)security_maclabel_getname();
> > +		vfs_setxattr_locked(dentry, key,
> > +			attr->ia_label, attr->ia_label_len, 0);
> > +		/* Avoid calling inode_setsecurity()
> > +		 * via inode_setattr() below
> > +		 */
> > +		attr->ia_valid &= ~ATTR_SECURITY_LABEL;
> > +	}
> > +#endif
> > +
> 
> Similarly, make this a function which is compiled away for 
> !CONFIG_SECURITY.

Same as above.

> 
> > +		if (!error) {
> > +#ifdef CONFIG_SECURITY
> > +			fsnotify_change(dentry, ATTR_SECURITY_LABEL);
> > +#endif
> >  			fsnotify_xattr(dentry);
> 
> Put the #ifdef inside fsnotify_change() and only process 
> ATTR_SECURITY_LABEL if CONFIG_SECURITY.

Will do.

> 
> 
> > +#ifdef CONFIG_SECURITY
> > +#define ATTR_SECURITY_LABEL  65536
> > +#endif
> 
> I don't think there's any harm in always defining this.
> 
> 

