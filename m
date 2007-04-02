Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXDBSv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXDBSv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXDBSv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:51:26 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48345 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965672AbXDBSvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:51:25 -0400
Date: Mon, 2 Apr 2007 20:50:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 09/16] zlib-decompression-status.diff
In-Reply-To: <20070402174801.GA23326@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0704022042070.17673@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012007390.12316@yvahk01.tjqt.qr> <20070402174801.GA23326@lazybastard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Apr 2 2007 19:48, Jörn Engel wrote:
>On Sun, 1 April 2007 20:15:42 +0200, Jan Engelhardt wrote:
>>  
>> +static inline void putstr(const char *s) {
>> +    printk("%s", s);
>> +    return;
>> +}
>> +
>>  static int __init crd_load(int in_fd, int out_fd)
>>  {
>>  	int result;
>> @@ -418,7 +423,7 @@ static int __init crd_load(int in_fd, in
>>  		return -1;
>>  	}
>>  	makecrc();
>> -	result = gunzip();
>> +	result = gunzip(putstr);
>
>You are sure this wasn't meant as an April fools joke?

It actually has use (for my 20 MHz 386 *hug*)

>Passing the address of an inline function certainly has a humorous aspect. ;)

You bet. Well, "inline" is, as far as I hear the voices of the C standard, just
a "hint" to the compiler that this function should be inlined. If it cannot do
that, well, then do not inline it. But you have a point, it gets interesting
when "inline" expands to __attribute__((always_inline)). Well, let's hope that
gcc 'carries the inlining over' into gunzip().

>Also, you can remove the "return;" in the void function and possibly
>change this bit to match Documentation/CodingStyle.

Yup.

>> +    if(putstr != NULL) putstr("*");
>
>The patch alternately uses puts() and putstr(), which looks rather odd.

It is because some arches seem to have a arch-specific "output function"
called puts() try the following:

$ grep -r 'puts(' arch/arm26/
(results)
$ grep -r 'puts(' arch/i386/
(no results)

So yes, I would need some advice what people were thinking here. If it
was not for this arch specific stuff, the putstr() function I added in
lib/ would also be gone and the "*" could be directly printed in
gunzip(), making the extra argument to gunzip superfluous.

The extra putstr() in init/initramfs.c [cf. putstr() in lib/inflate.c]
is also something I did not know how to really do better.

Thoughts are appreciated and stylofixed patch below.
(lib/inflate.c does not even use tabs, what could I possibly do more wrong than
already? :p)


---

Shows some stars during decompression. This is particularly useful on old 386s
where one asterisk is probably printed every second - making the long linux and
initramfs uncompress progress more evident.
Not compile tested outside {i386, x86_64} - don't have other machines.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 arch/alpha/boot/misc.c                    |    2 +-
 arch/arm/boot/compressed/misc.c           |    4 ++--
 arch/arm26/boot/compressed/misc.c         |    4 ++--
 arch/cris/arch-v10/boot/compressed/misc.c |    2 +-
 arch/cris/arch-v32/boot/compressed/misc.c |    2 +-
 arch/i386/boot/compressed/misc.c          |    2 +-
 arch/m32r/boot/compressed/misc.c          |    2 +-
 arch/sh/boot/compressed/misc.c            |    2 +-
 arch/sh64/boot/compressed/misc.c          |    2 +-
 arch/x86_64/boot/compressed/misc.c        |    2 +-
 init/do_mounts_rd.c                       |    7 ++++++-
 init/initramfs.c                          |    7 ++++++-
 lib/inflate.c                             |   10 ++++++----
 13 files changed, 30 insertions(+), 18 deletions(-)

Index: linux-2.6.21-rc5/arch/alpha/boot/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/alpha/boot/misc.c
+++ linux-2.6.21-rc5/arch/alpha/boot/misc.c
@@ -201,7 +201,7 @@ decompress_kernel(void *output_start,
 
 	makecrc();
 /*	puts("Uncompressing Linux..."); */
-	gunzip();
+	gunzip(NULL);
 /*	puts(" done, booting the kernel.\n"); */
 	return output_ptr;
 }
