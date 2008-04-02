Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYDBAS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYDBAS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYDBASt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:18:49 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:10320 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYDBASs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=AJXLoDSbCJ/7z4TWFdefAAfPynxHjRxusJ89qb79fevNNrXuF1852zQOcHpoJwvvqhb9uFsoG27T7zvlGJoEF1Fcqx2o8dvs5JGpjCqvavJTSrIOCmU8mfI1ZxmaAPi7OFrAmNQJL81SE9gDMmAeiXkvtZ+PWS1tgOjvA1p17JE=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ixgb/e: fix IRQx nobody cared for shared irq with INTx
Date: Tue, 1 Apr 2008 17:20:03 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
References: <200803291403.23479.yhlu.kernel@gmail.com> <200803311458.56119.yhlu.kernel@gmail.com>
In-Reply-To: <200803311458.56119.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011720.03569.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] ixgb/e: fix IRQx nobody cared for shared irq with INTx

solve
	ixgb on pci-x and mptsas on pci-x. sometime mptsas get confused.

same to
	[PATCH] e1000: fix IRQx nobody cared for shared irq with INTx
	http://lkml.org/lkml/2008/3/29/103

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/drivers/net/ixgb/ixgb_main.c
===================================================================
--- linux-2.6.orig/drivers/net/ixgb/ixgb_main.c
+++ linux-2.6/drivers/net/ixgb/ixgb_main.c
@@ -290,6 +290,11 @@ ixgb_up(struct ixgb_adapter *adapter)
 #endif
 	ixgb_irq_enable(adapter);
 
+	if (!adapter->have_msi) {
+		/* enable INTx if not using MSI */
+		pci_intx(adapter->pdev, 1);
+	}
+
 	return 0;
 }
 
@@ -368,6 +373,8 @@ ixgb_probe(struct pci_dev *pdev,
 	int i;
 	int err;
 
+	/* disable INTx at first */
+	pci_intx(pdev, 0);
 	if((err = pci_enable_device(pdev)))
 		return err;
 
Index: linux-2.6/drivers/net/ixgbe/ixgbe_main.c
===================================================================
--- linux-2.6.orig/drivers/net/ixgbe/ixgbe_main.c
+++ linux-2.6/drivers/net/ixgbe/ixgbe_main.c
@@ -1988,6 +1988,12 @@ try_intr_reinit:
 	if (err)
 		goto err_up;
 
+	if (!(adapter->flags &
+	      (IXGBE_FLAG_MSI_ENABLED | IXGBE_FLAG_MSIX_ENABLED))) {
+		/* enable INTx if not using MSI/MSIX */
+		pci_intx(adapter->pdev, 1);
+	}
+
 	return 0;
 
 err_up:
@@ -2627,6 +2633,8 @@ static int __devinit ixgbe_probe(struct 
 	u16 link_status, link_speed, link_width;
 	u32 part_num;
 
+	/* disable INTx at first */
+	pci_intx(pdev, 0);
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
