Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYEEIPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYEEIPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYEEIO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:14:57 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:33592 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753962AbYEEIOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:14:54 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 16/56] microblaze_v2: supported function for memory - kernel/lib
Date: Sun,  4 May 2008 13:41:05 +0200
Message-Id: <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/memcpy.c  |  162 +++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memmove.c |  176 +++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/lib/memset.c  |   77 ++++++++++++++++++
 3 files changed, 415 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/memcpy.c
 create mode 100644 arch/microblaze/lib/memmove.c
 create mode 100644 arch/microblaze/lib/memset.c

diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
new file mode 100644
index 0000000..8dc5b90
--- /dev/null
+++ b/arch/microblaze/lib/memcpy.c
@@ -0,0 +1,162 @@
+/*
+ * arch/microblaze/lib/memcpy.c
+ *
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
index 0000000..99233be
--- /dev/null
+++ b/arch/microblaze/lib/memmove.c
@@ -0,0 +1,176 @@
+/*
+ * arch/microblaze/lib/memmove.c
+ *
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
index 0000000..5697d66
--- /dev/null
+++ b/arch/microblaze/lib/memset.c
@@ -0,0 +1,77 @@
+/*
+ * arch/microblaze/lib/memset.c
+ *
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
+	char *src = v_src;
+	uint32_t *i_src;
+	uint32_t w32;
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
+		for (; c >= 4; c -= 4)
+			*i_src++ = w32;
+
+		src  = (void *)i_src;
+	}
+
+	/* Finish off the rest as byte sets */
+	while (n--)
+		*src++ = c;
+
+	return v_src;
+}
+EXPORT_SYMBOL(memset);
+#endif /* __HAVE_ARCH_MEMSET */
-- 
1.5.4.GIT

