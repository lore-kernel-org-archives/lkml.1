Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXBGIdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXBGIdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030498AbXBGIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:33:12 -0500
Received: from styx.suse.cz ([82.119.242.94]:34197 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030497AbXBGIdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:33:11 -0500
Date: Wed, 7 Feb 2007 09:35:57 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070207083557.GA5192@duck.suse.cz>
References: <20070206132333.GA9919@lst.de> <20070206155001.22ab74f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206155001.22ab74f6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-02-07 15:50:01, Andrew Morton wrote:
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
  Huh, I guess you meant O(n^2)... Yes, I know about this but as Christoph
pointed out, the loop runs only when quotaon is called on a filesystem and for
inodes somebody writes to. Usually, there are not so many such inodes. So
I'm not sure it's worth the trouble to fix this.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
