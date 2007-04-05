Return-Path: <linux-kernel-owner+w=401wt.eu-S1161121AbXDED5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161121AbXDED5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161128AbXDED5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:57:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4402 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161121AbXDED5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:57:24 -0400
X-IronPort-AV: i="4.14,373,1170651600"; 
   d="scan'208"; a="26394439:sNHT26180903"
Subject: [PATCH] Blackfin arch: sync with uClibc no functional changes
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <1175668055.10608.35.camel@roc-desktop>
References: <1175668055.10608.35.camel@roc-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 05 Apr 2007 11:59:04 +0800
Message-Id: <1175745544.17315.25.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/lib/memchr.S  |   31 +++++++++++++++++-----------
 arch/blackfin/lib/memcmp.S  |   46
++++++++++++++++++++++--------------------
 arch/blackfin/lib/memcpy.S  |   24 +++++++++++++++-------
 arch/blackfin/lib/memmove.S |   12 ++++++----
 arch/blackfin/lib/memset.S  |    2 +
 5 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/arch/blackfin/lib/memchr.S b/arch/blackfin/lib/memchr.S
index c4f1aab..4981222 100644
--- a/arch/blackfin/lib/memchr.S
+++ b/arch/blackfin/lib/memchr.S
@@ -29,24 +29,27 @@
 
 #include <linux/linkage.h>
 
-.align 2
-
-/*
- * C Library function MEMCHR
- * R0 = address
- * R1 = sought byte
- * R2 = count
+/* void *memchr(const void *s, int c, size_t n);
+ * R0 = address (s)
+ * R1 = sought byte (c)
+ * R2 = count (n)
+ *
  * Returns pointer to located character.
  */
 
+.text
+
+.align 2
+
 ENTRY(_memchr)
-	P0 = R0 ;             /* P0 = address */
-	P2 = R2 ;             /* P2 = count */
+	P0 = R0;		/* P0 = address */
+	P2 = R2;		/* P2 = count */
 	R1 = R1.B(Z);
 	CC = R2 == 0;
 	IF CC JUMP .Lfailed;
 
-.Lbytes: LSETUP (.Lbyte_loop_s , .Lbyte_loop_e) LC0=P2;
+.Lbytes:
+	LSETUP (.Lbyte_loop_s, .Lbyte_loop_e) LC0=P2;
 
 .Lbyte_loop_s:
 	R3 = B[P0++](Z);
@@ -55,9 +58,13 @@ ENTRY(_memchr)
 .Lbyte_loop_e:
 	NOP;
 
-.Lfailed: R0=0;
+.Lfailed:
+	R0=0;
 	RTS;
 
-.Lfound: R0 = P0;
+.Lfound:
+	R0 = P0;
 	R0 += -1;
 	RTS;
+
+.size _memchr,.-_memchr
diff --git a/arch/blackfin/lib/memcmp.S b/arch/blackfin/lib/memcmp.S
index e36fe8c..5b95023 100644
--- a/arch/blackfin/lib/memcmp.S
+++ b/arch/blackfin/lib/memcmp.S
@@ -29,39 +29,39 @@
 
 #include <linux/linkage.h>
 
-.align 2
-
-/*
- * C Library function MEMCMP
- * R0 = First Address
- * R1 = Second Address
- * R2 = count
+/* int memcmp(const void *s1, const void *s2, size_t n);
+ * R0 = First Address (s1)
+ * R1 = Second Address (s2)
+ * R2 = count (n)
+ *
  * Favours word aligned data.
  */
 
+.text
+
+.align 2
+
 ENTRY(_memcmp)
 	I1 = P3;
 	P0 = R0;			/* P0 = s1 address */
 	P3 = R1;			/* P3 = s2 Address  */
 	P2 = R2 ;			/* P2 = count */
 	CC = R2 <= 7(IU);
