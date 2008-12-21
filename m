Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYLUPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYLUPCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYLUPCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:02:02 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:59356 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYLUPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:02:00 -0500
Message-Id: <20081221150122.756673142@mail.of.borg>
References: <20081221150059.844577615@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 21 Dec 2008 16:01:03 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/6] fbdev: c2p - Extract common c2p core to c2p_core.h
Content-Disposition: inline; filename=c2p-extract-common.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c      |   87 ----------------------------------------
 drivers/video/c2p_core.h |  101 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 86 deletions(-)

--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -15,80 +15,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include "c2p.h"
-
-
-    /*
-     *  Basic transpose step
-     */
-
-#define _transp(d, i1, i2, shift, mask)			\
-    do {						\
-	u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;	\
-	d[i1] ^= t;					\
-	d[i2] ^= t << shift;				\
-    } while (0)
-
-static inline u32 get_mask(int n)
-{
-    switch (n) {
-	case 1:
-	    return 0x55555555;
-	    break;
-
-	case 2:
-	    return 0x33333333;
-	    break;
-
-	case 4:
-	    return 0x0f0f0f0f;
-	    break;
-
-	case 8:
-	    return 0x00ff00ff;
-	    break;
-
-	case 16:
-	    return 0x0000ffff;
-	    break;
-    }
-    return 0;
-}
-
-#define transp8_nx1(d, n)				\
-    do {						\
-	u32 mask = get_mask(n);				\
-	/* First block */				\
-	_transp(d, 0, 1, n, mask);			\
-	/* Second block */				\
-	_transp(d, 2, 3, n, mask);			\
-	/* Third block */				\
-	_transp(d, 4, 5, n, mask);			\
-	/* Fourth block */				\
-	_transp(d, 6, 7, n, mask);			\
-    } while (0)
-
-#define transp8_nx2(d, n)				\
-    do {						\
-	u32 mask = get_mask(n);				\
-	/* First block */				\
-	_transp(d, 0, 2, n, mask);			\
-	_transp(d, 1, 3, n, mask);			\
-	/* Second block */				\
-	_transp(d, 4, 6, n, mask);			\
-	_transp(d, 5, 7, n, mask);			\
-    } while (0)
-
-#define transp8_nx4(d, n)				\
-    do {						\
-	u32 mask = get_mask(n);				\
-	/* Single block */				\
-	_transp(d, 0, 4, n, mask);			\
-	_transp(d, 1, 5, n, mask);			\
-	_transp(d, 2, 6, n, mask);			\
-	_transp(d, 3, 7, n, mask);			\
-    } while (0)
-
-#define transp8(d, n, m)	transp8_nx ## m(d, n)
+#include "c2p_core.h"
 
 
     /*
@@ -116,18 +43,6 @@ static const int perm_c2p_32x8[8] = { 7,
 
 
     /*
-     *  Compose two values, using a bitmask as decision value
-     *  This is equivalent to (a & mask) | (b & ~mask)
-     */
-
-static inline unsigned long comp(unsigned long a, unsigned long b,
-				 unsigned long mask)
-{
-	return ((a ^ b) & mask) ^ b;
-}
-
-
-    /*
      *  Store a full block of planar data after c2p conversion
      */
 
--- /dev/null
+++ b/drivers/video/c2p_core.h
@@ -0,0 +1,101 @@
+/*
+ *  Fast C2P (Chunky-to-Planar) Conversion
+ *
+ *  Copyright (C) 2003-2008 Geert Uytterhoeven
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
+#define _transp(d, i1, i2, shift, mask)				\
+	do {							\
+		u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;	\
+		d[i1] ^= t;					\
+		d[i2] ^= t << shift;				\
+	} while (0)
+
+
+static inline u32 get_mask(int n)
+{
+	switch (n) {
+	case 1:
+		return 0x55555555;
+		break;
+
+	case 2:
+		return 0x33333333;
+		break;
+
+	case 4:
+		return 0x0f0f0f0f;
+		break;
+
+	case 8:
+		return 0x00ff00ff;
+		break;
+
+	case 16:
+		return 0x0000ffff;
+		break;
+	}
+	return 0;
+}
+
+
+    /*
+     *  Transpose operations on 8 32-bit words
+     */
+
+#define transp8_nx1(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* First block */				\
+		_transp(d, 0, 1, n, mask);			\
+		/* Second block */				\
+		_transp(d, 2, 3, n, mask);			\
+		/* Third block */				\
+		_transp(d, 4, 5, n, mask);			\
+		/* Fourth block */				\
+		_transp(d, 6, 7, n, mask);			\
+	} while (0)
+
+#define transp8_nx2(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* First block */				\
+		_transp(d, 0, 2, n, mask);			\
+		_transp(d, 1, 3, n, mask);			\
+		/* Second block */				\
+		_transp(d, 4, 6, n, mask);			\
+		_transp(d, 5, 7, n, mask);			\
+	} while (0)
+
+#define transp8_nx4(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* Single block */				\
+		_transp(d, 0, 4, n, mask);			\
+		_transp(d, 1, 5, n, mask);			\
+		_transp(d, 2, 6, n, mask);			\
+		_transp(d, 3, 7, n, mask);			\
+	} while (0)
+
+#define transp8(d, n, m)	transp8_nx ## m(d, n)
+
+
+    /*
+     *  Compose two values, using a bitmask as decision value
+     *  This is equivalent to (a & mask) | (b & ~mask)
+     */
+
+static inline unsigned long comp(unsigned long a, unsigned long b,
+				 unsigned long mask)
+{
+	return ((a ^ b) & mask) ^ b;
+}

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

