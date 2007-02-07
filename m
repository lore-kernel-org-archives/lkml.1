Return-Path: <linux-kernel-owner+w=401wt.eu-S965545AbXBGHXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545AbXBGHXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 02:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965667AbXBGHXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 02:23:10 -0500
Received: from verein.lst.de ([213.95.11.210]:60620 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965545AbXBGHXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 02:23:09 -0500
Date: Wed, 7 Feb 2007 08:22:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, jack@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070207072259.GA22083@lst.de>
References: <20070206132333.GA9919@lst.de> <20070206155001.22ab74f6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206155001.22ab74f6.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 03:50:01PM -0800, Andrew Morton wrote:
> On Tue, 6 Feb 2007 14:23:33 +0100
> Christoph Hellwig <hch@lst.de> wrote:
> 
> >  static void add_dquot_ref(struct super_block *sb, int type)
> >  {
> > -	struct list_head *p;
> > +	struct inode *inode;
> >  
> >  restart:
> > -	file_list_lock();
> > -	list_for_each(p, &sb->s_files) {
> > -		struct file *filp = list_entry(p, struct file, f_u.fu_list);
> > -		struct inode *inode = filp->f_path.dentry->d_inode;
> > -		if (filp->f_mode & FMODE_WRITE && dqinit_needed(inode, type)) {
> > -			struct dentry *dentry = dget(filp->f_path.dentry);
> > -			file_list_unlock();
> > -			sb->dq_op->initialize(inode, type);
> > -			dput(dentry);
> > -			/* As we may have blocked we had better restart... */
> > -			goto restart;
> > -		}
> > +	spin_lock(&inode_lock);
> > +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> > +		if (!atomic_read(&inode->i_writecount))
> > +			continue;
> > +		if (!dqinit_needed(inode, type))
> > +			continue;
> > +		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> > +			continue;
> > +
> > +		__iget(inode);
> > +		spin_unlock(&inode_lock);
> > +
> > +		sb->dq_op->initialize(inode, type);
> > +		iput(inode);
> > +		/* As we may have blocked we had better restart... */
> > +		goto restart;
> >  	}
> > -	file_list_unlock();
> > +	spin_unlock(&inode_lock);
> >  }
> 
> That loop has (and had) up to O(n^n) operations.  Is there something which
> prevents this from going insane?

I don't think so.  Then again it's only called when you call quotaon on
a mounted filesystem, and normally you don't have that many inodes
instanciated at that time.
