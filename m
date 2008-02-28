Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYB1Rsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYB1Rsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761238AbYB1RsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:48:22 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:47105 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761207AbYB1RsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:48:21 -0500
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.26] [WATCHDOG] Fix return value warning in hpwdt
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
	<ada3areyu7x.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net>
	<adamypmx7k1.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D5D6C@G3W0854.americas.hpqcorp.net>
	<adaejaxx9p7.fsf_-_@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 28 Feb 2008 09:48:10 -0800
In-Reply-To: <adaejaxx9p7.fsf_-_@cisco.com> (Roland Dreier's message of "Thu, 28 Feb 2008 09:38:44 -0800")
Message-ID: <adaabllx99h.fsf_-_@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Feb 2008 17:48:12.0556 (UTC) FILETIME=[16902CC0:01C87A32]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of smbios_scan_machine() is never used, and when it
succeeds it doesn't return anything, so just make it void.  This fixes:

    drivers/watchdog/hpwdt.c: In function 'smbios_scan_machine':
    drivers/watchdog/hpwdt.c:562: warning: control reaches end of non-void function

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a2e174b..b1cd0ac 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -528,20 +528,19 @@ static int __devinit smbios_present(const char __iomem *p)
 	return -ENODEV;
 }
 
-static int __devinit smbios_scan_machine(void)
+static void __devinit smbios_scan_machine(void)
 {
 	char __iomem *p, *q;
-	int rc;
 
 	if (efi_enabled) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			return -ENODEV;
+			return;
 
 		p = ioremap(efi.smbios, 32);
 		if (p == NULL)
-			return -ENOMEM;
+			return;
 
-		rc = smbios_present(p);
+		smbios_present(p);
 		iounmap(p);
 	} else {
 		/*
@@ -549,14 +548,12 @@ static int __devinit smbios_scan_machine(void)
 		 */
 		p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
 		if (p == NULL)
-			return -ENOMEM;
+			return;
 
-		for (q = p; q < p + ROM_SIZE; q += 16) {
-			rc = smbios_present(q);
-			if (!rc) {
+		for (q = p; q < p + ROM_SIZE; q += 16)
+			if (!smbios_present(q))
 				break;
-			}
-		}
+
 		iounmap(p);
 	}
 }
