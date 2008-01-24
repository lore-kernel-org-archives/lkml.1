Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYAZQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYAZQIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYAZP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:57:11 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757562AbYAZP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:57:09 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 16/52] [microblaze] supported function for memory - kernel/lib
Date: Thu, 24 Jan 2008 16:02:51 +0100
Message-Id: <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/memcpy.c  |  159 +++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memmove.c |  174 +++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memset.c  |   83 +++++++++++++++++++
 3 files changed, 416 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/memcpy.c
 create mode 100644 arch/microblaze/lib/memmove.c
 create mode 100644 arch/microblaze/lib/memset.c

diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
new file mode 100644
index 0000000..cc13ebd
--- /dev/null
+++ b/arch/microblaze/lib/memcpy.c
@@ -0,0 +1,159 @@
+/* Filename: memcpy.c
+ *
+ * Reasonably optimised generic C-code for memcpy on Microblaze
+ * This is generic C code to do efficient, alignment-aware memcpy.
+ *
+ * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
+ * http://www.embedded.com/showArticle.jhtml?articleID=19205567
+ *
+ * Attempts were made, unsuccesfully, to contact the original
+ * author of this code (Michael Morrow, Intel).  Below is the original
+ * copyright notice.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+
+#include <asm/string.h>
+#include <asm/system.h>
+
+/* Macro's for bytebliting unaligned data blocks */
+
+/* Big-endian MACROS */
+
+#define BYTE_BLIT_INIT(s, h, o) \
+	(h) = *((unsigned *)(s))++ << (o)
+
+#define BYTE_BLIT_STEP(d, s, h, o) \
+	{ register unsigned _v_; _v_ = *((unsigned *)(s))++; \
+	 *((unsigned *)(d))++ = (h) | _v_ >> (32-(o)); \
+	 (h) = _v_ << (o); \
+	}
+
+void *memcpy(void *d, const void *s, __kernel_size_t c)
+{
+#if 1
+	/* This code was put into place as we transitioned from gcc3 to gcc4.
+	 * gcc4 does not support the syntax *((char *)d)++ which causes the
+	 * original code below to break. Short of fixing up the original code,
+	 * a simpler byte oriented code was put into place.
+	 */
+	/* Simple, byte oriented memcpy. */
+	const char	*src = s;
+	char		*dst = d;
+
+	while (c--) *dst++ = *src++;
+
+	return d;
+
+#else
+	/* The following code tries to optimize the copy by using unsigned
+	 * alignment. This will work fine if both source and destination are
+	 * aligned on the same boundary. However, if they are aligned on
+	 * different boundaries shifts will be necessary. This might result in
+	 * bad performance on MicroBlaze systems without a barrel shifter.
+	 */
+	void *r = d;
+
+	if (c >= 4) {
+		unsigned x, a, h, align;
+
+		/* Align the destination to a word boundry. */
+		/* This is done in an endian independant manner. */
+		switch ((unsigned) d & 3) {
+		case 1:
+			*((char *) d)++ = *((char *) s)++;
+			c--;
+		case 2:
+			*((char *) d)++ = *((char *) s)++;
+			c--;
+		case 3:
+			*((char *) d)++ = *((char *) s)++;
+			c--;
+		}
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to destination. */
+		switch ((unsigned) s & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+
+			for (; c >= 4; c -= 4)
+				*((unsigned *) d)++ = *((unsigned *) s)++;
+
+			break;
+
+		case 0x1:	/* Unaligned - Off by 1 */
+			/* Word align the source */
+			a = (unsigned) s & ~3;
+
+			/* Load the holding buffer */
+			BYTE_BLIT_INIT(a, h, 8);
+
+			for (; c >= 4; c -= 4)
+				BYTE_BLIT_STEP(d, a, h, 8);
+
+			/* Realign the source */
+			(unsigned) s = a - 3;
+			break;
+
+		case 0x2:	/* Unaligned - Off by 2 */
+			/* Word align the source */
+			a = (unsigned) s & ~3;
+
+			/* Load the holding buffer */
+			BYTE_BLIT_INIT(a, h, 16);
+
+			for (; c >= 4; c -= 4)
+				BYTE_BLIT_STEP(d, a, h, 16);
+
+			/* Realign the source */
+			(unsigned) s = a - 2;
+			break;
+
+		case 0x3:	/* Unaligned - Off by 3 */
+			/* Word align the source */
+			a = (unsigned) s & ~3;
+
+			/* Load the holding buffer */
+			BYTE_BLIT_INIT(a, h, 24);
+
+			for (; c >= 4; c -= 4)
+				BYTE_BLIT_STEP(d, a, h, 24);
+
+			/* Realign the source */
+			(unsigned) s = a - 1;
+			break;
+		}
+
+	}
+
+	/* Finish off any remaining bytes */
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	switch (c) {
+	case 3:
+		*((char *) d)++ = *((char *) s)++;
+	case 2:
+		*((char *) d)++ = *((char *) s)++;
+	case 1:
+		*((char *) d)++ = *((char *) s)++;
+	}
+
+	return r;
+#endif
+}
+
+
+void *cacheable_memcpy(void *d, const void *s, __kernel_size_t c)
+{
+	return memcpy(d, s, c);
+}
diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
new file mode 100644
index 0000000..e9f8f04
--- /dev/null
+++ b/arch/microblaze/lib/memmove.c
@@ -0,0 +1,174 @@
+/* Filename: memmove.c
+ *
+ * Reasonably optimised generic C-code for memcpy on Microblaze
+ * This is generic C code to do efficient, alignment-aware memmove.
+ *
+ * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
+ * http://www.embedded.com/showArticle.jhtml?articleID=19205567
+ *
+ * Attempts were made, unsuccesfully, to contact the original
+ * author of this code (Michael Morrow, Intel).  Below is the original
+ * copyright notice.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+
+#include <asm/string.h>
+
+/* Macro's for bytebliting unaligned data blocks */
+
+/* Big-endian MACROS */
+
+#define BYTE_BLIT_INIT(s, h, o) \
+	(h) = *(--(unsigned *)(s)) >> (32-(o))
+
+#define BYTE_BLIT_STEP(d, s, h, o) \
+	{ register unsigned _v_; _v_ = *(--(unsigned *)(s)); \
+	 *(--(unsigned *)(d)) = _v_ << (o) | (h); \
+	 (h) = _v_ >> (32-(o)); \
+	}
+
+void *memmove(void *d, const void *s, __kernel_size_t c)
+{
+#if 1
+	/* This code was put into place as we transitioned from gcc3 to gcc4.
+	 * gcc4 does not support the syntax *((char *)d)++ which causes the
+	 * original code below to break. Short of fixing up the original code,
+	 * a simpler byte oriented code was put into place.
+	 */
+	/* Simple, byte oriented memmove. */
+	if (d <= s) {
+		return memcpy(d, s, c);
+	} else {
+		const char	*src = s;
+		char		*dst = d;
+
+		/* copy backwards, from end to beginning */
+		src += c;
+		dst += c;
+
+		while (c--) *--dst = *--src;
+
+		return d;
+	}
+
+#else
+	/* The following code tries to optimize the copy by using unsigned
+	 * alignment. This will work fine if both source and destination are
+	 * aligned on the same boundary. However, if they are aligned on
+	 * different boundaries shifts will be necessary. This might result in
+	 * bad performance on MicroBlaze systems without a barrel shifter.
+	 */
+	void *r = d;
+
+	/* Use memcpy when source is higher than dest */
+	if (d <= s)
+		return memcpy(d, s, c);
+
+	/* Do a descending copy - this is a bit trickier! */
+	d += c;
+	s += c;
+
+	if (c >= 4) {
+		unsigned x, a, h, align;
+
+		/* Align the destination to a word boundry. */
+		/* This is done in an endian independant manner. */
+		switch ((unsigned) d & 3) {
+		case 3:
+			*(--(char *) d) = *(--(char *) s);
+			c--;
+		case 2:
+			*(--(char *) d) = *(--(char *) s);
+			c--;
+		case 1:
+			*(--(char *) d) = *(--(char *) s);
+			c--;
+		}
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to destination. */
+		switch ((unsigned) s & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+
+			for (; c >= 4; c -= 4)
+				*(--(unsigned *) d) = *(--(unsigned *) s);
+
+			break;
+
+		case 0x1:	/* Unaligned - Off by 1 */
+			/* Word align the source */
+			a = (unsigned) (s + 4) & ~3;
+
+			/* Load the holding buffer */
+			BYTE_BLIT_INIT(a, h, 8);
+
+			for (; c >= 4; c -= 4)
+				BYTE_BLIT_STEP(d, a, h, 8);
+
+			/* Realign the source */
+			(unsigned) s = a + 1;
+			break;
+
+		case 0x2:	/* Unaligned - Off by 2 */
+			/* Word align the source */
+			a = (unsigned) (s + 4) & ~3;
+
+			/* Load the holding buffer */
+			BYTE_BLIT_INIT(a, h, 16);
+
+			for (; c >= 4; c -= 4)
+				BYTE_BLIT_STEP(d, a, h, 16);
+
+			/* Realign the source */
+			(unsigned) s = a + 2;
+			break;
+
+		case 0x3:	/* Unaligned - Off by 3 */
+			/* Word align the source */
+			a = (unsigned) (s + 4) & ~3;
+
+			/* Load the holding buffer */
+			BYTE_BLIT_INIT(a, h, 24);
+
+			for (; c >= 4; c -= 4)
+				BYTE_BLIT_STEP(d, a, h, 24);
+
+			/* Realign the source */
+			(unsigned) s = a + 3;
+			break;
+		}
+
+#if 0
+		/* Finish off any remaining bytes */
+		c &= 3;
+		goto finish;
+#endif
+
+	}
+
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	switch (c) {
+	case 4:
+		*(--(char *) d) = *(--(char *) s);
+	case 3:
+		*(--(char *) d) = *(--(char *) s);
+	case 2:
+		*(--(char *) d) = *(--(char *) s);
+	case 1:
+		*(--(char *) d) = *(--(char *) s);
+	}
+	return r;
+#endif
+}
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
new file mode 100644
index 0000000..5d3d83e
--- /dev/null
+++ b/arch/microblaze/lib/memset.c
@@ -0,0 +1,83 @@
+/* Filename: memset.c
+ *
+ * Reasonably optimised generic C-code for memset on Microblaze
+ * This is generic C code to do efficient, alignment-aware memcpy.
+ *
+ * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
+ * http://www.embedded.com/showArticle.jhtml?articleID=19205567
+ *
+ * Attempts were made, unsuccesfully, to contact the original
+ * author of this code (Michael Morrow, Intel).  Below is the original
+ * copyright notice.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+/* Filename: memcpy.c
+ *
+ * Reasonably optimised generic C-code for memset on Microblaze
+ * Based on demo code originally Copyright 2001 by Intel Corp.
+ *
+ * This software has been developed by Intel Corporation.
+ * Intel specifically disclaims all warranties, express or
+ * implied, and all liability, including consequential and
+ * other indirect damages, for the use of this program, including
+ * liability for infringement of any proprietary rights,
+ * and including the warranties of merchantability and fitness
+ * for a particular purpose. Intel does not assume any
+ * responsibility for and errors which may appear in this program
+ * not any responsibility to update it.
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+
+#include <asm/string.h>
+
+void *memset(void *s, int c, __kernel_size_t n)
+{
+	void *r = s;
+	unsigned int w32;
+
+	/* Truncate c to 8 bits */
+	w32 = c = (c & 0xFF);
+
+	/* Make a repeating word out of it */
+	w32 |= w32 << 8;
+	w32 |= w32 << 8;
+	w32 |= w32 << 8;
+
+	if (n >= 4) {
+		/* Align the destination to a word boundary. */
+		/* This is done in an endian independant manner. */
+		switch ((unsigned) s & 3) {
+		case 1: *(char *)s = c; s = (char *)s+1; n--;
+		case 2: *(char *)s = c; s = (char *)s+1; n--;
+		case 3: *(char *)s = c; s = (char *)s+1; n--;
+		}
+
+		/* Do as many full-word copies as we can */
+		for (; n >= 4; n -= 4) {
+			*(unsigned *)s = w32;
+			s = (unsigned *)s + 1;
+		}
+
+	}
+
+	/* Finish off the rest as byte sets */
+	while (n--) {
+		*(char *)s = c;
+		s = (char *)s+1;
+	}
+	return r;
+}
+
-- 
1.5.4.rc4.14.g6fc74

