Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZLOCtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZLOCtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbZLOCtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:49:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:39026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbZLOCtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:49:08 -0500
Message-ID: <4B26F8BD.5070501@kernel.org>
Date: Mon, 14 Dec 2009 18:47:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Robert Hancock <hancockrwd@gmail.com>, Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/pci: don't check mmconf again if it is from MSR with
 amd faml0h
References: <200912130807.44905.tvrtko@ursulin.net> <200912141934.10628.tvrtko@ursulin.net> <4B26965C.6020203@kernel.org> <200912142016.53160.tvrtko@ursulin.net> <4B269F92.1050909@kernel.org> <4B26E4C7.8040100@gmail.com>
In-Reply-To: <4B26E4C7.8040100@gmail.com>
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
