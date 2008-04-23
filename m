Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYDWEsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYDWEsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 00:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYDWEsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 00:48:43 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:59133 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbYDWEsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 00:48:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=E2z2dfanoCB48Wj7OtfbPcG6MRZ56HOksbbj/6jM6BkNY2sO6wjRnE+bDB9yk2bE31XxwU2FaCMiNHd39sPYE5uHVAumvBVe0/Wo1YMCTB8LhaeQLwiX+Gcv8Q8VUmnsesokdVQAAZyhXs71tgG+vdHO3Sm1OdxMYemVb5OoFcw=
Reply-To: yhlu.kernel@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
Date: Tue, 22 Apr 2008 21:48:16 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Greg KH" <greg@kroah.com>, "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "linux-pci" <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804222148.17530.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

so try to call pci_disable_msi in shutdown patch

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -360,6 +360,8 @@ static void pci_device_shutdown(struct d
 
 	if (drv && drv->shutdown)
 		drv->shutdown(pci_dev);
+	pci_disable_msi_simple(pci_dev);
+	pci_disable_msix_simple(pci_dev);
 }
 
 /**
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -722,9 +722,11 @@ static inline void pci_restore_msi_state
 { }
 #else
 extern int pci_enable_msi(struct pci_dev *dev);
+extern void pci_disable_msi_simple(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_enable_msix(struct pci_dev *dev,
 	struct msix_entry *entries, int nvec);
+extern void pci_disable_msix_simple(struct pci_dev *dev);
 extern void pci_disable_msix(struct pci_dev *dev);
 extern void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 extern void pci_restore_msi_state(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -569,7 +569,7 @@ int pci_enable_msi(struct pci_dev* dev)
 }
 EXPORT_SYMBOL(pci_enable_msi);
 
-void pci_disable_msi(struct pci_dev* dev)
+static void __pci_disable_msi(struct pci_dev* dev, int msi_free)
 {
 	struct msi_desc *entry;
 	int default_irq;
@@ -591,11 +591,20 @@ void pci_disable_msi(struct pci_dev* dev
 	}
 
 	default_irq = entry->msi_attrib.default_irq;
-	msi_free_irqs(dev);
+	if (msi_free)
+		msi_free_irqs(dev);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = default_irq;
 }
+void pci_disable_msi_simple(struct pci_dev* dev)
+{
+	__pci_disable_msi(dev, 0);
+}
+void pci_disable_msi(struct pci_dev* dev)
+{
+	__pci_disable_msi(dev, 1);
+}
 EXPORT_SYMBOL(pci_disable_msi);
 
 static int msi_free_irqs(struct pci_dev* dev)
@@ -687,7 +696,7 @@ static void msix_free_all_irqs(struct pc
 	msi_free_irqs(dev);
 }
 
-void pci_disable_msix(struct pci_dev* dev)
+static void __pci_disable_msix(struct pci_dev* dev, int msix_free)
 {
 	if (!pci_msi_enable || !dev || !dev->msix_enabled)
 		return;
@@ -696,7 +705,16 @@ void pci_disable_msix(struct pci_dev* de
 	pci_intx_for_msi(dev, 1);
 	dev->msix_enabled = 0;
 
-	msix_free_all_irqs(dev);
+	if (msix_free)
+		msix_free_all_irqs(dev);
+}
+void pci_disable_msix_simple(struct pci_dev* dev)
+{
+	__pci_disable_msix(dev, 0);
+}
+void pci_disable_msix(struct pci_dev* dev)
+{
+	__pci_disable_msix(dev, 1);
 }
 EXPORT_SYMBOL(pci_disable_msix);
 
