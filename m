Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYEWNpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYEWNpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYEWNoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:21 -0400
Received: from gw.goop.org ([64.81.55.164]:53239 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYEWNoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 12] xen: add rebind_evtchn_irq
X-Mercurial-Node: 0fbdf6f43f1bb84b8856dd01ef62c8211f611a3b
Message-Id: <0fbdf6f43f1bb84b8856.1211550073@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:13 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rebind_evtchn_irq(), which will rebind an device driver's existing
irq to a new event channel on restore.  Since the new event channel
will be masked and bound to vcpu0, we update the state accordingly and
unmask the irq once everything is set up.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   27 +++++++++++++++++++++++++++
 include/xen/events.h |    1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -557,6 +557,33 @@
 	put_cpu();
 }
 
+/* Rebind a new event channel to an existing irq. */
+void rebind_evtchn_irq(int evtchn, int irq)
+{
+	/* Make sure the irq is masked, since the new event channel
+	   will also be masked. */
+	disable_irq(irq);
+
+	spin_lock(&irq_mapping_update_lock);
+
+	/* After resume the irq<->evtchn mappings are all cleared out */
+	BUG_ON(evtchn_to_irq[evtchn] != -1);
+	/* Expect irq to have been bound before,
+	   so the bindcount should be non-0 */
+	BUG_ON(irq_bindcount[irq] == 0);
+
+	evtchn_to_irq[evtchn] = irq;
+	irq_info[irq] = mk_irq_info(IRQT_EVTCHN, 0, evtchn);
+
+	spin_unlock(&irq_mapping_update_lock);
+
+	/* new event channels are always bound to cpu 0 */
+	irq_set_affinity(irq, cpumask_of_cpu(0));
+
+	/* Unmask the event channel. */
+	enable_irq(irq);
+}
+
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
 static void rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
diff --git a/include/xen/events.h b/include/xen/events.h
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -32,6 +32,7 @@
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
 int resend_irq_on_evtchn(unsigned int irq);
+void rebind_evtchn_irq(int evtchn, int irq);
 
 static inline void notify_remote_via_evtchn(int port)
 {


