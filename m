Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXA2Nqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXA2Nqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbXA2Nqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:46:44 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40374 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXA2Nqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:46:42 -0500
Message-ID: <45BDFAB5.40606@gmail.com>
Date: Mon, 29 Jan 2007 14:46:29 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: akpm@osdl.org
CC: ak@suse.de, jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: sync up probe_roms() with i386
References: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net>
In-Reply-To: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net>
Content-Type: multipart/mixed;
 boundary="------------010507060704000009040800"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010507060704000009040800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

This syncs up the x86_64 probe_roms() with the i386 version as just 
submitted.

===
Sync up with i386. Specifically, be careful about touching the
legacy ROMs; in virtualized environments they may not be mapped.

Crosscompiled, but not booted due to lack of hardware.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
===

Rene

--------------010507060704000009040800
Content-Type: text/plain;
 name="x86_64_sync_probe_roms_with_i386.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_64_sync_probe_roms_with_i386.diff"

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index af425a8..0b3d237 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -183,22 +183,31 @@ static struct resource video_ram_resourc
 	.flags = IORESOURCE_RAM,
 };
 
-#define romsignature(x) (*(unsigned short *)(x) == 0xaa55)
+#define ROMSIGNATURE 0xaa55
 
-static int __init romchecksum(unsigned char *rom, unsigned long length)
+static int __init romsignature(const unsigned char *rom)
 {
-	unsigned char *p, sum = 0;
+	const unsigned short * const ptr = (const unsigned short *)rom;
+	unsigned short sig;
 
-	for (p = rom; p < rom + length; p++)
-		sum += *p;
-	return sum == 0;
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
+}
+
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
+{
+	unsigned char sum, c;
+
+	for (sum = 0; length && probe_kernel_address(rom++, c) == 0; length--)
+		sum += c;
+	return !length && !sum;
 }
 
 static void __init probe_roms(void)
 {
+	const unsigned char *rom;
 	unsigned long start, length, upper;
-	unsigned char *rom;
-	int	      i;
+	unsigned char c;
+	int i;
 
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
@@ -209,8 +218,11 @@ static void __init probe_roms(void)
 
 		video_rom_resource.start = start;
 
+		if (probe_kernel_address(rom, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* if checksum okay, trust length byte */
 		if (length && romchecksum(rom, length))
@@ -245,8 +257,11 @@ static void __init probe_roms(void)
 		if (!romsignature(rom))
 			continue;
 
+		if (probe_kernel_address(rom, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* but accept any length that fits if checksum okay */
 		if (!length || start + length > upper || !romchecksum(rom, length))

--------------010507060704000009040800--
