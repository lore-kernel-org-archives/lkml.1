Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZCABdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZCABdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 20:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZCABdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 20:33:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37214 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbZCABdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 20:33:38 -0500
Message-ID: <49A9E5DB.8070203@redhat.com>
Date: Sat, 28 Feb 2009 20:33:15 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix DMI for EFI
Content-Type: multipart/mixed;
 boundary="------------010802040006030407010402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010802040006030407010402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


DMI tables are loaded by EFI, so the dmi calls must happen after 
efi_init() and not before. Currently Apple hardware uses DMI to 
determine the framebuffer mappings for efifb. Without DMI working you 
also have no video on MacBook Pro. This patch resolves the DMI issue for 
EFI hardware (DMI is now properly detected at boot), and additionally 
efifb now loads on Apple hardware (i.e. video works).


Signed-off-by: Brian Maly <bmaly@redhat>

setup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


--------------010802040006030407010402
Content-Type: text/x-patch;
 name="fix-DMI-for-EFI-2.6.29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-DMI-for-EFI-2.6.29.patch"

--- a/arch/x86/kernel/setup.c	2009-02-08 15:37:27.000000000 -0500
+++ b/arch/x86/kernel/setup.c	2009-03-01 01:09:41.000000000 -0500
@@ -770,10 +770,6 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
-	dmi_scan_machine();
-
-	dmi_check_system(bad_bios_dmi_table);
-
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
@@ -792,6 +788,10 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
+	dmi_scan_machine();
+	
+	dmi_check_system(bad_bios_dmi_table);
+
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,

--------------010802040006030407010402--