Index: linux-2.6.21-rc5/arch/arm/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/arm/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/arm/boot/compressed/misc.c
@@ -355,7 +355,7 @@ decompress_kernel(ulg output_start, ulg 
 
 	makecrc();
 	putstr("Uncompressing Linux...");
-	gunzip();
+	gunzip(putstr);
 	putstr(" done, booting the kernel.\n");
 	return output_ptr;
 }
@@ -369,7 +369,7 @@ int main()
 
 	makecrc();
 	putstr("Uncompressing Linux...");
-	gunzip();
+	gunzip(putstr);
 	putstr("done.\n");
 	return 0;
 }
Index: linux-2.6.21-rc5/arch/arm26/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/arm26/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/arm26/boot/compressed/misc.c
@@ -294,7 +294,7 @@ decompress_kernel(ulg output_start, ulg 
 
 	makecrc();
 	puts("Uncompressing Linux...");
-	gunzip();
+	gunzip(puts);
 	puts(" done, booting the kernel.\n");
 	return output_ptr;
 }
@@ -308,7 +308,7 @@ int main()
 
 	makecrc();
 	puts("Uncompressing Linux...");
-	gunzip();
+	gunzip(puts);
 	puts("done.\n");
 	return 0;
 }
Index: linux-2.6.21-rc5/arch/cris/arch-v10/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/cris/arch-v10/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/cris/arch-v10/boot/compressed/misc.c
@@ -267,6 +267,6 @@ decompress_kernel()
 	}
 
 	puts("Uncompressing Linux...\n");
-	gunzip();
+	gunzip(puts);
 	puts("Done. Now booting the kernel.\n");
 }
Index: linux-2.6.21-rc5/arch/cris/arch-v32/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/cris/arch-v32/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/cris/arch-v32/boot/compressed/misc.c
@@ -312,6 +312,6 @@ decompress_kernel()
 	}
 
 	puts("Uncompressing Linux...\n");
-	gunzip();
+	gunzip(puts);
 	puts("Done. Now booting the kernel.\n");
 }
Index: linux-2.6.21-rc5/arch/i386/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/i386/boot/compressed/misc.c
@@ -373,7 +373,7 @@ asmlinkage void decompress_kernel(void *
 
 	makecrc();
 	putstr("Uncompressing Linux... ");
-	gunzip();
+	gunzip(putstr);
 	putstr("Ok, booting the kernel.\n");
 	return;
 }
Index: linux-2.6.21-rc5/arch/m32r/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/m32r/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/m32r/boot/compressed/misc.c
@@ -204,6 +204,6 @@ decompress_kernel(int mmu_on, unsigned c
 
 	makecrc();
 	puts("Uncompressing Linux... ");
-	gunzip();
+	gunzip(puts);
 	puts("Ok, booting the kernel.\n");
 }
Index: linux-2.6.21-rc5/arch/sh/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/sh/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/sh/boot/compressed/misc.c
@@ -236,6 +236,6 @@ void decompress_kernel(void)
 
 	makecrc();
 	puts("Uncompressing Linux... ");
-	gunzip();
+	gunzip(puts);
 	puts("Ok, booting the kernel.\n");
 }
Index: linux-2.6.21-rc5/arch/sh64/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/sh64/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/sh64/boot/compressed/misc.c
@@ -218,7 +218,7 @@ void decompress_kernel(void)
 	makecrc();
 	puts("Uncompressing Linux... ");
 	cache_control(CACHE_ENABLE);
-	gunzip();
+	gunzip(puts);
 	puts("\n");
 
 #if 0
