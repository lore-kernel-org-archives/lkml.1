Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbXJXOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbXJXOlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXJXOkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:40:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:53799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXJXOkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=izXBSEONEgdm+vcwtOvAwrTe72ibm3vq1AyQXRoJcgMqN2artrxcZmgOc7Z+Stn2TQpzgidCTc/wi9LHc+0XBC5yr7Ct5PAdFdSwYTXoS906M+e9IICYu4k6UVTYqFnZMBGfvRkCj2eFhe8ZNXG+Z240H5TJ7ITzLKssHHR7S3I=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix "passing argument # of '__memcpy' discards qualifiers from pointer target type" warnings
Date: Wed, 24 Oct 2007 16:39:46 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710241639.46986.mboton.lkml@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the warnings "passing argument 1 of '__memcpy' discards 
qualifiers from pointer target type" and "passing argument 2 of '__memcpy' 
discards qualifiers from pointer target type" when compiling some files.

I don't really know if this is the best way but at least I don't get more 
warnings.


diff -ruN linux-2.6.24-rc1.orig/fs/cifs/dir.c linux-2.6.24-rc1/fs/cifs/dir.c
--- linux-2.6.24-rc1.orig/fs/cifs/dir.c	2007-10-24 16:06:42.000000000 +0200
+++ linux-2.6.24-rc1/fs/cifs/dir.c	2007-10-24 15:49:44.000000000 +0200
@@ -585,6 +585,7 @@
 			   struct qstr *b)
 {
 	struct nls_table *codepage = CIFS_SB(dentry->d_inode->i_sb)->local_nls;
+	unsigned char *dstname = (unsigned char *)a->name;
 
 	if ((a->len == b->len) &&
 	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0)) {
@@ -593,7 +594,7 @@
 		 * case take precedence.  If a is not a negative dentry, this
 		 * should have no side effects
 		 */
-		memcpy((unsigned char *)a->name, b->name, a->len);
+		memcpy(dstname, b->name, a->len);
 		return 0;
 	}
 	return 1;
diff -ruN linux-2.6.24-rc1.orig/fs/jfs/namei.c linux-2.6.24-rc1/fs/jfs/namei.c
--- linux-2.6.24-rc1.orig/fs/jfs/namei.c	2007-10-24 16:06:43.000000000 +0200
+++ linux-2.6.24-rc1/fs/jfs/namei.c	2007-10-24 15:40:34.000000000 +0200
@@ -1580,6 +1580,7 @@
 
 static int jfs_ci_compare(struct dentry *dir, struct qstr *a, struct qstr *b)
 {
+	unsigned char *dstname = (unsigned char *)a->name;
 	int i, result = 1;
 
 	if (a->len != b->len)
@@ -1597,7 +1598,7 @@
 	 * dentry, we blindly replace it with b.  This should be harmless if
 	 * a is not a negative dentry.
 	 */
-	memcpy((unsigned char *)a->name, b->name, a->len);
+	memcpy(dstname, b->name, a->len);
 out:
 	return result;
 }
diff -ruN linux-2.6.24-rc1.orig/fs/smbfs/cache.c 
linux-2.6.24-rc1/fs/smbfs/cache.c
--- linux-2.6.24-rc1.orig/fs/smbfs/cache.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.24-rc1/fs/smbfs/cache.c	2007-10-24 16:01:46.000000000 +0200
@@ -145,9 +145,10 @@
 		if (!newdent)
 			goto end_advance;
 	} else {
+		char *dstname = (char *)newdent->d_name.name;
+
 		hashed = 1;
-		memcpy((char *) newdent->d_name.name, qname->name,
-		       newdent->d_name.len);
+		memcpy(dstname, qname->name, newdent->d_name.len);
 	}
 
 	if (!newdent->d_inode) {
diff -ruN linux-2.6.24-rc1.orig/include/asm-x86/io_32.h 
linux-2.6.24-rc1/include/asm-x86/io_32.h
--- linux-2.6.24-rc1.orig/include/asm-x86/io_32.h	2007-10-24 
16:06:45.000000000 +0200
+++ linux-2.6.24-rc1/include/asm-x86/io_32.h	2007-10-24 15:56:42.000000000 
+0200
@@ -208,7 +208,8 @@
 static inline void
 memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
 {
-	__memcpy(dst, (const void __force *)src, count);
+	const void __force *src1 = (const void __force *)src;
+	__memcpy(dst, src1, count);
 }
 
 static inline void

-- 
	Miguel Botón
