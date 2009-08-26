Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZHZGpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZHZGpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZHZGpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:45:54 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:57633
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755365AbZHZGpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:45:52 -0400
Subject: Subject: [PATCH 29/33] score: create lib/ files ashrdi3.c
	ashldi3.c lshrdi3.c checksum.S checksum_copy.c
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:35:38 +0800
Message-Id: <1251268538.3204.6.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8064145644006b319c7f1b6939b77de849ef802a Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:11 +0800
Subject: [PATCH 29/33] score: create lib/ files ashrdi3.c ashldi3.c lshrdi3.c checksum.S checksum_copy.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/lib/ashldi3.c       |   46 +++++++
 arch/score/lib/ashrdi3.c       |   48 ++++++++
 arch/score/lib/checksum.S      |  255 ++++++++++++++++++++++++++++++++++++++++
 arch/score/lib/checksum_copy.c |   52 ++++++++
 arch/score/lib/lshrdi3.c       |   47 ++++++++
 5 files changed, 448 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/lib/ashldi3.c
 create mode 100644 arch/score/lib/ashrdi3.c
 create mode 100644 arch/score/lib/checksum.S
 create mode 100644 arch/score/lib/checksum_copy.c
 create mode 100644 arch/score/lib/lshrdi3.c

diff --git a/arch/score/lib/ashldi3.c b/arch/score/lib/ashldi3.c
new file mode 100644
index 0000000..15691a9
--- /dev/null
+++ b/arch/score/lib/ashldi3.c
@@ -0,0 +1,46 @@
+/*
+ * arch/score/lib/ashldi3.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+long long __ashldi3(long long u, word_type b)
+{
+	DWunion uu, w;
+	word_type bm;
+
+	if (b == 0)
+		return u;
+
+	uu.ll = u;
+	bm = 32 - b;
+
+	if (bm <= 0) {
+		w.s.low = 0;
+		w.s.high = (unsigned int) uu.s.low << -bm;
+	} else {
+		const unsigned int carries = (unsigned int) uu.s.low >> bm;
+
+		w.s.low = (unsigned int) uu.s.low << b;
+		w.s.high = ((unsigned int) uu.s.high << b) | carries;
+	}
+
+	return w.ll;
+}
+EXPORT_SYMBOL(__ashldi3);
diff --git a/arch/score/lib/ashrdi3.c b/arch/score/lib/ashrdi3.c
new file mode 100644
index 0000000..d9814a5
--- /dev/null
+++ b/arch/score/lib/ashrdi3.c
@@ -0,0 +1,48 @@
+/*
+ * arch/score/lib/ashrdi3.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+long long __ashrdi3(long long u, word_type b)
+{
+	DWunion uu, w;
+	word_type bm;
+
+	if (b == 0)
+		return u;
+
+	uu.ll = u;
+	bm = 32 - b;
+
+	if (bm <= 0) {
+		/* w.s.high = 1..1 or 0..0 */
+		w.s.high =
+		    uu.s.high >> 31;
+		w.s.low = uu.s.high >> -bm;
+	} else {
+		const unsigned int carries = (unsigned int) uu.s.high << bm;
+
+		w.s.high = uu.s.high >> b;
+		w.s.low = ((unsigned int) uu.s.low >> b) | carries;
+	}
+
+	return w.ll;
+}
+EXPORT_SYMBOL(__ashrdi3);
diff --git a/arch/score/lib/checksum.S b/arch/score/lib/checksum.S
new file mode 100644
index 0000000..706157e
--- /dev/null
+++ b/arch/score/lib/checksum.S
@@ -0,0 +1,255 @@
+/*
+ * arch/score/lib/csum_partial.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/linkage.h>
+
+#define ADDC(sum,reg)			\
+	add	sum, sum, reg;		\
+	cmp.c	reg, sum;		\
+	bleu	9f;			\
+	addi	sum, 0x1;		\
+9:
+
+#define CSUM_BIGCHUNK(src, offset, sum)		\
+	lw	r8, [src, offset + 0x00];	\
+	lw	r9, [src, offset + 0x04];	\
+	lw	r10, [src, offset + 0x08];	\
+	lw	r11, [src, offset + 0x0c];	\
+	ADDC(sum, r8);				\
+	ADDC(sum, r9);				\
+	ADDC(sum, r10);				\
+	ADDC(sum, r11);				\
+	lw	r8, [src, offset + 0x10];	\
+	lw	r9, [src, offset + 0x14];	\
+	lw	r10, [src, offset + 0x18]; 	\
+	lw	r11, [src, offset + 0x1c]; 	\
+	ADDC(sum, r8);				\
+	ADDC(sum, r9);				\
+	ADDC(sum, r10);				\
+	ADDC(sum, r11);				\
+
+#define src r4
+#define dest r5
+#define sum r27
+
+	.text
+/* unknown src alignment and < 8 bytes to go */
+small_csumcpy:
+	mv	r5, r10
+	ldi	r9, 0x0
+	cmpi.c	r25, 0x1
+	beq pass_small_set_t7	/*already set, jump to pass_small_set_t7*/
+	andri.c	r25,r4 , 0x1	/*Is src 2 bytes aligned?*/
+
+pass_small_set_t7:
+	beq	aligned
+	cmpi.c	r5, 0x0
+	beq	fold
+	lbu	r9, [src]
+	slli	r9,r9, 0x8	/*Little endian*/
+	ADDC(sum, r9)
+	addi	src, 0x1
+	subi.c	r5, 0x1
+
+	/*len still a full word */
+aligned:
+	andri.c r8, r5, 0x4	/*Len >= 4?*/
+	beq	len_less_4bytes
+
+	/* Still a full word (4byte) to go,and the src is word aligned.*/
+	andri.c	r8, src, 0x3	/*src is 4bytes aligned, so use LW!!*/
+	beq	four_byte_aligned
+	lhu 	r9, [src]
+	addi	src, 2
+	ADDC(sum, r9)
+	lhu 	r9, [src]
+	addi	src, 2
+	ADDC(sum, r9)
+	b len_less_4bytes
+
+four_byte_aligned:		/* Len >=4 and four byte aligned */
+	lw	r9, [src]
+	addi	src, 4
+	ADDC(sum, r9)
+
+len_less_4bytes:		/* 2 byte aligned aligned and length<4B */
+	andri.c r8, r5, 0x2
+	beq	len_less_2bytes
+	lhu	r9, [src]
+	addi	src, 0x2	/* src+=2 */
+	ADDC(sum, r9)
+
+len_less_2bytes:		/* len = 1 */
+	andri.c r8, r5, 0x1
+	beq 	fold		/* less than 2 and not equal 1--> len=0 -> fold */
+	lbu	r9, [src]
+
+fold_ADDC:
+	ADDC(sum, r9)
+fold:
+	/* fold checksum */
+	slli	r26, sum, 16
+	add	sum, sum, r26
+	cmp.c	r26, sum
+	srli	sum, sum, 16
+	bleu 	1f 		/* if r26<=sum */
+	addi	sum, 0x1 	/* r26>sum */
+1:
+	/* odd buffer alignment? r25 was set in csum_partial */
+	cmpi.c	r25, 0x0
+	beq	1f
+	slli	r26, sum, 8
+	srli	sum, sum, 8
+	or	sum, sum, r26
+	andi	sum, 0xffff
+1:
+	.set	optimize
+	/* Add the passed partial csum. */
+	ADDC(sum, r6)
+	mv	r4, sum
+	br	r3
+	.set	volatile
+
+	.align	5
+ENTRY(csum_partial)
+	ldi sum, 0
+	ldi r25, 0
+	mv r10, r5
+	cmpi.c	r5, 0x8
+	blt	small_csumcpy		/* < 8(singed) bytes to copy */
+	cmpi.c	r5, 0x0
+	beq	out
+	andri.c	r25, src, 0x1		/* odd buffer? */
+
+	beq	word_align
+hword_align:				/* 1 byte */
+	lbu	r8, [src]
+	subi	r5, 0x1
+	slli	r8, r8, 8
+	ADDC(sum, r8)
+	addi	src, 0x1
+
+word_align:				/* 2 bytes */
+	andri.c r8, src, 0x2		/* 4bytes(dword)_aligned? */
+	beq	dword_align		/* not, maybe dword_align */
+	lhu	r8, [src]
+	subi	r5, 0x2
+	ADDC(sum, r8)
+	addi	src, 0x2
+
+dword_align:				/* 4bytes */
+	mv 	r26, r5			/* maybe useless when len >=56 */
+	ldi 	r8, 56
+	cmp.c	r8, r5
+	bgtu	do_end_words		/* if a1(len)<t0(56) ,unsigned */
+	andri.c	r26, src, 0x4
+	beq	qword_align
+	lw	r8, [src]
+	subi	r5, 0x4
+	ADDC(sum, r8)
+	addi	src, 0x4
+
+qword_align:				/* 8 bytes */
+	andri.c r26, src, 0x8
+	beq	oword_align
+	lw	r8, [src, 0x0]
+	lw	r9, [src, 0x4]
+	subi	r5, 0x8			/* len-=0x8 */
+	ADDC(sum, r8)
+	ADDC(sum, r9)
+	addi	src, 0x8
+
+oword_align:				/* 16bytes */
+	andri.c	r26, src, 0x10
+	beq	begin_movement
+	lw	r10, [src, 0x08]
+	lw	r11, [src, 0x0c]
+	lw	r8, [src, 0x00]
+	lw	r9, [src, 0x04]
+	ADDC(sum, r10)
+	ADDC(sum, r11)
+	ADDC(sum, r8)
+	ADDC(sum, r9)
+	subi	r5, 0x10
+	addi	src, 0x10
+
+begin_movement:
+	srli.c	r26, r5, 0x7		/* len>=128? */
+	beq	1f			/* len<128 */
+
+/* r26 is the result that computed in oword_align */
+move_128bytes:
+	CSUM_BIGCHUNK(src, 0x00, sum)
+	CSUM_BIGCHUNK(src, 0x20, sum)
+	CSUM_BIGCHUNK(src, 0x40, sum)
+	CSUM_BIGCHUNK(src, 0x60, sum)
+	subi.c	r26, 0x01		/* r26 equals len/128 */
+	addi	src, 0x80
+	bne	move_128bytes
+
+1:	/* len<128,we process 64byte here */
+	andri.c	r10, r5, 0x40
+	beq	1f
+
+move_64bytes:
+	CSUM_BIGCHUNK(src, 0x00, sum)
+	CSUM_BIGCHUNK(src, 0x20, sum)
+	addi	src, 0x40
+
+1:					/* len<64 */
+	andri	r26, r5, 0x1c		/* 0x1c=28 */
+	andri.c	r10, r5, 0x20
+	beq	do_end_words		/* decided by andri */
+
+move_32bytes:
+	CSUM_BIGCHUNK(src, 0x00, sum)
+	andri	r26, r5, 0x1c
+	addri	src, src, 0x20
+
+do_end_words:				/* len<32 */
+	/* r26 was set already in dword_align */
+	cmpi.c	r26, 0x0
+	beq	maybe_end_cruft		/* len<28 or len<56 */
+	srli	r26, r26, 0x2
+
+end_words:
+	lw	r8, [src]
+	subi.c	r26, 0x1		/* unit is 4 byte */
+	ADDC(sum, r8)
+	addi	src, 0x4
+	cmpi.c	r26, 0x0
+	bne	end_words		/* r26!=0 */
+
+maybe_end_cruft:			/* len<4 */
+	andri	r10, r5, 0x3
+
+small_memcpy:
+	mv	r5, r10
+	j	small_csumcpy
+
+out:
+	mv	r4, sum
+	br	r3
+
+END(csum_partial)
diff --git a/arch/score/lib/checksum_copy.c b/arch/score/lib/checksum_copy.c
new file mode 100644
index 0000000..04565dd
--- /dev/null
+++ b/arch/score/lib/checksum_copy.c
@@ -0,0 +1,52 @@
+/*
+ * arch/score/lib/csum_partial_copy.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <net/checksum.h>
+
+#include <asm/uaccess.h>
+
+unsigned int csum_partial_copy(const char *src, char *dst,
+				int len, unsigned int sum)
+{
+	sum = csum_partial(src, len, sum);
+	memcpy(dst, src, len);
+
+	return sum;
+}
+
+unsigned int csum_partial_copy_from_user(const char *src, char *dst,
+					int len, unsigned int sum,
+					int *err_ptr)
+{
+	int missing;
+
+	missing = copy_from_user(dst, src, len);
+	if (missing) {
+		memset(dst + len - missing, 0, missing);
+		*err_ptr = -EFAULT;
+	}
+
+	return csum_partial(dst, len, sum);
+}
diff --git a/arch/score/lib/lshrdi3.c b/arch/score/lib/lshrdi3.c
new file mode 100644
index 0000000..ce21175
--- /dev/null
+++ b/arch/score/lib/lshrdi3.c
@@ -0,0 +1,47 @@
+/*
+ * arch/score/lib/lshrdi3.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+long long __lshrdi3(long long u, word_type b)
+{
+	DWunion uu, w;
+	word_type bm;
+
+	if (b == 0)
+		return u;
+
+	uu.ll = u;
+	bm = 32 - b;
+
+	if (bm <= 0) {
+		w.s.high = 0;
+		w.s.low = (unsigned int) uu.s.high >> -bm;
+	} else {
+		const unsigned int carries = (unsigned int) uu.s.high << bm;
+
+		w.s.high = (unsigned int) uu.s.high >> b;
+		w.s.low = ((unsigned int) uu.s.low >> b) | carries;
+	}
+
+	return w.ll;
+}
+EXPORT_SYMBOL(__lshrdi3);
-- 
1.6.2



