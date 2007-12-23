Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXLWUYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXLWUYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbXLWUXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:23:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38053 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbXLWUXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:23:51 -0500
Date: Sun, 23 Dec 2007 15:23:28 -0500
Message-Id: <200712232023.lBNKNST6011525@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk
Subject: vfs_rmdir "bug"?
Cc: linux-kernel@vger.kernel.org
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Christoph,

vfs_rmdir is called from do_rmdir and does essentially this:

	dentry_unhash(dentry);
	error = dir->i_op->rmdir(dir, dentry);
	if (!error)
		d_delete(dentry);
	dput(dentry);


do_rmdir grabs a ref on the dentry to be rmdir'ed, and also dput's it (so
it's nice and symmetric).  But vfs_rmdir seems asymmetric esp. when ->rmdir
returns and error (e.g., -ENOTEMPTY):

1. on error, the dentry will remain unhashed: shouldn't it be re-hashed (the
   way vfs_rename_dir does)?

2. vfs_rmdir unconditionally dput's the dentry, but it never grabbed that
   ref in the first place.  Is this really necessary.  We had a good dentry
   in the dcache before the call to rmdir(2), but after this unconditional
   dput(), it'll be removed from the dcache.  This would cause the vfs to
   have to re-issue a lookup on it next time someone tries to do anything
   with that directory.

I discovered this while trying to figure out why an expected-to-fail rmdir
on unionfs (one of the ltp tests tests for -ENOTEMPTY) left a lower inode
behind until umount(2) was called.  I fixed it by implementing
unionfs_d_iput, but still, it seems odd that we'll have dropped/unhashed a
possibly good dentry b/c ->rmdir failed.

Thanks,
Erez.
