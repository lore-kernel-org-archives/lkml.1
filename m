Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYETSL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYETSL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbYETSGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:49 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3485 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbYETSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uM0fEDT7asMC12k1cNZp39qml6+1Q1QyzKEWf3iQdSziqAVQlsO2JMBC24Ld2z9Vouv5ah31A/YGe98GGCVTDDp2lp36j8igHCVM9IC4G22uHvgrohedmOXfMnhWBu46V4DQJFMTJZHcqIHrYo8RbQYvII0lTBt5kCbJasMit3s=
Subject: [PATCH 21/21] arch: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:18 -0700
Message-Id: <1211306778.5915.180.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/parisc/lib/iomap.c         |    4 ++--
 arch/powerpc/sysdev/qe_lib/qe.c |    2 +-
 arch/sparc64/kernel/unaligned.c |    8 ++++----
 arch/sparc64/lib/PeeCeeI.c      |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/parisc/lib/iomap.c b/arch/parisc/lib/iomap.c
index 9abed07..ac2f0eb 100644
--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -278,7 +278,7 @@ unsigned int ioread16(void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read16(addr);
-	return le16_to_cpup((u16 *)addr);
+	return get_le16(addr);
 }
 
 unsigned int ioread16be(void __iomem *addr)
@@ -292,7 +292,7 @@ unsigned int ioread32(void __iomem *addr)
 {
 	if (unlikely(INDIRECT_ADDR(addr)))
 		return iomap_ops[ADDR_TO_REGION(addr)]->read32(addr);
-	return le32_to_cpup((u32 *)addr);
+	return get_le32(addr);
 }
 
 unsigned int ioread32be(void __iomem *addr)
diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index cff550e..9f09707 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -528,7 +528,7 @@ int qe_upload_firmware(const struct qe_firmware *firmware)
 	}
 
 	/* Validate the CRC */
-	crc = be32_to_cpu(*(__be32 *)((void *)firmware + calc_size));
+	crc = get_be32((void *)firmware + calc_size);
 	if (crc != crc32(0, firmware, calc_size)) {
 		printk(KERN_ERR "qe-firmware: firmware CRC is invalid\n");
 		return -EIO;
diff --git a/arch/sparc64/kernel/unaligned.c b/arch/sparc64/kernel/unaligned.c
index 1a511e9..fe5b7fb 100644
--- a/arch/sparc64/kernel/unaligned.c
+++ b/arch/sparc64/kernel/unaligned.c
@@ -535,11 +535,11 @@ int handle_ldf_stq(u32 insn, struct pt_regs *regs)
 			u64 tmp;
 
 			switch (size) {
-			case 1: data[0] = le32_to_cpup(data + 0); break;
-			default:*(u64 *)(data + 0) = le64_to_cpup((u64 *)(data + 0));
+			case 1: data[0] = get_le32(data + 0); break;
+			default:*(u64 *)(data + 0) = get_le64(data + 0));
 				break;
-			case 4: tmp = le64_to_cpup((u64 *)(data + 0));
-				*(u64 *)(data + 0) = le64_to_cpup((u64 *)(data + 2));
+			case 4: tmp = get_le64(data + 0);
+				*(u64 *)(data + 0) = get_le64(data + 2);
 				*(u64 *)(data + 2) = tmp;
 				break;
 			}
diff --git a/arch/sparc64/lib/PeeCeeI.c b/arch/sparc64/lib/PeeCeeI.c
index 3c6cfbb..f85a50f 100644
--- a/arch/sparc64/lib/PeeCeeI.c
+++ b/arch/sparc64/lib/PeeCeeI.c
@@ -25,14 +25,14 @@ void outsw(unsigned long __addr, const void *src, unsigned long count)
 		u32 *pi;
 
 		if (((u64)src) & 0x2) {
-			u16 val = le16_to_cpup(ps);
+			u16 val = get_le16(ps);
 			outw(val, addr);
 			ps++;
 			count--;
 		}
 		pi = (u32 *)ps;
 		while (count >= 2) {
-			u32 w = le32_to_cpup(pi);
+			u32 w = get_le32(pi);
 
 			pi++;
 			outw(w >> 0, addr);
@@ -41,7 +41,7 @@ void outsw(unsigned long __addr, const void *src, unsigned long count)
 		}
 		ps = (u16 *)pi;
 		if (count) {
-			u16 val = le16_to_cpup(ps);
+			u16 val = get_le16(ps);
 			outw(val, addr);
 		}
 	}
-- 
1.5.5.1.570.g26b5e

