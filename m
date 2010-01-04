Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374Ab0ADDN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0ADDN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952Ab0ADDHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:07:19 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65040 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0ADDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:14 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/29] x86/pci: don't check mmconf again if it is from MSR with
 amd faml0h
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
because we check it and correct it already.

so skip the reject check there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/mmconfig-shared.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index b19d1e5..bcce99b 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -168,6 +168,7 @@ static const char __init *pci_mmcfg_intel_945(void)
 	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
 }
 
+static int __initdata amd_fam10h_mmconf_found_via_hostbridge;
 static const char __init *pci_mmcfg_amd_fam10h(void)
 {
 	u32 low, high, address;
@@ -215,6 +216,8 @@ static const char __init *pci_mmcfg_amd_fam10h(void)
 			return NULL;
 		}
 
+	amd_fam10h_mmconf_found_via_hostbridge = 1;
+
 	return "AMD Family 10h NB";
 }
 
@@ -606,7 +609,12 @@ static void __init __pci_mmcfg_init(int early)
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
-- 
1.6.4.2

