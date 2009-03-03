Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbZCCAHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbZCCAHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZCCAHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:07:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:43428 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbZCCAHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:07:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BIJFFezLXsVTzqCNgeEpaKT+ABkW0hgifgfNj60iZBmRuLDzQIEPK9muChVcMuMQQl
         mA1v2eOXnI+lOPcCBjTmX/BSRC60+2wZfqtmX6JYHCfYSut0lLPNcfSrIpkI+SilDl8C
         EJ4rcy7Y7r6HUK5N5ckUqp4Y0ke5xY45dtZpY=
Subject: [PATCH 1/2] byteorder: add load/store_{endian} API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:06:57 -0800
Message-Id: <1236038817.5756.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
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

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus,

I'd like you to consider this for 2.6.29 as it just adds the new API using
the old API as the implementation.  I've had multiple requests to get this
in so that the typesafe unaligned bits can be used in 2.6.30 without waiting
on the API additions to go in.

For 2.6.30 I have a series of patches to begin replacing users of the existing
bits (aligned and unaligned) and make the tangle of headers more sane, but getting
the API exposed would be great to avoid ordering headaches during the merge window.

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
1.6.2.rc2.289.g2fa25


