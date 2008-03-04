Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYCDOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYCDOc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYCDOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:32:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbYCDOcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:32:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080303173620.GA9243@freya.fugue.com>
References: <20080303173620.GA9243@freya.fugue.com>
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Patch: romfs_lookup always failed in linux-2.6.25-rc3-git3
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 04 Mar 2008 14:32:43 +0000
Message-ID: <5368.1204641163@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam J. Richter <adam@yggdrasil.com> wrote:

> 	romfs_lookup worked in 2.6.24.2, but always fails in
> linux-2.6.25-rc3-git3.  fs/romfs/inode.c is the same in at least
> 2.6.25-rc3 through 2.6.25-rc3-git4 and the latest sources from git, so
> these versions almost certainly have the same problem.
> 
> 	The bug appears to be from a well meaning but botched attempt
> to eliminate a goto from romfs_lookup.  Previously, a goto statement
> was used to skip over "inode = NULL;" when the lookup succeeded.  In
> the 2.6.25-rc3 version, inode is set to NULL even when an inode was
> found, so the result is the the lookup always appears to fail.

No, the problem is that I've changed the sense of the condition of the
if-statement, but failed to notice:-(

> 	 The attached patch fixes the problem while still eliminating
> the goto.  The patch adds one line and replaces one line.  It only
> looks big because I've set the number of context lines to 10 for
> better readability.  I have tested it in on a romfs initial ramdisk
> which on which I had experienced the problem.

Looking at the code, the negative/error case is in the main flow, and was
jumped around by the positive case.  Your patch sets up the negative case in
advance as the default, thus meaning the positive case handles the negative
case too.  I like it.

> 	If this patch looks OK to you, can you please submit it
> upstream?

Perhaps.  Can you look over the attached patch as an alternative, please?

> P.S. romfs_lookup casts a valid pointer to an int and then back again
> with res = PTR_ERR(inode);...return ERR_PTR(res).  This may break on
> arhictectures where sizeof(int) < sizeof(pointer).

This is not true.  Note the if-statement in the following:

	inode = romfs_iget(dir->i_sb, offset);
	if (IS_ERR(inode)) {
		res = PTR_ERR(inode);
		goto out;
	}

Inside the if-statement, the pointer 'inode' is actually an integer in the
range -4095 to -1, and, as such, actually represents an error code.  Casting it
to an int and back will be fine.  A cleaner way to do it would be to avoid the
cast entirely, especially as it may avoid a couple of instructions on a 64-bit
platform (32/64-bit conversion).

David
---
ROMFS: Fix up an error in iget removal

From: David Howells <dhowells@redhat.com>

Fix up an error in iget removal in which romfs_lookup() making a successful
call to romfs_iget() continues through the negative/error handling (previously
the successful case jumped around the negative/error handling case):

 (1) inode is initialised to NULL at the top of the function, eliminating the
     need for specific negative-inode handling.  This means the positive
     success handling now flows straight through.

 (2) Rename the labels to be clearer about what they mean.

Also make romfs_lookup()'s result variable of type long so as to avoid
32-bit/64-bit conversions with PTR_ERR() and friends.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/romfs/inode.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)


diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 00b6f0a..3f13d49 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -340,8 +340,9 @@ static struct dentry *
 romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	unsigned long offset, maxoff;
-	int fslen, res;
-	struct inode *inode;
+	long res;
+	int fslen;
+	struct inode *inode = NULL;
 	char fsname[ROMFS_MAXFN];	/* XXX dynamic? */
 	struct romfs_inode ri;
 	const char *name;		/* got from dentry */
@@ -351,7 +352,7 @@ romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	offset = dir->i_ino & ROMFH_MASK;
 	lock_kernel();
 	if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
-		goto out;
+		goto error;
 
 	maxoff = romfs_maxsize(dir->i_sb);
 	offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
@@ -364,9 +365,9 @@ romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 
 	for(;;) {
 		if (!offset || offset >= maxoff)
-			goto out0;
+			goto success; /* negative success */
 		if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
-			goto out;
+			goto error;
 
 		/* try to match the first 16 bytes of name */
 		fslen = romfs_strnlen(dir, offset+ROMFH_SIZE, ROMFH_SIZE);
@@ -397,23 +398,14 @@ romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	inode = romfs_iget(dir->i_sb, offset);
 	if (IS_ERR(inode)) {
 		res = PTR_ERR(inode);
-		goto out;
+		goto error;
 	}
 
-	/*
-	 * it's a bit funky, _lookup needs to return an error code
-	 * (negative) or a NULL, both as a dentry.  ENOENT should not
-	 * be returned, instead we need to create a negative dentry by
-	 * d_add(dentry, NULL); and return 0 as no error.
-	 * (Although as I see, it only matters on writable file
-	 * systems).
-	 */
-
-out0:	inode = NULL;
+success:
+	d_add(dentry, inode);
 	res = 0;
-	d_add (dentry, inode);
-
-out:	unlock_kernel();
+error:
+	unlock_kernel();
 	return ERR_PTR(res);
 }
 

