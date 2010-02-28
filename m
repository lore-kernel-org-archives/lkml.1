Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab0B1QOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:14:16 -0500
Received: from gw1.transmode.se ([213.115.205.20]:46704 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0B1QOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:14:15 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Feb 2010 11:14:15 EST
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH 2/2] crc32: Some minor cleanups
Date: Sun, 28 Feb 2010 17:06:03 +0100
Message-Id: <1267373163-10841-2-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-02-28 17:06:08,
	Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-02-28 17:06:08,
	Serialize complete at 2010-02-28 17:06:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/crc32.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 02e3b31..0f45fbf 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -30,11 +30,15 @@
 #include <asm/atomic.h>
 #include "crc32defs.h"
 #if CRC_LE_BITS == 8
-#define tole(x) __constant_cpu_to_le32(x)
-#define tobe(x) __constant_cpu_to_be32(x)
+# define tole(x) __constant_cpu_to_le32(x)
 #else
-#define tole(x) (x)
-#define tobe(x) (x)
+# define tole(x) (x)
+#endif
+
+#if CRC_BE_BITS == 8
+# define tobe(x) __constant_cpu_to_be32(x)
+#else
+# define tobe(x) (x)
 #endif
 #include "crc32table.h"
 
@@ -52,20 +56,19 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
 # else
 #  define DO_CRC(x) crc = tab[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
 # endif
-	const u32 *b = (const u32 *)buf;
+	const u32 *b;
 	size_t    rem_len;
 
 	/* Align it */
-	if (unlikely((long)b & 3 && len)) {
-		u8 *p = (u8 *)b;
+	if (unlikely((long)buf & 3 && len)) {
 		do {
-			DO_CRC(*p++);
-		} while ((--len) && ((long)p)&3);
-		b = (u32 *)p;
+			DO_CRC(*buf++);
+		} while ((--len) && ((long)buf)&3);
 	}
 	rem_len = len & 3;
 	/* load data 32 bits wide, xor data 32 bits wide. */
 	len = len >> 2;
+	b = (const u32 *)buf;
 	for (--b; len; --len) {
 		crc ^= *++b; /* use pre increment for speed */
 		DO_CRC(0);
@@ -82,6 +85,7 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 *tab)
 		} while (--len);
 	}
 	return crc;
+#undef DO_CRC
 }
 #endif
 /**
@@ -119,9 +123,6 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 	crc = __cpu_to_le32(crc);
 	crc = crc32_body(crc, p, len, tab);
 	return __le32_to_cpu(crc);
-#undef ENDIAN_SHIFT
-#undef DO_CRC
-
 # elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
@@ -179,9 +180,6 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 	crc = __cpu_to_be32(crc);
 	crc = crc32_body(crc, p, len, tab);
 	return __be32_to_cpu(crc);
-#undef ENDIAN_SHIFT
-#undef DO_CRC
-
 # elif CRC_BE_BITS == 4
 	while (len--) {
 		crc ^= *p++ << 24;
-- 
1.6.4.4

