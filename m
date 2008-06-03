Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYFCMtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYFCMtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYFCMtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:49:25 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:28510 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYFCMtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:49:24 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linux PPC devel <linuxppc-dev@ozlabs.org>
Subject: [RFC 1/3] hvc_console: rework setup to replace irq functions with callbacks (not word wrapped)
Date: Tue, 3 Jun 2008 14:49:14 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <200806031444.21945.borntraeger@de.ibm.com>
In-Reply-To: <200806031444.21945.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031449.14385.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to change hvc_console to not use request_irq/free_irq if
the backend does not use irqs. This allows virtio_console to use hvc_console
without having a linker reference to request_irq/free_irq.

The irq specific code is moved to hvc_irq.c and selected by the drivers that
use irqs (System p, System i, XEN).

I replaced "irq" with the opaque name "data". The request_irq and free_irq
calls are replaced with notifier_add and notifier_del. I have also changed
the code a bit to call the notifier_add and notifier_del inside the spinlock
area as the callbacks are found via hp->ops.

Feedback is appreciated.
 
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>
CC: Linux PPC devel <linuxppc-dev@ozlabs.org>
---
 drivers/char/Kconfig       |    8 ++++
 drivers/char/Makefile      |    1 
 drivers/char/hvc_console.c |   80 ++++++++++-----------------------------------
 drivers/char/hvc_console.h |   34 ++++++++++++++++---
 drivers/char/hvc_irq.c     |   37 ++++++++++++++++++++
 drivers/char/hvc_iseries.c |    2 +
 drivers/char/hvc_vio.c     |    2 +
 drivers/char/hvc_xen.c     |    2 +
 8 files changed, 100 insertions(+), 66 deletions(-)

Index: kvm/drivers/char/Kconfig
===================================================================
--- kvm.orig/drivers/char/Kconfig
+++ kvm/drivers/char/Kconfig
@@ -588,11 +588,17 @@ config HVC_DRIVER
 	  It will automatically be selected if one of the back-end console drivers
 	  is selected.
 
+config HVC_IRQ
+	bool
+	help
+	  Infrastructure for using the IRQ code for HVC console.
+	  It will automatically be selected by the drivers that need it.
 
 config HVC_CONSOLE
 	bool "pSeries Hypervisor Virtual Console support"
 	depends on PPC_PSERIES
 	select HVC_DRIVER
+	select HVC_IRQ
 	help
 	  pSeries machines when partitioned support a hypervisor virtual
 	  console. This driver allows each pSeries partition to have a console
@@ -603,6 +609,7 @@ config HVC_ISERIES
 	depends on PPC_ISERIES
 	default y
 	select HVC_DRIVER
+	select HVC_IRQ
 	help
 	  iSeries machines support a hypervisor virtual console.
 
@@ -624,6 +631,7 @@ config HVC_XEN
 	bool "Xen Hypervisor Console support"
 	depends on XEN
 	select HVC_DRIVER
+	select HVC_IRQ
 	default y
 	help
 	  Xen virtual console device driver
Index: kvm/drivers/char/Makefile
===================================================================
--- kvm.orig/drivers/char/Makefile
+++ kvm/drivers/char/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
 obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
+obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
 obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
 obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
Index: kvm/drivers/char/hvc_console.c
===================================================================
--- kvm.orig/drivers/char/hvc_console.c
+++ kvm/drivers/char/hvc_console.c
@@ -75,23 +75,6 @@ static int hvc_init(void);
 static int sysrq_pressed;
 #endif
 
-struct hvc_struct {
-	spinlock_t lock;
-	int index;
-	struct tty_struct *tty;
-	unsigned int count;
-	int do_wakeup;
-	char *outbuf;
-	int outbuf_size;
-	int n_outbuf;
-	uint32_t vtermno;
-	struct hv_ops *ops;
-	int irq_requested;
-	int irq;
-	struct list_head next;
-	struct kref kref; /* ref count & hvc_struct lifetime */
-};
-
 /* dynamic list of hvc_struct instances */
 static LIST_HEAD(hvc_structs);
 
@@ -300,26 +283,12 @@ int hvc_instantiate(uint32_t vtermno, in
 }
 
 /* Wake the sleeping khvcd */
-static void hvc_kick(void)
+void hvc_kick(void)
 {
 	hvc_kicked = 1;
 	wake_up_process(hvc_task);
 }
 
