Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbZLRULf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbZLRULf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbZLRULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:11:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:55355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548AbZLRULS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:11:18 -0500
Message-ID: <4B2BE196.2000404@kernel.org>
Date: Fri, 18 Dec 2009 12:09:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 7/7] x86/pci: don't check mmconf again if it is from MSR with
 amd faml0h
References: <4B2BE063.4040704@kernel.org>
In-Reply-To: <4B2BE063.4040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

