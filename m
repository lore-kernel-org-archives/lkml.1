Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXCHRHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXCHRHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXCHRHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:07:38 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58867 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXCHRHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:07:37 -0500
Date: Thu, 8 Mar 2007 11:07:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
Message-ID: <20070308170733.GA21099@sergelap.austin.ibm.com>
References: <1173369812.5981.2.camel@localhost.localdomain> <20070308164132.GL6602@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308164132.GL6602@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> * Mimi Zohar (zohar@linux.vnet.ibm.com) wrote:
> > +	integrity_d_instantiate(entry, inode);
> >  	security_d_instantiate(entry, inode);
> 
> > +		integrity_d_instantiate(entry, inode);
> >  		security_d_instantiate(entry, inode);
> 
> >  			spin_unlock(&dcache_lock);
> > +			integrity_d_instantiate(new, inode);
> >  			security_d_instantiate(new, inode);
> >  			d_rehash(dentry);
> 
> >  			d_move(new, dentry);
> > +			integrity_d_instantiate(dentry, inode);
> >  			security_d_instantiate(dentry, inode);
> >  			d_rehash(dentry);
> 
> >  	if (actual == dentry) {
> > +		integrity_d_instantiate(dentry, inode);
> >  		security_d_instantiate(dentry, inode);
> 
> 
> >  		file->f_op->release(inode, file);
> >  	security_file_free(file);
> > +	integrity_file_free(file);
> 
> 
> >  		security_file_free(file);
> > +		integrity_file_free(file);
> 
> 
> > 		if (security_inode_alloc(inode)) {
> ...
> > +		if (integrity_inode_alloc(inode)) {
> > +			if (inode->i_sb->s_op->destroy_inode)
> > +				inode->i_sb->s_op->destroy_inode(inode);
> 
> >  	security_inode_free(inode);
> > +	integrity_inode_free(inode);
> 
> >  	error = security_inode_setxattr(dentry, name, value, size, flags);
> >  	if (error)
> >  		goto out;
> > +
> > +	error = integrity_inode_setxattr(dentry, name, value, size, flags);
> 
> >  			fsnotify_xattr(dentry);
> > +			integrity_inode_post_setxattr(dentry, name);
> >  			security_inode_post_setxattr(dentry, name, value,
> 
> I know there's some slightly different goals, but this just doesn't make
> sense.  Need to get back to defining and expressing just the differences.

Are you objecting only to the duplication at the callsites, so that an
fsnotify-type of consolidation of security and integrity hooks would be
ok?  Or are you complaining that the security_inode_setxattr and
integrity_inode_setxattr hooks are too similar anyway, and integrity
modules should just use some lsm hooks for anything which will be
authoritative?

(I could see an argument that integirty subsystem should be purely for
measuring and hence its hooks should never return a value.  Only hitch
there is that if integrity subsystem hits ENOMEM it should be able to
refuse the action...)

-serge
