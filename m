Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYGRQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYGRQly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYGRQlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:41:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:6762 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbYGRQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=vU6vDOmdJOXOQsIhWOjxbKifeMkoHEiiYHuQ+FPaD/P8/E39gGbuM3P+rikkNzTBN0
         K0046xyVv+QfMCEBNFNnDG2paPN1vcHsxnDD4tpOc5prRSCUrayYhZifQNxrAXjm63Fm
         OxMQt5p/CyVA6NEkJMSuaDIoaHVWMy76YVPtM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       Jack Howarth <howarth@bromo.msbb.uc.edu>
Subject: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Date: Fri, 18 Jul 2008 09:41:09 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807180941.09779.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


change the mconf bus range from [0,0xff] to to [0, 0x3f]
to match range [0xf0000000, 0xf4000000) in e820 tables.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>

---
 arch/x86/pci/mmconfig-shared.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -374,6 +374,40 @@ reject:
 
 static int __initdata known_bridge;
 
+static int __devinit check_mmconf(const struct dmi_system_id *d)
+{
+	typeof(pci_mmcfg_config[0]) *cfg;
+
+	if ((pci_mmcfg_config_num != 1) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return 1;
+
+	cfg = &pci_mmcfg_config[0];
+
+	if (cfg->start_bus_number == 0 && cfg->end_bus_number > 0x3f)
+		cfg->end_bus_number = 0x3f;
+
+	return 0;
+}
+
+static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
+	{
+		.callback = check_mmconf,
+		.ident = "Apple",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2"),
+		},
+	},
+	{}
+};
+
+void __init check_mmconf_dmi(void)
+{
+        dmi_check_system(mmconf_dmi_table);
+}
+
 static void __init __pci_mmcfg_init(int early)
 {
 	/* MMCONFIG disabled */
@@ -395,6 +429,7 @@ static void __init __pci_mmcfg_init(int
 
 	if (!known_bridge) {
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+		check_mmconf_dmi();
 		pci_mmcfg_reject_broken(early);
 	}
 
