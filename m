Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYC3XXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYC3XXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYC3XWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:22:33 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55098 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYC3XWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:22:31 -0400
Date: Mon, 31 Mar 2008 02:22:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dhananjay Phadke <dhananjay@netxen.com>, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make netxen_workq static
Message-ID: <20080330232218.GP28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netxen_workq can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/netxen/netxen_nic.h      |   17 -----------------
 drivers/net/netxen/netxen_nic_main.c |   20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 18 deletions(-)

725b949974133f14ecf29807ae9605b1a84d43e3 diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index ca339cf..8cb29f5 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -95,23 +95,6 @@
 
 #define ADDR_IN_WINDOW1(off)	\
 	((off > NETXEN_CRB_PCIX_HOST2) && (off < NETXEN_CRB_MAX)) ? 1 : 0
-/*
- * In netxen_nic_down(), we must wait for any pending callback requests into
- * netxen_watchdog_task() to complete; eg otherwise the watchdog_timer could be
- * reenabled right after it is deleted in netxen_nic_down(). FLUSH_SCHEDULED_WORK()
- * does this synchronization.
- *
- * Normally, schedule_work()/flush_scheduled_work() could have worked, but
- * netxen_nic_close() is invoked with kernel rtnl lock held. netif_carrier_off()
- * call in netxen_nic_close() triggers a schedule_work(&linkwatch_work), and a
- * subsequent call to flush_scheduled_work() in netxen_nic_down() would cause
- * linkwatch_event() to be executed which also attempts to acquire the rtnl
- * lock thus causing a deadlock.
- */
-
-#define SCHEDULE_WORK(tp)	queue_work(netxen_workq, tp)
-#define FLUSH_SCHEDULED_WORK()	flush_workqueue(netxen_workq)
-extern struct workqueue_struct *netxen_workq;
 
 /*
  * normalize a 64MB crb address to 32MB PCI window
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index a8fb439..c3be3ef 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -86,7 +86,24 @@ static struct pci_device_id netxen_pci_tbl[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(pci, netxen_pci_tbl);
 
-struct workqueue_struct *netxen_workq;
+/*
+ * In netxen_nic_down(), we must wait for any pending callback requests into
+ * netxen_watchdog_task() to complete; eg otherwise the watchdog_timer could be
+ * reenabled right after it is deleted in netxen_nic_down().
+ * FLUSH_SCHEDULED_WORK()  does this synchronization.
+ *
+ * Normally, schedule_work()/flush_scheduled_work() could have worked, but
+ * netxen_nic_close() is invoked with kernel rtnl lock held. netif_carrier_off()
+ * call in netxen_nic_close() triggers a schedule_work(&linkwatch_work), and a
+ * subsequent call to flush_scheduled_work() in netxen_nic_down() would cause
+ * linkwatch_event() to be executed which also attempts to acquire the rtnl
+ * lock thus causing a deadlock.
+ */
+
+static struct workqueue_struct *netxen_workq;
+#define SCHEDULE_WORK(tp)	queue_work(netxen_workq, tp)
+#define FLUSH_SCHEDULED_WORK()	flush_workqueue(netxen_workq)
+
 static void netxen_watchdog(unsigned long);
 
 static void netxen_nic_update_cmd_producer(struct netxen_adapter *adapter,

