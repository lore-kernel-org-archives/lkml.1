Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYA2V0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYA2V0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYA2V0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:26:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37194 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYA2V0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:26:12 -0500
Date: Tue, 29 Jan 2008 22:26:11 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 16/52] [microblaze] supported function for memory -
 kernel/lib
In-Reply-To: <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801292154540.14907@fbirervta.pbzchgretzou.qr>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 16:02, monstr@monstr.eu wrote:
>diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
>new file mode 100644
>index 0000000..cc13ebd
>--- /dev/null
>+++ b/arch/microblaze/lib/memcpy.c
>@@ -0,0 +1,159 @@
>+/* Filename: memcpy.c
>+ *

Please, no such filenames in files. It is redundant and hard to keep
uptodate, should things move at one point in time.

>+#define BYTE_BLIT_STEP(d, s, h, o) \
>+	{ register unsigned _v_; _v_ = *((unsigned *)(s))++; \
>+	 *((unsigned *)(d))++ = (h) | _v_ >> (32-(o)); \
>+	 (h) = _v_ << (o); \
>+	}

'register' is a relict from 30 years ago. Compilers likely ignore it
these days, so it can jsut be removed anyway.

>+	/* This code was put into place as we transitioned from gcc3 to gcc4.
>+	 * gcc4 does not support the syntax *((char *)d)++ which causes the

Of course not, because (char *)d is not an lvalue - and if you ask
me, it is ambiguous and bogus code.

Assuming 'd' was int*, d++ would cause it to be incremented by 4.

If you incremented 'd' with char* semantics, it would be incremented
by 1. But since 'd' is still int*, you now have an unaligned pointer,
which is a problem in itself. We do not need more pitfalls than C
already provides.

>+	if (c >= 4) {
>+		unsigned x, a, h, align;

You will be wanting to use unsigned long since you are working with
pointers.

>+		/* Align the destination to a word boundry. */
>+		/* This is done in an endian independant manner. */
>+		switch ((unsigned) d & 3) {
>+		case 1:
>+			*((char *) d)++ = *((char *) s)++;
>+			c--;
>+		case 2:
>+			*((char *) d)++ = *((char *) s)++;
>+			c--;
>+		case 3:
>+			*((char *) d)++ = *((char *) s)++;
>+			c--;
>+		}

This gets my strongest NAK. Please rewrite it in a sane manner.
In other words, like this:

+void *memcpy(void *v_dest, const void *v_src, __kernel_size_t c)
+{
+	const char *src = v_src;
+	char *dest = v_dest;
+
+	const uint32_t *i_src;
+	uint32_t *i_dest;
+
+	if (c >= 4) {
+		unsigned x, a, h, align;
+
+		/* Align the destination to a word boundry. */
+		/* This is done in an endian independant manner. */
+		switch ((unsigned long)dest & 3) {
+		case 1:
+			*dest++ = *src++;
+			--c;
+		case 2:
+			*dest++ = *src++;
+			--c;
+		case 3:
+			*dest++ = *src++;
+			--c;
+		}
+		/* Choose a copy scheme based on the source */
+		/* alignment relative to destination. */
+		switch ((unsigned long)src & 3) {
+		case 0x0:	/* Both byte offsets are aligned */
+
+			i_src  = (const void *)src;
+			i_dest = (void *)dest;
+
+			for (; c >= 4; c -= 4)
+				*i_dest++ = *i_src++;
+
+			src  = (const void *)i_src;
+			dest = (void *)i_dest;
+
+			break;
+
+		case 0x1:	/* Unaligned - Off by 1 */
			...

The BYTE_BLIT_ macros need reworking. The suggestions
so far should provide everything needed.

+		}
+
+	}
+
+	/* Finish off any remaining bytes */
+	/* simple fast copy, ... unless a cache boundry is crossed */
+	switch (c) {
+	case 3:
+		*dest++ = *src++;
+	case 2:
+		*dest++ = *src++;
+	case 1:
+		*dest++ = *src++;
+	}
+
+	return r;
+#endif
+}

 - and voilà, you can use it even with gcc4.
The same goes for memmove.c and memset.c.

By the way, I think you should just replace lib/string.c's memcpy,
etc. (which still do per-byte copying) with this optimized variant
instead, so everyone can benefit.
