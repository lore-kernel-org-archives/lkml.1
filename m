Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZLTOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZLTOMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZLTOMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:12:35 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:45522 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZLTOMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:12:34 -0500
Date: Sun, 20 Dec 2009 15:11:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Michal Marek <mmarek@suse.cz>, Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
	boot
Message-ID: <20091220141156.GA3744@merkur.ravnborg.org>
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org> <4B2E084D.6080105@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2E084D.6080105@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 02:19:41PM +0300, Michael Tokarev wrote:
> Sam Ravnborg wrote:
> > We use ... printf \x ... when calculating the size of the
> > compressed kernel.
> > Unfortunately dash built-in printf does not support this notation
> > resulting in a non-bootable kernel.
> > 
> > Fix this by always using the external version of printf.
> > 
> > The commit that introduced this bug was:
> > 4a2ff67c88211026afcbdbc190c13f705dae1b59: "kbuild: fix bzImage
> > build for x86"
> 
> It's not that simple Sam.

The whole business using shell scripts to append the size seems broken.
How about moving this functionality to mkpiggy where we are
less shell script dependent.

Something like the following.
I have only tested it lightly (vmlinux.bin did not differ
before/after the patch.

It includes the length also in the gzip case - I dunno if that matters.
Also I dunno if ".long" is the same on 32 and 64 bit.

	Sam

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index f8ed065..d39fe2e 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -54,7 +54,8 @@ suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
 suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
 
 quiet_cmd_mkpiggy = MKPIGGY $@
-      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
+      cmd_mkpiggy = $(obj)/mkpiggy $< $(vmlinux.bin.all-y) > $@ || \
+                   ( rm -f $@ ; false )
 
 targets += piggy.S
 $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index bcbd36c..f4a1a3f 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -29,6 +29,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <inttypes.h>
+#include <sys/stat.h>
 
 static uint32_t getle32(const void *p)
 {
@@ -38,12 +39,27 @@ static uint32_t getle32(const void *p)
 		((uint32_t)cp[2] << 16) + ((uint32_t)cp[3] << 24);
 }
 
+static file_size(const char *filename)
+{
+	struct stat statbuf;
+	int res;
+
+	res = stat(filename, &statbuf);
+	if (res < 0) {
+		perror(filename);
+		exit(1);
+	}
+	return (size_t)statbuf.st_size;
+}
+
 int main(int argc, char *argv[])
 {
 	uint32_t olen;
 	long ilen;
 	unsigned long offs;
+	size_t size;
 	FILE *f;
+	int i;
 
 	if (argc < 2) {
 		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
@@ -67,6 +83,11 @@ int main(int argc, char *argv[])
 	olen = getle32(&olen);
 	fclose(f);
 
+	i = 2;
+	size = 0;
+	while (i < argc)
+		size += file_size(argv[i++]);
+
 	/*
 	 * Now we have the input (compressed) and output (uncompressed)
 	 * sizes, compute the necessary decompression offset...
@@ -91,6 +112,14 @@ int main(int argc, char *argv[])
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
 	printf(".incbin \"%s\"\n", argv[1]);
+
+        /*
+         * Bzip2 and LZMA do not include size in file... so we have to fake that;
+         * append the size as a 32-bit littleendian number as gzip does.
+         */
+	if (size > 0)
+		printf(".long %d\n", size);
+
 	printf("input_data_end:\n");
 
 	return 0;
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cd815ac..10bef1c 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -211,27 +211,14 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 # Bzip2
 # ---------------------------------------------------------------------------
 
-# Bzip2 and LZMA do not include size in file... so we have to fake that;
-# append the size as a 32-bit littleendian number as gzip does.
-size_append = printf $(shell						\
-dec_size=0;								\
-for F in $1; do								\
-	fsize=$$(stat -c "%s" $$F);					\
-	dec_size=$$(expr $$dec_size + $$fsize);				\
-done;									\
-printf "%08x" $$dec_size |						\
-	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
-)
-
 quiet_cmd_bzip2 = BZIP2   $@
-cmd_bzip2 = (cat $(filter-out FORCE,$^) | \
-	bzip2 -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
-	(rm -f $@ ; false)
+cmd_bzip2 = cat $(filter-out FORCE,$^) | \
+	bzip2 -9 > $@ || (rm -f $@ ; false)
 
 # Lzma
 # ---------------------------------------------------------------------------
 
 quiet_cmd_lzma = LZMA    $@
-cmd_lzma = (cat $(filter-out FORCE,$^) | \
-	lzma -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
-	(rm -f $@ ; false)
+cmd_lzma = cat $(filter-out FORCE,$^) | \
+	lzma -9 > $@ || (rm -f $@ ; false)
+
