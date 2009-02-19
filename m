Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZBSULr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZBSULr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZBSULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:11:39 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:34874 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZBSULi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:11:38 -0500
Message-ID: <499DBCDD.90806@knaff.lu>
Date: Thu, 19 Feb 2009 21:11:09 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu>
In-Reply-To: <499BBD62.5090506@knaff.lu>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090403010804080902050301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090403010804080902050301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alain Knaff wrote:
> hmmm, but on a second glance, there seems to be indeed an issue. When
> compiling it a _second time_, compilation will "succeed" but produce a
> bad kernel because the first attempt left an empty
> usr/initramfs_data.cpio.bz2 .
> 
> I'll look into it this evening, probably a case of "bad" failure
> recovery in the Makefile.
> 

Took me slightly longer than promised, attached is the patch.

It changes/fixes three things:
1. Fix a bug in decompress.c : only scanned until the first
non-configured compressor (with disastrous result if that was gzip)
2. Fix a bug in gen_initramfs_list.sh : in case of failure, it left
indeed an empty output file behind, messing up the next make.
3. Make builtin initramfs compression configurable

Regards,

Alain

--------------090403010804080902050301
Content-Type: text/x-diff;
 name="20090219.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="20090219.diff"

This changes three things:
1. Fix a bug in decompress.c : only scanned until the first
non-configured compressor (with disastrous result if that was gzip)
2. Fix a bug in gen_initramfs_list.sh : in case of failure, it left an
empty output file behind, messing up the next make.
3. Make builtin initramfs compression configurable


Signed-off-by: Alain Knaff <alain@knaff.lu>

---

diff -purN base/lib/decompress.c i386/lib/decompress.c
--- base/lib/decompress.c	2009-02-18 07:59:07.000000000 +0100
+++ i386/lib/decompress.c	2009-02-19 20:56:07.000000000 +0100
@@ -43,7 +43,7 @@ decompress_fn decompress_method(const un
 	if (len < 2)
 		return NULL;	/* Need at least this much... */
 
-	for (cf = compressed_formats; cf->decompressor; cf++) {
+	for (cf = compressed_formats; cf->name; cf++) {
 		if (!memcmp(inbuf, cf->magic, 2))
 			break;
 
diff -purN base/scripts/gen_initramfs_list.sh i386/scripts/gen_initramfs_list.sh
--- base/scripts/gen_initramfs_list.sh	2009-02-18 07:59:07.000000000 +0100
+++ i386/scripts/gen_initramfs_list.sh	2009-02-19 07:52:57.000000000 +0100
@@ -292,7 +292,7 @@ if [ ! -z ${output_file} ]; then
 	if [ "${is_cpio_compressed}" = "compressed" ]; then
 		cat ${cpio_tfile} > ${output_file}
 	else
-		cat ${cpio_tfile} | ${compr}  - > ${output_file}
+		(cat ${cpio_tfile} | ${compr}  - > ${output_file}) || (rm ${output_file} ; false)
 	fi
 	[ -z ${cpio_file} ] && rm ${cpio_tfile}
 fi
diff -purN base/usr/Kconfig i386/usr/Kconfig
--- base/usr/Kconfig	2009-02-18 07:59:07.000000000 +0100
+++ i386/usr/Kconfig	2009-02-19 20:02:41.000000000 +0100
@@ -71,3 +71,65 @@ config RD_LZMA
 	help
 	  Support loading of a lzma encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
+
+choice
+	prompt "Built-in initramfs compression mode"
+	help
+	  This setting is only meaningful if the INITRAMFS_SOURCE is
+	  set. It decides by which algorithm the INITRAMFS_SOURCE will
+	  be compressed.
+	  Several compression algorithms are available, which differ
+	  in efficiency, compression and decompression speed.
+	  Compression speed is only relevant when building a kernel.
+	  Decompression speed is relevant at each boot.
+
+	  If you have any problems with bzip2 or lzma compressed
+	  initramfs, mail me (Alain Knaff) <alain@knaff.lu>.
+
+	  High compression options are mostly useful for users who
+	  are low on disk space (embedded systems), but for whom ram
+	  size matters less.
+
+	  If in doubt, select 'gzip'
+
+config INITRAMFS_COMPRESSION_NONE
+	bool "None"
+	help
+	  Do not compress the built-in initramfs at all. This may
+	  sound wasteful in space, but, you should be aware that the
+	  built-in initramfs will be compressed at a later stage
+	  anyways along with the rest of the kernel, on those
+	  architectures that support this.
+	  However, not compressing the initramfs may lead to slightly
+	  higher memory consumption during a short time at boot, while
+	  both the cpio image and the unpacked filesystem image will
+	  be present in memory simultaneously
+
+config INITRAMFS_COMPRESSION_GZIP
+	bool "Gzip"
+	depends on RD_GZIP
+	help
+	  The old and tried gzip compression. Its compression ratio is
+	  the poorest among the 3 choices; however its speed (both
+	  compression and decompression) is the fastest.
+
+config INITRAMFS_COMPRESSION_BZIP2
+	bool "Bzip2"
+	depends on RD_BZIP2
+	help
+	  Its compression ratio and speed is intermediate.
+	  Decompression speed is slowest among the three.  The initramfs
+	  size is about 10% smaller with bzip2, in comparison to gzip.
+	  Bzip2 uses a large amount of memory. For modern kernels you
+	  will need at least 8MB RAM or more for booting.
+
+config INITRAMFS_COMPRESSION_LZMA
+	bool "LZMA"
+	depends on RD_LZMA
+	help
+	  The most recent compression algorithm.
+	  Its ratio is best, decompression speed is between the other
+	  two. Compression is slowest.	The initramfs size is about 33%
+	  smaller with LZMA in comparison to gzip.
+
+endchoice
diff -purN base/usr/Makefile i386/usr/Makefile
--- base/usr/Makefile	2009-02-18 07:59:07.000000000 +0100
+++ i386/usr/Makefile	2009-02-19 20:27:31.000000000 +0100
@@ -5,24 +5,18 @@
 klibcdirs:;
 PHONY += klibcdirs
 
-# Find out "preferred" ramdisk compressor. Order of preference is
-#  1. bzip2 efficient, and likely to be present
-#  2. gzip former default
-#  3. lzma
-#  4. none
 
-# None of the above
-suffix_y                   =
-
-# Lzma, but no gzip nor bzip2
-suffix_$(CONFIG_RD_LZMA)   = .lzma
+# No compression
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_NONE)   =
 
 # Gzip, but no bzip2
-suffix_$(CONFIG_RD_GZIP)   = .gz
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   = .gz
 
 # Bzip2
-suffix_$(CONFIG_RD_BZIP2)  = .bz2
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_BZIP2)  = .bz2
 
+# Lzma
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZMA)   = .lzma
 
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o

--------------090403010804080902050301--
