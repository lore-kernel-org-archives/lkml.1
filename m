Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZLMW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZLMW5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZLMW5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:57:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:36364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbZLMW5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:57:37 -0500
Message-ID: <4B257117.40009@kernel.org>
Date: Sun, 13 Dec 2009 14:56:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Are these MTRR settings correct?
References: <200912130807.44905.tvrtko@ursulin.net> <200912130826.48302.tvrtko@ursulin.net> <86802c440912130125y4215ca49l9b1bd49bde07f558@mail.gmail.com> <200912131719.01388.tvrtko@ursulin.net>
In-Reply-To: <200912131719.01388.tvrtko@ursulin.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> On Sunday 13 Dec 2009 09:25:33 Yinghai Lu wrote:
>> On Sun, Dec 13, 2009 at 12:26 AM, Tvrtko Ursulin <tvrtko@ursulin.net> wrote:
>>> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
>>> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
>>> reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
>>> reg03: base=0x0f0000000 ( 3840MB), size=  128MB, count=1: write-combining
>>>
>>> Still looks like from 3328MB to 3840MB is of status unknown?
>>>
>>> dmesg in that case:
>>>
> [    0.250038] node 0 link 0: io port [1000, ffffff]
> [    0.250040] TOM: 00000000e0000000 aka 3584M
> [    0.250041] Fam 10h mmconf [e0000000, efffffff]
> [    0.250043] node 0 link 0: mmio [a0000, bffff]
> [    0.250045] node 0 link 0: mmio [e0000000, efffffff] ==> none
> [    0.250047] node 0 link 0: mmio [f0000000, fe7fffff]
> [    0.250048] node 0 link 0: mmio [fe800000, fe9fffff]
> [    0.250050] node 0 link 0: mmio [fea00000, ffefffff]
> [    0.250051] TOM2: 0000000120000000 aka 4608M
> [    0.250053] bus: [00,07] on node 0 link 0
> [    0.250054] bus: 00 index 0 io port: [0, ffff]
> [    0.250055] bus: 00 index 1 mmio: [a0000, bffff]
> [    0.250057] bus: 00 index 2 mmio: [f0000000, ffffffff]
> [    0.250058] bus: 00 index 3 mmio: [120000000, fcffffffff]
> [    0.250065] ACPI: bus type pci registered
> [    0.250088] PCI: Found AMD Family 10h NB with MMCONFIG support.
> [    0.250091] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.250092] PCI: Not using MMCONFIG.
> [    0.250094] PCI: Using configuration type 1 for base access
> [    0.250095] PCI: Using configuration type 1 for extended access

something wrong, we should not check that with e820 or acpi resource in that case.
please check

{PATCH] x86/pci: don't check mmconf again if it is from MSR with amd faml0h

for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
because we check it and correct it already.

so skip the reject check there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/mmconfig-shared.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -168,6 +168,7 @@ static const char __init *pci_mmcfg_inte
 	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
 }
 
+static int __initdata amd_fam10h_mmconf_found_via_hostbridge;
 static const char __init *pci_mmcfg_amd_fam10h(void)
 {
 	u32 low, high, address;
@@ -215,6 +216,8 @@ static const char __init *pci_mmcfg_amd_
 			return NULL;
 		}
 
+	amd_fam10h_mmconf_found_via_hostbridge = 1;
+
 	return "AMD Family 10h NB";
 }
 
@@ -606,7 +609,12 @@ static void __init __pci_mmcfg_init(int
 	if (!known_bridge)
 		acpi_sfi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
 
-	pci_mmcfg_reject_broken(early);
+	/*
+	 * if it is amd fam10h, and that is read from msr,
+	 * we don't need check them again.
+	 */
+	if (!amd_fam10h_mmconf_found_via_hostbridge)
+		pci_mmcfg_reject_broken(early);
 
 	if (list_empty(&pci_mmcfg_list))
 		return;
