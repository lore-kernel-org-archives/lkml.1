Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYJNPaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYJNPaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYJNP37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:29:59 -0400
Received: from igw3.watson.ibm.com ([129.34.20.18]:50928 "EHLO
	igw3.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYJNP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:29:59 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: david safford <safford@watson.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081014132823.GA18474@infradead.org>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <20081014132823.GA18474@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Oct 2008 11:27:52 -0400
Message-Id: <1223998072.3089.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
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
> Please only make decisions based on what you get in inode_permission().

Hmm... As Mimi mentioned in the last review, we really need access
to a path, which is not available in inode_permission. (Note the
path is not used to make any integrity decision, but is recorded along
with the measurement to help with the integrity analysis by a third
party verifier.) Yes, there are other callers without path information,
but getting a path here covers the bulk of the measurements.

Is there some other alternative, other than this, or passing the 
dentry into inode_permission, which was also rejected?

> >  }
> >  
> >  /*
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 32477e8..349d548 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -683,6 +683,9 @@ struct inode {
> >  #ifdef CONFIG_SECURITY
> >  	void			*i_security;
> >  #endif
> > +#ifdef CONFIG_INTEGRITY
> > +	void			*i_integrity;
> > +#endif
> 
> Sorry, but as said before bloating the inode for this is not an option.
> Please use something like the MRU approach I suggested in the last
> review round.

Sorry, in that thread I thought we were ok, as Serge made the points
that the bloat would only affect Integrity compiled kernels, that
no one would press for making Integrity default (not only because of the
bloat, but even more so because of the performance impact of hashing
all the files), and that having LIM do MRU would be a big hit, as
LIM allocates i_integrity for all inodes, and references it on all
inode_permission, bprm and mmap calls.  

If we have to, we have to, but we certainly would prefer not to.

thanks
dave

