Return-Path: <linux-kernel-owner+w=401wt.eu-S1767672AbXEDH1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767672AbXEDH1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767703AbXEDH1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:27:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34423 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767700AbXEDH1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:27:45 -0400
Date: Fri, 4 May 2007 08:27:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Sipek <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, mhalcrow@us.ibm.com
Subject: Re: [PATCH 1/1] fs: add 4th case to do_path_lookup
Message-ID: <20070504072734.GA21188@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Sipek <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, mhalcrow@us.ibm.com
References: <20070430032624.GA32047@filer.fsl.cs.sunysb.edu> <20070430033012.GB32047@filer.fsl.cs.sunysb.edu> <20070504000200.d14bd8d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504000200.d14bd8d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, I proposed Jeff a reply long ago but haven't done yet.

On Fri, May 04, 2007 at 12:02:00AM -0700, Andrew Morton wrote:
> > @@ -1125,6 +1125,10 @@ static int fastcall do_path_lookup(int dfd, const char *name,
> >  		nd->mnt = mntget(fs->rootmnt);
> >  		nd->dentry = dget(fs->root);
> >  		read_unlock(&fs->lock);
> > +	} else if (flags & LOOKUP_ONE) {
> > +		/* nd->mnt and nd->dentry already set, just grab references */
> > +		mntget(nd->mnt);
> > +		dget(nd->dentry);
> >  	} else if (dfd == AT_FDCWD) {
> >  		read_lock(&fs->lock);
> >  		nd->mnt = mntget(fs->pwdmnt);
> 
> Well the patch passes my too-small-to-care-about test ;)
> 
> Unless someone objects I'd suggest that you add it to the unionfs tree.

The code is obviously correct.  There is one little thing that bothers
me, and that's that nd was purely an output paramter to path_lookup and
do_path_lookup, and no it's an input paramter for the least used case.
It might make sense to just a simple helper ala:



static int path_component_lookup(struct dentry *dentry, struct vfsmount *mnt,
		const char *name, unsigned int flags, struct nameidata *nd)
{
	int retval;

	nd->last_type = LAST_ROOT;
	nd->flags = flags;
	nd->mnt = mntget(mnt);
	nd->dentry = dget(dentry);
	nd->depth = 0;

	retval = path_walk(name, nd);
	if (unlikely(!retval && !audit_dummy_context() &&
	             nd->dentry && nd->dentry->d_inode))
		audit_inode(name, nd->dentry->d_inode);

	return retval;

}

instead.
