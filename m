Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYLCQz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYLCQz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYLCQzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:55:49 -0500
Received: from usul.saidi.cx ([204.11.33.34]:32812 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbYLCQzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:55:48 -0500
Message-ID: <54240.67.164.5.76.1228323573.squirrel@overt.org>
Date: Wed, 3 Dec 2008 11:59:33 -0500 (EST)
Subject: [PATCH] ricoh_mmc: Use suspend/resume_noirq (v2)
From: philipl@overt.org
To: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       "Pierre Ossman" <drzeus@drzeus.cx>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Frans Pop" <elendil@planet.nl>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ricoh_mmc suspends before sdhci_pci, it will pull the card
out from under the controller, which could leave the system in
a very confused state.

Using suspend/resume_noirq ensures that sdhci_pci suspends first
and resumes second.

Signed-off-by: Philip Langdale <philipl@overt.org>
---

  ricoh_mmc.c |   20 ++++++++++++++++----
  1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
index 1837719..b4958a7 100644
--- a/drivers/mmc/host/ricoh_mmc.c
+++ b/drivers/mmc/host/ricoh_mmc.c
@@ -194,10 +194,14 @@ static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 }

-static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ricoh_mmc_suspend_noirq(struct device *dev)
 {
+	struct pci_dev *pdev = NULL;
 	struct pci_dev *fw_dev = NULL;

+	pdev = to_pci_dev(dev);
+	BUG_ON(pdev == NULL);
+
 	fw_dev = pci_get_drvdata(pdev);
 	BUG_ON(fw_dev == NULL);

@@ -208,10 +212,14 @@ static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }

-static int ricoh_mmc_resume(struct pci_dev *pdev)
+static int ricoh_mmc_resume_noirq(struct device *dev)
 {
+	struct pci_dev *pdev = NULL;
 	struct pci_dev *fw_dev = NULL;

+	pdev = to_pci_dev(dev);
+	BUG_ON(pdev == NULL);
+
 	fw_dev = pci_get_drvdata(pdev);
 	BUG_ON(fw_dev == NULL);

@@ -222,13 +230,17 @@ static int ricoh_mmc_resume(struct pci_dev *pdev)
 	return 0;
 }

+static struct dev_pm_ops ricoh_mmc_pm_opts = {
+	.suspend_noirq =	ricoh_mmc_suspend_noirq,
+	.resume_noirq =		ricoh_mmc_resume_noirq,
+};
+
 static struct pci_driver ricoh_mmc_driver = {
 	.name = 	DRIVER_NAME,
 	.id_table =	pci_ids,
 	.probe = 	ricoh_mmc_probe,
 	.remove =	__devexit_p(ricoh_mmc_remove),
-	.suspend =	ricoh_mmc_suspend,
-	.resume =	ricoh_mmc_resume,
+	.driver.pm =	&ricoh_mmc_pm_opts,
 };

 /*****************************************************************************\