-	IF CC JUMP  .Ltoo_small;
+	IF CC JUMP .Ltoo_small;
 	I0 = R1;			/* s2 */
 	R1 = R1 | R0;		/* OR addresses together */
 	R1 <<= 30;		/* check bottom two bits */
 	CC =  AZ;			/* AZ set if zero. */
-	IF !CC JUMP  .Lbytes ;	/* Jump if addrs not aligned. */
+	IF !CC JUMP .Lbytes ;	/* Jump if addrs not aligned. */
 
 	P1 = P2 >> 2;		/* count = n/4 */
 	R3 =  3;
 	R2 = R2 & R3;		/* remainder */
 	P2 = R2;			/* set remainder */
 
-	LSETUP (.Lquad_loop_s , .Lquad_loop_e) LC0=P1;
+	LSETUP (.Lquad_loop_s, .Lquad_loop_e) LC0=P1;
 .Lquad_loop_s:
-	NOP;
-	R0 = [P0++];
-	R1 = [I0++];
+	MNOP || R0 = [P0++] || R1 = [I0++];
 	CC = R0 == R1;
 	IF !CC JUMP .Lquad_different;
 .Lquad_loop_e:
@@ -73,7 +73,7 @@ ENTRY(_memcmp)
 	IF CC JUMP .Lfinished;	/* very unlikely*/
 
 .Lbytes:
-	LSETUP (.Lbyte_loop_s , .Lbyte_loop_e) LC0=P2;
+	LSETUP (.Lbyte_loop_s, .Lbyte_loop_e) LC0=P2;
 .Lbyte_loop_s:
 	R1 = B[P3++](Z);	/* *s2 */
 	R0 = B[P0++](Z);	/* *s1 */
@@ -88,14 +88,14 @@ ENTRY(_memcmp)
 	RTS;
 
 .Lquad_different:
-/* We've read two quads which don't match.
- * Can't just compare them, because we're
- * a little-endian machine, so the MSBs of
- * the regs occur at later addresses in the
- * string.
- * Arrange to re-read those two quads again,
- * byte-by-byte.
- */
+	/* We've read two quads which don't match.
+	 * Can't just compare them, because we're
+	 * a little-endian machine, so the MSBs of
+	 * the regs occur at later addresses in the
+	 * string.
+	 * Arrange to re-read those two quads again,
+	 * byte-by-byte.
+	 */
 	P0 += -4;		/* back up to the start of the */
 	P3 = I0;		/* quads, and increase the*/
 	P2 += 4;		/* remainder count*/
@@ -106,3 +106,5 @@ ENTRY(_memcmp)
 	R0 = 0;
 	P3 = I1;
 	RTS;
+
+.size _memcmp,.-_memcmp
diff --git a/arch/blackfin/lib/memcpy.S b/arch/blackfin/lib/memcpy.S
index f757e1d..c1e00ef 100644
--- a/arch/blackfin/lib/memcpy.S
+++ b/arch/blackfin/lib/memcpy.S
@@ -35,6 +35,14 @@
 
 #include <linux/linkage.h>
 
+/* void *memcpy(void *dest, const void *src, size_t n);
+ * R0 = To Address (dest) (leave unchanged to form result)
+ * R1 = From Address (src)
+ * R2 = count
+ *
+ * Note: Favours word alignment
+ */
+
 #ifdef CONFIG_MEMCPY_L1
 .section .l1.text
 #else
@@ -44,8 +52,8 @@
 .align 2
 
 ENTRY(_memcpy)
-	CC = R2 <=  0;	/* length not positive?*/
-	IF CC JUMP  .L_P1L2147483647;	/* Nothing to do */
+	CC = R2 <=  0;	/* length not positive? */
+	IF CC JUMP .L_P1L2147483647;	/* Nothing to do */
 
 	P0 = R0 ;	/* dst*/
 	P1 = R1 ;	/* src*/
@@ -104,7 +112,7 @@ ENTRY(_memcpy)
 .Lbytes_left:	P2 = R3;
 .Lnot_aligned:
 	/* From here, we're copying byte-by-byte. */
