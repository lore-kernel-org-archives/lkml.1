Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZBWL5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZBWL5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZBWL5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:57:25 -0500
Received: from smtp03.msg.oleane.net ([62.161.4.3]:57704 "EHLO
	smtp03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZBWL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:57:25 -0500
X-Greylist: delayed 1250 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 06:57:24 EST
X-Oleane-Rep: REPA
From: "Thomas Jourdan" <tjourdan@interfaceconcept.com>
To: <linux-kernel@vger.kernel.org>
Subject: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
Date: Mon, 23 Feb 2009 16:40:29 +0100
Message-ID: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0052_01C995D5.73E4B1B0"
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Importance: Normal
X-Spam-Flag: NO
X-PMX-Spam: Probability=14%
X-PFSI-Info: PMX 5.5.2.365749, Antispam-Engine: 2.6.1.350677, Antispam-Data: 2009.2.23.111922 (no antivirus check)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0052_01C995D5.73E4B1B0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi

On x86/EFI platforms, if efi_enabled is true, the dmi_scan_machine function
fails, even if valid DMI table is present. In the setup_arch function,
efi_init is called after dmi_scan_machine. But this is efi_init which will
initialize the smbios address, needed by dmi_scan_machine.

This leads to dmi_scan_machine ioremapping physical address 0, instead of
the address provided by the EFI system table. The following patch fixes the
problem.

Regards,
Thomas

------=_NextPart_000_0052_01C995D5.73E4B1B0
Content-Type: application/octet-stream;
	name="dmi_scan.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmi_scan.patch"

On x86 / EFI platforms, the SMBIOS table address is available in the EFI=0A=
system table. During the setup_arch function, the dmi_scan_machine =
function=0A=
will detect valid DMI table or not. =0A=
=0A=
If CONFIG_EFI is set, the dmi_scan_table function will use the address =
provided=0A=
by the EFI system table. But it is inialized later, in the efi_init =
function. =0A=
=0A=
This patch fixes the call order.=0A=
=0A=
--- linux-2.6.28.6/arch/x86/kernel/setup.c	2009-02-17 18:29:27.000000000 =
+0100=0A=
+++ linux-2.6.28.6/arch/x86/kernel/setup.c	2009-02-23 09:57:57.000000000 =
+0100=0A=
@@ -903,6 +903,9 @@=0A=
 =0A=
 	finish_e820_parsing();=0A=
 =0A=
+	if (efi_enabled)=0A=
+		efi_init();=0A=
+=0A=
 	dmi_scan_machine();=0A=
 =0A=
 	dmi_check_system(bad_bios_dmi_table);=0A=
@@ -916,9 +919,6 @@=0A=
 	insert_resource(&iomem_resource, &data_resource);=0A=
 	insert_resource(&iomem_resource, &bss_resource);=0A=
 =0A=
-	if (efi_enabled)=0A=
-		efi_init();=0A=
-=0A=
 #ifdef CONFIG_X86_32=0A=
 	if (ppro_with_ram_bug()) {=0A=
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,=0A=

------=_NextPart_000_0052_01C995D5.73E4B1B0--

