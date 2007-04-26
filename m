Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbXDZGKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbXDZGKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXDZGKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:10:14 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:51018 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbXDZGKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:10:12 -0400
Date: Thu, 26 Apr 2007 02:10:10 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 09/12] selinux: explicitly number all selinuxfs inodes
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260209330.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Carter <jwcart2@tycho.nsa.gov>

Explicitly number all selinuxfs inodes to prevent a conflict between
inodes numbered using last_ino when created with new_inode() and those
labeled explicitly.

Signed-off-by: James Carter <jwcart2@tycho.nsa.gov>
Acked-by: Eric Paris <eparis@parisplace.org>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/selinuxfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index e24235c..1a786db 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -100,8 +100,11 @@ enum sel_inos {
 	SEL_MEMBER,	/* compute polyinstantiation membership decision */
 	SEL_CHECKREQPROT, /* check requested protection, not kernel-applied one */
 	SEL_COMPAT_NET,	/* whether to use old compat network packet controls */
+	SEL_INO_NEXT,	/* The next inode number to use */
 };
 
+static unsigned long sel_last_ino = SEL_INO_NEXT - 1;
+
 #define SEL_INITCON_INO_OFFSET 	0x01000000
 #define SEL_INO_MASK		0x00ffffff
 
@@ -1237,6 +1240,7 @@ static int sel_make_avc_files(struct dentry *dir)
 			goto out;
 		}
 		inode->i_fop = files[i].ops;
+		inode->i_ino = ++sel_last_ino;
 		d_add(dentry, inode);
 	}
 out:
@@ -1304,6 +1308,7 @@ static int sel_make_dir(struct inode *dir, struct dentry *dentry)
 	}
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
+	inode->i_ino = ++sel_last_ino;
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	d_add(dentry, inode);
@@ -1366,6 +1371,7 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 		ret = -ENOMEM;
 		goto err;
 	}
+	inode->i_ino = ++sel_last_ino;
 	isec = (struct inode_security_struct*)inode->i_security;
 	isec->sid = SECINITSID_DEVNULL;
 	isec->sclass = SECCLASS_CHR_FILE;
-- 
1.5.0.6

