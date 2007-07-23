Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbXGWPzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbXGWPzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbXGWPzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:55:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbXGWPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:55:07 -0400
Message-ID: <46A4CE51.2060509@zytor.com>
Date: Mon, 23 Jul 2007 08:50:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.23-rc1 broke APM
References: <200707231310.l6NDA9Dn004031@harpo.it.uu.se>
In-Reply-To: <200707231310.l6NDA9Dn004031@harpo.it.uu.se>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------040500090300000201020608"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040500090300000201020608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mikael Pettersson wrote:
> On this machine (Gigabyte mobo with i815EP chipset and a PIII),
> APM worked fine up to 2.6.22. With 2.6.23-rc1 however the APM
> driver fails to locate the APM bios:
> 
> --- dmesg-2.6.22	2007-07-23 14:07:46.000000000 +0200
> +++ dmesg-2.6.23-rc1	2007-07-23 14:48:24.000000000 +0200
> @@ -102,7 +105,7 @@
>  Unpacking initramfs... done
>  Freeing initrd memory: 976k freed
>  Machine check exception polling timer started.
> -apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
> +apm: BIOS not found.
>  io scheduler noop registered
>  io scheduler anticipatory registered (default)
>  io scheduler deadline registered
> 
> The only change in 2.6.23-rc1 to arch/i386/kernel/apm.c is a
> trivial nofreeze flag removal, so I suspect the boot code changes,
> perhaps the new arch/i386/boot/apm.c:query_apm_bios().
> 

Seems like a reasonable suspicion.

Could you try the attached patch and:

a) see if it helps the situation, and
b) tell me what it prints?

	-hpa


--------------040500090300000201020608
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/apm.c b/arch/i386/boot/apm.c
index a34087c..5843beb 100644
--- a/arch/i386/boot/apm.c
+++ b/arch/i386/boot/apm.c
@@ -34,6 +34,9 @@ int query_apm_bios(void)
 		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
 		     : : "esi", "edi");
 
+	printf("apm: err = %d, ax = %#x, bx = %#x, cx = %#x\n",
+	       err, ax, bx, cx);
+
 	if (err)
 		return -1;		/* No APM BIOS */
 
@@ -45,9 +48,10 @@ int query_apm_bios(void)
 
 	/* Disconnect first, just in case */
 	ax = 0x5304;
+	bx = 0;
 	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+		     : "+a" (ax), "+b" (bx)
+		     : "ecx", "edx", "esi", "edi");
 
 	/* Paranoia */
 	ebx = esi = 0;
@@ -59,6 +63,10 @@ int query_apm_bios(void)
 		       "+S" (esi), "+D" (di), "=m" (err)
 		     : "a" (0x5303));
 
+	printf("apm: err = %d, ax = %#x, ebx = %#x, cx = %#x, dx = %#x\n"
+	       "     esi = %#x, di = %#x\n",
+	       err, ax, ebx, cx, dx, esi, di);
+
 	boot_params.apm_bios_info.cseg = ax;
 	boot_params.apm_bios_info.offset = ebx;
 	boot_params.apm_bios_info.cseg_16 = cx;
@@ -79,6 +87,9 @@ int query_apm_bios(void)
 		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
 		     : : "esi", "edi");
 
+	printf("apm: err = %d, ax = %#x, bx = %#x, cx = %#x\n",
+	       err, ax, bx, cx);
+
 	if (err || bx != 0x504d) {
 		/* Failure with 32-bit connect, try to disconect and ignore */
 		ax = 0x5304;
diff --git a/arch/i386/boot/main.c b/arch/i386/boot/main.c
index 7f01f96..b0072d7 100644
--- a/arch/i386/boot/main.c
+++ b/arch/i386/boot/main.c
@@ -150,6 +150,8 @@ void main(void)
 	/* Query APM information */
 #if defined(CONFIG_APM) || defined(CONFIG_APM_MODULE)
 	query_apm_bios();
+#else
+	printf("apm: disabled\n");
 #endif
 
 	/* Query EDD information */

--------------040500090300000201020608--
