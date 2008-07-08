Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYGHNJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYGHNJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYGHNJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:09:30 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27709 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752019AbYGHNJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:09:29 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 17/58] microblaze_v5: supported function for memory - kernel/lib
Date: Tue,  8 Jul 2008 13:59:17 +0200
Message-Id: <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/memcpy.c  |  160 +++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memmove.c |  174 +++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memset.c  |   78 ++++++++++++++++++
 3 files changed, 412 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/memcpy.c
 create mode 100644 arch/microblaze/lib/memmove.c
 create mode 100644 arch/microblaze/lib/memset.c

diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
new file mode 100644
index 0000000..199668d
--- /dev/null
+++ b/arch/microblaze/lib/memcpy.c
@@ -0,0 +1,160 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
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
+#include <linux/module.h>
+
+#include <asm/string.h>
+#include <asm/system.h>
+
+#ifdef __HAVE_ARCH_MEMCPY
+void *memcpy(void *v_dst, const void *v_src, __kernel_size_t c)
+{
+	const char *src = v_src;
+	char *dst = v_dst;
+#ifndef CONFIG_OPT_LIB_FUNCTION
+	/* Simple, byte oriented memcpy. */
+	while (c--)
+		*dst++ = *src++;
+
+	return v_dst;
+#else
+	/* The following code tries to optimize the copy by using unsigned
+	 * alignment. This will work fine if both source and destination are
+	 * aligned on the same boundary. However, if they are aligned on
+	 * different boundaries shifts will be necessary. This might result in
+	 * bad performance on MicroBlaze systems without a barrel shifter.
+	 */
+	const uint32_t *i_src;
+	uint32_t *i_dst;
+
+	if (c >= 4) {
+		unsigned  value, buf_hold;
+
+		/* Align the dstination to a word boundry. */
+		/* This is done in an endian independant manner. */
+		switch ((unsigned long)dst & 3) {
+		case 1:
+			*dst++ = *src++;
+			--c;
+		case 2:
+			*dst++ = *src++;
+			--c;
+		case 3:
+			*dst++ = *src++;
+			--c;
+		}
+
+		i_dst = (void *)dst;
+
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to dstination. */
+		switch ((unsigned long)src & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+			i_src  = (const void *)src;
+
+			for (; c >= 4; c -= 4)
+				*i_dst++ = *i_src++;
+
+			src  = (const void *)i_src;
+			break;
+		case 0x1:	/* Unaligned - Off by 1 */
+			/* Word align the source */
+			i_src = (const void *) ((unsigned)src & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *i_src++ << 8;
+
+			for (; c >= 4; c -= 4) {
+				value = *i_src++;
+				*i_dst++ = buf_hold | value >> 24;
+				buf_hold = value << 8;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src -= 3;
+			break;
+		case 0x2:	/* Unaligned - Off by 2 */
+			/* Word align the source */
+			i_src = (const void *) ((unsigned)src & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *i_src++ << 16;
+
+			for (; c >= 4; c -= 4) {
+				value = *i_src++;
+				*i_dst++ = buf_hold | value >> 16;
+				buf_hold = value << 16;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src -= 2;
+			break;
+		case 0x3:	/* Unaligned - Off by 3 */
+			/* Word align the source */
+			i_src = (const void *) ((unsigned)src & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *i_src++ << 24;
+
+			for (; c >= 4; c -= 4) {
+				value = *i_src++;
+				*i_dst++ = buf_hold | value >> 8;
+				buf_hold = value << 24;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src -= 1;
+			break;
+		}
+		dst = (void *)i_dst;
+	}
+
+	/* Finish off any remaining bytes */
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	switch (c) {
+	case 3:
+		*dst++ = *src++;
+	case 2:
+		*dst++ = *src++;
+	case 1:
+		*dst++ = *src++;
+	}
+
+	return v_dst;
+#endif
+}
+EXPORT_SYMBOL(memcpy);
+#endif /* __HAVE_ARCH_MEMCPY */
+
+
+void *cacheable_memcpy(void *d, const void *s, __kernel_size_t c)
+{
+	return memcpy(d, s, c);
+}
diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
new file mode 100644
index 0000000..4db1ea6
--- /dev/null
+++ b/arch/microblaze/lib/memmove.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
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
+#include <linux/module.h>
+
+#include <asm/string.h>
+
+#ifdef __HAVE_ARCH_MEMMOVE
+void *memmove(void *v_dst, const void *v_src, __kernel_size_t c)
+{
+	const char *src = v_src;
+	char *dst = v_dst;
+
+#ifdef CONFIG_OPT_LIB_FUNCTION
+	const uint32_t *i_src;
+	uint32_t *i_dst;
+#endif
+
+	if (!c)
+		return v_dst;
+
+	/* Use memcpy when source is higher than dest */
+	if (v_dst <= v_src)
+		return memcpy(v_dst, v_src, c);
+
+#ifndef CONFIG_OPT_LIB_FUNCTION
+	/* copy backwards, from end to beginning */
+	src += c;
+	dst += c;
+
+	/* Simple, byte oriented memmove. */
+	while (c--)
+		*--dst = *--src;
+
+	return v_dst;
+#else
+	/* The following code tries to optimize the copy by using unsigned
+	 * alignment. This will work fine if both source and destination are
+	 * aligned on the same boundary. However, if they are aligned on
+	 * different boundaries shifts will be necessary. This might result in
+	 * bad performance on MicroBlaze systems without a barrel shifter.
+	 */
+	/* FIXME this part needs more test */
+	/* Do a descending copy - this is a bit trickier! */
+	dst += c;
+	src += c;
+
+	if (c >= 4) {
+		unsigned  value, buf_hold;
+
+		/* Align the destination to a word boundry. */
+		/* This is done in an endian independant manner. */
+
+		switch ((unsigned long)dst & 3) {
+		case 3:
+			*--dst = *--src;
+			--c;
+		case 2:
+			*--dst = *--src;
+			--c;
+		case 1:
+			*--dst = *--src;
+			--c;
+		}
+
+		i_dst = (void *)dst;
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to dstination. */
+		switch ((unsigned long)src & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+
+			i_src  = (const void *)src;
+
+			for (; c >= 4; c -= 4)
+				*--i_dst = *--i_src;
+
+			src  = (const void *)i_src;
+			break;
+		case 0x1:	/* Unaligned - Off by 1 */
+			/* Word align the source */
+			i_src = (const void *) (((unsigned)src + 4) & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *--i_src >> 24;
+
+			for (; c >= 4; c -= 4) {
+				value = *--i_src;
+				*--i_dst = buf_hold << 8 | value;
+				buf_hold = value >> 24;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src += 1;
+			break;
+		case 0x2:	/* Unaligned - Off by 2 */
+			/* Word align the source */
+			i_src = (const void *) (((unsigned)src + 4) & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *--i_src >> 16;
+
+			for (; c >= 4; c -= 4) {
+				value = *--i_src;
+				*--i_dst = buf_hold << 16 | value;
+				buf_hold = value >> 16;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src += 2;
+			break;
+		case 0x3:	/* Unaligned - Off by 3 */
+			/* Word align the source */
+			i_src = (const void *) (((unsigned)src + 4) & ~3);
+
+			/* Load the holding buffer */
+			buf_hold = *--i_src >> 8;
+
+			for (; c >= 4; c -= 4) {
+				value = *--i_src;
+				*--i_dst = buf_hold << 24 | value;
+				buf_hold = value >> 8;
+			}
+
+			/* Realign the source */
+			src = (const void *)i_src;
+			src += 3;
+			break;
+		}
+		dst = (void *)i_dst;
+	}
+
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	/* Finish off any remaining bytes */
+	switch (c) {
+	case 4:
+		*--dst = *--src;
+	case 3:
+		*--dst = *--src;
+	case 2:
+		*--dst = *--src;
+	case 1:
+		*--dst = *--src;
+	}
+	return v_dst;
+#endif
+}
+EXPORT_SYMBOL(memmove);
+#endif /* __HAVE_ARCH_MEMMOVE */
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
new file mode 100644
index 0000000..6a2f4e5
--- /dev/null
+++ b/arch/microblaze/lib/memset.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
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
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler.h>
+#include <linux/module.h>
+
+#include <asm/string.h>
+
+#ifdef __HAVE_ARCH_MEMSET
+void *memset(void *v_src, int c, __kernel_size_t n)
+{
+
+	char *src = v_src;
+#ifdef CONFIG_OPT_LIB_FUNCTION
+	uint32_t *i_src;
+	uint32_t w32;
+#endif
+	/* Truncate c to 8 bits */
+	c = (c & 0xFF);
+
+#ifdef CONFIG_OPT_LIB_FUNCTION
+	/* Make a repeating word out of it */
+	w32 = c;
+	w32 |= w32 << 8;
+	w32 |= w32 << 16;
+
+	if (n >= 4) {
+		/* Align the destination to a word boundary */
+		/* This is done in an endian independant manner */
+		switch ((unsigned) src & 3) {
+		case 1: *src++ = c;
+			--n;
+		case 2: *src++ = c;
+			--n;
+		case 3: *src++ = c;
+			--n;
+		}
+
+		i_src  = (void *)src;
+
+		/* Do as many full-word copies as we can */
+		for (; n >= 4; n -= 4)
+			*i_src++ = w32;
+
+		src  = (void *)i_src;
+	}
+#endif
+	/* Simple, byte oriented memset or the rest of count. */
+	while (n--)
+		*src++ = c;
+
+	return v_src;
+}
+EXPORT_SYMBOL(memset);
+#endif /* __HAVE_ARCH_MEMSET */
-- 
1.5.4.GIT

