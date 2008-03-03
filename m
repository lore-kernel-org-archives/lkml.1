Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYCCRv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYCCRv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbYCCRvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:51:07 -0500
Received: from c-67-188-67-135.hsd1.ca.comcast.net ([67.188.67.135]:42206 "EHLO
	freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756561AbYCCRvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:51:04 -0500
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2008 12:51:03 EST
Date: Mon, 3 Mar 2008 09:36:20 -0800
From: "Adam J. Richter" <adam@yggdrasil.com>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Patch: romfs_lookup always failed in linux-2.6.25-rc3-git3
Message-ID: <20080303173620.GA9243@freya.fugue.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

	romfs_lookup worked in 2.6.24.2, but always fails in
linux-2.6.25-rc3-git3.  fs/romfs/inode.c is the same in at least
2.6.25-rc3 through 2.6.25-rc3-git4 and the latest sources from git, so
these versions almost certainly have the same problem.

	The bug appears to be from a well meaning but botched attempt
to eliminate a goto from romfs_lookup.  Previously, a goto statement
was used to skip over "inode = NULL;" when the lookup succeeded.  In
the 2.6.25-rc3 version, inode is set to NULL even when an inode was
found, so the result is the the lookup always appears to fail.

	 The attached patch fixes the problem while still eliminating
the goto.  The patch adds one line and replaces one line.  It only
looks big because I've set the number of context lines to 10 for
better readability.  I have tested it in on a romfs initial ramdisk
which on which I had experienced the problem.

	If this patch looks OK to you, can you please submit it
upstream?

P.S. romfs_lookup casts a valid pointer to an int and then back again
with res = PTR_ERR(inode);...return ERR_PTR(res).  This may break on
arhictectures where sizeof(int) < sizeof(pointer).  If I want to submit
a subsequent fix for this, are you the person I should the patch to?

Adam Richter

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="romfs.diff"

diff -U 8 -r linux-2.6.25-rc3-git3/fs/romfs/inode.c linux/fs/romfs/inode.c
--- linux-2.6.25-rc3-git3/fs/romfs/inode.c	2008-03-03 09:05:38.000000000 -0800
+++ linux/fs/romfs/inode.c	2008-03-03 09:06:03.000000000 -0800
@@ -342,16 +342,17 @@
 	unsigned long offset, maxoff;
 	int fslen, res;
 	struct inode *inode;
 	char fsname[ROMFS_MAXFN];	/* XXX dynamic? */
 	struct romfs_inode ri;
 	const char *name;		/* got from dentry */
 	int len;
 
+	inode = NULL;
 	res = -EACCES;			/* placeholder for "no data here" */
 	offset = dir->i_ino & ROMFH_MASK;
 	lock_kernel();
 	if (romfs_copyfrom(dir, &ri, offset, ROMFH_SIZE) <= 0)
 		goto out;
 
 	maxoff = romfs_maxsize(dir->i_sb);
 	offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
@@ -404,17 +405,17 @@
 	 * it's a bit funky, _lookup needs to return an error code
 	 * (negative) or a NULL, both as a dentry.  ENOENT should not
 	 * be returned, instead we need to create a negative dentry by
 	 * d_add(dentry, NULL); and return 0 as no error.
 	 * (Although as I see, it only matters on writable file
 	 * systems).
 	 */
 
-out0:	inode = NULL;
+out0:
 	res = 0;
 	d_add (dentry, inode);
 
 out:	unlock_kernel();
 	return ERR_PTR(res);
 }
 
 /*

--MGYHOYXEY6WxJCY8--
