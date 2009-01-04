Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZADLsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZADLsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZADLrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:15 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:59197 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZADLrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/7] fbdev: c2p - Extract common c2p core to c2p_core.h
Date: Sun,  4 Jan 2009 12:47:02 +0100
Message-Id: <1231069624-13362-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-5-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-4-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-5-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c      |   92 +---------------------------------------
 drivers/video/c2p_core.h |  106 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 91 deletions(-)
 create mode 100644 drivers/video/c2p_core.h

diff --git a/drivers/video/c2p.c b/drivers/video/c2p.c
index c170fff..1238c8b 100644
--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -3,10 +3,6 @@
  *
  *  Copyright (C) 2003-2008 Geert Uytterhoeven
  *
- *  NOTES:
- *    - This code was inspired by Scout's C2P tutorial
- *    - It assumes to run on a big endian system
- *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive
  *  for more details.
@@ -18,82 +14,7 @@
 #include <asm/unaligned.h>
 
 #include "c2p.h"
-
-
-    /*
-     *  Basic transpose step
-     */
-
-static inline void _transp(u32 d[], unsigned int i1, unsigned int i2,
-			   unsigned int shift, u32 mask)
-{
-	u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;
-
-	d[i1] ^= t;
-	d[i2] ^= t << shift;
-}
-
-extern void c2p_unsupported(void);
-
-static inline u32 get_mask(unsigned int n)
-{
-	switch (n) {
-	case 1:
-		return 0x55555555;
-
-	case 2:
-		return 0x33333333;
-
-	case 4:
-		return 0x0f0f0f0f;
-
-	case 8:
-		return 0x00ff00ff;
-
-	case 16:
-		return 0x0000ffff;
-	}
-
-	c2p_unsupported();
-	return 0;
-}
-
-static inline void transp8(u32 d[], unsigned int n, unsigned int m)
-{
-	u32 mask = get_mask(n);
-
-	switch (m) {
-	case 1:
-		/* First n x 1 block */
-		_transp(d, 0, 1, n, mask);
-		/* Second n x 1 block */
-		_transp(d, 2, 3, n, mask);
-		/* Third n x 1 block */
-		_transp(d, 4, 5, n, mask);
-		/* Fourth n x 1 block */
-		_transp(d, 6, 7, n, mask);
-		return;
-
-	case 2:
-		/* First n x 2 block */
-		_transp(d, 0, 2, n, mask);
-		_transp(d, 1, 3, n, mask);
-		/* Second n x 2 block */
-		_transp(d, 4, 6, n, mask);
-		_transp(d, 5, 7, n, mask);
-		return;
-
-	case 4:
-		/* Single n x 4 block */
-		_transp(d, 0, 4, n, mask);
-		_transp(d, 1, 5, n, mask);
-		_transp(d, 2, 6, n, mask);
-		_transp(d, 3, 7, n, mask);
-		return;
-	}
-
-	c2p_unsupported();
-}
+#include "c2p_core.h"
 
 
     /*
@@ -121,17 +42,6 @@ static const int perm_c2p_32x8[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
 
 
     /*
-     *  Compose two values, using a bitmask as decision value
-     *  This is equivalent to (a & mask) | (b & ~mask)
-     */
-
-static inline u32 comp(u32 a, u32 b, u32 mask)
-{
-	return ((a ^ b) & mask) ^ b;
-}
-
-
-    /*
      *  Store a full block of planar data after c2p conversion
      */
 
diff --git a/drivers/video/c2p_core.h b/drivers/video/c2p_core.h
new file mode 100644
index 0000000..3573cf7
--- /dev/null
+++ b/drivers/video/c2p_core.h
@@ -0,0 +1,106 @@
+/*
+ *  Fast C2P (Chunky-to-Planar) Conversion
+ *
+ *  Copyright (C) 2003-2008 Geert Uytterhoeven
+ *
+ *  NOTES:
+ *    - This code was inspired by Scout's C2P tutorial
+ *    - It assumes to run on a big endian system
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive
+ *  for more details.
+ */
+
+
+    /*
+     *  Basic transpose step
+     */
+
+static inline void _transp(u32 d[], unsigned int i1, unsigned int i2,
+			   unsigned int shift, u32 mask)
+{
+	u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;
+
+	d[i1] ^= t;
+	d[i2] ^= t << shift;
+}
+
+
+extern void c2p_unsupported(void);
+
+static inline u32 get_mask(unsigned int n)
+{
+	switch (n) {
+	case 1:
+		return 0x55555555;
+
+	case 2:
+		return 0x33333333;
+
+	case 4:
+		return 0x0f0f0f0f;
+
+	case 8:
+		return 0x00ff00ff;
+
+	case 16:
+		return 0x0000ffff;
+	}
+
+	c2p_unsupported();
+	return 0;
+}
+
+
+    /*
+     *  Transpose operations on 8 32-bit words
+     */
+
+static inline void transp8(u32 d[], unsigned int n, unsigned int m)
+{
+	u32 mask = get_mask(n);
+
+	switch (m) {
+	case 1:
+		/* First n x 1 block */
+		_transp(d, 0, 1, n, mask);
+		/* Second n x 1 block */
+		_transp(d, 2, 3, n, mask);
+		/* Third n x 1 block */
+		_transp(d, 4, 5, n, mask);
+		/* Fourth n x 1 block */
+		_transp(d, 6, 7, n, mask);
+		return;
+
+	case 2:
+		/* First n x 2 block */
+		_transp(d, 0, 2, n, mask);
+		_transp(d, 1, 3, n, mask);
+		/* Second n x 2 block */
+		_transp(d, 4, 6, n, mask);
+		_transp(d, 5, 7, n, mask);
+		return;
+
+	case 4:
+		/* Single n x 4 block */
+		_transp(d, 0, 4, n, mask);
+		_transp(d, 1, 5, n, mask);
+		_transp(d, 2, 6, n, mask);
+		_transp(d, 3, 7, n, mask);
+		return;
+	}
+
+	c2p_unsupported();
+}
+
+
+    /*
+     *  Compose two values, using a bitmask as decision value
+     *  This is equivalent to (a & mask) | (b & ~mask)
+     */
+
+static inline u32 comp(u32 a, u32 b, u32 mask)
+{
+	return ((a ^ b) & mask) ^ b;
+}
-- 
1.5.6.5

