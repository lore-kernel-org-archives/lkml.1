Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYEWNqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYEWNqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYEWNoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:23 -0400
Received: from gw.goop.org ([64.81.55.164]:53231 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbYEWNoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 12] xenbus: rebind irq on restore
X-Mercurial-Node: 9a8a2c775e8659a0d36a42e178d4ebaa50b17fe2
Message-Id: <9a8a2c775e8659a0d36a.1211550076@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:16 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When restoring, rebind the existing xenbus irq to the new xenbus event
channel.  (It turns out in practice that this is always the same, and
is never updated on restore.  That's a bug, but Xeno-linux has been
like this for a long time, so it can't really be fixed.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/xenbus/xenbus_comms.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
--- a/drivers/xen/xenbus/xenbus_comms.c
+++ b/drivers/xen/xenbus/xenbus_comms.c
@@ -203,7 +203,6 @@
 int xb_init_comms(void)
 {
 	struct xenstore_domain_interface *intf = xen_store_interface;
-	int err;
 
 	if (intf->req_prod != intf->req_cons)
 		printk(KERN_ERR "XENBUS request ring is not quiescent "
@@ -216,18 +215,20 @@
 		intf->rsp_cons = intf->rsp_prod;
 	}
 
-	if (xenbus_irq)
-		unbind_from_irqhandler(xenbus_irq, &xb_waitq);
+	if (xenbus_irq) {
+		/* Already have an irq; assume we're resuming */
+		rebind_evtchn_irq(xen_store_evtchn, xenbus_irq);
+	} else {
+		int err;
+		err = bind_evtchn_to_irqhandler(xen_store_evtchn, wake_waiting,
+						0, "xenbus", &xb_waitq);
+		if (err <= 0) {
+			printk(KERN_ERR "XENBUS request irq failed %i\n", err);
+			return err;
+		}
 
-	err = bind_evtchn_to_irqhandler(
-		xen_store_evtchn, wake_waiting,
-		0, "xenbus", &xb_waitq);
-	if (err <= 0) {
-		printk(KERN_ERR "XENBUS request irq failed %i\n", err);
-		return err;
+		xenbus_irq = err;
 	}
-
-	xenbus_irq = err;
 
 	return 0;
 }


