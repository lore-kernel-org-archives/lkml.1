Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbZFELaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbZFELaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZFEL36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:29:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:58115 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZFEL36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:29:58 -0400
X-Greylist: delayed 1003 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2009 07:29:57 EDT
From: "Denis V. Lunev" <den@openvz.org>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, "Denis V. Lunev" <den@openvz.org>,
       Vasily Averin <vvs@openvz.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 1/1] [WATCHDOG] fix memory corruption when RCBA is disabled by hardware
Date: Fri, 5 Jun 2009 15:13:08 +0400
Message-ID: <1244200388-17933-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to 9.1.33 on p.343 of ICH8.pdf RCBA can be disabled by
hardware if bit 0 of RCBA register is not set.

Perform correct check for this to prevent memory corruption under
some virtual machines where this feature is disabled.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Vasily Averin <vvs@openvz.org>
CC: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/iTCO_wdt.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 648250b..c35c1f5 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -666,6 +666,12 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   GCS = RCBA + ICH6_GCS(0x3410). */
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
+		if ((base_address & 1) == 0) {
+			printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+			       "RCBA is disabled by harddware\n");
+			ret = -ENODEV;
+			goto out_put;
+		}
 		RCBA = base_address & 0xffffc000;
 		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
 	}
@@ -745,6 +751,7 @@ unreg_smi_en:
 out:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
+out_put:
 	pci_dev_put(iTCO_wdt_private.pdev);
 	iTCO_wdt_private.ACPIBASE = 0;
 	return ret;
-- 
1.6.0.6

