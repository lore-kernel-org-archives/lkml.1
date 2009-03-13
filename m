Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZCMIUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZCMIUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbZCMIMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:33 -0400
Received: from gw.goop.org ([64.81.55.164]:34825 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757261AbZCMIM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 17/24] xen/dev-evtchn: clean up locking in evtchn
Date: Fri, 13 Mar 2009 01:11:53 -0700
Message-Id: <1236931920-6861-18-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Define a new per_user_data mutex to serialize bind/unbind operations
to prevent them from racing with each other.  Fix error returns
and don't do a bind while holding a spinlock.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/evtchn.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 517b9ee..af03195 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -54,6 +54,8 @@
 #include <asm/xen/hypervisor.h>
 
 struct per_user_data {
+	struct mutex bind_mutex; /* serialize bind/unbind operations */
+
 	/* Notification ring, accessed via /dev/xen/evtchn. */
 #define EVTCHN_RING_SIZE     (PAGE_SIZE / sizeof(evtchn_port_t))
 #define EVTCHN_RING_MASK(_i) ((_i)&(EVTCHN_RING_SIZE-1))
@@ -69,7 +71,7 @@ struct per_user_data {
 
 /* Who's bound to each port? */
 static struct per_user_data *port_user[NR_EVENT_CHANNELS];
-static DEFINE_SPINLOCK(port_user_lock);
+static DEFINE_SPINLOCK(port_user_lock); /* protects port_user[] and ring_prod */
 
 irqreturn_t evtchn_interrupt(int irq, void *data)
 {
@@ -210,22 +212,24 @@ static ssize_t evtchn_write(struct file *file, const char __user *buf,
 
 static int evtchn_bind_to_user(struct per_user_data *u, int port)
 {
-	int irq;
 	int rc = 0;
 
-	spin_lock_irq(&port_user_lock);
-
+	/*
+	 * Ports are never reused, so every caller should pass in a
+	 * unique port.
+	 *
+	 * (Locking not necessary because we haven't registered the
+	 * interrupt handler yet, and our caller has already
+	 * serialized bind operations.)
+	 */
 	BUG_ON(port_user[port] != NULL);
-
-	irq = bind_evtchn_to_irqhandler(port, evtchn_interrupt, IRQF_DISABLED,
-					u->name, (void *)(unsigned long)port);
-	if (rc < 0)
-		goto fail;
-
 	port_user[port] = u;
 
-fail:
-	spin_unlock_irq(&port_user_lock);
+	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, IRQF_DISABLED,
+				       u->name, (void *)(unsigned long)port);
+	if (rc >= 0)
+		rc = 0;
+
 	return rc;
 }
 
@@ -234,6 +238,10 @@ static void evtchn_unbind_from_user(struct per_user_data *u, int port)
 	int irq = irq_from_evtchn(port);
 
 	unbind_from_irqhandler(irq, (void *)(unsigned long)port);
+
+	/* make sure we unbind the irq handler before clearing the port */
+	barrier();
+
 	port_user[port] = NULL;
 }
 
@@ -244,6 +252,9 @@ static long evtchn_ioctl(struct file *file,
 	struct per_user_data *u = file->private_data;
 	void __user *uarg = (void __user *) arg;
 
+	/* Prevent bind from racing with unbind */
+	mutex_lock(&u->bind_mutex);
+
 	switch (cmd) {
 	case IOCTL_EVTCHN_BIND_VIRQ: {
 		struct ioctl_evtchn_bind_virq bind;
@@ -368,6 +379,7 @@ static long evtchn_ioctl(struct file *file,
 		rc = -ENOSYS;
 		break;
 	}
+	mutex_unlock(&u->bind_mutex);
 
 	return rc;
 }
@@ -414,6 +426,7 @@ static int evtchn_open(struct inode *inode, struct file *filp)
 		return -ENOMEM;
 	}
 
+	mutex_init(&u->bind_mutex);
 	mutex_init(&u->ring_cons_mutex);
 
 	filp->private_data = u;
-- 
1.6.0.6

