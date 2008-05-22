Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbYEVX3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbYEVX3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbYEVX3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:29:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:39260 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757638AbYEVX3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:29:33 -0400
Message-Id: <20080522232103.120033152@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 16:21:03 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linville@tuxdriver.com
Cc: rusty@rustcorp.com.au, matthew@wil.cx, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       arjan@infradead.org
Subject: [PATCH] net: wireless: airo semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>
 
---
 drivers/net/wireless/airo.c |  107 ++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 53 deletions(-)

Index: linux-2.6.25/drivers/net/wireless/airo.c
===================================================================
--- linux-2.6.25.orig/drivers/net/wireless/airo.c
+++ linux-2.6.25/drivers/net/wireless/airo.c
@@ -36,6 +36,7 @@
 #include <linux/bitops.h>
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/unaligned.h>
@@ -1197,7 +1198,7 @@ struct airo_info {
 	tdsRssiEntry *rssi;
 	struct task_struct *list_bss_task;
 	struct task_struct *airo_thread_task;
-	struct semaphore sem;
+	struct mutex lock;
 	wait_queue_head_t thr_wait;
 	unsigned long expires;
 	struct {
@@ -1294,7 +1295,7 @@ static void micinit(struct airo_info *ai
 
 	clear_bit(JOB_MIC, &ai->jobs);
 	PC4500_readrid(ai, RID_MIC, &mic_rid, sizeof(mic_rid), 0);
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 
 	ai->micstats.enabled = (mic_rid.state & 0x00FF) ? 1 : 0;
 
@@ -1740,11 +1741,11 @@ static int readBSSListRid(struct airo_in
 		if (ai->flags & FLAG_RADIO_MASK) return -ENETDOWN;
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd=CMD_LISTBSS;
-		if (down_interruptible(&ai->sem))
+		if (mutex_lock_interruptible(&ai->lock))
 			return -ERESTARTSYS;
 		ai->list_bss_task = current;
 		issuecommand(ai, &cmd, &rsp);
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
 		/* Let the command take effect */
 		schedule_timeout_uninterruptible(3 * HZ);
 		ai->list_bss_task = NULL;
@@ -2094,7 +2095,7 @@ static void airo_end_xmit(struct net_dev
 	clear_bit(JOB_XMIT, &priv->jobs);
 	clear_bit(FLAG_PENDING_XMIT, &priv->flags);
 	status = transmit_802_3_packet (priv, fids[fid], skb->data);
-	up(&priv->sem);
+	mutex_unlock(&priv->lock);
 
 	i = 0;
 	if ( status == SUCCESS ) {
@@ -2138,7 +2139,7 @@ static int airo_start_xmit(struct sk_buf
 	fids[i] |= (len << 16);
 	priv->xmit.skb = skb;
 	priv->xmit.fid = i;
-	if (down_trylock(&priv->sem) != 0) {
+	if (mutex_trylock(&priv->lock) == 0) {
 		set_bit(FLAG_PENDING_XMIT, &priv->flags);
 		netif_stop_queue(dev);
 		set_bit(JOB_XMIT, &priv->jobs);
@@ -2159,7 +2160,7 @@ static void airo_end_xmit11(struct net_d
 	clear_bit(JOB_XMIT11, &priv->jobs);
 	clear_bit(FLAG_PENDING_XMIT11, &priv->flags);
 	status = transmit_802_11_packet (priv, fids[fid], skb->data);
-	up(&priv->sem);
+	mutex_unlock(&priv->lock);
 
 	i = MAX_FIDS / 2;
 	if ( status == SUCCESS ) {
@@ -2209,7 +2210,7 @@ static int airo_start_xmit11(struct sk_b
 	fids[i] |= (len << 16);
 	priv->xmit11.skb = skb;
 	priv->xmit11.fid = i;
-	if (down_trylock(&priv->sem) != 0) {
+	if (mutex_trylock(&priv->lock) == 0) {
 		set_bit(FLAG_PENDING_XMIT11, &priv->flags);
 		netif_stop_queue(dev);
 		set_bit(JOB_XMIT11, &priv->jobs);
@@ -2226,11 +2227,11 @@ static void airo_read_stats(struct airo_
 
 	clear_bit(JOB_STATS, &ai->jobs);
 	if (ai->power.event) {
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
 		return;
 	}
 	readStatsRid(ai, &stats_rid, RID_STATS, 0);
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 
 	ai->stats.rx_packets = le32_to_cpu(vals[43]) + le32_to_cpu(vals[44]) +
 			       le32_to_cpu(vals[45]);
@@ -2257,7 +2258,7 @@ static struct net_device_stats *airo_get
 
 	if (!test_bit(JOB_STATS, &local->jobs)) {
 		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) != 0) {
+		if (mutex_trylock(&local->lock) == 0) {
 			set_bit(JOB_STATS, &local->jobs);
 			wake_up_interruptible(&local->thr_wait);
 		} else
@@ -2276,7 +2277,7 @@ static void airo_set_promisc(struct airo
 	clear_bit(JOB_PROMISC, &ai->jobs);
 	cmd.parm0=(ai->flags&IFF_PROMISC) ? PROMISC : NOPROMISC;
 	issuecommand(ai, &cmd, &rsp);
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 }
 
 static void airo_set_multicast_list(struct net_device *dev) {
@@ -2284,7 +2285,7 @@ static void airo_set_multicast_list(stru
 
 	if ((dev->flags ^ ai->flags) & IFF_PROMISC) {
 		change_bit(FLAG_PROMISC, &ai->flags);
-		if (down_trylock(&ai->sem) != 0) {
+		if (mutex_trylock(&ai->lock) == 0) {
 			set_bit(JOB_PROMISC, &ai->jobs);
 			wake_up_interruptible(&ai->thr_wait);
 		} else
@@ -2680,7 +2681,7 @@ static struct net_device *init_wifidev(s
 static int reset_card( struct net_device *dev , int lock) {
 	struct airo_info *ai = dev->priv;
 
-	if (lock && down_interruptible(&ai->sem))
+	if (lock && mutex_lock_interruptible(&ai->lock))
 		return -1;
 	waitbusy (ai);
 	OUT4500(ai,COMMAND,CMD_SOFTRESET);
@@ -2688,7 +2689,7 @@ static int reset_card( struct net_device
 	waitbusy (ai);
 	msleep(200);
 	if (lock)
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
 	return 0;
 }
 
@@ -2774,7 +2775,7 @@ static struct net_device *_init_airo_car
 		set_bit(FLAG_MPI, &ai->flags);
 	}
 	spin_lock_init(&ai->aux_lock);
-	sema_init(&ai->sem, 1);
+	mutex_init(&ai->lock);
 	ai->config.len = 0;
 	ai->pci = pci;
 	init_waitqueue_head (&ai->thr_wait);
@@ -2946,7 +2947,7 @@ static void airo_send_event(struct net_d
 
 	clear_bit(JOB_EVENT, &ai->jobs);
 	PC4500_readrid(ai, RID_STATUS, &status_rid, sizeof(status_rid), 0);
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 	wrqu.data.length = 0;
 	wrqu.data.flags = 0;
 	memcpy(wrqu.ap_addr.sa_data, status_rid.bssid[0], ETH_ALEN);
@@ -3001,7 +3002,7 @@ static void airo_process_scan_results (s
 out:
 	ai->scan_timeout = 0;
 	clear_bit(JOB_SCAN_RESULTS, &ai->jobs);
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 
 	/* Send an empty event to user space.
 	 * We don't send the received data on
@@ -3029,7 +3030,7 @@ static int airo_thread(void *data) {
 			break;
 
 		if (ai->jobs) {
-			locked = down_interruptible(&ai->sem);
+			locked = mutex_lock_interruptible(&ai->lock);
 		} else {
 			wait_queue_t wait;
 
@@ -3078,12 +3079,12 @@ static int airo_thread(void *data) {
 			continue;
 
 		if (test_bit(JOB_DIE, &ai->jobs)) {
-			up(&ai->sem);
+			mutex_unlock(&ai->lock);
 			break;
 		}
 
 		if (ai->power.event || test_bit(FLAG_FLASHING, &ai->flags)) {
-			up(&ai->sem);
+			mutex_unlock(&ai->lock);
 			continue;
 		}
 
@@ -3106,7 +3107,7 @@ static int airo_thread(void *data) {
 		else if (test_bit(JOB_SCAN_RESULTS, &ai->jobs))
 			airo_process_scan_results(ai);
 		else  /* Shouldn't get here, but we make sure to unlock */
-			up(&ai->sem);
+			mutex_unlock(&ai->lock);
 	}
 
 	return 0;
@@ -3211,7 +3212,7 @@ static irqreturn_t airo_interrupt(int ir
 				set_bit(FLAG_UPDATE_UNI, &apriv->flags);
 				set_bit(FLAG_UPDATE_MULTI, &apriv->flags);
 
-				if (down_trylock(&apriv->sem) != 0) {
+				if (mutex_trylock(&apriv->lock) == 0) {
 					set_bit(JOB_EVENT, &apriv->jobs);
 					wake_up_interruptible(&apriv->thr_wait);
 				} else
@@ -3487,7 +3488,7 @@ static int enable_MAC(struct airo_info *
 	 * "cheaper" - Jean II */
 	if (ai->flags & FLAG_RADIO_MASK) return SUCCESS;
 
-	if (lock && down_interruptible(&ai->sem))
+	if (lock && mutex_lock_interruptible(&ai->lock))
 		return -ERESTARTSYS;
 
 	if (!test_bit(FLAG_ENABLED, &ai->flags)) {
@@ -3500,7 +3501,7 @@ static int enable_MAC(struct airo_info *
 		rc = SUCCESS;
 
 	if (lock)
-	    up(&ai->sem);
+	    mutex_unlock(&ai->lock);
 
 	if (rc)
 		airo_print_err(ai->dev->name, "Cannot enable MAC");
@@ -3516,7 +3517,7 @@ static void disable_MAC( struct airo_inf
         Cmd cmd;
 	Resp rsp;
 
-	if (lock && down_interruptible(&ai->sem))
+	if (lock && mutex_lock_interruptible(&ai->lock))
 		return;
 
 	if (test_bit(FLAG_ENABLED, &ai->flags)) {
@@ -3526,7 +3527,7 @@ static void disable_MAC( struct airo_inf
 		clear_bit(FLAG_ENABLED, &ai->flags);
 	}
 	if (lock)
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
 }
 
 static void enable_interrupts( struct airo_info *ai ) {
@@ -3721,11 +3722,11 @@ static u16 setup_card(struct airo_info *
 	/* The NOP is the first step in getting the card going */
 	cmd.cmd = NOP;
 	cmd.parm0 = cmd.parm1 = cmd.parm2 = 0;
-	if (lock && down_interruptible(&ai->sem))
+	if (lock && mutex_lock_interruptible(&ai->lock))
 		return ERROR;
 	if ( issuecommand( ai, &cmd, &rsp ) != SUCCESS ) {
 		if (lock)
-			up(&ai->sem);
+			mutex_unlock(&ai->lock);
 		return ERROR;
 	}
 	disable_MAC( ai, 0);
@@ -3735,7 +3736,7 @@ static u16 setup_card(struct airo_info *
 		cmd.cmd = CMD_ENABLEAUX;
 		if (issuecommand(ai, &cmd, &rsp) != SUCCESS) {
 			if (lock)
-				up(&ai->sem);
+				mutex_unlock(&ai->lock);
 			airo_print_err(ai->dev->name, "Error checking for AUX port");
 			return ERROR;
 		}
@@ -3748,7 +3749,7 @@ static u16 setup_card(struct airo_info *
 		}
 	}
 	if (lock)
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
 	if (ai->config.len == 0) {
 		tdsRssiRid rssi_rid;
 		CapabilityRid cap_rid;
@@ -4047,7 +4048,7 @@ static int PC4500_readrid(struct airo_in
         int rc = SUCCESS;
 
 	if (lock) {
-		if (down_interruptible(&ai->sem))
+		if (mutex_lock_interruptible(&ai->lock))
 			return ERROR;
 	}
 	if (test_bit(FLAG_MPI,&ai->flags)) {
@@ -4100,7 +4101,7 @@ static int PC4500_readrid(struct airo_in
 	}
 done:
 	if (lock)
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
 	return rc;
 }
 
@@ -4115,7 +4116,7 @@ static int PC4500_writerid(struct airo_i
 	*(__le16*)pBuf = cpu_to_le16((u16)len);
 
 	if (lock) {
-		if (down_interruptible(&ai->sem))
+		if (mutex_lock_interruptible(&ai->lock))
 			return ERROR;
 	}
 	if (test_bit(FLAG_MPI,&ai->flags)) {
@@ -4174,7 +4175,7 @@ static int PC4500_writerid(struct airo_i
 	}
 done:
 	if (lock)
-		up(&ai->sem);
+		mutex_unlock(&ai->lock);
         return rc;
 }
 
@@ -4190,7 +4191,7 @@ static u16 transmit_allocate(struct airo
 
 	cmd.cmd = CMD_ALLOCATETX;
 	cmd.parm0 = lenPayload;
-	if (down_interruptible(&ai->sem))
+	if (mutex_lock_interruptible(&ai->lock))
 		return ERROR;
 	if (issuecommand(ai, &cmd, &rsp) != SUCCESS) {
 		txFid = ERROR;
@@ -4230,7 +4231,7 @@ static u16 transmit_allocate(struct airo
 		bap_write(ai, &txControl, sizeof(txControl), BAP1);
 
 done:
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 
 	return txFid;
 }
@@ -5403,10 +5404,10 @@ static int proc_BSSList_open( struct ino
 			if (ai->flags & FLAG_RADIO_MASK) return -ENETDOWN;
 			memset(&cmd, 0, sizeof(cmd));
 			cmd.cmd=CMD_LISTBSS;
-			if (down_interruptible(&ai->sem))
+			if (mutex_lock_interruptible(&ai->lock))
 				return -ERESTARTSYS;
 			issuecommand(ai, &cmd, &rsp);
-			up(&ai->sem);
+			mutex_unlock(&ai->lock);
 			data->readlen = 0;
 			return 0;
 		}
@@ -5482,7 +5483,7 @@ static void timer_func( struct net_devic
 	set_bit (FLAG_COMMIT, &apriv->flags);
 	writeConfigRid(apriv, 0);
 	enable_MAC(apriv, 0);
-	up(&apriv->sem);
+	mutex_unlock(&apriv->lock);
 
 /* Schedule check to see if the change worked */
 	clear_bit(JOB_AUTOWEP, &apriv->jobs);
@@ -5539,7 +5540,7 @@ static int airo_pci_suspend(struct pci_d
 	readSsidRid(ai, ai->SSID);
 	memset(&cmd, 0, sizeof(cmd));
 	/* the lock will be released at the end of the resume callback */
-	if (down_interruptible(&ai->sem))
+	if (mutex_lock_interruptible(&ai->lock))
 		return -EAGAIN;
 	disable_MAC(ai, 0);
 	netif_device_detach(dev);
@@ -5593,7 +5594,7 @@ static int airo_pci_resume(struct pci_de
 	netif_device_attach(dev);
 	netif_wake_queue(dev);
 	enable_interrupts(ai);
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 	return 0;
 }
 #endif
@@ -5904,10 +5905,10 @@ static int airo_set_wap(struct net_devic
 	         !memcmp(off, awrq->sa_data, ETH_ALEN)) {
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.cmd=CMD_LOSE_SYNC;
-		if (down_interruptible(&local->sem))
+		if (mutex_lock_interruptible(&local->lock))
 			return -ERESTARTSYS;
 		issuecommand(local, &cmd, &rsp);
-		up(&local->sem);
+		mutex_unlock(&local->lock);
 	} else {
 		memset(&APList_rid, 0, sizeof(APList_rid));
 		APList_rid.len = cpu_to_le16(sizeof(APList_rid));
@@ -7135,7 +7136,7 @@ static int airo_set_scan(struct net_devi
 	 * Jean II */
 	if (ai->flags & FLAG_RADIO_MASK) return -ENETDOWN;
 
-	if (down_interruptible(&ai->sem))
+	if (mutex_lock_interruptible(&ai->lock))
 		return -ERESTARTSYS;
 
 	/* If there's already a scan in progress, don't
@@ -7151,7 +7152,7 @@ static int airo_set_scan(struct net_devi
 	wake = 1;
 
 out:
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 	if (wake)
 		wake_up_interruptible(&ai->thr_wait);
 	return 0;
@@ -7346,7 +7347,7 @@ static int airo_get_scan(struct net_devi
 	if (ai->scan_timeout > 0)
 		return -EAGAIN;
 
-	if (down_interruptible(&ai->sem))
+	if (mutex_lock_interruptible(&ai->lock))
 		return -EAGAIN;
 
 	list_for_each_entry (net, &ai->network_list, list) {
@@ -7368,7 +7369,7 @@ static int airo_get_scan(struct net_devi
 	dwrq->flags = 0;	/* todo */
 
 out:
-	up(&ai->sem);
+	mutex_unlock(&ai->lock);
 	return err;
 }
 
@@ -7403,14 +7404,14 @@ static int airo_config_commit(struct net
 		writeSsidRid(local, &SSID_rid, 1);
 		writeAPListRid(local, &APList_rid, 1);
 	}
-	if (down_interruptible(&local->sem))
+	if (mutex_lock_interruptible(&local->lock))
 		return -ERESTARTSYS;
 	writeConfigRid(local, 0);
 	enable_MAC(local, 0);
 	if (test_bit (FLAG_RESET, &local->flags))
 		airo_set_promisc(local);
 	else
-		up(&local->sem);
+		mutex_unlock(&local->lock);
 
 	return 0;
 }
@@ -7607,13 +7608,13 @@ static void airo_read_wireless_stats(str
 	/* Get stats out of the card */
 	clear_bit(JOB_WSTATS, &local->jobs);
 	if (local->power.event) {
-		up(&local->sem);
+		mutex_unlock(&local->lock);
 		return;
 	}
 	readCapabilityRid(local, &cap_rid, 0);
 	readStatusRid(local, &status_rid, 0);
 	readStatsRid(local, &stats_rid, RID_STATS, 0);
-	up(&local->sem);
+	mutex_unlock(&local->lock);
 
 	/* The status */
 	local->wstats.status = le16_to_cpu(status_rid.mode);
@@ -7658,7 +7659,7 @@ static struct iw_statistics *airo_get_wi
 
 	if (!test_bit(JOB_WSTATS, &local->jobs)) {
 		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) != 0) {
+		if (mutex_trylock(&local->lock) == 0) {
 			set_bit(JOB_WSTATS, &local->jobs);
 			wake_up_interruptible(&local->thr_wait);
 		} else
-- 

-- 