-static int hvc_poll(struct hvc_struct *hp);
-
-/*
- * NOTE: This API isn't used if the console adapter doesn't support interrupts.
- * In this case the console is poll driven.
- */
-static irqreturn_t hvc_handle_interrupt(int irq, void *dev_instance)
-{
-	/* if hvc_poll request a repoll, then kick the hvcd thread */
-	if (hvc_poll(dev_instance))
-		hvc_kick();
-	return IRQ_HANDLED;
-}
-
 static void hvc_unthrottle(struct tty_struct *tty)
 {
 	hvc_kick();
@@ -333,7 +302,6 @@ static int hvc_open(struct tty_struct *t
 {
 	struct hvc_struct *hp;
 	unsigned long flags;
-	int irq = 0;
 	int rc = 0;
 
 	/* Auto increments kref reference if found. */
@@ -352,18 +320,15 @@ static int hvc_open(struct tty_struct *t
 	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
 
 	hp->tty = tty;
-	/* Save for request_irq outside of spin_lock. */
-	irq = hp->irq;
-	if (irq)
-		hp->irq_requested = 1;
+
+	if (hp->ops->notifier_add)
+		rc = hp->ops->notifier_add(hp, hp->data);
 
 	spin_unlock_irqrestore(&hp->lock, flags);
-	/* check error, fallback to non-irq */
-	if (irq)
-		rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED, "hvc_console", hp);
+
 
 	/*
-	 * If the request_irq() fails and we return an error.  The tty layer
+	 * If the notifier fails we return an error.  The tty layer
 	 * will call hvc_close() after a failed open but we don't want to clean
 	 * up there so we'll clean up here and clear out the previously set
 	 * tty fields and return the kref reference.
@@ -371,7 +336,6 @@ static int hvc_open(struct tty_struct *t
 	if (rc) {
 		spin_lock_irqsave(&hp->lock, flags);
 		hp->tty = NULL;
-		hp->irq_requested = 0;
 		spin_unlock_irqrestore(&hp->lock, flags);
 		tty->driver_data = NULL;
 		kref_put(&hp->kref, destroy_hvc_struct);
@@ -386,7 +350,6 @@ static int hvc_open(struct tty_struct *t
 static void hvc_close(struct tty_struct *tty, struct file * filp)
 {
 	struct hvc_struct *hp;
-	int irq = 0;
 	unsigned long flags;
 
 	if (tty_hung_up_p(filp))
@@ -404,9 +367,8 @@ static void hvc_close(struct tty_struct 
 	spin_lock_irqsave(&hp->lock, flags);
 
 	if (--hp->count == 0) {
-		if (hp->irq_requested)
-			irq = hp->irq;
-		hp->irq_requested = 0;
+		if (hp->ops->notifier_del)
+			hp->ops->notifier_del(hp, hp->data);
 
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
@@ -418,10 +380,6 @@ static void hvc_close(struct tty_struct 
 		 * waking periodically to check chars_in_buffer().
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
-
-		if (irq)
-			free_irq(irq, hp);
-
 	} else {
 		if (hp->count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
@@ -436,7 +394,6 @@ static void hvc_hangup(struct tty_struct
 {
 	struct hvc_struct *hp = tty->driver_data;
 	unsigned long flags;
-	int irq = 0;
 	int temp_open_count;
 
 	if (!hp)
@@ -458,13 +415,12 @@ static void hvc_hangup(struct tty_struct
 	hp->count = 0;
 	hp->n_outbuf = 0;
 	hp->tty = NULL;
-	if (hp->irq_requested)
-		/* Saved for use outside of spin_lock. */
-		irq = hp->irq;
-	hp->irq_requested = 0;
+
+	if (hp->ops->notifier_del)
+			hp->ops->notifier_del(hp, hp->data);
+
 	spin_unlock_irqrestore(&hp->lock, flags);
-	if (irq)
-		free_irq(irq, hp);
+
 	while(temp_open_count) {
 		--temp_open_count;
 		kref_put(&hp->kref, destroy_hvc_struct);
@@ -575,7 +531,7 @@ static u32 timeout = MIN_TIMEOUT;
 #define HVC_POLL_READ	0x00000001
 #define HVC_POLL_WRITE	0x00000002
 
-static int hvc_poll(struct hvc_struct *hp)
+int hvc_poll(struct hvc_struct *hp)
 {
 	struct tty_struct *tty;
 	int i, n, poll_mask = 0;
@@ -602,10 +558,10 @@ static int hvc_poll(struct hvc_struct *h
 	if (test_bit(TTY_THROTTLED, &tty->flags))
 		goto throttled;
 
-	/* If we aren't interrupt driven and aren't throttled, we always
+	/* If we aren't notifier driven and aren't throttled, we always
 	 * request a reschedule
 	 */
-	if (hp->irq == 0)
+	if (!hp->ops->notifier_add)
 		poll_mask |= HVC_POLL_READ;
 
 	/* Read data if any */
@@ -739,7 +695,7 @@ static const struct tty_operations hvc_o
 	.chars_in_buffer = hvc_chars_in_buffer,
 };
 
-struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int irq,
+struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int data,
 					struct hv_ops *ops, int outbuf_size)
 {
 	struct hvc_struct *hp;
@@ -760,7 +716,7 @@ struct hvc_struct __devinit *hvc_alloc(u
 	memset(hp, 0x00, sizeof(*hp));
 
 	hp->vtermno = vtermno;
-	hp->irq = irq;
+	hp->data = data;
 	hp->ops = ops;
 	hp->outbuf_size = outbuf_size;
 	hp->outbuf = &((char *)hp)[ALIGN(sizeof(*hp), sizeof(long))];
Index: kvm/drivers/char/hvc_console.h
===================================================================
--- kvm.orig/drivers/char/hvc_console.h
+++ kvm/drivers/char/hvc_console.h
@@ -42,22 +42,48 @@
  */
 #define HVC_ALLOC_TTY_ADAPTERS	8
 
+struct hvc_struct {
+	spinlock_t lock;
+	int index;
+	struct tty_struct *tty;
+	unsigned int count;
+	int do_wakeup;
+	char *outbuf;
+	int outbuf_size;
+	int n_outbuf;
+	uint32_t vtermno;
+	struct hv_ops *ops;
+	int data;
+	struct list_head next;
+	struct kref kref; /* ref count & hvc_struct lifetime */
+};
 
 /* implemented by a low level driver */
 struct hv_ops {
 	int (*get_chars)(uint32_t vtermno, char *buf, int count);
 	int (*put_chars)(uint32_t vtermno, const char *buf, int count);
-};
 
-struct hvc_struct;
+	/* Callbacks for notification. Called in open and close */
+	int (*notifier_add)(struct hvc_struct *hp, int data);
+	void (*notifier_del)(struct hvc_struct *hp, int data);
+};
 
 /* Register a vterm and a slot index for use as a console (console_init) */
 extern int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops);
 
 /* register a vterm for hvc tty operation (module_init or hotplug add) */
-extern struct hvc_struct * __devinit hvc_alloc(uint32_t vtermno, int irq,
+extern struct hvc_struct * __devinit hvc_alloc(uint32_t vtermno, int data,
 				struct hv_ops *ops, int outbuf_size);
-/* remove a vterm from hvc tty operation (modele_exit or hotplug remove) */
+/* remove a vterm from hvc tty operation (module_exit or hotplug remove) */
 extern int __devexit hvc_remove(struct hvc_struct *hp);
 
+/* data available */
+int hvc_poll(struct hvc_struct *hp);
+void hvc_kick(void);
+
+#ifdef CONFIG_HVC_IRQ
+/* default notifier for irq based notification */
+extern int notifier_add_irq(struct hvc_struct *hp, int irq);
+extern void notifier_del_irq(struct hvc_struct *hp, int irq);
+#endif
 #endif // HVC_CONSOLE_H
Index: kvm/drivers/char/hvc_irq.c
===================================================================
--- /dev/null
+++ kvm/drivers/char/hvc_irq.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright IBM Corp. 2001,2008
+ *
+ * This file contains the IRQ specific code for hvc_console
+ *
+ */
+
+#include <linux/interrupt.h>
+
+#include "hvc_console.h"
+
+static irqreturn_t hvc_handle_interrupt(int irq, void *dev_instance)
+{
+	/* if hvc_poll request a repoll, then kick the hvcd thread */
+	if (hvc_poll(dev_instance))
+		hvc_kick();
+	return IRQ_HANDLED;
+}
+
+/*
+ * For IRQ based systems these callbacks can be used
+ */
+int notifier_add_irq(struct hvc_struct *hp, int irq)
+{
+	if (!irq)
+		return 0;
+	return request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED,
+			   "hvc_console", hp);
+}
+
+void notifier_del_irq(struct hvc_struct *hp, int irq)
+{
+	if (!irq)
+		return;
+	free_irq(irq, hp);
+}
+
Index: kvm/drivers/char/hvc_iseries.c
===================================================================
--- kvm.orig/drivers/char/hvc_iseries.c
+++ kvm/drivers/char/hvc_iseries.c
@@ -200,6 +200,8 @@ done:
 static struct hv_ops hvc_get_put_ops = {
 	.get_chars = get_chars,
 	.put_chars = put_chars,
+	.notifier_add = notifier_add_irq,
+	.notifier_del = notifier_del_irq,
 };
 
 static int __devinit hvc_vio_probe(struct vio_dev *vdev,
Index: kvm/drivers/char/hvc_vio.c
===================================================================
--- kvm.orig/drivers/char/hvc_vio.c
+++ kvm/drivers/char/hvc_vio.c
@@ -80,6 +80,8 @@ static int filtered_get_chars(uint32_t v
 static struct hv_ops hvc_get_put_ops = {
 	.get_chars = filtered_get_chars,
 	.put_chars = hvc_put_chars,
+	.notifier_add = notifier_add_irq,
+	.notifier_del = notifier_del_irq,
 };
 
 static int __devinit hvc_vio_probe(struct vio_dev *vdev,
Index: kvm/drivers/char/hvc_xen.c
===================================================================
--- kvm.orig/drivers/char/hvc_xen.c
+++ kvm/drivers/char/hvc_xen.c
@@ -95,6 +95,8 @@ static int read_console(uint32_t vtermno
 static struct hv_ops hvc_ops = {
 	.get_chars = read_console,
 	.put_chars = write_console,
+	.notifier_add = notifier_add_irq,
+	.notifier_del = notifier_del_irq,
 };
 
 static int __init xen_init(void)
