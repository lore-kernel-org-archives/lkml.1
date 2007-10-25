Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbXJYQei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbXJYQei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJYQe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:34:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbXJYQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:34:26 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/31] Remove iget() and read_inode() [try #5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:33:52 +0100
Message-ID: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Here's a set of patches that remove all calls to iget() and all read_inode()
functions.  They should be removed for two reasons: firstly they don't lend
themselves to good error handling, and secondly their presence is a temptation
for code outside a filesystem to call iget() to access inodes within that
filesystem.

There are a few benefits to this:

 (1) Error handling gets simpler as you can return an error code rather than
     having to call is_bad_inode().

 (2) You can now tell the difference between ENOMEM and EIO occurring in the
     read_inode() path.

 (3) The code should get smaller.  iget() is an inline function that is
     typically called 2-3 times per filesystem that uses it.  By folding the
     iget code into the read_inode code for each filesystem, it eliminates
     some duplication.

A tarball of the patches can be retrieved from:

	http://people.redhat.com/~dhowells/iget-remove.tar.bz2


Additionally, there are a couple of patches that introduce an ERR_CAST() macro
to be used instead of ERR_PTR(PTR_ERR(p)) constructs and apply it to all such
instances in the kernel.

Of the patches directly relevant to the subject:

The first patch adds a function, iget_failed() that is a canned piece of code
for killing an inode when the inode construction path fails.

The second and third patches makes AFS and GFS2 use iget_failed() rather than
interpolating the sequence directly.

The final patch removes iget() and read_inode().

Each of the other patches modify a filesystem that used iget() and read_inode()
to use iget_locked() instead.  The standard procedure was to convert:

	void thingyfs_read_inode(struct inode *inode)
	{
		...
	}

into:

	struct inode *thingyfs_iget(struct super_block *sp, unsigned long ino)
	{
		struct inode *inode;
		int ret;
		
		inode = iget_locked(sb, ino);
		if (!inode)
			return ERR_PTR(-ENOMEM);
		if (!(inode->i_state & I_NEW))
			return inode;

		...
		unlock_new_inode(inode);
		return inode;
	error:
		iget_failed(inode);
		return ERR_PTR(ret);
	}

and then call thingyfs_iget() rather than iget():

	ret = -EINVAL;
	inode = iget(sb, ino);
	if (!inode || is_bad_inode(inode))
		goto error;

becomes:

	inode = thingyfs_iget(sb, ino);
	if (IS_ERR(inode)) {
		ret = PTR_ERR(inode);
		goto error;
	}

There were exceptions; most notably it appeared FAT should be calling ilookup()
not iget().

Additionally, HPPFS and HOSTFS (UM-specific filesystems) really need checking:

 hostfs_kern.c:

 (*) hostfs_iget() should perhaps subsume init_inode() and hostfs_read_inode().

 (*) It would appear that all hostfs inodes are the same inode because iget()
     was being called with inode number 0 - which forms the lookup key.

 hppfs_kern.c:

 (*) The HPPFS inode retains a pointer to the proc dentry it is shadowing, but
     whilst it does appear to retain a reference to it, it doesn't appear to
     destroy the reference if the inode goes away.

 (*) hppfs_iget() should perhaps subsume init_inode() and hppfs_read_inode().

 (*) It would appear that all hppfs inodes are the same inode because iget()
     was being called with inode number 0, which forms the lookup key.

David
