Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYIDVti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYIDVti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYIDVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:48:44 -0400
Received: from suva.vyatta.com ([69.59.150.140]:39264 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbYIDVsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:48:41 -0400
X-Greylist: delayed 2714 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 17:48:36 EDT
Message-Id: <20080904205718.543005986@vyatta.com>
References: <20080904205636.130211023@vyatta.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 13:56:37 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] PCI: vpd handle longer delays in access
Content-Disposition: inline; filename=vpd-delay.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing the VPD area can take a long time.  The existing 
VPD access code fails consistently on my hardware. There are comments
in the SysKonnect vendor driver that it can take up to 13ms per word. 

Change the access routines to:
  * use a mutex rather than spinning with IRQ's disabled and lock held
  * have a longer timeout
  * call schedule while spinning to provide some responsivness

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/pci/access.c	2008-09-04 09:06:51.000000000 -0700
+++ b/drivers/pci/access.c	2008-09-04 10:16:52.000000000 -0700
@@ -133,7 +133,7 @@ PCI_USER_WRITE_CONFIG(dword, u32)
 
 struct pci_vpd_pci22 {
 	struct pci_vpd base;
-	spinlock_t lock; /* controls access to hardware and the flags */
+	struct mutex lock;
 	u8	cap;
 	bool	busy;
 	bool	flag; /* value of F bit to wait for */
@@ -144,29 +144,33 @@ static int pci_vpd_pci22_wait(struct pci
 {
 	struct pci_vpd_pci22 *vpd =
 		container_of(dev->vpd, struct pci_vpd_pci22, base);
-	u16 flag, status;
-	int wait;
+	u16 flag = vpd->flag ? PCI_VPD_ADDR_F : 0;
+	unsigned long timeout = jiffies + (vpd->flag ? HZ/50 : HZ/10);
+	u16 status;
 	int ret;
 
 	if (!vpd->busy)
 		return 0;
 
-	flag = vpd->flag ? PCI_VPD_ADDR_F : 0;
-	wait = vpd->flag ? 10 : 1000; /* read: 100 us; write: 10 ms */
 	for (;;) {
-		ret = pci_user_read_config_word(dev,
-						vpd->cap + PCI_VPD_ADDR,
+		ret = pci_user_read_config_word(dev, vpd->cap + PCI_VPD_ADDR,
 						&status);
 		if (ret < 0)
-			return ret;
+			break;
+
 		if ((status & PCI_VPD_ADDR_F) == flag) {
 			vpd->busy = false;
-			return 0;
+			break;
 		}
-		if (wait-- == 0)
+
+		if (time_after(jiffies, timeout))
 			return -ETIMEDOUT;
-		udelay(10);
+		if (signal_pending(current))
+			return -EINTR;
+		yield();
 	}
+
+	return ret;
 }
 
 static int pci_vpd_pci22_read(struct pci_dev *dev, int pos, int size,
@@ -183,7 +187,9 @@ static int pci_vpd_pci22_read(struct pci
 	if (size == 0)
 		return 0;
 
-	spin_lock_irq(&vpd->lock);
+	ret = mutex_lock_killable(&vpd->lock);
+	if (ret)
+		return ret;
 	ret = pci_vpd_pci22_wait(dev);
 	if (ret < 0)
 		goto out;
@@ -199,7 +205,7 @@ static int pci_vpd_pci22_read(struct pci
 	ret = pci_user_read_config_dword(dev, vpd->cap + PCI_VPD_DATA,
 					 &val);
 out:
-	spin_unlock_irq(&vpd->lock);
+	mutex_unlock(&vpd->lock);
 	if (ret < 0)
 		return ret;
 
@@ -231,7 +237,9 @@ static int pci_vpd_pci22_write(struct pc
 	val |= ((u8) *buf++) << 16;
 	val |= ((u32)(u8) *buf++) << 24;
 
-	spin_lock_irq(&vpd->lock);
+	ret = mutex_lock_killable(&vpd->lock);
+	if (ret)
+		return ret;
 	ret = pci_vpd_pci22_wait(dev);
 	if (ret < 0)
 		goto out;
@@ -247,7 +255,7 @@ static int pci_vpd_pci22_write(struct pc
 	vpd->flag = 0;
 	ret = pci_vpd_pci22_wait(dev);
 out:
-	spin_unlock_irq(&vpd->lock);
+	mutex_unlock(&vpd->lock);
 	if (ret < 0)
 		return ret;
 
@@ -279,7 +287,7 @@ int pci_vpd_pci22_init(struct pci_dev *d
 
 	vpd->base.len = PCI_VPD_PCI22_SIZE;
 	vpd->base.ops = &pci_vpd_pci22_ops;
-	spin_lock_init(&vpd->lock);
+	mutex_init(&vpd->lock);
 	vpd->cap = cap;
 	vpd->busy = false;
 	dev->vpd = &vpd->base;

-- 