Index: linux-2.6.21-rc5/arch/x86_64/boot/compressed/misc.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/boot/compressed/misc.c
+++ linux-2.6.21-rc5/arch/x86_64/boot/compressed/misc.c
@@ -351,7 +351,7 @@ int decompress_kernel(struct moveparams 
 
 	makecrc();
 	putstr(".\nDecompressing Linux...");
-	gunzip();
+	gunzip(putstr);
 	putstr("done.\nBooting the kernel.\n");
 	if (high_loaded) close_output_buffer_if_we_run_high(mv);
 	return high_loaded;
Index: linux-2.6.21-rc5/init/do_mounts_rd.c
===================================================================
--- linux-2.6.21-rc5.orig/init/do_mounts_rd.c
+++ linux-2.6.21-rc5/init/do_mounts_rd.c
@@ -393,6 +393,11 @@ static void __init error(char *x)
 	unzip_error = 1;
 }
 
+static void putstr(const char *s)
+{
+	printk("%s", s);
+}
+
 static int __init crd_load(int in_fd, int out_fd)
 {
 	int result;
@@ -418,7 +423,7 @@ static int __init crd_load(int in_fd, in
 		return -1;
 	}
 	makecrc();
-	result = gunzip();
+	result = gunzip(putstr);
 	if (unzip_error)
 		result = 1;
 	kfree(inbuf);
Index: linux-2.6.21-rc5/init/initramfs.c
===================================================================
--- linux-2.6.21-rc5.orig/init/initramfs.c
+++ linux-2.6.21-rc5/init/initramfs.c
@@ -441,6 +441,11 @@ static void __init flush_window(void)
 	outcnt = 0;
 }
 
+static void putstr(const char *s)
+{
+	printk("%s", s);
+}
+
 static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 {
 	int written;
@@ -477,7 +482,7 @@ static char * __init unpack_to_rootfs(ch
 		bytes_out = 0;
 		crc = (ulg)0xffffffffL; /* shift register contents */
 		makecrc();
-		gunzip();
+		gunzip(putstr);
 		if (state != Reset)
 			error("junk in gzipped archive");
 		this_header = saved_offset + inptr;
Index: linux-2.6.21-rc5/lib/inflate.c
===================================================================
--- linux-2.6.21-rc5.orig/lib/inflate.c
+++ linux-2.6.21-rc5/lib/inflate.c
@@ -151,7 +151,7 @@ STATIC int INIT inflate_stored OF((void)
 STATIC int INIT inflate_fixed OF((void));
 STATIC int INIT inflate_dynamic OF((void));
 STATIC int INIT inflate_block OF((int *));
-STATIC int INIT inflate OF((void));
+STATIC int INIT inflate OF((void (*)(const char *)));
 
 
 /* The inflate algorithm uses a sliding 32 K byte window on the uncompressed
@@ -983,7 +983,7 @@ STATIC int INIT inflate_block(
 
 
 
-STATIC int INIT inflate(void)
+STATIC int INIT inflate(void (*putstr)(const char *))
 /* decompress an inflated entry */
 {
   int e;                /* last block flag */
@@ -1000,6 +1000,8 @@ STATIC int INIT inflate(void)
   /* decompress until the last block */
   h = 0;
   do {
+    if(putstr != NULL)
+      putstr("*");
     hufts = 0;
     gzip_mark(&ptr);
     if ((r = inflate_block(&e)) != 0) {
@@ -1093,7 +1095,7 @@ makecrc(void)
 /*
  * Do the uncompression!
  */
-static int INIT gunzip(void)
+static int INIT gunzip(void (*putstr)(const char *))
 {
     uch flags;
     unsigned char magic[2]; /* magic header */
@@ -1157,7 +1159,7 @@ static int INIT gunzip(void)
     }
 
     /* Decompress */
-    if ((res = inflate())) {
+    if ((res = inflate(putstr))) {
 	    switch (res) {
 	    case 0:
 		    break;
#<EOF>


Jan
-- 
