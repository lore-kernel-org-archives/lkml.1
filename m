Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbXHUVVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbXHUVVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXHUVVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:21:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56863 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXHUVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:21:37 -0400
Date: Tue, 21 Aug 2007 17:21:28 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Jeff Layton <jlayton@redhat.com>
Cc: Timothy Shimmin <tes@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>
Subject: Re: [PATCH 2/4] Fix mainline filesystems to handle ATTR_KILL_ bits
	correctly
Message-ID: <20070821212128.GC1741@filer.fsl.cs.sunysb.edu>
References: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com> <46CA798C.1020101@sgi.com> <20070821073551.dac4a5dd.jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821073551.dac4a5dd.jlayton@redhat.com>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:35:51AM -0400, Jeff Layton wrote:
> On Tue, 21 Aug 2007 15:35:08 +1000
> Timothy Shimmin <tes@sgi.com> wrote:
> 
> > Jeff Layton wrote:
> > > This should fix all of the filesystems in the mainline kernels to handle
> > > ATTR_KILL_SUID and ATTR_KILL_SGID correctly. For most of them, this is
> > > just a matter of making sure that they call generic_attrkill early in
> > > the setattr inode op.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > ---
> > >  fs/xfs/linux-2.6/xfs_iops.c               |    5 ++++-
> > > --- a/fs/xfs/linux-2.6/xfs_iops.c
> > > +++ b/fs/xfs/linux-2.6/xfs_iops.c
> > > @@ -651,12 +651,15 @@ xfs_vn_setattr(
> > >  	struct iattr	*attr)
> > >  {
> > >  	struct inode	*inode = dentry->d_inode;
> > > -	unsigned int	ia_valid = attr->ia_valid;
> > > +	unsigned int	ia_valid;
> > >  	bhv_vnode_t	*vp = vn_from_inode(inode);
> > >  	bhv_vattr_t	vattr = { 0 };
> > >  	int		flags = 0;
> > >  	int		error;
> > >  
> > > +	generic_attrkill(inode->i_mode, attr);
> > > +	ia_valid = attr->ia_valid;
> > > +
> > >  	if (ia_valid & ATTR_UID) {
> > >  		vattr.va_mask |= XFS_AT_UID;
> > >  		vattr.va_uid = attr->ia_uid;
> > 
> > Looks reasonable to me for XFS.
> > Acked-by: Tim Shimmin <tes@sgi.com>
> > 
> > So before, this clearing would happen directly in notify_change()
> > and now this won't happen until notify_change() calls i_op->setattr
> > which for a particular fs it can call generic_attrkill() to do it.
> > So I guess for the cases where i_op->setattr is called outside of
> > via notify_change, we don't normally have ATTR_KILL_SUID/SGID
> > set so that nothing will happen there?
> 
> Right. If neither ATTR_KILL bit is set then generic_attrkill is a
> noop.
> 
> > I guess just wondering the effect with having the code on all
> > setattr's. (I'm not familiar with the code path)
> > 
> 
> These bits are referenced in very few places in the current kernel
> tree -- mostly in the VFS layer. The *only* place I see that they
> actually get interpreted into a mode change is in notify_change. So
> places that call setattr ops w/o going through notify_change are
> not likely to have those bits set.
> 
> But hypothetically, if a fs did set ATTR_KILL_* and call setattr
> directly, then the setattr would now include a mode change that
> clears setuid or setgid bits where it may not have before.

It almost sounds like an argument for a new inode op (NULL would use
generic_attr_kill).

Josef 'Jeff' Sipek.

-- 
A CRAY is the only computer that runs an endless loop in just 4 hours...
