Return-Path: <linux-kernel-owner+w=401wt.eu-S932981Ab0AFWE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0AFWE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262Ab0AFWEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:04:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369Ab0AFWEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:04:43 -0500
Date: Wed, 6 Jan 2010 14:04:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH V2 6/8] lzma: Make lzma available to non
 initramfs/initrd code
Message-Id: <20100106140409.ba0f63d1.akpm@linux-foundation.org>
In-Reply-To: <E1NIuOW-0001ol-RC@dylan.lougher.demon.co.uk>
References: <E1NIuOW-0001ol-RC@dylan.lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 01:34:08 +0000
Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> Add a config option DECOMPRESS_LZMA_NEEDED which allows subsystems to
> specify they need the unlzma code.  Normally decompress_unlzma.c is
> compiled with __init and unlzma is not exported to modules.
> 
> Move INIT definition into separate header files for bzip2/lzma/inflate
> so it can be defined differently for each decompressor.
> 

This patch (which is in linux-next) breaks
lib-add-support-for-lzo-compressed-kernels.patch, below.  The
definition of INIT is no longer available in lib/decompress_unlzo.c, and

lib/decompress_unlzo.c: In function 'unlzo':
lib/decompress_unlzo.c:106: error: 'error' undeclared (first use in this function)
lib/decompress_unlzo.c:106: error: (Each undeclared identifier is reported only once
lib/decompress_unlzo.c:106: error: for each function it appears in.)
lib/decompress_unlzo.c:111: error: implicit declaration of function 'error'


I'm planning on merging 

zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
arm-add-support-for-lzo-compressed-kernels.patch
x86-add-support-for-lzo-compressed-kernels.patch
add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

into 2.6.33.  I don't immediately remember why I decided that - perhaps
because the patches did arrive in time for .33, but got stalled because
people were screwing around in other trees.

So if I go ahead with that merge, linux-next will need fixing.  And I
didn't get down and work what the appropriate fix is, and I don't want
to break linux-next in serious ways.


So what to do?  I guess I could go ahead with the mainline merge, and
Stephen drops <whatever that tree was> from linux-next until it has
been fixed up?

If we decide to hold the above five patches off until 2.6.34 then
they'll need to be fixed up to work against linux-next, and they will
be dependent upon your patch series.




From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

This patch series adds generic support for creating and extracting
LZO-compressed kernel images, as well as support for using such images on
the x86 and ARM architectures, and support for creating and using
LZO-compressed initrd and initramfs images.


Russell King said:

: Testing on a Cortex A9 model:
: - lzo decompressor is 65% of the time gzip takes to decompress a kernel
: - lzo kernel is 9% larger than a gzip kernel
: 
: which I'm happy to say confirms your figures when comparing the two.
: 
: However, when comparing your new gzip code to the old gzip code:
: - new is 99% of the size of the old code
: - new takes 42% of the time to decompress than the old code
: 
: What this means is that for a proper comparison, the results get even better:
: - lzo is 7.5% larger than the old gzip'd kernel image
: - lzo takes 28% of the time that the old gzip code took
: 
: So the expense seems definitely worth the effort.  The only reason I
: can think of ever using gzip would be if you needed the additional
: compression (eg, because you have limited flash to store the image.)
: 
: I would argue that the default for ARM should therefore be LZO.


This patch:

The lzo compressor is worse than gzip at compression, but faster at
extraction.  Here are some figures for an ARM board I'm working on:

Uncompressed size: 3.24Mo
gzip  1.61Mo 0.72s
lzo   1.75Mo 0.48s

So for a compression ratio that is still relatively close to gzip, it's
much faster to extract, at least in that case.

This part contains:
 - Makefile routine to support lzo compression
 - Fixes to the existing lzo compressor so that it can be used in
   compressed kernels
 - wrapper around the existing lzo1x_decompress, as it only extracts one
   block at a time, while we need to extract a whole file here
 - config dialog for kernel compression

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: cleanup]
Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Tested-by: Wu Zhangjin <wuzhangjin@gmail.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Russell King <rmk@arm.linux.org.uk>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/decompress/unlzo.h |   10 +
 init/Kconfig                     |   18 +-
 lib/decompress_unlzo.c           |  209 +++++++++++++++++++++++++++++
 lib/lzo/lzo1x_decompress.c       |    9 -
 scripts/Makefile.lib             |    5 
 5 files changed, 244 insertions(+), 7 deletions(-)

