Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYFZMvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYFZMvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYFZMhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:37:16 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:20703 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758483AbYFZMhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:37:09 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 18/60] microblaze_v4: supported function for memory - kernel/lib
Date: Thu, 26 Jun 2008 14:29:47 +0200
Message-Id: <1214483429-32360-19-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-18-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


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

