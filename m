Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbYIPFcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbYIPFcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 01:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYIPFb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 01:31:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:41247 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbYIPFb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 01:31:58 -0400
Date: Tue, 16 Sep 2008 14:31:40 +0900 (JST)
Message-Id: <20080916.143140.75515448.ryusuke@osrg.net>
To: penberg@cs.helsinki.fi
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/27] nilfs2: pathname operations
From: konishi.ryusuke@lab.ntt.co.jp
In-Reply-To: <84144f020809151120u36338574y4577fa73ea3d222f@mail.gmail.com>
References: <1221419304-18572-18-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1221419304-18572-19-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<84144f020809151120u36338574y4577fa73ea3d222f@mail.gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka!

On Mon, 15 Sep 2008 21:20:23 +0300, "Pekka Enberg" wrote:
> Hi Ryusuke,
> 
> On Sun, Sep 14, 2008 at 10:08 PM, Ryusuke Konishi
> <konishi.ryusuke@lab.ntt.co.jp> wrote:
> > This adds pathname operations, most of which comes from the ext2 file
> > system.
> >
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> > +/*
> > + * By the time this is called, we already have created
> > + * the directory cache entry for the new file, but it
> > + * is so far negative - it has no inode.
> > + *
> > + * If the create succeeds, we fill in the inode information
> > + * with d_instantiate().
> > + */
> > +static int nilfs_create(struct inode *dir, struct dentry *dentry, int mode,
> > +                       struct nameidata *nd)
> > +{
> > +       struct inode *inode;
> > +       struct nilfs_transaction_info ti;
> > +       int err, err2;
> > +
> > +       err = nilfs_transaction_begin(dir->i_sb, &ti, 1);
> > +       if (err)
> > +               return err;
> > +       inode = nilfs_new_inode(dir, mode);
> > +       err = PTR_ERR(inode);
> > +       if (!IS_ERR(inode)) {
> > +               inode->i_op = &nilfs_file_inode_operations;
> > +               inode->i_fop = &nilfs_file_operations;
> > +               inode->i_mapping->a_ops = &nilfs_aops;
> > +               mark_inode_dirty(inode);
> > +               err = nilfs_add_nondir(dentry, inode);
> > +       }
> > +       err2 = nilfs_transaction_end(dir->i_sb, !err);
> 
> OK, I don't understand this. The only way nilfs_transaction_end() can
> fail is if we have NILFS_TI_SYNC set and we fail to construct the
> segment. But why do we want to construct a segment if we don't commit?
>
> I guess what I'm asking is why don't we have a separate
> nilfs_transaction_abort() function that can't fail for the erroneous
> case to avoid this double error value tracking thing?
> 
>                       Pekka

Yeah, that's quite right.  nilfs_transaction_end() should not call
nilfs_construct_segment() in the error case, and this double error
handling seems to be avoidable.

The ``commit'' argument of nilfs_transaction_end() is insufficient
because it does not cancel the commit state.

I'd like to correct these error hanlings by adding
nilfs_transaction_abort() as you told me.

Thank you for the comment.

Regards,
Ryusuke
