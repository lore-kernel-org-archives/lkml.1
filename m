Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZKKHlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZKKHlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZKKHlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:41:00 -0500
Received: from gw1.transmode.se ([213.115.205.20]:49489 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZKKHlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:41:00 -0500
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] crc32: minor optimizations and cleanup.
Date: Wed, 11 Nov 2009 08:40:41 +0100
Message-Id: <1257925241-13090-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-11 08:41:03,
	Serialize by Router on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-11 08:41:04,
	Serialize complete at 2009-11-11 08:41:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common crc body to new function crc32_body()
cleaup and micro optimize crc32_body for speed and less size.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/crc32.c |  121 +++++++++++++++++++++-------------------------------------
 1 files changed, 44 insertions(+), 77 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 49d1c9e..5b96189 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -42,6 +42,48 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");
 
+#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+
+static __inline__ u32
+crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
+{
+# ifdef __LITTLE_ENDIAN
+#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
+# else
+#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
+# endif
+	const u32 *b =(u32 *)buf;
+	size_t    rem_len;
+
+	/* Align it */
+	if(unlikely(((long)b)&3 && len)) {
+		u8 *p = (u8 *)b;
+		do {
+			DO_CRC(*p++);
+		} while ((--len) && ((long)p)&3);
+		b = (u32 *)p;
+	}
+	rem_len = len & 3;
+	/* load data 32 bits wide, xor data 32 bits wide. */
+	len = len >> 2;
+	for (--b; len; --len) {
+		crc ^= *++b; /* use pre increment for speed */
+		DO_CRC(0);
+		DO_CRC(0);
+		DO_CRC(0);
+		DO_CRC(0);
+	}
+	len = rem_len;
+	/* And the last few bytes */
+	if(len) {
+		u8 *p = (u8 *)(b + 1) - 1;
+		do {
+			DO_CRC(*++p); /* use pre increment for speed */
+		} while (--len);
+	}
+	return crc;
+}
+#endif
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -72,48 +114,10 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
-	const u32      *b =(u32 *)p;
 	const u32      *tab = crc32table_le;
 
-# ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
-# else
-#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
-# endif
-
 	crc = __cpu_to_le32(crc);
-	/* Align it */
-	if(unlikely(((long)b)&3 && len)){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
-		} while ((--len) && ((long)b)&3 );
-	}
-	if(likely(len >= 4)){
-		/* load data 32 bits wide, xor data 32 bits wide. */
-		size_t save_len = len & 3;
-	        len = len >> 2;
-		--b; /* use pre increment below(*++b) for speed */
-		do {
-			crc ^= *++b;
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-		} while (--len);
-		b++; /* point to next byte(s) */
-		len = save_len;
-	}
-	/* And the last few bytes */
-	if(len){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
-		} while (--len);
-	}
-
+	crc = crc32_body(crc, p, len, tab);
 	return __le32_to_cpu(crc);
 #undef ENDIAN_SHIFT
 #undef DO_CRC
@@ -170,47 +174,10 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
-	const u32      *b =(u32 *)p;
 	const u32      *tab = crc32table_be;
 
-# ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[ (crc ^ (x)) & 255 ] ^ (crc>>8)
-# else
-#  define DO_CRC(x) crc = tab[ ((crc >> 24) ^ (x)) & 255] ^ (crc<<8)
-# endif
-
 	crc = __cpu_to_be32(crc);
-	/* Align it */
-	if(unlikely(((long)b)&3 && len)){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (u32 *)p;
-		} while ((--len) && ((long)b)&3 );
-	}
-	if(likely(len >= 4)){
-		/* load data 32 bits wide, xor data 32 bits wide. */
-		size_t save_len = len & 3;
-	        len = len >> 2;
-		--b; /* use pre increment below(*++b) for speed */
-		do {
-			crc ^= *++b;
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-			DO_CRC(0);
-		} while (--len);
-		b++; /* point to next byte(s) */
-		len = save_len;
-	}
-	/* And the last few bytes */
-	if(len){
-		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
-		} while (--len);
-	}
+	crc = crc32_body(crc, p, len, tab);
 	return __be32_to_cpu(crc);
 #undef ENDIAN_SHIFT
 #undef DO_CRC
-- 
1.6.4.4

