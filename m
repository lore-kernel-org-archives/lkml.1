Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYJXOsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYJXOsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYJXOrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:47:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51600 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYJXOrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:47:55 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081014132823.GA18474@infradead.org>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <20081014132823.GA18474@infradead.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 10:47:49 -0400
Message-Id: <1224859669.9634.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 09:28 -0400, Christoph Hellwig wrote: 
> >  int vfs_permission(struct nameidata *nd, int mask)
> >  {
> > -	return inode_permission(nd->path.dentry->d_inode, mask);
> > +	int retval;
> > +
> > +	retval = inode_permission(nd->path.dentry->d_inode, mask);
> > +	if (retval)
> > +		return retval;
> > +	return integrity_inode_permission(NULL, &nd->path,
> > +					  mask & (MAY_READ | MAY_WRITE |
> > +						  MAY_EXEC));
> >  }
> >  
> >  /**
> > @@ -306,7 +314,14 @@ int vfs_permission(struct nameidata *nd, int mask)
> >   */
> >  int file_permission(struct file *file, int mask)
> >  {
> > -	return inode_permission(file->f_path.dentry->d_inode, mask);
> > +	int retval;
> > +
> > +	retval = inode_permission(file->f_path.dentry->d_inode, mask);
> > +	if (retval)
> > +		return retval;
> > +	return integrity_inode_permission(file, NULL,
> > +					  mask & (MAY_READ | MAY_WRITE |
> > +						  MAY_EXEC));
> 
> Please don't add anything here as these two wrappers will go away.

Ok.

> Please only make decisions based on what you get in inode_permission().

Is there any way to read a file, in order to calculate a hash, based
just on an inode and a mask?  As far as I'm aware, either a file, or a
dentry and vfsmount structures, are needed.  Previously, only the
dentry, not the vfsmount, was required, which is accessible from the
inode. 

Without access to the vfsmount in inode_permission(), as
vfs_permission() is going away, the only option I see is to move the
integrity_inode_permission() call up a level to may_open(), after the
call to vfs_permission().  Would this be acceptable?  (And change the
hook name to integrity_may_open.)

Mimi

