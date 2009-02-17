Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZBQPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZBQPon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZBQPoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:44:18 -0500
Received: from sh.osrg.net ([192.16.179.4]:42579 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbZBQPoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:44:16 -0500
Date: Wed, 18 Feb 2009 00:43:41 +0900 (JST)
Message-Id: <20090218.004341.65155545.ryusuke@osrg.net>
To: penberg@cs.helsinki.fi
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 4/6] nilfs2: use unlocked_ioctl
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <1234869973.21383.1.camel@penberg-laptop>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1234856526-1947-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1234869973.21383.1.camel@penberg-laptop>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 18 Feb 2009 00:43:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,
On Tue, 17 Feb 2009 13:26:13 +0200, Pekka Enberg wrote:
> Hi Ryusuke,
> 
> On Tue, 2009-02-17 at 16:42 +0900, Ryusuke Konishi wrote:
> > Pekka Enberg suggested converting ->ioctl operations to use
> > ->unlocked_ioctl to avoid BKL.
> > 
> > The conversion was verified to be safe, so I will take it on this
> > occasion.
> > 
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> > ---
> >  fs/nilfs2/dir.c   |    2 +-
> >  fs/nilfs2/file.c  |    2 +-
> >  fs/nilfs2/ioctl.c |    4 ++--
> >  fs/nilfs2/nilfs.h |    2 +-
> >  4 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > index 393316c..54100ac 100644
> > --- a/fs/nilfs2/dir.c
> > +++ b/fs/nilfs2/dir.c
> > @@ -702,7 +702,7 @@ struct file_operations nilfs_dir_operations = {
> >  	.llseek		= generic_file_llseek,
> >  	.read		= generic_read_dir,
> >  	.readdir	= nilfs_readdir,
> > -	.ioctl		= nilfs_ioctl,
> > +	.unlocked_ioctl	= nilfs_ioctl,
> >  #ifdef CONFIG_COMPAT
> >  	.compat_ioctl	= nilfs_ioctl,
> >  #endif	/* CONFIG_COMPAT */
> > diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> > index 1670038..df74577 100644
> > --- a/fs/nilfs2/file.c
> > +++ b/fs/nilfs2/file.c
> > @@ -138,7 +138,7 @@ struct file_operations nilfs_file_operations = {
> >  	.write		= do_sync_write,
> >  	.aio_read	= generic_file_aio_read,
> >  	.aio_write	= generic_file_aio_write,
> > -	.ioctl		= nilfs_ioctl,
> > +	.unlocked_ioctl	= nilfs_ioctl,
> >  #ifdef CONFIG_COMPAT
> >  	.compat_ioctl	= nilfs_ioctl,
> >  #endif	/* CONFIG_COMPAT */
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index 33aff88..cfb2789 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -600,9 +600,9 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
> >  	return 0;
> >  }
> >  
> > -int nilfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> > -		unsigned long arg)
> > +long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  {
> > +	struct inode *inode = filp->f_dentry->d_inode;
> >  	void __user *argp = (void * __user *)arg;
> >  
> >  	switch (cmd) {
> > diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> > index ad17fa9..f865ecb 100644
> > --- a/fs/nilfs2/nilfs.h
> > +++ b/fs/nilfs2/nilfs.h
> > @@ -242,7 +242,7 @@ extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
> >  extern int nilfs_sync_file(struct file *, struct dentry *, int);
> >  
> >  /* ioctl.c */
> > -int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
> > +long nilfs_ioctl(struct file *, unsigned int, unsigned long);
> >  int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
> >  
> >  /* inode.c */
> 
> Maybe I'm looking at an old version of nilfs but don't you need to
> remove nilfs_compat_locked_ioctl() and the lock_kernel()/unlock_kernel()
> from nilfs_ioctl_timedwait() as well?
> 
> 			Pekka

That's right, but the nilfs_ioctl_timedwait() itself was removed by
the first patch of this patch set.  And, the compat ioctl was removed
in the third patch.  So they don't appear in this patch.

Cheers,
Ryusuke
