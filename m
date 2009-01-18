Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZARTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZARTIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZARTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:08:34 -0500
Received: from usul.saidi.cx ([204.11.33.34]:60174 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752501AbZARTId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:08:33 -0500
Message-ID: <39393.98.210.152.237.1232305880.squirrel@overt.org>
Date: Sun, 18 Jan 2009 14:11:20 -0500 (EST)
Subject: [PATCH] ricoh_mmc: Use suspend_late/resume_early
From: philipl@overt.org
To: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       "Pierre Ossman" <drzeus@drzeus.cx>
Cc: rjw@sisk.pl
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

Using suspend_late/resume_early ensures that sdhci_pci suspends first
and resumes second.

Signed-off-by: Philip Langdale <philipl@overt.org>
---

 ricoh_mmc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
index be9e7b3..f627905 100644
--- a/drivers/mmc/host/ricoh_mmc.c
+++ b/drivers/mmc/host/ricoh_mmc.c
@@ -196,7 +196,7 @@ static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 }

-static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ricoh_mmc_suspend_late(struct pci_dev *pdev, pm_message_t state)
 {
 	struct pci_dev *fw_dev = NULL;

@@ -210,7 +210,7 @@ static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }

-static int ricoh_mmc_resume(struct pci_dev *pdev)
+static int ricoh_mmc_resume_early(struct pci_dev *pdev)
 {
 	struct pci_dev *fw_dev = NULL;

@@ -229,8 +229,8 @@ static struct pci_driver ricoh_mmc_driver = {
 	.id_table =	pci_ids,
 	.probe = 	ricoh_mmc_probe,
 	.remove =	__devexit_p(ricoh_mmc_remove),
-	.suspend =	ricoh_mmc_suspend,
-	.resume =	ricoh_mmc_resume,
+	.suspend_late =	ricoh_mmc_suspend_late,
+	.resume_early =	ricoh_mmc_resume_early,
 };

 /*****************************************************************************\

Based on comments from Rafael, I'm resending this patch using suspend_late and
resume_early instead.

