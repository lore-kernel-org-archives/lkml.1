Return-Path: <linux-kernel-owner+w=401wt.eu-S1762418AbZAOHgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762418AbZAOHgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762251AbZAOHgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:36:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:3886 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762168AbZAOHg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VcxYXIZqeHyBgG0z1JTaCwDj/ASIVAnsWkyFPVvzfHRxlMsvOtHDtJhkLu7jN0wZDG
         3U3VG48MYy8IS8GqE2m3pvPjqS8Rdg9dmNt59Yfxok3ld1baq/f2pj5Ya5moOFOULOuo
         WkOlhCFdSXiK8wVW66MahXz7ce7MGyT7738zw=
Subject: [PATCH 1/7] byteorder: add load/store_{endian} api
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 23:36:25 -0800
Message-Id: <1232004985.5819.56.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_le16 is a synonym for the existing le16_to_cpup and is added to be
symmetric with the load_le16_noalign API.  On arches where unaligned
access is OK, the unaligned calls are replaced with aligned calls.

store_le16 is a new API and is added to be symmetric with the unaligned
functions.  It is implemented as a macro to allow compile-time
byteswapping when the value is a constant.  This will also allow use in
many places currently that are of the form:

*(__le16 *)ptr = cpu_to_le16(foo);

In addition, some drivers/filesystems/arches already provide this API
privately, which will allow them to be consolidated into this common code.

Also, on arches where load-swapped through a pointer is available, load_le16
is more efficient than le16_to_cpu(*ptr), and no worse on arches that don't
provide the load-swapped.  load_le16 is a shorter name and hopefully will
encourage more use of this API.  It will also make the aligned/unaligned
cases have a consistent namespace, making it easier to remember.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus, this set was in -mm for awhile and was only dropped recently due to the
byteorder churn (conditional include you disliked)

 include/linux/byteorder/generic.h |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b..621a506 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -119,6 +119,19 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
+#define load_le16 __le16_to_cpup
+#define load_le32 __le32_to_cpup
+#define load_le64 __le64_to_cpup
+#define load_be16 __be16_to_cpup
+#define load_be32 __be32_to_cpup
+#define load_be64 __be64_to_cpup
+#define store_le16(p, val) (*(__le16 *)(p) = cpu_to_le16(val))
+#define store_le32(p, val) (*(__le32 *)(p) = cpu_to_le32(val))
+#define store_le64(p, val) (*(__le64 *)(p) = cpu_to_le64(val))
+#define store_be16(p, val) (*(__be16 *)(p) = cpu_to_be16(val))
+#define store_be32(p, val) (*(__be32 *)(p) = cpu_to_be32(val))
+#define store_be64(p, val) (*(__be64 *)(p) = cpu_to_be64(val))
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
@@ -142,32 +155,32 @@
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
+	store_le16(var, load_le16(var) + val);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
+	store_le32(var, load_le32(var) + val);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
+	store_le64(var, load_le64(var) + val);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	*var = cpu_to_be16(be16_to_cpu(*var) + val);
+	store_be16(var, load_be16(var) + val);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
+	store_be32(var, load_be32(var) + val);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	*var = cpu_to_be64(be64_to_cpu(*var) + val);
+	store_be64(var, load_be64(var) + val);
 }
 
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
-- 
1.6.1.212.g4b3ec


