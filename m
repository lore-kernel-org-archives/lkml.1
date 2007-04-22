Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXDVVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXDVVgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXDVVgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:36:55 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:44180
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752051AbXDVVgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:36:54 -0400
Date: Sun, 22 Apr 2007 23:39:59 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: chas@cmf.nrl.navy.mil, ecd@atecom.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070422213959.GP5013@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	chas@cmf.nrl.navy.mil, ecd@atecom.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use spinlock instead of binary mutex in idt77252 driver

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
 
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index b4b8014..e3cf141 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2430,7 +2430,7 @@ idt77252_open(struct atm_vcc *vcc)
 
 	set_bit(ATM_VF_ADDR, &vcc->flags);
 
-	down(&card->mutex);
+	mutex_lock(&card->mutex);
 
 	OPRINTK("%s: opening vpi.vci: %d.%d\n", card->name, vpi, vci);
 
@@ -2441,7 +2441,7 @@ idt77252_open(struct atm_vcc *vcc)
 		break;
 	default:
 		printk("%s: Unsupported AAL: %d\n", card->name, vcc->qos.aal);
-		up(&card->mutex);
+		mutex_unlock(&card->mutex);
 		return -EPROTONOSUPPORT;
 	}
 
@@ -2450,7 +2450,7 @@ idt77252_open(struct atm_vcc *vcc)
 		card->vcs[index] = kzalloc(sizeof(struct vc_map), GFP_KERNEL);
 		if (!card->vcs[index]) {
 			printk("%s: can't alloc vc in open()\n", card->name);
-			up(&card->mutex);
+			mutex_unlock(&card->mutex);
 			return -ENOMEM;
 		}
 		card->vcs[index]->card = card;
@@ -2479,14 +2479,14 @@ idt77252_open(struct atm_vcc *vcc)
 	if (inuse) {
 		printk("%s: %s vci already in use.\n", card->name,
 		       inuse == 1 ? "tx" : inuse == 2 ? "rx" : "tx and rx");
-		up(&card->mutex);
+		mutex_unlock(&card->mutex);
 		return -EADDRINUSE;
 	}
 
 	if (vcc->qos.txtp.traffic_class != ATM_NONE) {
 		error = idt77252_init_tx(card, vc, vcc, &vcc->qos);
 		if (error) {
-			up(&card->mutex);
+			mutex_unlock(&card->mutex);
 			return error;
 		}
 	}
@@ -2494,14 +2494,14 @@ idt77252_open(struct atm_vcc *vcc)
 	if (vcc->qos.rxtp.traffic_class != ATM_NONE) {
 		error = idt77252_init_rx(card, vc, vcc, &vcc->qos);
 		if (error) {
-			up(&card->mutex);
+			mutex_unlock(&card->mutex);
 			return error;
 		}
 	}
 
 	set_bit(ATM_VF_READY, &vcc->flags);
 
-	up(&card->mutex);
+	mutex_unlock(&card->mutex);
 	return 0;
 }
 
@@ -2515,7 +2515,7 @@ idt77252_close(struct atm_vcc *vcc)
 	unsigned long addr;
 	unsigned long timeout;
 
-	down(&card->mutex);
+	mutex_lock(&card->mutex);
 
 	IPRINTK("%s: idt77252_close: vc = %d (%d.%d)\n",
 		card->name, vc->index, vcc->vpi, vcc->vci);
@@ -2586,7 +2586,7 @@ done:
 		free_scq(card, vc->scq);
 	}
 
-	up(&card->mutex);
+	mutex_unlock(&card->mutex);
 }
 
 static int
@@ -2597,7 +2597,7 @@ idt77252_change_qos(struct atm_vcc *vcc, struct atm_qos *qos, int flags)
 	struct vc_map *vc = vcc->dev_data;
 	int error = 0;
 
-	down(&card->mutex);
+	mutex_lock(&card->mutex);
 
 	if (qos->txtp.traffic_class != ATM_NONE) {
 	    	if (!test_bit(VCF_TX, &vc->flags)) {
@@ -2643,7 +2643,7 @@ idt77252_change_qos(struct atm_vcc *vcc, struct atm_qos *qos, int flags)
 	set_bit(ATM_VF_HASQOS, &vcc->flags);
 
 out:
-	up(&card->mutex);
+	mutex_unlock(&card->mutex);
 	return error;
 }
 
@@ -3703,7 +3703,7 @@ idt77252_init_one(struct pci_dev *pcidev, const struct pci_device_id *id)
 	membase = pci_resource_start(pcidev, 1);
 	srambase = pci_resource_start(pcidev, 2);
 
-	init_MUTEX(&card->mutex);
+	mutex_init(&card->mutex);
 	spin_lock_init(&card->cmd_lock);
 	spin_lock_init(&card->tst_lock);
 
diff --git a/drivers/atm/idt77252.h b/drivers/atm/idt77252.h
index 544b397..a3b2f74 100644
--- a/drivers/atm/idt77252.h
+++ b/drivers/atm/idt77252.h
@@ -359,7 +359,7 @@ struct idt77252_dev
 	unsigned long		srambase;	/* SAR's sram  base address */
 	void __iomem		*fbq[4];	/* FBQ fill addresses */
 
-	struct semaphore	mutex;
+	struct mutex		mutex;
 	spinlock_t		cmd_lock;	/* for r/w utility/sram */
 
 	unsigned long		softstat;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              Insanity: doing the same thing over and over
                again and expecting different results
                            (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
