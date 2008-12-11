Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbYLKTlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbYLKTlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbYLKTTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:17 -0500
Received: from kroah.org ([198.145.64.141]:56618 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757107AbYLKTTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:15 -0500
Date: Thu, 11 Dec 2008 11:16:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Divy Le Ray <divy@chelsio.com>,
       "David S. Miller" <davem@davemloft.net>,
       Karsten Keil <kkeil@novell.com>
Subject: [patch 65/83] cxgb3 - fix race in EEH
Message-ID: <20081211191613.GM5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cxgb3-fix-race-in-eeh.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Divy Le Ray <divy@chelsio.com>

commit 0ca41c0413a4d9ca58767d53d23accea9aa1cdef upstream.

A SGE queue set timer might access registers while in EEH recovery,
triggering an EEH error loop. Stop all timers early in EEH process.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Karsten Keil <kkeil@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cxgb3/adapter.h    |    1 +
 drivers/net/cxgb3/cxgb3_main.c |    5 +++++
 drivers/net/cxgb3/sge.c        |   21 ++++++++++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/net/cxgb3/adapter.h
+++ b/drivers/net/cxgb3/adapter.h
@@ -285,6 +285,7 @@ void t3_os_link_changed(struct adapter *
 
 void t3_sge_start(struct adapter *adap);
 void t3_sge_stop(struct adapter *adap);
+void t3_stop_sge_timers(struct adapter *adap);
 void t3_free_sge_resources(struct adapter *adap);
 void t3_sge_err_intr_handler(struct adapter *adapter);
 irq_handler_t t3_intr_handler(struct adapter *adap, int polling);
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -479,6 +479,7 @@ static int setup_sge_qsets(struct adapte
 							     irq_idx,
 				&adap->params.sge.qset[qset_idx], ntxq, dev);
 			if (err) {
+				t3_stop_sge_timers(adap);
 				t3_free_sge_resources(adap);
 				return err;
 			}
@@ -2449,6 +2450,9 @@ static pci_ers_result_t t3_io_error_dete
 	    test_bit(OFFLOAD_DEVMAP_BIT, &adapter->open_device_map))
 		offload_close(&adapter->tdev);
 
+	/* Stop SGE timers */
+	t3_stop_sge_timers(adapter);
+
 	adapter->flags &= ~FULL_INIT_DONE;
 
 	pci_disable_device(pdev);
@@ -2801,6 +2805,7 @@ static void __devexit remove_one(struct 
 		    if (test_bit(i, &adapter->registered_device_map))
 			unregister_netdev(adapter->port[i]);
 
+		t3_stop_sge_timers(adapter);
 		t3_free_sge_resources(adapter);
 		cxgb_disable_msi(adapter);
 
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -603,9 +603,6 @@ static void t3_free_qset(struct adapter 
 	int i;
 	struct pci_dev *pdev = adapter->pdev;
 
-	if (q->tx_reclaim_timer.function)
-		del_timer_sync(&q->tx_reclaim_timer);
-
 	for (i = 0; i < SGE_RXQ_PER_SET; ++i)
 		if (q->fl[i].desc) {
 			spin_lock_irq(&adapter->sge.reg_lock);
@@ -3043,6 +3040,24 @@ err:
 }
 
 /**
+ *	t3_stop_sge_timers - stop SGE timer call backs
+ *	@adap: the adapter
+ *
+ *	Stops each SGE queue set's timer call back
+ */
+void t3_stop_sge_timers(struct adapter *adap)
+{
+	int i;
+
+	for (i = 0; i < SGE_QSETS; ++i) {
+		struct sge_qset *q = &adap->sge.qs[i];
+
+		if (q->tx_reclaim_timer.function)
+			del_timer_sync(&q->tx_reclaim_timer);
+	}
+}
+
+/**
  *	t3_free_sge_resources - free SGE resources
  *	@adap: the adapter
  *

