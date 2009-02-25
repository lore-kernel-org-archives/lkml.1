Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZBYMqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZBYMqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZBYMq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:46:29 -0500
Received: from smtp02.msg.oleane.net ([62.161.4.2]:39664 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZBYMq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:46:28 -0500
X-Oleane-Rep: REPA
From: "Thomas Jourdan" <tjourdan@interfaceconcept.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: [BUG] efi_call_phys arguments has virtual address on IA32 / EFI
Date: Wed, 25 Feb 2009 18:13:20 +0100
Message-ID: <FCA979400714455FA1BAFF6E60B5A829@thje6600v>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0030_01C99774.BF75AAD0"
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
In-Reply-To: 
Importance: Normal
X-Spam-Flag: NO
X-PMX-Spam: Probability=14%
X-PFSI-Info: PMX 5.5.2.365749, Antispam-Engine: 2.6.1.350677, Antispam-Data: 2009.2.25.122820 (no antivirus check)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0030_01C99774.BF75AAD0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi

I propose the following patch to fix the "Oops: efitime: can't read time!"
error message on boot. We call the efi runtime get time function with
arguments storing the physical address instead of the kernel virtual
address. It works on my IA32 / EFI platform but I can not test on x86_64 /
EFI (not yet).

Could someone have a look to it ?

Regards,
Thomas

-----Message d'origine-----
De : Thomas Jourdan [mailto:tjourdan@interfaceconcept.com]
Envoyé : lun. 23 février 2009 18:29
À : 'linux-kernel@vger.kernel.org'
Objet : [BUG] efi_call_phys arguments has virtual address on IA32 / EFI


Hi

On a x86 UEFI (IA32) platform, with CONFIG_EFI enabled, I have the following
error on boot :
...
PID hash table entries: 4096 (order: 12, 16384 bytes)
Oops: efitime: can't read time!
TSC: PIT calibration matches PMTIMER. 1 loops
...

This happens early (during start_kernel), the first time we call the
efi_get_time function of EFI runtime services (from timekeeping_init). At
this moment, phys_efi_get_time is called. I'm not fluent with x86 assembler
but it seems that there is a bug in the efi_call_phys function
(arch/x86/kernel/efi_stub_32.S). From what I understand, we need to switch
from virtual mode to flat mode, ie removing __PAGE_OFFSET for the low
memory. It seems that it is not the case for the parameters.

For example, phys_efi_get_time uses 2 parameters : efi_time_t *tm and
efi_time_cap_t *tc. In my case, when phys_efi_get_time is called, tm =
0xC05C5FA8 (valid kernel virtual address). When I enter the associated get
time function of my efi firmware, the tm paramater has been put into %EDI,
which is 0xC05C5FA8, not 0x005C5FA8 :
- If I continue the execution of the get time function from the efi
firmware, rtc value are stored at invalid address and we leave the function
with an error.
- If I manually change the %EDI value from 0xC05C5FA8 to 0x005C5FA8 before
executing the get time function of the efi firmware, the function behaves
correctly, and there is no error.

Could someone confirm that it is really a bug ? If a patch is proposed, I
can test it quickly.

Regards,
Thomas




------=_NextPart_000_0030_01C99774.BF75AAD0
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

------=_NextPart_000_0030_01C99774.BF75AAD0--

