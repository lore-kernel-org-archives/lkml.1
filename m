Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbYDDNMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbYDDNMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbYDDNE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:04:59 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:51474 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbYDDNE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:04:57 -0400
From: Thomas Klein <osstklei@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] ehea: Fix DLPAR memory add support
Date: Fri, 4 Apr 2008 15:04:53 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hannes Hering <hering2@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041504.54130.osstklei@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two weaknesses in send/receive packet handling which may
lead to kernel panics during DLPAR memory add operations.

Signed-off-by: Thomas Klein <tklein@de.ibm.com>

---
diff -Nurp -X dontdiff linux-2.6.25-rc8/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
--- linux-2.6.25-rc8/drivers/net/ehea/ehea.h	2008-04-01 21:44:26.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea.h	2008-04-03 15:36:36.000000000 +0200
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0089"
+#define DRV_VERSION	"EHEA_0090"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
@@ -371,6 +371,7 @@ struct ehea_port_res {
 	struct ehea_q_skb_arr rq2_skba;
 	struct ehea_q_skb_arr rq3_skba;
 	struct ehea_q_skb_arr sq_skba;
+	int sq_skba_size;
 	spinlock_t netif_queue;
 	int queue_stopped;
 	int swqe_refill_th;
diff -Nurp -X dontdiff linux-2.6.25-rc8/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
--- linux-2.6.25-rc8/drivers/net/ehea/ehea_main.c	2008-04-01 21:44:26.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea_main.c	2008-04-03 15:36:36.000000000 +0200
@@ -349,7 +349,8 @@ static void ehea_refill_rq1(struct ehea_
 	pr->rq1_skba.os_skbs = 0;
 
 	if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags))) {
-		pr->rq1_skba.index = index;
+		if (nr_of_wqes > 0)
+			pr->rq1_skba.index = index;
 		pr->rq1_skba.os_skbs = fill_wqes;
 		return;
 	}
@@ -1464,7 +1465,9 @@ static int ehea_init_port_res(struct ehe
 			  init_attr->act_nr_rwqes_rq2,
 			  init_attr->act_nr_rwqes_rq3);
 
-	ret = ehea_init_q_skba(&pr->sq_skba, init_attr->act_nr_send_wqes + 1);
+	pr->sq_skba_size = init_attr->act_nr_send_wqes + 1;
+
+	ret = ehea_init_q_skba(&pr->sq_skba, pr->sq_skba_size);
 	ret |= ehea_init_q_skba(&pr->rq1_skba, init_attr->act_nr_rwqes_rq1 + 1);
 	ret |= ehea_init_q_skba(&pr->rq2_skba, init_attr->act_nr_rwqes_rq2 + 1);
 	ret |= ehea_init_q_skba(&pr->rq3_skba, init_attr->act_nr_rwqes_rq3 + 1);
@@ -2621,6 +2624,22 @@ void ehea_purge_sq(struct ehea_qp *orig_
 	}
 }
 
+void ehea_flush_sq(struct ehea_port *port)
+{
+	int i;
+
+	for (i = 0; i < port->num_def_qps + port->num_add_tx_qps; i++) {
+		struct ehea_port_res *pr = &port->port_res[i];
+		int swqe_max = pr->sq_skba_size - 2 - pr->swqe_ll_count;
+		int k = 0;
+		while (atomic_read(&pr->swqe_avail) < swqe_max) {
+			msleep(5);
+			if (++k == 20)
+				break;
+		}
+	}
+}
+
 int ehea_stop_qps(struct net_device *dev)
 {
 	struct ehea_port *port = netdev_priv(dev);
@@ -2845,6 +2864,7 @@ static void ehea_rereg_mrs(struct work_s
 					if (dev->flags & IFF_UP) {
 						down(&port->port_lock);
 						netif_stop_queue(dev);
+						ehea_flush_sq(port);
 						ret = ehea_stop_qps(dev);
 						if (ret) {
 							up(&port->port_lock);
