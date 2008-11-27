Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYK0Bnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYK0Bnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYK0Bnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:43:40 -0500
Received: from usul.saidi.cx ([204.11.33.34]:53050 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751157AbYK0Bnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:43:39 -0500
Message-ID: <492DFB39.1050503@overt.org>
Date: Wed, 26 Nov 2008 17:43:21 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Pierre Ossman <drzeus@drzeus.cx>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Frans Pop <elendil@planet.nl>
Subject: [PATCH] ricoh_mmc: Use suspend/resume_noirq
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
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
index be9e7b3..34064d2 100644
--- a/drivers/mmc/host/ricoh_mmc.c
+++ b/drivers/mmc/host/ricoh_mmc.c
@@ -196,10 +196,14 @@ static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
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

@@ -210,10 +214,14 @@ static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
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

@@ -224,13 +232,17 @@ static int ricoh_mmc_resume(struct pci_dev *pdev)
  	return 0;
  }

+static struct pm_ext_ops ricoh_mmc_pm_ext_opts = {
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
+	.pm =		&ricoh_mmc_pm_ext_opts,
  };

  /*****************************************************************************\

I based this change on top of my previous fix for the new chip but it will apply
successfully to the original tree. There's still merit in considering the quirk
idea but this is the simplest fix and it works (for my machine, at least :-)

--phil
