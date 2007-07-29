Return-Path: <linux-kernel-owner+w=401wt.eu-S937096AbXG2Vep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937096AbXG2Vep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935779AbXG2Veh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:34:37 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:57152
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S935486AbXG2Veg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:34:36 -0400
Date: Sun, 29 Jul 2007 23:34:34 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/5] Use mutex instead of semaphore in the Host AP driver
Message-ID: <20070729213434.GD3432@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070729212909.GC3432@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729212909.GC3432@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Host AP driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

-	res = down_interruptible(&local->rid_bap_sem);
+	res = mutex_lock_interruptible(&local->rid_bap_mtx);
 	if (res)
 		return res;
 
@@ -834,7 +834,7 @@ static int hfa384x_get_rid(struct net_device *dev, u16 rid, void *buf, int len,
 		printk(KERN_DEBUG "%s: hfa384x_get_rid: CMDCODE_ACCESS failed "
 		       "(res=%d, rid=%04x, len=%d)\n",
 		       dev->name, res, rid, len);
-		up(&local->rid_bap_sem);
+		mutex_unlock(&local->rid_bap_mtx);
 		return res;
 	}
 
@@ -861,7 +861,7 @@ static int hfa384x_get_rid(struct net_device *dev, u16 rid, void *buf, int len,
 		res = hfa384x_from_bap(dev, BAP0, buf, len);
 
 	spin_unlock_bh(&local->baplock);
-	up(&local->rid_bap_sem);
+	mutex_unlock(&local->rid_bap_mtx);
 
 	if (res) {
 		if (res != -ENODATA)
@@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
 	/* RID len in words and +1 for rec.rid */
 	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
 
-	res = down_interruptible(&local->rid_bap_sem);
+	res = mutex_lock_interruptible(&local->rid_bap_mtx);
 	if (res)
 		return res;
 
@@ -917,12 +917,12 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
 	if (res) {
 		printk(KERN_DEBUG "%s: hfa384x_set_rid (rid=%04x, len=%d) - "
 		       "failed - res=%d\n", dev->name, rid, len, res);
-		up(&local->rid_bap_sem);
+		mutex_unlock(&local->rid_bap_mtx);
 		return res;
 	}
 
 	res = hfa384x_cmd(dev, HFA384X_CMDCODE_ACCESS_WRITE, rid, NULL, NULL);
-	up(&local->rid_bap_sem);
+	mutex_unlock(&local->rid_bap_mtx);
 
 	if (res) {
 		printk(KERN_DEBUG "%s: hfa384x_set_rid: CMDCODE_ACCESS_WRITE "
@@ -3171,7 +3171,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
-	init_MUTEX(&local->rid_bap_sem);
+	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
 		card_idx = 0;
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index 87a54aa..a42325c 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -3,6 +3,7 @@
 
 #include <linux/wireless.h>
 #include <linux/netdevice.h>
+#include <linux/mutex.h>
 #include <net/iw_handler.h>
 
 #include "hostap_config.h"
@@ -641,7 +642,7 @@ struct local_info {
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
 	spinlock_t cmdlock, baplock, lock;
-	struct semaphore rid_bap_sem;
+	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by
 	 * txfidlock */


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

  Si deseas mantener tu libertad, debes estar preparado para defenderla
                          (Richard Stallman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
