Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbYJNRHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbYJNRHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYJNRH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:07:29 -0400
Received: from igw3.watson.ibm.com ([129.34.20.18]:59182 "EHLO
	igw3.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYJNRH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:07:29 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: david safford <safford@watson.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081014155359.GC12330@us.ibm.com>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <20081014132823.GA18474@infradead.org>
	 <1223998072.3089.53.camel@localhost.localdomain>
	 <20081014155359.GC12330@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Oct 2008 13:06:31 -0400
Message-Id: <1224003991.3089.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 10:53 -0500, Serge E. Hallyn wrote:
> Quoting david safford (safford@watson.ibm.com):
> > On Tue, 2008-10-14 at 09:28 -0400, Christoph Hellwig wrote:
> > > >  int vfs_permission(struct nameidata *nd, int mask)
> > > >  {
> > > > -	return inode_permission(nd->path.dentry->d_inode, mask);
> > > > +	int retval;
> > > > +
> > > > +	retval = inode_permission(nd->path.dentry->d_inode, mask);
> > > > +	if (retval)
> > > > +		return retval;
> > > > +	return integrity_inode_permission(NULL, &nd->path,
> > > > +					  mask & (MAY_READ | MAY_WRITE |
> > > > +						  MAY_EXEC));
> > > >  }
> > > >  
> > > >  /**
> > > > @@ -306,7 +314,14 @@ int vfs_permission(struct nameidata *nd, int mask)
> > > >   */
> > > >  int file_permission(struct file *file, int mask)
> > > >  {
> > > > -	return inode_permission(file->f_path.dentry->d_inode, mask);
> > > > +	int retval;
> > > > +
> > > > +	retval = inode_permission(file->f_path.dentry->d_inode, mask);
> > > > +	if (retval)
> > > > +		return retval;
> > > > +	return integrity_inode_permission(file, NULL,
> > > > +					  mask & (MAY_READ | MAY_WRITE |
> > > > +						  MAY_EXEC));
> > > 
> > > Please don't add anything here as these two wrappers will go away.
> > > Please only make decisions based on what you get in inode_permission().
> > 
> > Hmm... As Mimi mentioned in the last review, we really need access
> > to a path, which is not available in inode_permission. (Note the
> > path is not used to make any integrity decision, but is recorded along
> > with the measurement to help with the integrity analysis by a third
> > party verifier.) Yes, there are other callers without path information,
> > but getting a path here covers the bulk of the measurements.
> > 
> > Is there some other alternative, other than this, or passing the 
> > dentry into inode_permission, which was also rejected?
> 
> Whatever happened to the patch Mimi had floated to use the audit
> subsystem to output a pathname?  I thought that was pretty neat,
> and it made particularly clear the the pathname was purely
> informational.
> 
> -serge

I'll double check with Mimi, but my recollection is that using the 
audit pathnames was nice, in that it returned a full path as a hint, 
not just a dentry filename, but that the audit system often did not 
have a path yet, so both the dentry name and the audit path were 
desirable.

dave
