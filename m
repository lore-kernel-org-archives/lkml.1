Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZCZUn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZCZUn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZCZUns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:43:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35175 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505AbZCZUnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:43:47 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] cx88: Missing failure checks
To: linux-kernel@vger.kernel.org, mchehab@infradead.org
Date: Thu, 26 Mar 2009 20:44:38 +0000
Message-ID: <20090326204408.4341.49334.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioremap one was reported in October 2007 (Bug 9146), the kmalloc one
was blindingly obvious while looking at the ioremap one

The bug suggests some other configuration for lots of I/O memory (32MB per
device is ioremapped) but I'll leave that to the real maintainers

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/media/video/cx88/cx88-cards.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 733ede3..2fa02cf 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3089,6 +3089,8 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	int i;
 
 	core = kzalloc(sizeof(*core), GFP_KERNEL);
+	if (core == NULL)
+		return NULL;
 
 	atomic_inc(&core->refcount);
 	core->pci_bus  = pci->bus->number;
@@ -3110,6 +3112,11 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->lmmio = ioremap(pci_resource_start(pci, 0),
 			      pci_resource_len(pci, 0));
 	core->bmmio = (u8 __iomem *)core->lmmio;
+	
+	if (core->lmmio == NULL) {
+		kfree(core);
+		return NULL;
+	}
 
 	/* board config */
 	core->boardnr = UNSET;

