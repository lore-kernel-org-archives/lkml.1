Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZLVXno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZLVXno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZLVXmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:42:16 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58157 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZLVXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:42:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:40:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/25] x86/pci: don't check mmconf again if it is from MSR with
 amd faml0h
In-reply-to: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261525263-13763-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
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
1.6.0.2

