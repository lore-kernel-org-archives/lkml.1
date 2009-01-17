Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbZAQKBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbZAQKBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 05:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbZAQKAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 05:00:52 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34043 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbZAQKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 05:00:51 -0500
Subject: Re: ext3: call blkdev_issue_flush on fsync
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090114103532.GA18834@duck.suse.cz>
	 <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz>
	 <20090114141204.GD6222@mit.edu> <20090114143756.GF19950@duck.suse.cz>
	 <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Sat, 17 Jan 2009 19:00:49 +0900
Message-Id: <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 18:47 +0900, Fernando Luis Vázquez Cao wrote:
> On Fri, 2009-01-16 at 17:30 +0100, Jan Kara wrote:
> > On Fri 16-01-09 22:55:01, Fernando Luis Vázquez Cao wrote:
> > > To ensure that bits are truly on-disk after an fsync or fdatasync, we
> > > should force a disk flush explicitly when there is dirty data/metadata
> > > and the journal didn't emit a write barrier (either because metadata is
> > > not being synched or barriers are disabled).
> > > 
> > > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > > ---
> >   Only two minor nits:
> > 
> > > --- linux-2.6.29-rc1-orig/fs/ext3/fsync.c	2008-12-25 08:26:37.000000000 +0900
> > > +++ linux-2.6.29-rc1/fs/ext3/fsync.c	2009-01-16 22:18:53.000000000 +0900
> > > @@ -27,6 +27,7 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/writeback.h>
> > >  #include <linux/jbd.h>
> > > +#include <linux/blkdev.h>
> > >  #include <linux/ext3_fs.h>
> > >  #include <linux/ext3_jbd.h>
> > >  
> > > @@ -45,6 +46,8 @@
> > >  int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
> > >  {
> > >  	struct inode *inode = dentry->d_inode;
> > > +	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
> > > +	unsigned long i_state = inode->i_state;
> > >  	int ret = 0;
> > >  
> > >  	J_ASSERT(ext3_journal_current_handle() == NULL);
> > > @@ -69,23 +72,33 @@ int ext3_sync_file(struct file * file, s
> > >  	 */
> > >  	if (ext3_should_journal_data(inode)) {
> > >  		ret = ext3_force_commit(inode->i_sb);
> > > +		if (!(journal->j_flags & JFS_BARRIER))
> > > +			goto no_journal_barrier;
> > >  		goto out;
> > >  	}
> > >  
> > > -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> > > -		goto out;
> > > +	if (datasync && !(i_state & I_DIRTY_DATASYNC))
> > > +		goto flush_blkdev;
> > >  
> > >  	/*
> > >  	 * The VFS has written the file data.  If the inode is unaltered
> > >  	 * then we need not start a commit.
> > >  	 */
> > > -	if (inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
> > > +	if (i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC)) {
> > >  		struct writeback_control wbc = {
> > >  			.sync_mode = WB_SYNC_ALL,
> > >  			.nr_to_write = 0, /* sys_fsync did this */
> > >  		};
> > >  		ret = sync_inode(inode, &wbc);
> > > +		if (journal && !(journal->j_flags & JFS_BARRIER))
> > > +			goto no_journal_barrier;
> >   I cannot imagine "journal" will be NULL here.
> 
> I'll try to check whether that is always so just in case.
> 
> >   And we can also optimize here a bit and do "goto out" because here
> > we know the barrier has been issued.
> 
> Yep, I was considering the same optimization. By the way, I was
> wondering if we should honor ext3 and ext4's "barrier" mount option for
> sys_fsync()/sys_fdatasync() and do not force a flush when "barrier=1".

The last phrase should read " do not force a flush when "barrier=0" ".

Sorry for the noise.

- Fernando

