Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbZFJT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbZFJT7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761452AbZFJT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:56:07 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47578 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761471AbZFJTzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:55:43 -0400
Subject: [PATCH v3 08/12] ACPI: acpi_pci_unbind should clean up properly after
	acpi_pci_bind
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Wed, 10 Jun 2009 13:55:45 -0600
Message-ID: <20090610195545.28982.31987.stgit@bob.kio>
In-Reply-To: <20090610194714.28982.51363.stgit@bob.kio>
References: <20090610194714.28982.51363.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_pci_bind, we set device->ops.bind and device->ops.unbind, but
never clear them out.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 62cb383..a205769 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -109,12 +109,15 @@ static int acpi_pci_unbind(struct acpi_device *device)
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
-	if (!dev)
-		return 0;
+	if (!dev || !dev->subordinate)
+		goto out;
 
-	if (dev->subordinate)
-		acpi_pci_irq_del_prt(dev->subordinate);
+	acpi_pci_irq_del_prt(dev->subordinate);
+
+	device->ops.bind = NULL;
+	device->ops.unbind = NULL;
 
+out:
 	pci_dev_put(dev);
 	return 0;
 }

