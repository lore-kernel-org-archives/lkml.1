Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbZI1GeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbZI1GeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZI1GeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZI1GeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:34:13 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: lenb@kernel.org, bjorn.helgaas@hp.com, achiang@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] acpi: pci_root: fix NULL pointer deref after resume from suspend
Date: Mon, 28 Sep 2009 14:31:20 +0800
Message-Id: <1254119480-9730-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 275582 introduces acpi_get_pci_dev(), but pdev->subordinate
can be NULL, then a NULL was passed to pci_get_slot, this results
the kernel oops when resume from suspend.

This patch resolves following kernel oops:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/acpi/pci_root.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 3112221..3c35144 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -387,7 +387,11 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 		if (!pdev || hnd == handle)
 			break;
 
-		pbus = pdev->subordinate;
+		if (pdev->subordinate)
+			pbus = pdev->subordinate;
+		else
+			pbus = pdev->bus;
+
 		pci_dev_put(pdev);
 	}
 out:
-- 
1.6.2.5

