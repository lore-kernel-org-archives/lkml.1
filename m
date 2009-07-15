Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZGOXCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZGOXCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZGOXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:02:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:12026 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbZGOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:02:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,406,1243839600"; 
   d="scan'208";a="533197324"
Subject: Why do we probe option roms at 2K boundaries?
From: Dan Williams <dan.j.williams@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 16:02:45 -0700
Message-Id: <1247698965.3989.1.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I developed support for mdadm to enumerate the capabilities of an
Intel(r) Matrix Storage Technology (software RAID) platform by
interrogating a data structure stored in option-rom memory.  My initial
implementation involved blindly scanning from c0000 to f0000 in 512 byte
increments.  Neil and others pointed out that this may not be a safe
operation, so I decided to grab the kernel's probe_roms() implementation
under the assumption that it is safe by virtue of its exposure.

Recently Hans has been working to get Fedora up and running on a recent
Intel software RAID platform and noticed that the option-rom is no
longer visible with the 2K aligned scan.  I.e. he needed to make the
following changes to the mdadm probe_roms() routine:

diff -up mdadm-3.0/probe_roms.c~ mdadm-3.0/probe_roms.c
--- mdadm-3.0/probe_roms.c~	2009-06-02 07:48:29.000000000 +0200
+++ mdadm-3.0/probe_roms.c	2009-07-13 16:24:21.000000000 +0200
@@ -220,7 +220,7 @@ void probe_roms(void)
 
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
-	for (start = video_rom_resource.start; start < upper; start += 2048) {
+	for (start = video_rom_resource.start; start < upper; start += 512) {
 		rom = isa_bus_to_virt(start);
 		if (!romsignature(rom))
 			continue;
@@ -239,7 +239,7 @@ void probe_roms(void)
 		break;
 	}
 
-	start = (video_rom_resource.end + 1 + 2047) & ~2047UL;
+	start = (video_rom_resource.end + 1 + 511) & ~511UL;
 	if (start < upper)
 		start = upper;
 
@@ -255,7 +255,7 @@ void probe_roms(void)
 	}
 
 	/* check for adapter roms on 2k boundaries */
-	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 2048) {
+	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 512) {
 		rom = isa_bus_to_virt(start);
 		if (!romsignature(rom))
 			continue;
@@ -273,7 +273,7 @@ void probe_roms(void)
 		adapter_rom_resources[i].start = start;
 		adapter_rom_resources[i].end = start + length - 1;
 
-		start = adapter_rom_resources[i++].end & ~2047UL;
+		start = adapter_rom_resources[i++].end & ~511UL;
 	}
 }
 
Is this safe?  Should the kernel be updated as well?  I am assuming that
you were the one that originally introduced the 2K aligned scan with
this commit from the historical git:

commit 3bcbf341ca4e71b93be52eac6f6f5f698c70f0d9
Author: alan <alan>
Date:   Tue Apr 8 16:42:23 2003 +0000

    [PATCH] add but do not yet use mach specific definitions for ports etc on PC
    
    BKrev: 3e92fbefFSaWWI1bUJHNKOjfyZlfkQ

It was subsequently updated here but the alignment constraints remained
intact.

commit 8cc489a8f5a7aa83ac370480784af0206f2ce57b
Author: akpm <akpm>
Date:   Mon Apr 12 21:57:08 2004 +0000

    [PATCH] i386 probe_roms(): fixes
    
    From: Rene Herman <rene.herman@keyaccess.nl>
    
    This patch tries to improve the i386/mach-default probe_roms().  This also
    c99ifies the data, adds an IORESOURCE_IO flag for the I/O port resources,
    an IORESOURCE_MEM flag for the VRAM resource, IORESOURCE_READONLY |
    IORESOURCE_MEM for the ROM resources and adds two additional "adapter ROM
    slots" (for a total of 6) since it now also scans the 0xe0000 segment.
    
    BKrev: 407b10b4nrXSAT3lFi4Io1Kpp4Q8Jw


Thanks for the help,
Dan

