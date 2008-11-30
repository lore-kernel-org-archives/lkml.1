Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYK3Cku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYK3Cku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 21:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYK3Ckf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 21:40:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:23550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYK3Cke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 21:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Hfzx65otJEpAXPNRt2cXNxaP7z8uluI65kvF5Wq/ApQw87bG+53BPYwkaBd0EUbvvQ
         X/WewJBvihle+0JL1KFfIWn0hUc5qNCrGq+tGOJ8yMdggtxuYWsGT2wTxC/pipXkVvL5
         ildpKKdll9DNEtdKap4bMP8YQww9THJ4JL9vs=
Subject: [PATCH-mm 1/7] byteorder: add load_/store_{endian} API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 29 Nov 2008 18:40:29 -0800
Message-Id: <1228012829.26141.1026.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_le16 is a synonym for the existing le16_to_cpup and is added to
be symmetric with the load_le16_noalign API.  On arches where unaligned
access is OK, the unaligned calls are replaced with aligned calls.

store_le16 is a new API and is added to be symmetric with the unaligned
functions.  It is implemented as a macro to allow compile-time byteswapping
when the value is a constant.  This will also allow use in many places
currently that are of the form:

*(__le16 *)ptr = cpu_to_le16(foo);

In addition, some drivers/filesystems/arches already provide this API
privately, which will allow them to be consolidated into this common
code.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, the series become shorter if I just wire the aligned versions first
and then use them in the unaligned headers.

 include/linux/byteorder.h |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
index 29f002d..91cf7a5 100644
--- a/include/linux/byteorder.h
+++ b/include/linux/byteorder.h
@@ -292,6 +292,20 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 # define cpu_to_be32 __cpu_to_be32
 # define cpu_to_be64 __cpu_to_be64
 
+# define load_le16 __le16_to_cpup
+# define load_le32 __le32_to_cpup
+# define load_le64 __le64_to_cpup
+# define load_be16 __be16_to_cpup
+# define load_be32 __be32_to_cpup
+# define load_be64 __be64_to_cpup
+
+# define store_le16(p, val) (*(__le16 *)(p) = cpu_to_le16(val))
+# define store_le32(p, val) (*(__le32 *)(p) = cpu_to_le32(val))
+# define store_le64(p, val) (*(__le64 *)(p) = cpu_to_le64(val))
+# define store_be16(p, val) (*(__be16 *)(p) = cpu_to_be16(val))
+# define store_be32(p, val) (*(__be32 *)(p) = cpu_to_be32(val))
+# define store_be64(p, val) (*(__be64 *)(p) = cpu_to_be64(val))
+
 # define le16_to_cpup __le16_to_cpup
 # define le32_to_cpup __le32_to_cpup
 # define le64_to_cpup __le64_to_cpup
@@ -340,32 +354,32 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	*var = cpu_to_le16(le16_to_cpup(var) + val);
+	store_le16(var, load_le16(var) + val);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	*var = cpu_to_le32(le32_to_cpup(var) + val);
+	store_le32(var, load_le32(var) + val);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	*var = cpu_to_le64(le64_to_cpup(var) + val);
+	store_le64(var, load_le64(var) + val);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	*var = cpu_to_be16(be16_to_cpup(var) + val);
+	store_be16(var, load_be16(var) + val);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	*var = cpu_to_be32(be32_to_cpup(var) + val);
+	store_be32(var, load_be32(var) + val);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	*var = cpu_to_be64(be64_to_cpup(var) + val);
+	store_be64(var, load_be64(var) + val);
 }
 
 #endif /* __KERNEL__ */
-- 
1.6.0.4.1044.g77718


