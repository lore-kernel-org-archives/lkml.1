Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbYBZCdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbYBZCdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbYBZCcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:32:51 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41045 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbYBZCcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:32:50 -0500
Date: Mon, 25 Feb 2008 18:41:35 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: force re setting the mmconf for fam10h if acpi=off
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Message-id: <200802251841.36135.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some BIOS only let AMD fam 10h handle bus0, and nvidia mcp55/ck804
to handle other buses. at that case MCFG will cover all over them.

but with acpi=off, we can not use MCFG. this patch will double check
the busnbits, and if it is less handling 256 bues, and acpi=off
will forcely reset the mmconf in msr, so we still use mmconf in above case.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -720,14 +720,21 @@ static void __cpuinit fam10h_check_enabl
 
 	/* try to make sure that AP's setting is identical to BSP setting */
 	if (val & FAM10H_MMIO_CONF_ENABLE) {
-		u64 base;
-		base = val & (0xffffULL << 32);
-		if (fam10h_pci_mmconf_base_status <= 0) {
-			fam10h_pci_mmconf_base = base;
-			fam10h_pci_mmconf_base_status = 1;
-			return;
-		} else if (fam10h_pci_mmconf_base ==  base)
-			return;
+		unsigned busnbits;
+		busnbits = (val >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+		/* only trust the one handle 256 buses, if acpi=off */
+		if (!acpi_pci_disabled || busnbits >= 8) {
+			u64 base;
+			base = val & (0xffffULL << 32);
+			if (fam10h_pci_mmconf_base_status <= 0) {
+				fam10h_pci_mmconf_base = base;
+				fam10h_pci_mmconf_base_status = 1;
+				return;
+			} else if (fam10h_pci_mmconf_base ==  base)
+				return;
+		}
 	}
 
 	/*