diff -puN /dev/null include/linux/decompress/unlzo.h
--- /dev/null
+++ a/include/linux/decompress/unlzo.h
@@ -0,0 +1,10 @@
+#ifndef DECOMPRESS_UNLZO_H
+#define DECOMPRESS_UNLZO_H
+
+int unlzo(unsigned char *inbuf, int len,
+	int(*fill)(void*, unsigned int),
+	int(*flush)(void*, unsigned int),
+	unsigned char *output,
+	int *pos,
+	void(*error)(char *x));
+#endif
diff -puN init/Kconfig~lib-add-support-for-lzo-compressed-kernels init/Kconfig
--- a/init/Kconfig~lib-add-support-for-lzo-compressed-kernels
+++ a/init/Kconfig
@@ -123,10 +123,13 @@ config HAVE_KERNEL_BZIP2
 config HAVE_KERNEL_LZMA
 	bool
 
+config HAVE_KERNEL_LZO
+	bool
+
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA
+	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_LZO
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -149,9 +152,8 @@ config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
 	help
-	  The old and tried gzip compression. Its compression ratio is
-	  the poorest among the 3 choices; however its speed (both
-	  compression and decompression) is the fastest.
+	  The old and tried gzip compression. It provides a good balance
+	  between compression ratio and decompression speed.
 
 config KERNEL_BZIP2
 	bool "Bzip2"
@@ -172,6 +174,14 @@ config KERNEL_LZMA
 	  two. Compression is slowest.	The kernel size is about 33%
 	  smaller with LZMA in comparison to gzip.
 
+config KERNEL_LZO
+	bool "LZO"
+	depends on HAVE_KERNEL_LZO
+	help
+	  Its compression ratio is the poorest among the 4. The kernel
+	  size is about about 10% bigger than gzip; however its speed
+	  (both compression and decompression) is the fastest.
+
 endchoice
 
 config SWAP
