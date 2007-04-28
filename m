Return-Path: <linux-kernel-owner+w=401wt.eu-S1031911AbXD1Rzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031911AbXD1Rzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163314AbXD1RxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163310AbXD1Rwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:51 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Rene Herman <rene.herman@gmail.com>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [17/35] i386: probe_roms() cleanup
Message-Id: <20070428175242.050AE151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rene Herman <rene.herman@gmail.com>

Remove the assumption that if the first page of a legacy ROM is mapped,
it'll all be mapped. This'll also stop people reading this code from
wondering if they're looking at a bug...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Martin Murray <murrayma@citi.umich.edu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

Index: linux/arch/i386/kernel/e820.c
===================================================================
--- linux.orig/arch/i386/kernel/e820.c
+++ linux/arch/i386/kernel/e820.c
@@ -161,26 +161,27 @@ static struct resource standard_io_resou
 
 static int __init romsignature(const unsigned char *rom)
 {
+	const unsigned short * const ptr = (const unsigned short *)rom;
 	unsigned short sig;
 
-	return probe_kernel_address((const unsigned short *)rom, sig) == 0 &&
-	       sig == ROMSIGNATURE;
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
 }
 
-static int __init romchecksum(unsigned char *rom, unsigned long length)
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
 {
-	unsigned char sum;
+	unsigned char sum, c;
 
-	for (sum = 0; length; length--)
-		sum += *rom++;
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
@@ -191,8 +192,11 @@ static void __init probe_roms(void)
 
 		video_rom_resource.start = start;
 
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* if checksum okay, trust length byte */
 		if (length && romchecksum(rom, length))
@@ -226,8 +230,11 @@ static void __init probe_roms(void)
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
