Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYDVMwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYDVMwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYDVMvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:51:46 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:51550 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYDVMvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:51:44 -0400
From: Jiri Slaby <xslaby@fi.muni.cz>
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       <James.Bottomley@HansenPartnership.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] SCSI: megaraid, fix suspend/resume sections
Date: Tue, 22 Apr 2008 14:51:22 +0200
Message-Id: <1208868682-12311-1-git-send-email-xslaby@decibel.fi.muni.cz>
X-Mailer: git-send-email 1.5.5
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: xslaby@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 22 Apr 2008 14:51:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

megaraid_sas suspend and resume are inappropriatelly placed in
__devinit section. Remove those placements and make the stuff
dependent on CONFIG_PM.

While at it, mark remove function as __devexit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index b937e9c..a90944c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -2650,12 +2650,13 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	return;
 }
 
+#ifdef CONFIG_PM
 /**
  * megasas_suspend -	driver suspend entry point
  * @pdev:		PCI device structure
  * @state:		PCI power state to suspend routine
  */
-static int __devinit
+static int
 megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *host;
@@ -2687,7 +2688,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
  * megasas_resume-      driver resume entry point
  * @pdev:               PCI device structure
  */
-static int __devinit
+static int
 megasas_resume(struct pci_dev *pdev)
 {
 	int rval;
@@ -2782,12 +2783,16 @@ fail_ready_state:
 
 	return -ENODEV;
 }
+#else
+#define megasas_suspend	NULL
+#define megasas_resume	NULL
+#endif
 
 /**
  * megasas_detach_one -	PCI hot"un"plug entry point
  * @pdev:		PCI device structure
  */
-static void megasas_detach_one(struct pci_dev *pdev)
+static void __devexit megasas_detach_one(struct pci_dev *pdev)
 {
 	int i;
 	struct Scsi_Host *host;
-- 
1.5.4.5