diff -puN /dev/null lib/decompress_unlzo.c
--- /dev/null
+++ a/lib/decompress_unlzo.c
@@ -0,0 +1,209 @@
+/*
+ * LZO decompressor for the Linux kernel. Code borrowed from the lzo
+ * implementation by Markus Franz Xaver Johannes Oberhumer.
+ *
+ * Linux kernel adaptation:
+ * Copyright (C) 2009
+ * Albin Tonnerre, Free Electrons <albin.tonnerre@free-electrons.com>
+ *
+ * Original code:
+ * Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
+ * All Rights Reserved.
+ *
+ * lzop and the LZO library are free software; you can redistribute them
+ * and/or modify them under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Markus F.X.J. Oberhumer
+ * <markus@oberhumer.com>
+ * http://www.oberhumer.com/opensource/lzop/
+ */
+
+#ifdef STATIC
+#include "lzo/lzo1x_decompress.c"
+#else
+#include <linux/slab.h>
+#include <linux/decompress/unlzo.h>
+#endif
+
+#include <linux/types.h>
+#include <linux/lzo.h>
+#include <linux/decompress/mm.h>
+
+#include <linux/compiler.h>
+#include <asm/unaligned.h>
+
+static const unsigned char lzop_magic[] = {
+	0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a };
+
+#define LZO_BLOCK_SIZE        (256*1024l)
+#define HEADER_HAS_FILTER      0x00000800L
+
+STATIC inline int INIT parse_header(u8 *input, u8 *skip)
+{
+	int l;
+	u8 *parse = input;
+	u8 level = 0;
+	u16 version;
+
+	/* read magic: 9 first bits */
+	for (l = 0; l < 9; l++) {
+		if (*parse++ != lzop_magic[l])
+			return 0;
+	}
+	/* get version (2bytes), skip library version (2),
+	 * 'need to be extracted' version (2) and
+	 * method (1) */
+	version = get_unaligned_be16(parse);
+	parse += 7;
+	if (version >= 0x0940)
+		level = *parse++;
+	if (get_unaligned_be32(parse) & HEADER_HAS_FILTER)
+		parse += 8; /* flags + filter info */
+	else
+		parse += 4; /* flags */
+
+	/* skip mode and mtime_low */
+	parse += 8;
+	if (version >= 0x0940)
+		parse += 4;	/* skip mtime_high */
+
+	l = *parse++;
+	/* don't care about the file name, and skip checksum */
+	parse += l + 4;
+
+	*skip = parse - input;
+	return 1;
+}
+
+STATIC inline int INIT unlzo(u8 *input, int in_len,
+				int (*fill) (void *, unsigned int),
+				int (*flush) (void *, unsigned int),
+				u8 *output, int *posp,
+				void (*error_fn) (char *x))
+{
+	u8 skip = 0, r = 0;
+	u32 src_len, dst_len;
+	size_t tmp;
+	u8 *in_buf, *in_buf_save, *out_buf;
+	int obytes_processed = 0;
+
+	set_error_fn(error_fn);
+
+	if (output) {
+		out_buf = output;
+	} else if (!flush) {
+		error("NULL output pointer and no flush function provided");
+		goto exit;
+	} else {
+		out_buf = malloc(LZO_BLOCK_SIZE);
+		if (!out_buf) {
+			error("Could not allocate output buffer");
+			goto exit;
+		}
+	}
+
+	if (input && fill) {
+		error("Both input pointer and fill function provided, don't know what to do");
+		goto exit_1;
+	} else if (input) {
+		in_buf = input;
+	} else if (!fill || !posp) {
+		error("NULL input pointer and missing position pointer or fill function");
+		goto exit_1;
+	} else {
+		in_buf = malloc(lzo1x_worst_compress(LZO_BLOCK_SIZE));
+		if (!in_buf) {
+			error("Could not allocate input buffer");
+			goto exit_1;
+		}
+	}
+	in_buf_save = in_buf;
+
+	if (posp)
+		*posp = 0;
+
+	if (fill)
+		fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
+
+	if (!parse_header(input, &skip)) {
+		error("invalid header");
+		goto exit_2;
+	}
+	in_buf += skip;
+
+	if (posp)
+		*posp = skip;
+
+	for (;;) {
+		/* read uncompressed block size */
+		dst_len = get_unaligned_be32(in_buf);
+		in_buf += 4;
+
+		/* exit if last block */
+		if (dst_len == 0) {
+			if (posp)
+				*posp += 4;
+			break;
+		}
+
+		if (dst_len > LZO_BLOCK_SIZE) {
+			error("dest len longer than block size");
+			goto exit_2;
+		}
+
+		/* read compressed block size, and skip block checksum info */
+		src_len = get_unaligned_be32(in_buf);
+		in_buf += 8;
+
+		if (src_len <= 0 || src_len > dst_len) {
+			error("file corrupted");
+			goto exit_2;
+		}
+
+		/* decompress */
+		tmp = dst_len;
+		r = lzo1x_decompress_safe((u8 *) in_buf, src_len,
+						out_buf, &tmp);
+
+		if (r != LZO_E_OK || dst_len != tmp) {
+			error("Compressed data violation");
+			goto exit_2;
+		}
+
+		obytes_processed += dst_len;
+		if (flush)
+			flush(out_buf, dst_len);
+		if (output)
+			out_buf += dst_len;
+		if (posp)
+			*posp += src_len + 12;
+		if (fill) {
+			in_buf = in_buf_save;
+			fill(in_buf, lzo1x_worst_compress(LZO_BLOCK_SIZE));
+		} else
+			in_buf += src_len;
+	}
+
+exit_2:
+	if (!input)
+		free(in_buf);
+exit_1:
+	if (!output)
+		free(out_buf);
+exit:
+	return obytes_processed;
+}
+
+#define decompress unlzo
diff -puN lib/lzo/lzo1x_decompress.c~lib-add-support-for-lzo-compressed-kernels lib/lzo/lzo1x_decompress.c
--- a/lib/lzo/lzo1x_decompress.c~lib-add-support-for-lzo-compressed-kernels
+++ a/lib/lzo/lzo1x_decompress.c
@@ -11,11 +11,13 @@
  *  Richard Purdie <rpurdie@openedhand.com>
  */
 
+#ifndef STATIC
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/lzo.h>
-#include <asm/byteorder.h>
+#endif
+
 #include <asm/unaligned.h>
+#include <linux/lzo.h>
 #include "lzodefs.h"
 
 #define HAVE_IP(x, ip_end, ip) ((size_t)(ip_end - ip) < (x))
@@ -244,9 +246,10 @@ lookbehind_overrun:
 	*out_len = op - out;
 	return LZO_E_LOOKBEHIND_OVERRUN;
 }
-
+#ifndef STATIC
 EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO1X Decompressor");
 
+#endif
diff -puN scripts/Makefile.lib~lib-add-support-for-lzo-compressed-kernels scripts/Makefile.lib
--- a/scripts/Makefile.lib~lib-add-support-for-lzo-compressed-kernels
+++ a/scripts/Makefile.lib
@@ -235,3 +235,8 @@ quiet_cmd_lzma = LZMA    $@
 cmd_lzma = (cat $(filter-out FORCE,$^) | \
 	lzma -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+quiet_cmd_lzo = LZO    $@
+cmd_lzo = (cat $(filter-out FORCE,$^) | \
+	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
_

