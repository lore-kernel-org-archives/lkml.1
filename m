Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbXJUH4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbXJUH4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXJUHwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37273 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbXJUHws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:48 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pcmcia@lists.infradead.org
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 14/17] pcmcia/i82365: irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075248.40201190418@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:48 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit c94109209f6d3aa2ff8c6c458552775f693ad7ee
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:34:33 2007 -0400

    pcmcia/i82365: irq handler cleanups
    
    * pass irq number to irq handler via dev_id
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/pcmcia/i82365.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

c94109209f6d3aa2ff8c6c458552775f693ad7ee
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 839bb1c..330150e 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -82,7 +82,8 @@ module_param(pc_debug, int, 0644);
 static irqreturn_t i365_count_irq(int, void *);
 static inline int _check_irq(int irq, int flags)
 {
-    if (request_irq(irq, i365_count_irq, flags, "x", i365_count_irq) != 0)
+    if (request_irq(irq, i365_count_irq, flags, "x",
+    		    (void *)(unsigned long) irq) != 0)
 	return -1;
     free_irq(irq, i365_count_irq);
     return 0;
@@ -497,8 +498,10 @@ static u_int __init set_bridge_opts(u_short s, u_short ns)
 static volatile u_int irq_hits;
 static u_short irq_sock;
 
-static irqreturn_t i365_count_irq(int irq, void *dev)
+static irqreturn_t i365_count_irq(int dummy, void *dev_id)
 {
+    int irq = (int)(unsigned long) dev_id;
+
     i365_get(irq_sock, I365_CSC);
     irq_hits++;
     debug(2, "-> hit on irq %d\n", irq);
@@ -509,7 +512,7 @@ static u_int __init test_irq(u_short sock, int irq)
 {
     debug(2, "  testing ISA irq %d\n", irq);
     if (request_irq(irq, i365_count_irq, IRQF_PROBE_SHARED, "scan",
-			i365_count_irq) != 0)
+		    (void *)(unsigned long) irq) != 0)
 	return 1;
     irq_hits = 0; irq_sock = sock;
     msleep(10);
@@ -847,8 +850,9 @@ static void __init isa_probe(void)
 
 /*====================================================================*/
 
-static irqreturn_t pcic_interrupt(int irq, void *dev)
+static irqreturn_t pcic_interrupt(int dummy, void *dev_id)
 {
+    int irq = (int)(unsigned long) dev_id;
     int i, j, csc;
     u_int events, active;
     u_long flags = 0;
@@ -1293,7 +1297,8 @@ static int __init init_i82365(void)
 
     /* Set up interrupt handler(s) */
     if (grab_irq != 0)
-	request_irq(cs_irq, pcic_interrupt, 0, "i82365", pcic_interrupt);
+	request_irq(cs_irq, pcic_interrupt, 0, "i82365",
+		    (void *)(unsigned long) cs_irq);
     
     /* register sockets with the pcmcia core */
     for (i = 0; i < sockets; i++) {
