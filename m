Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZEaGoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZEaGoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbZEaGnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:43:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:34081 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZEaGny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="417224601"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:43:55 +0800
Subject: [Patch 06/08] Staging: heci - fix setting h_is bit in h_csr register
Thread-Topic: [Patch 06/08] Staging: heci - fix setting h_is bit in h_csr
 register
Thread-Index: AcnhuyrMPf6zb6L3TBy7N1C7hrjaCA==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE4@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 88efd711b8209047054126e1d89254b0a6cfb5d4 Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:46:34 +0800
Subject: [PATCH] heci: fix setting h_is bit in h_csr register.

Host software could issue interrupts to ME firmware, using H_IG bit. While
Setting H_IG bit, host software should preserve all the other bits in H_CSR
unchanged. In the original function which sets H_CSR register, they first read
the register, then set some bits, and write the whole 32bits back to the
register. And that the special behavior of H_IS (write-one-to-zero) causes problem.
This patch fixes the issue in the following ways:

 - Modify heci_set_csr_register() function so that it doesn't change H_IS bit.
 - Add interface heci_csr_clear_his() to clear H_IS bit. This function is called
   after H_IS checking (dev->host_hw_state & H_IS == H_IS).
 - In original heci_csr_disable_interrupts() function, it not only clears H_IE
   bit, sometimes it also clears H_IS bit. This patch separates the two parts.
 - Avoid calling write_heci_register() function to set H_CSR register directly,
   and instead using heci_set_csr_register() function

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/heci_init.c      |    4 ++--
 drivers/staging/heci/heci_interface.c |   17 +++++++++++++++--
 drivers/staging/heci/heci_interface.h |    1 +
 drivers/staging/heci/interrupt.c      |    6 ++++++
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/heci/heci_init.c b/drivers/staging/heci/heci_init.c
index 06ea196..427f55d 100644
--- a/drivers/staging/heci/heci_init.c
+++ b/drivers/staging/heci/heci_init.c
@@ -249,7 +249,7 @@ int heci_hw_init(struct iamt_heci_device *dev)
 
 	if ((dev->host_hw_state & H_IS) == H_IS) {
 		/* acknowledge interrupt and stop interupts */
-		heci_set_csr_register(dev);
+		heci_csr_clear_his(dev);
 	}
 	dev->recvd_msg = 0;
 	DBG("reset in start the heci device.\n");
@@ -354,7 +354,7 @@ void heci_reset(struct iamt_heci_device *dev, int interrupts)
 	dev->host_hw_state &= ~H_RST;
 	dev->host_hw_state |= H_IG;
 
-	write_heci_register(dev, H_CSR, dev->host_hw_state);
+	heci_set_csr_register(dev);
 
 	DBG("currently saved host_hw_state = 0x%08x.\n",
 	    dev->host_hw_state);
diff --git a/drivers/staging/heci/heci_interface.c b/drivers/staging/heci/heci_interface.c
index c5f51a7..03e1df1 100644
--- a/drivers/staging/heci/heci_interface.c
+++ b/drivers/staging/heci/heci_interface.c
@@ -44,12 +44,15 @@
 
 
 /**
- * heci_set_csr_register - write H_CSR register to the heci device
+ * heci_set_csr_register - write H_CSR register to the heci device,
+ * and ignore the H_IS bit for it is write-one-to-zero.
  *
  * @dev: device object for our driver
  */
 void heci_set_csr_register(struct iamt_heci_device *dev)
 {
+	if ((dev->host_hw_state & H_IS) == H_IS)
+		dev->host_hw_state &= ~H_IS;
 	write_heci_register(dev, H_CSR, dev->host_hw_state);
 	dev->host_hw_state = read_heci_register(dev, H_CSR);
 }
@@ -76,6 +79,16 @@ void heci_csr_disable_interrupts(struct iamt_heci_device *dev)
 	heci_set_csr_register(dev);
 }
 
+/**
+ * heci_csr_clear_his - clear H_IS bit in H_CSR
+ *
+ * @dev: device object for our driver
+ */
+void heci_csr_clear_his(struct iamt_heci_device *dev)
+{
+	write_heci_register(dev, H_CSR, dev->host_hw_state);
+	dev->host_hw_state = read_heci_register(dev, H_CSR);
+}
 
 /**
  * _host_get_filled_slots - get number of device filled buffer slots
@@ -185,7 +198,7 @@ int heci_write_message(struct iamt_heci_device *dev,
 	}
 
 	dev->host_hw_state |= H_IG;
-	write_heci_register(dev, H_CSR, dev->host_hw_state);
+	heci_set_csr_register(dev);
 	dev->me_hw_state = read_heci_register(dev, ME_CSR_HA);
 	if ((dev->me_hw_state & ME_RDY_HRA) != ME_RDY_HRA)
 		return 0;
diff --git a/drivers/staging/heci/heci_interface.h b/drivers/staging/heci/heci_interface.h
index 37336eb..aff7f80 100644
--- a/drivers/staging/heci/heci_interface.h
+++ b/drivers/staging/heci/heci_interface.h
@@ -134,6 +134,7 @@ enum client_disconnect_status_types{
 void heci_set_csr_register(struct iamt_heci_device *dev);
 void heci_csr_enable_interrupts(struct iamt_heci_device *dev);
 void heci_csr_disable_interrupts(struct iamt_heci_device *dev);
+void heci_csr_clear_his(struct iamt_heci_device *dev);
 
 void heci_read_slots(struct iamt_heci_device *dev,
 		     unsigned char *buffer, unsigned long buffer_length);
diff --git a/drivers/staging/heci/interrupt.c b/drivers/staging/heci/interrupt.c
index b7ce73b..3a510ed 100644
--- a/drivers/staging/heci/interrupt.c
+++ b/drivers/staging/heci/interrupt.c
@@ -92,6 +92,9 @@ irqreturn_t heci_isr_interrupt(int irq, void *dev_id)
 	/* disable interrupts */
 	heci_csr_disable_interrupts(dev);
 
+	/* clear H_IS bit in H_CSR */
+	heci_csr_clear_his(dev);
+
 	/*
 	 * Our device interrupted, schedule work the heci_bh_handler
 	 * to handle the interrupt processing. This needs to be a
@@ -251,6 +254,9 @@ end:
 		/* acknowledge interrupt and disable interrupts */
 		heci_csr_disable_interrupts(dev);
 
+		/* clear H_IS bit in H_CSR */
+		heci_csr_clear_his(dev);
+
 		PREPARE_WORK(&dev->work, heci_bh_handler);
 		DBG("schedule work the heci_bh_handler.\n");
 		rets = schedule_work(&dev->work);
-- 
1.6.0.rc1

