Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYDWV6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYDWV6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYDWV6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:58:34 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:15763 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752253AbYDWV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=uCoG2FWeJsRMdQN6CFyD11mpiQOvipjDqObe40npMmH13a5wt3lKjJjnhBkMcGkl5KywtyMS+u781O6BJp4c9oe+unkICUsnZOlAfdNZnYZeK3EEp8nxaTWZKGfLlFG/HPLql8mmE0btvQQdTsX5Y6wNhKf2F5Uy1zENrAkD4+0=
Reply-To: yhlu.kernel@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       "Jeff Garzik" <jeff@garzik.org>
Subject: [PATCH 2/2] pci/irq: let pci_device_shutdown to call pci_msi_shutdown v2
Date: Wed, 23 Apr 2008 14:58:09 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Greg KH" <greg@kroah.com>,
       "linux-pci" <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
References: <200804222148.17530.yhlu.kernel@gmail.com> <200804231456.30786.yhlu.kernel@gmail.com>
In-Reply-To: <200804231456.30786.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231458.10170.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/2] pci/irq: let pci_device_shutdown to call pci_msi_shutdown v2

this change

| commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
| Author: Prakash, Sathya <sathya.prakash@lsi.com>
| Date:   Fri Mar 7 15:53:21 2008 +0530
|
|     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
|
|     This patch modifies the driver to enable MSI by default for all SAS chips.
|
|     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
|     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
|
cause kexec RHEL 5.1 kernel fail.

root casue: the rhel 5.1 kernel still use INTx emulation.
and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path

so try to call pci_msi_shutdown in shutdown patch
do the same thing to msix

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -360,6 +360,8 @@ static void pci_device_shutdown(struct d
 
 	if (drv && drv->shutdown)
 		drv->shutdown(pci_dev);
+	pci_msi_shutdown(pci_dev);
+	pci_msix_shutdown(pci_dev);
 }
 
 /**
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -703,6 +703,8 @@ static inline int pci_enable_msi(struct 
 	return -1;
 }
 
+static inline void pci_msi_shutdown(struct pci_dev *dev)
+{ }
 static inline void pci_disable_msi(struct pci_dev *dev)
 { }
 
@@ -712,6 +714,8 @@ static inline int pci_enable_msix(struct
 	return -1;
 }
 
+static inline void pci_msix_shutdown(struct pci_dev *dev)
+{ }
 static inline void pci_disable_msix(struct pci_dev *dev)
 { }
 
@@ -722,9 +726,11 @@ static inline void pci_restore_msi_state
 { }
 #else
 extern int pci_enable_msi(struct pci_dev *dev);
+extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_enable_msix(struct pci_dev *dev,
 	struct msix_entry *entries, int nvec);
+extern void pci_msix_shutdown(struct pci_dev *dev);
 extern void pci_disable_msix(struct pci_dev *dev);
 extern void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 extern void pci_restore_msi_state(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -571,10 +571,9 @@ int pci_enable_msi(struct pci_dev* dev)
 }
 EXPORT_SYMBOL(pci_enable_msi);
 
-void pci_disable_msi(struct pci_dev* dev)
+void pci_msi_shutdown(struct pci_dev* dev)
 {
 	struct msi_desc *entry;
-	int default_irq;
 
 	if (!pci_msi_enable || !dev || !dev->msi_enabled)
 		return;
@@ -590,15 +589,26 @@ void pci_disable_msi(struct pci_dev* dev
 		u32 mask = entry->msi_attrib.maskbits_mask;
 		msi_set_mask_bits(dev->irq, mask, ~mask);
 	}
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
+	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
 		return;
-	}
-
-	default_irq = entry->msi_attrib.default_irq;
-	msi_free_irqs(dev);
 
 	/* Restore dev->irq to its default pin-assertion irq */
-	dev->irq = default_irq;
+	dev->irq = entry->msi_attrib.default_irq;
+}
+void pci_disable_msi(struct pci_dev* dev)
+{
+	struct msi_desc *entry;
+
+	if (!pci_msi_enable || !dev || !dev->msi_enabled)
+		return;
+
+	pci_msi_shutdown(dev);
+
+	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
+	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+		return;
+
+	msi_free_irqs(dev);
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -691,7 +701,7 @@ static void msix_free_all_irqs(struct pc
 	msi_free_irqs(dev);
 }
 
-void pci_disable_msix(struct pci_dev* dev)
+void pci_msix_shutdown(struct pci_dev* dev)
 {
 	if (!pci_msi_enable || !dev || !dev->msix_enabled)
 		return;
@@ -699,6 +709,13 @@ void pci_disable_msix(struct pci_dev* de
 	msix_set_enable(dev, 0);
 	pci_intx_for_msi(dev, 1);
 	dev->msix_enabled = 0;
+}
+void pci_disable_msix(struct pci_dev* dev)
+{
+	if (!pci_msi_enable || !dev || !dev->msix_enabled)
+		return;
+
+	pci_msix_shutdown(dev);
 
 	msix_free_all_irqs(dev);
 }
