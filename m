Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYFZBGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYFZBGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbYFZBBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2779 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbYFZBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=uShnYsLE3Y59hmiAZ0mYWryHM/ULU7UYy7D9/OS7vXO71soorywNozhUI3bH9jG6Fi
         kOW056dm/M7uUxCQz2XEA1r1apOqZTC4kbG+2c3RQcFS/xzhUwUgLiqQL6uJ4ZgieenV
         OQVnnZB+958Vos5xgC2JGkKENxKAhshjPHGmM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/16] x86: move reserve_standard_io_resources back to setup.c
Date: Wed, 25 Jun 2008 17:58:02 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251758.02316.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c        |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_percpu.c |   32 --------------------------------
 2 files changed, 33 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -454,6 +454,39 @@ void __init reserve_crashkernel(void)
 }
 #endif
 
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
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -387,38 +387,6 @@ EXPORT_SYMBOL(node_to_cpumask);
 
 #endif /* X86_64_NUMA */
 
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
-void __init reserve_standard_io_resources(void)
-{
-	int i;
-
-	/* request I/O space for devices used on all i[345]86 PCs */
-	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
-		request_resource(&ioport_resource, &standard_io_resources[i]);
-
-}
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
