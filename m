Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0BICk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:40:26 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50952 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab0BICkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:40:25 -0500
Message-Id: <1265683224.4096.1358983441@webmail.messagingengine.com>
X-Sasl-Enc: F2iWXKgkmmroIe2g2lHjaDKdgjgyF/wa3JDyVCyYXAum 1265683224
From: "Alex Viskovatoff" <viskovatoff@imap.cc>
To: "Evgeniy Dushistov" <dushistov@mail.ru>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
Subject: [PATCH] fs/ufs: Recognize Solaris-specific file system state
Date: Mon, 08 Feb 2010 21:40:24 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent releases of Solaris set the fs_clean state of an unmounted UFS file system as FSLOG ("logging fs"). However, the Linux kernel currently does not recognize the value which represents this state. Thus, attempting to mount such a file system rw produces the message

kernel: ufs_read_super: can't grok fs_clean 0xfffffffd

and the file system is mounted read-only. This patch makes the kernel recognize that value.

Signed-off-by: Alex Viskovatoff <viskovatoff@imap.cc>
---
The definitions I used in the patch can be found here:
http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/common/sys/fs/ufs_fs.h

--- linux-2.6.32.7-vanilla/fs/ufs/super.c	2010-01-28 18:06:20.000000000 -0500
+++ linux-2.6/fs/ufs/super.c	2010-02-07 14:56:39.933794932 -0500
@@ -965,6 +965,9 @@ magic_found:
 		case UFS_FSSTABLE:
 			UFSD("fs is stable\n");
 			break;
+		case UFS_FSLOG :
+			UFSD("fs is logging fs\n");
+			break;
 		case UFS_FSOSF1:
 			UFSD("fs is DEC OSF/1\n");
 			break;
diff -uprN -X linux-2.6.32.7-vanilla/Documentation/dontdiff linux-2.6.32.7-vanilla/fs/ufs/ufs_fs.h linux-2.6/fs/ufs/ufs_fs.h
--- linux-2.6.32.7-vanilla/fs/ufs/ufs_fs.h	2010-01-28 18:06:20.000000000 -0500
+++ linux-2.6/fs/ufs/ufs_fs.h	2010-02-08 17:32:49.392619575 -0500
@@ -138,6 +138,7 @@ typedef __u16 __bitwise __fs16;
 
 #define UFS_USEEFT  ((__u16)65535)
 
+/* fs_clean values */
 #define UFS_FSOK      0x7c269d38
 #define UFS_FSACTIVE  ((__s8)0x00)
 #define UFS_FSCLEAN   ((__s8)0x01)
@@ -145,6 +146,11 @@ typedef __u16 __bitwise __fs16;
 #define UFS_FSOSF1    ((__s8)0x03)	/* is this correct for DEC OSF/1? */
 #define UFS_FSBAD     ((__s8)0xff)
 
+/* Solaris-specific fs_clean values */
+#define UFS_FSSUSPEND ((__s8)0xfe)	/* temporarily suspended */
+#define UFS_FSLOG     ((__s8)0xfd)	/* logging fs */
+#define UFS_FSFIX     ((__s8)0xfc)	/* being repaired while mounted */
+
 /* From here to next blank line, s_flags for ufs_sb_info */
 /* directory entry encoding */
 #define UFS_DE_MASK		0x00000010	/* mask for the following */