-	LSETUP (.Lbyte_start , .Lbyte_end) LC0=P2;
+	LSETUP (.Lbyte_start, .Lbyte_end) LC0=P2;
 	R0 = R1;	/* Save src address for return */
 .Lbyte_start:
 	R1 = B[P1++] (X);
@@ -115,11 +123,11 @@ ENTRY(_memcpy)
 	RTS;
 
 .Lhas_overlap:
-/* Need to reverse the copying, because the
- * dst would clobber the src.
- * Don't bother to work out alignment for
- * the reverse case.
- */
+	/* Need to reverse the copying, because the
+	 * dst would clobber the src.
+	 * Don't bother to work out alignment for
+	 * the reverse case.
+	 */
 	R0 = R1;	/* save src for later. */
 	P0 = P0 + P2;
 	P0 += -1;
diff --git a/arch/blackfin/lib/memmove.S b/arch/blackfin/lib/memmove.S
index 4d4c48a..2e5fb7f 100644
--- a/arch/blackfin/lib/memmove.S
+++ b/arch/blackfin/lib/memmove.S
@@ -43,7 +43,7 @@ ENTRY(_memmove)
 	I1 = P3;
 	P0 = R0;                  /* P0 = To address */
 	P3 = R1;                  /* P3 = From Address */
-	P2 = R2 ;                 /* P2 = count */
+	P2 = R2;                  /* P2 = count */
 	CC = P2 == 0;             /* Check zero count*/
 	IF CC JUMP .Lfinished;    /* very unlikely */
 
@@ -55,11 +55,11 @@ ENTRY(_memmove)
 .Lno_overlap:
 	R3 = 11;
 	CC = R2 <= R3;
-	IF CC JUMP  .Lbytes;
+	IF CC JUMP .Lbytes;
 	R3 = R1 | R0;             /* OR addresses together */
 	R3 <<= 30;                /* check bottom two bits */
 	CC =  AZ;                 /* AZ set if zero.*/
-	IF !CC JUMP  .Lbytes ;    /* Jump if addrs not aligned.*/
+	IF !CC JUMP .Lbytes;      /* Jump if addrs not aligned.*/
 
 	I0 = P3;
 	P1 = P2 >> 2;             /* count = n/4 */
@@ -69,7 +69,7 @@ ENTRY(_memmove)
 	P2 = R2;                  /* set remainder */
 	R1 = [I0++];
 
-	LSETUP (.Lquad_loop , .Lquad_loop) LC0=P1;
+	LSETUP (.Lquad_loop, .Lquad_loop) LC0=P1;
 .Lquad_loop: MNOP || [P0++] = R1 || R1 = [I0++];
 	[P0++] = R1;
 
@@ -79,7 +79,7 @@ ENTRY(_memmove)
 	P3 = I1;
 	RTS;
 
-.Lbytes:     LSETUP (.Lbyte2_s , .Lbyte2_e) LC0=P2;
+.Lbytes:     LSETUP (.Lbyte2_s, .Lbyte2_e) LC0=P2;
 .Lbyte2_s:   R1 = B[P3++](Z);
 .Lbyte2_e:   B[P0++] = R1;
 
@@ -99,3 +99,5 @@ ENTRY(_memmove)
 .Lno_loop: B[P0] = R1;
 	P3 = I1;
 	RTS;
+
+.size _memmove,.-_memmove
diff --git a/arch/blackfin/lib/memset.S b/arch/blackfin/lib/memset.S
index 7d46fca..ba6d047 100644
--- a/arch/blackfin/lib/memset.S
+++ b/arch/blackfin/lib/memset.S
@@ -105,3 +105,5 @@ ENTRY(_memset)
 	B[P0++] = R1;
 	B[P0++] = R1;
 	JUMP .Laligned;
+
+.size _memset,.-_memset
-- 
1.5.0.5

