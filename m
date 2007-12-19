Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXLSRf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXLSRf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXLSRfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:35:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXLSRfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:35:12 -0500
Message-ID: <47695621.6040709@redhat.com>
Date: Wed, 19 Dec 2007 11:34:25 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Halcrow <mhalcrow@us.ibm.com>
CC: mike@halcrow.us, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] ecryptfs: redo dget,mntget on dentry_open failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Jeff Moyer for pointing this out.

If the RDWR dentry_open() in ecryptfs_init_persistent_file fails,
it will do a dput/mntput.  Need to re-take references if we
retry as RDONLY.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.24-rc3/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
+++ linux-2.6.24-rc3/fs/ecryptfs/main.c
@@ -138,11 +138,14 @@ int ecryptfs_init_persistent_file(struct
 		inode_info->lower_file = dentry_open(lower_dentry,
 						     lower_mnt,
 						     (O_RDWR | O_LARGEFILE));
-		if (IS_ERR(inode_info->lower_file))
+		if (IS_ERR(inode_info->lower_file)) {
+			dget(lower_dentry);
+			mntget(lower_mnt);
 			inode_info->lower_file = dentry_open(lower_dentry,
 							     lower_mnt,
 							     (O_RDONLY
 							      | O_LARGEFILE));
+		}
 		if (IS_ERR(inode_info->lower_file)) {
 			printk(KERN_ERR "Error opening lower persistent file "
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]\n",

