Return-Path: <linux-kernel-owner+w=401wt.eu-S2993215AbXDSJqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993215AbXDSJqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993220AbXDSJqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:46:31 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:57803
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993215AbXDSJqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:46:31 -0400
Date: Thu, 19 Apr 2007 11:49:45 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: chas@cmf.nrl.navy.mil
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of binary semaphore in FORE Systems 200E-series driver for ATM
Message-ID: <20070419094945.GE5013@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use mutex instead of binary semaphore in FORE Systems 200E-series
driver for ATM

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

---

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index a7c0ed3..7ab827d 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1502,9 +1502,9 @@ fore200e_open(struct atm_vcc *vcc)
     /* pseudo-CBR bandwidth requested? */
     if ((vcc->qos.txtp.traffic_class == ATM_CBR) && (vcc->qos.txtp.max_pcr > 0)) {
 	
-	down(&fore200e->rate_sf);
+	mutex_lock(&fore200e->rate_mtx);
 	if (fore200e->available_cell_rate < vcc->qos.txtp.max_pcr) {
-	    up(&fore200e->rate_sf);
+	    mutex_unlock(&fore200e->rate_mtx);
 
 	    kfree(fore200e_vcc);
 	    vc_map->vcc = NULL;
@@ -1513,7 +1513,7 @@ fore200e_open(struct atm_vcc *vcc)
 
 	/* reserve bandwidth */
 	fore200e->available_cell_rate -= vcc->qos.txtp.max_pcr;
-	up(&fore200e->rate_sf);
+	mutex_unlock(&fore200e->rate_mtx);
     }
     
     vcc->itf = vcc->dev->number;
@@ -1599,9 +1599,9 @@ fore200e_close(struct atm_vcc* vcc)
     /* release reserved bandwidth, if any */
     if ((vcc->qos.txtp.traffic_class == ATM_CBR) && (vcc->qos.txtp.max_pcr > 0)) {
 
-	down(&fore200e->rate_sf);
+	mutex_lock(&fore200e->rate_mtx);
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
-	up(&fore200e->rate_sf);
+	mutex_unlock(&fore200e->rate_mtx);
 
 	clear_bit(ATM_VF_HASQOS, &vcc->flags);
     }
@@ -2064,16 +2064,16 @@ fore200e_change_qos(struct atm_vcc* vcc,struct atm_qos* qos, int flags)
 
     if ((qos->txtp.traffic_class == ATM_CBR) && (qos->txtp.max_pcr > 0)) {
 
-	down(&fore200e->rate_sf);
+	mutex_lock(&fore200e->rate_mtx);
 	if (fore200e->available_cell_rate + vcc->qos.txtp.max_pcr < qos->txtp.max_pcr) {
-	    up(&fore200e->rate_sf);
+	    mutex_unlock(&fore200e->rate_mtx);
 	    return -EAGAIN;
 	}
 
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
 	fore200e->available_cell_rate -= qos->txtp.max_pcr;
 
-	up(&fore200e->rate_sf);
+	mutex_unlock(&fore200e->rate_mtx);
 	
 	memcpy(&vcc->qos, qos, sizeof(struct atm_qos));
 	
@@ -2459,7 +2459,7 @@ fore200e_initialize(struct fore200e* fore200e)
 
     DPRINTK(2, "device %s being initialized\n", fore200e->name);
 
-    init_MUTEX(&fore200e->rate_sf);
+    mutex_init(&fore200e->rate_mtx);
     spin_lock_init(&fore200e->q_lock);
 
     cpq = fore200e->cp_queues = fore200e->virt_base + FORE200E_CP_QUEUES_OFFSET;
diff --git a/drivers/atm/fore200e.h b/drivers/atm/fore200e.h
index f9abfda..b85a546 100644
--- a/drivers/atm/fore200e.h
+++ b/drivers/atm/fore200e.h
@@ -869,7 +869,7 @@ typedef struct fore200e {
 
     struct stats*              stats;                  /* last snapshot of the stats         */
     
-    struct semaphore           rate_sf;                /* protects rate reservation ops      */
+    struct mutex               rate_mtx;               /* protects rate reservation ops      */
     spinlock_t                 q_lock;                 /* protects queue ops                 */
 #ifdef FORE200E_USE_TASKLET
     struct tasklet_struct      tx_tasklet;             /* performs tx interrupt work         */
 
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
