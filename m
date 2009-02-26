Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZBZR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZBZR5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZBZR5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:57:07 -0500
Received: from smtp06.msg.oleane.net ([62.161.4.6]:47164 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZBZR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:57:06 -0500
X-Oleane-Rep: REPA
From: "Thomas Jourdan" <tjourdan@interfaceconcept.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 / EFI dmi and efi get time error messages on boot
Date: Thu, 26 Feb 2009 20:56:55 +0100
Message-ID: <95E94E38877043A696149D0B895142AF@thje6600v>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0000_01C99854.C378F9D0"
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-Spam-Flag: NO
X-PMX-Spam: Probability=8%
X-PFSI-Info: PMX 5.5.2.365749, Antispam-Engine: 2.6.1.350677, Antispam-Data: 2009.2.26.174310 (no antivirus check)
X-Orange-Auth: dGpvdXJkYW5AaW50ZXJmYWNlY29uY2VwdC5jb20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0000_01C99854.C378F9D0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On x86 / EFI platforms, the following patches fixes :
- use of uninitialized smbios table address by dmi_scan_machine
- call phys_efi_get_time with arguments storing physical address instead of
kernel virtual address

Regards,
Thomas

Signed-off-by: Thomas Jourdan <tjourdan@interfaceconcept.com>

------=_NextPart_000_0000_01C99854.C378F9D0
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

------=_NextPart_000_0000_01C99854.C378F9D0
Content-Type: application/octet-stream;
	name="phys_efi_get_time.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="phys_efi_get_time.patch"

--- linux-2.6.28.6/arch/x86/kernel/efi.c	2009-02-17 18:29:27.000000000 =
+0100=0A=
+++ linux-2.6.28.6/arch/x86/kernel/efi.c	2009-02-25 11:00:39.000000000 =
+0100=0A=
@@ -176,7 +176,7 @@=0A=
 	efi_status_t status;=0A=
 =0A=
 	efi_call_phys_prelog();=0A=
-	status =3D efi_call_phys2(efi_phys.get_time, tm, tc);=0A=
+	status =3D efi_call_phys2(efi_phys.get_time, __pa(tm), __pa(tc));=0A=
 	efi_call_phys_epilog();=0A=
 	return status;=0A=
 }=0A=

------=_NextPart_000_0000_01C99854.C378F9D0--

