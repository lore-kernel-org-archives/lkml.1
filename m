Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZF2M03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZF2M03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZF2M0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:26:21 -0400
Received: from recombinator.qemfd.net ([216.27.165.184]:34018 "EHLO qemfd.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752373AbZF2M0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:26:20 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 08:26:20 EDT
Date: Mon, 29 Jun 2009 08:16:57 -0400
From: nick black <dank@qemfd.net>
To: William Irwin <wli@holomorphy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       man-pages <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlbfs: publish HUGETLBFS_MAGIC via linux/magic.h
Message-ID: <20090629121657.GA9848@qemfd.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

statfs(2)'s man page (release 3.21) lists HUGETLBFS_MAGIC among the other
constants, as one would expect. It's not actually exported, though; it's
buried within inode.c in fs/hugetlbfs/ (iirc, the kvm userland code has
cut-and-pasted the definition into their sources). This patch brings the
exported interface into conformance with documentation, is necessary for
[f]statfs(2)-based verification of hugetlbfs mounts, and eliminates a
duplicate definition of TMPFS_MAGIC floating around in smack_lsm.c.

This is against 2.6.30-rc1. --rigorously, nick

Signed-off-by: Nick Black <dank@qemfd.net>
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31-rc1-pristine/fs/hugetlbfs/inode.c linux-2.6.31-rc1/fs/hugetlbfs/inode.c
--- linux-2.6.31-rc1-pristine/fs/hugetlbfs/inode.c	2009-06-24 19:25:37.000000000 -0400
+++ linux-2.6.31-rc1/fs/hugetlbfs/inode.c	2009-06-29 07:52:43.000000000 -0400
@@ -31,12 +31,10 @@
 #include <linux/statfs.h>
 #include <linux/security.h>
 #include <linux/ima.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 
-/* some random number */
-#define HUGETLBFS_MAGIC	0x958458f6
-
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31-rc1-pristine/include/linux/magic.h linux-2.6.31-rc1/include/linux/magic.h
--- linux-2.6.31-rc1-pristine/include/linux/magic.h	2009-06-24 19:25:37.000000000 -0400
+++ linux-2.6.31-rc1/include/linux/magic.h	2009-06-29 07:58:15.000000000 -0400
@@ -13,6 +13,7 @@
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
 #define TMPFS_MAGIC		0x01021994
+#define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
 #define SQUASHFS_MAGIC		0x73717368
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31-rc1-pristine/security/smack/smack_lsm.c linux-2.6.31-rc1/security/smack/smack_lsm.c
--- linux-2.6.31-rc1-pristine/security/smack/smack_lsm.c	2009-06-24 19:25:37.000000000 -0400
+++ linux-2.6.31-rc1/security/smack/smack_lsm.c	2009-06-29 07:54:28.000000000 -0400
@@ -30,6 +30,7 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include "smack.h"
 
 #define task_security(task)	(task_cred_xxx((task), security))
@@ -39,7 +40,6 @@
  */
 #define DEVPTS_SUPER_MAGIC	0x1cd1
 #define SOCKFS_MAGIC		0x534F434B
-#define TMPFS_MAGIC		0x01021994
 
 /**
  * smk_fetch - Fetch the smack label from a file.
-- 
                                      Nick Black <dankamongmen@acm.org>
                                             Principal Engineer, McAfee
                                  Grad student, GT College of Computing
                    "np: the class of dashed hopes, and idle dreams..."
