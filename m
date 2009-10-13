Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbZJMTYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbZJMTYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761099AbZJMTWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:22:53 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43609 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934109AbZJMTWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:22:51 -0400
Subject: [PATCH v2 4/9] PCI: set IORESOURCE_MEM_64 before printing resource
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:22:15 -0600
Message-ID: <20091013192215.22336.54808.stgit@bob.kio>
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
References: <20091013192040.22336.84876.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the IORESOURCE_MEM_64 struct resource flag before printing the
resource, so when %pR decodes the resource, we get the "64bit" text.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 drivers/pci/probe.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..f760c19 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -225,7 +225,10 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
 			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
 			goto fail;
-		} else if ((sizeof(resource_size_t) < 8) && l) {
+		}
+		
+		res->flags |= IORESOURCE_MEM_64;
+		if ((sizeof(resource_size_t) < 8) && l) {
 			/* Address above 32-bit boundary; disable the BAR */
 			pci_write_config_dword(dev, pos, 0);
 			pci_write_config_dword(dev, pos + 4, 0);
@@ -240,8 +243,6 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 					"64bit mmio pref" : "64bit mmio",
 				 res);
 		}
-
-		res->flags |= IORESOURCE_MEM_64;
 	} else {
 		sz = pci_size(l, sz, mask);
 

