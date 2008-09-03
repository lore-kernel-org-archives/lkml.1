Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYICKyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYICKyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYICKx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:53:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:40705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYICKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:53:55 -0400
Subject: Blacklist DMAR on Intel G31/G33 chipsets
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: andi@firstfloor.org, arjan@infradead.org
In-Reply-To: <20080902061920.GK18288@one.firstfloor.org>
References: <20080902061920.GK18288@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 11:53:51 +0100
Message-Id: <1220439231.2985.103.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
when they don't. Avoid the resulting crashes when it doesn't work as
expected.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
Using early-quirks this time, at Andi's suggestion. I haven't been able 
to test this version though, since I killed my board when trying to reflash 
the BIOS too many times. Arjan, did you say we have a pile of these?

 arch/x86/kernel/early-quirks.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..f51f61b 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,20 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+#ifdef CONFIG_DMAR
+static void __init intel_g33_dmar(int num, int slot, int func)
+{
+	struct acpi_table_header *dmar_tbl;
+	acpi_status = status;
+
+	status = acpi_get_table(ACPI_SIG_DMAR, 0, &dmar_tbl);
+	if (ACPI_SUCCESS(status)) {
+		printk(KERN_INFO "BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring\n");
+		dmar_disabled = 1;
+	}
+}
+#endif
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -114,6 +128,10 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+#ifdef CONFIG_DMAR
+	{ PCI_VENDOR_ID_INTEL, 0x29c0,
+	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
+#endif
 	{}
 };
 
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



