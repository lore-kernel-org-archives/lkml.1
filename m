Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXA2NqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXA2NqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXA2NqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:46:25 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46700 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXA2NqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:46:24 -0500
Message-ID: <45BDFAA8.6080201@gmail.com>
Date: Mon, 29 Jan 2007 14:46:16 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: akpm@osdl.org
CC: ak@suse.de, jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: probe_roms() cleanup
References: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net>
In-Reply-To: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net>
Content-Type: multipart/mixed;
 boundary="------------070606030004090006010906"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070606030004090006010906
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

Resubmit. I once heard you say you wanted patches not against -mm but 
against mainline so this replaces "romsignature-checksum-cleanup.patch" 
in current -mm.

===
Remove the assumption that if the first page of a legacy ROM is mapped,
it'll all be mapped. This'll also stop people reading this code from
wondering if they're looking at a bug...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
===

Rene.

--------------070606030004090006010906
Content-Type: text/plain;
 name="i386_probe_roms_cleanup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386_probe_roms_cleanup.diff"

diff --git a/arch/i386/kernel/e820.c b/arch/i386/kernel/e820.c
index f391abc..8b8741f 100644
--- a/arch/i386/kernel/e820.c
+++ b/arch/i386/kernel/e820.c
@@ -156,29 +156,31 @@ static struct resource standard_io_resou
 	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
 } };
 
-static int romsignature(const unsigned char *x)
+#define ROMSIGNATURE 0xaa55
+
+static int __init romsignature(const unsigned char *rom)
 {
+	const unsigned short * const ptr = (const unsigned short *)rom;
 	unsigned short sig;
-	int ret = 0;
-	if (probe_kernel_address((const unsigned short *)x, sig) == 0)
-		ret = (sig == 0xaa55);
-	return ret;
+	
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
 }
 
-static int __init romchecksum(unsigned char *rom, unsigned long length)
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
 {
-	unsigned char *p, sum = 0;
+	unsigned char sum, c;
 
-	for (p = rom; p < rom + length; p++)
-		sum += *p;
-	return sum == 0;
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
@@ -189,8 +191,11 @@ static void __init probe_roms(void)
 
 		video_rom_resource.start = start;
 
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* if checksum okay, trust length byte */
 		if (length && romchecksum(rom, length))
@@ -224,8 +229,11 @@ static void __init probe_roms(void)
 		if (!romsignature(rom))
 			continue;
 
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* but accept any length that fits if checksum okay */
 		if (!length || start + length > upper || !romchecksum(rom, length))

--------------070606030004090006010906--
