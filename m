Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYICXBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYICXBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYICXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:00:31 -0400
Received: from mail.vyatta.com ([216.93.170.194]:38560 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbYICXA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:00:27 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.573
Date: Wed, 3 Sep 2008 15:57:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH 1/3] pci: VPD access timeout increase
Message-ID: <20080903155713.7fab2e19@extreme>
In-Reply-To: <20080828111323.GI7908@solarflare.com>
References: <20080827204626.4b65862f@extreme>
 <20080828111323.GI7908@solarflare.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing the VPD area can take a long time. There are comments in the
SysKonnect vendor driver that it can take up to 25ms.  The existing vpd
access code fails consistently on my hardware.

Change the access routines to:
  * use a mutex rather than spinning with IRQ's disabled and lock held
  * have a longer timeout
  * call schedule while spinning to provide some responsivness

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/pci/access.c	2008-09-02 10:42:12.000000000 -0700
+++ b/drivers/pci/access.c	2008-09-03 08:47:49.000000000 -0700
@@ -133,7 +133,7 @@ PCI_USER_WRITE_CONFIG(dword, u32)
 
 struct pci_vpd_pci22 {
 	struct pci_vpd base;
-	spinlock_t lock; /* controls access to hardware and the flags */
+	struct mutex lock;
 	u8	cap;
 	bool	busy;
 	bool	flag; /* value of F bit to wait for */
@@ -144,29 +144,30 @@ static int pci_vpd_pci22_wait(struct pci
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
-	for (;;) {
-		ret = pci_user_read_config_word(dev,
-						vpd->cap + PCI_VPD_ADDR,
-						&status);
-		if (ret < 0)
-			return ret;
+	while ( (ret = pci_user_read_config_word(dev,
+						 vpd->cap + PCI_VPD_ADDR,
+						 &status)) == 0) {
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
+		schedule();
 	}
+
+	return ret;
 }
 
 static int pci_vpd_pci22_read(struct pci_dev *dev, int pos, int size,
@@ -183,7 +184,7 @@ static int pci_vpd_pci22_read(struct pci
 	if (size == 0)
 		return 0;
 
-	spin_lock_irq(&vpd->lock);
+	mutex_lock(&vpd->lock);
 	ret = pci_vpd_pci22_wait(dev);
 	if (ret < 0)
 		goto out;
@@ -199,7 +200,7 @@ static int pci_vpd_pci22_read(struct pci
 	ret = pci_user_read_config_dword(dev, vpd->cap + PCI_VPD_DATA,
 					 &val);
 out:
-	spin_unlock_irq(&vpd->lock);
+	mutex_unlock(&vpd->lock);
 	if (ret < 0)
 		return ret;
 
@@ -231,7 +232,7 @@ static int pci_vpd_pci22_write(struct pc
 	val |= ((u8) *buf++) << 16;
 	val |= ((u32)(u8) *buf++) << 24;
 
-	spin_lock_irq(&vpd->lock);
+	mutex_lock(&vpd->lock);
 	ret = pci_vpd_pci22_wait(dev);
 	if (ret < 0)
 		goto out;
@@ -247,7 +248,7 @@ static int pci_vpd_pci22_write(struct pc
 	vpd->flag = 0;
 	ret = pci_vpd_pci22_wait(dev);
 out:
-	spin_unlock_irq(&vpd->lock);
+	mutex_unlock(&vpd->lock);
 	if (ret < 0)
 		return ret;
 
@@ -279,7 +280,7 @@ int pci_vpd_pci22_init(struct pci_dev *d
 
 	vpd->base.len = PCI_VPD_PCI22_SIZE;
 	vpd->base.ops = &pci_vpd_pci22_ops;
-	spin_lock_init(&vpd->lock);
+	mutex_init(&vpd->lock);
 	vpd->cap = cap;
 	vpd->busy = false;
 	dev->vpd = &vpd->base;
