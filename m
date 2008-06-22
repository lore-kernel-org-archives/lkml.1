Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYFVDVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYFVDVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 23:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYFVDVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 23:21:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:8545 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYFVDVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 23:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rwvdUVEPoGCx4ITkZQa2p74FTFT4ztW4Tgh3BGlKGP8vOuMKi82al0Lzw/Kakw9drb
         JOXO+U+M+iS8P8MNkcQoSiDg66Vd/QGUjOZxyf8g6h/kUvbF2yKRsrGLbV4kj9uq1ZU7
         kCRL1Io0bVNikTYETeWTeIXksStc7R82mKMSM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: move reserve_standard_io_resource to setup.c
Date: Sat, 21 Jun 2008 20:22:09 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806210324.20059.yhlu.kernel@gmail.com> <200806211916.52949.yhlu.kernel@gmail.com>
In-Reply-To: <200806211916.52949.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212022.10077.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c    |   33 ++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c |   57 ---------------------------------------------
 arch/x86/kernel/setup_64.c |   29 ----------------------
 include/asm-x86/setup.h    |    2 +
 4 files changed, 37 insertions(+), 84 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -110,29 +110,6 @@ extern int root_mountflags;
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-static struct resource standard_io_resources[] = {
-	{ .name = "dma1", .start = 0x00, .end = 0x1f,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "pic1", .start = 0x20, .end = 0x21,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "timer0", .start = 0x40, .end = 0x43,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "timer1", .start = 0x50, .end = 0x53,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "keyboard", .start = 0x60, .end = 0x60,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "keyboard", .start = 0x64, .end = 0x64,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "dma page reg", .start = 0x80, .end = 0x8f,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "pic2", .start = 0xa0, .end = 0xa1,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "fpu", .start = 0xf0, .end = 0xff,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
-};
-
 #define IORESOURCE_RAM (IORESOURCE_BUSY | IORESOURCE_MEM)
 
 static struct resource data_resource = {
@@ -220,8 +197,6 @@ static inline void copy_edd(void)
  */
 void __init setup_arch(char **cmdline_p)
 {
-	unsigned i;
-
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
@@ -430,9 +405,7 @@ void __init setup_arch(char **cmdline_p)
 	e820_reserve_resources();
 	e820_mark_nosave_regions(end_pfn);
 
-	/* request I/O space for devices used on all i[345]86 PCs */
-	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
-		request_resource(&ioport_resource, &standard_io_resources[i]);
+	reserve_standard_io_resources();
 
 	e820_setup_gap();
 
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -109,58 +109,6 @@ static struct resource video_ram_resourc
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
 
-static struct resource standard_io_resources[] = { {
-	.name	= "dma1",
-	.start	= 0x0000,
-	.end	= 0x001f,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "pic1",
-	.start	= 0x0020,
-	.end	= 0x0021,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name   = "timer0",
-	.start	= 0x0040,
-	.end    = 0x0043,
-	.flags  = IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name   = "timer1",
-	.start  = 0x0050,
-	.end    = 0x0053,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "keyboard",
-	.start	= 0x0060,
-	.end	= 0x0060,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "keyboard",
-	.start	= 0x0064,
-	.end	= 0x0064,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "dma page reg",
-	.start	= 0x0080,
-	.end	= 0x008f,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "pic2",
-	.start	= 0x00a0,
-	.end	= 0x00a1,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "dma2",
-	.start	= 0x00c0,
-	.end	= 0x00df,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "fpu",
-	.start	= 0x00f0,
-	.end	= 0x00ff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-} };
-
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 /* common cpu data for all cpus */
@@ -615,7 +563,6 @@ static void set_mca_bus(int x) { }
  */
 void __init setup_arch(char **cmdline_p)
 {
-	int i;
 	unsigned long max_low_pfn;
 
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
@@ -830,9 +777,7 @@ void __init setup_arch(char **cmdline_p)
 	e820_mark_nosave_regions(max_low_pfn);
 
 	request_resource(&iomem_resource, &video_ram_resource);
-	/* request I/O space for devices used on all i[345]86 PCs */
-	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
-		request_resource(&ioport_resource, &standard_io_resources[i]);
+	reserve_standard_io_resources();
 
 	e820_setup_gap();
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -467,3 +467,36 @@ void __init reserve_crashkernel(void)
 void __init reserve_crashkernel(void)
 {}
 #endif
+
+static struct resource standard_io_resources[] = {
+	{ .name = "dma1", .start = 0x00, .end = 0x1f,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "pic1", .start = 0x20, .end = 0x21,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "timer0", .start = 0x40, .end = 0x43,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "timer1", .start = 0x50, .end = 0x53,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "keyboard", .start = 0x60, .end = 0x60,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "keyboard", .start = 0x64, .end = 0x64,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "dma page reg", .start = 0x80, .end = 0x8f,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "pic2", .start = 0xa0, .end = 0xa1,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "fpu", .start = 0xf0, .end = 0xff,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
+};
+
+void __init reserve_standard_io_resources(void)
+{
+	int i;
+
+	/* request I/O space for devices used on all i[345]86 PCs */
+	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
+		request_resource(&ioport_resource, &standard_io_resources[i]);
+
+}
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -38,6 +38,8 @@ void reserve_crashkernel(void);
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 
+void reserve_standard_io_resources(void);
+
 #ifndef _SETUP
 
 /*
