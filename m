Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXGAQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXGAQeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXGAQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:34:06 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:43257
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752865AbXGAQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:34:05 -0400
Date: Sun, 1 Jul 2007 18:35:13 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: samuel@sortiz.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 5/5] use mutex instead of semaphore in VLSI 82C147 IrDA controller driver
Message-ID: <20070701163513.GH3940@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	samuel@sortiz.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070701162529.GC3940@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701162529.GC3940@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The VLSI 82C147 IrDA controller driver uses a semaphore as mutex. Use
the mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index bf78ef1..0538ca9 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -44,6 +44,7 @@ MODULE_LICENSE("GPL");
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
@@ -1660,8 +1661,8 @@ vlsi_irda_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	idev = ndev->priv;
 
 	spin_lock_init(&idev->lock);
-	init_MUTEX(&idev->sem);
-	down(&idev->sem);
+	mutex_init(&idev->mtx);
+	mutex_lock(&idev->mtx);
 	idev->pdev = pdev;
 
 	if (vlsi_irda_init(ndev) < 0)
@@ -1689,12 +1690,12 @@ vlsi_irda_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	IRDA_MESSAGE("%s: registered device %s\n", drivername, ndev->name);
 
 	pci_set_drvdata(pdev, ndev);
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 
 	return 0;
 
 out_freedev:
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 	free_netdev(ndev);
 out_disable:
 	pci_disable_device(pdev);
@@ -1716,12 +1717,12 @@ static void __devexit vlsi_irda_remove(struct pci_dev *pdev)
 	unregister_netdev(ndev);
 
 	idev = ndev->priv;
-	down(&idev->sem);
+	mutex_lock(&idev->mtx);
 	if (idev->proc_entry) {
 		remove_proc_entry(ndev->name, vlsi_proc_root);
 		idev->proc_entry = NULL;
 	}
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 
 	free_netdev(ndev);
 
@@ -1751,7 +1752,7 @@ static int vlsi_irda_suspend(struct pci_dev *pdev, pm_message_t state)
 		return 0;
 	}
 	idev = ndev->priv;	
-	down(&idev->sem);
+	mutex_lock(&idev->mtx);
 	if (pdev->current_state != 0) {			/* already suspended */
 		if (state.event > pdev->current_state) {	/* simply go deeper */
 			pci_set_power_state(pdev, pci_choose_state(pdev, state));
@@ -1759,7 +1760,7 @@ static int vlsi_irda_suspend(struct pci_dev *pdev, pm_message_t state)
 		}
 		else
 			IRDA_ERROR("%s - %s: invalid suspend request %u -> %u\n", __FUNCTION__, pci_name(pdev), pdev->current_state, state.event);
-		up(&idev->sem);
+		mutex_unlock(&idev->mtx);
 		return 0;
 	}
 
@@ -1775,7 +1776,7 @@ static int vlsi_irda_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	pdev->current_state = state.event;
 	idev->resume_ok = 1;
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 	return 0;
 }
 
@@ -1790,9 +1791,9 @@ static int vlsi_irda_resume(struct pci_dev *pdev)
 		return 0;
 	}
 	idev = ndev->priv;	
-	down(&idev->sem);
+	mutex_lock(&idev->mtx);
 	if (pdev->current_state == 0) {
-		up(&idev->sem);
+		mutex_unlock(&idev->mtx);
 		IRDA_WARNING("%s - %s: already resumed\n",
 			     __FUNCTION__, pci_name(pdev));
 		return 0;
@@ -1814,7 +1815,7 @@ static int vlsi_irda_resume(struct pci_dev *pdev)
 		 * device and independently resume_ok should catch any garbage config.
 		 */
 		IRDA_WARNING("%s - hm, nothing to resume?\n", __FUNCTION__);
-		up(&idev->sem);
+		mutex_unlock(&idev->mtx);
 		return 0;
 	}
 
@@ -1824,7 +1825,7 @@ static int vlsi_irda_resume(struct pci_dev *pdev)
 		netif_device_attach(ndev);
 	}
 	idev->resume_ok = 0;
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 	return 0;
 }
 
diff --git a/drivers/net/irda/vlsi_ir.h b/drivers/net/irda/vlsi_ir.h
index 2d3b773..ca12a60 100644
--- a/drivers/net/irda/vlsi_ir.h
+++ b/drivers/net/irda/vlsi_ir.h
@@ -728,7 +728,7 @@ typedef struct vlsi_irda_dev {
 	struct timeval		last_rx;
 
 	spinlock_t		lock;
-	struct semaphore	sem;
+	struct mutex		mtx;
 
 	u8			resume_ok;	
 	struct proc_dir_entry	*proc_entry;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            You can chain me, you can torture me, you can even
          destroy this body, but you will never imprison my mind
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
