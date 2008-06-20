Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYFTNYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYFTNYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYFTNYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:24:46 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:4392 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYFTNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:24:45 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linux PPC devel <linuxppc-dev@ozlabs.org>
Subject: [RFC 2/3 v2] virtio_console: use virtqueue notification for hvc_console
Date: Fri, 20 Jun 2008 15:24:15 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Yajin <zyj001et@gmail.com>
References: <200806031444.21945.borntraeger@de.ibm.com>
In-Reply-To: <200806031444.21945.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201524.15478.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exploits the new notifier callbacks of the hvc_console. We can
use the virtio callbacks instead of the polling code. 

I also added a small Kconfig change that allows the user to specify the 
virtio console in menuconfig. 

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/char/Kconfig          |    6 +++++-
 drivers/char/virtio_console.c |   40 +++++++++++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 8 deletions(-)

Index: kvm/drivers/char/Kconfig
===================================================================
--- kvm.orig/drivers/char/Kconfig
+++ kvm/drivers/char/Kconfig
@@ -634,8 +634,12 @@ config HVC_XEN
 	  Xen virtual console device driver
 
 config VIRTIO_CONSOLE
-	bool
+	bool "Virtio console"
+	depends on VIRTIO
 	select HVC_DRIVER
+	help
+	  Virtio console for use with lguest and other hypervisors.
+
 
 config HVCS
 	tristate "IBM Hypervisor Virtual Console Server support"
Index: kvm/drivers/char/virtio_console.c
===================================================================
--- kvm.orig/drivers/char/virtio_console.c
+++ kvm/drivers/char/virtio_console.c
@@ -46,6 +46,9 @@ static char *in, *inbuf;
 /* The operations for our console. */
 static struct hv_ops virtio_cons;
 
+/* The hvc device */
+static struct hvc_struct *hvc;
+
 /*D:310 The put_chars() callback is pretty straightforward.
  *
  * We turn the characters into a scatter-gather list, add it to the output
@@ -134,6 +137,27 @@ int __init virtio_cons_early_init(int (*
 	return hvc_instantiate(0, 0, &virtio_cons);
 }
 
+/*
+ * we support only one console, the hvc struct is a global var
+ * There is no need to do anything
+ */
+static int notifier_add_vio(struct hvc_struct *hp, int data)
+{
+	hp->irq_requested = 1;
+	return 0;
+}
+
+static void notifier_del_vio(struct hvc_struct *hp, int data)
+{
+	hp->irq_requested = 0;
+}
+
+static void hvc_handle_input(struct virtqueue *vq)
+{
+	if (hvc_poll(hvc))
+		hvc_kick();
+}
+
 /*D:370 Once we're further in boot, we get probed like any other virtio device.
  * At this stage we set up the output virtqueue.
  *
@@ -144,7 +168,6 @@ int __init virtio_cons_early_init(int (*
 static int __devinit virtcons_probe(struct virtio_device *dev)
 {
 	int err;
-	struct hvc_struct *hvc;
 
 	vdev = dev;
 
@@ -158,7 +181,7 @@ static int __devinit virtcons_probe(stru
 	/* Find the input queue. */
 	/* FIXME: This is why we want to wean off hvc: we do nothing
 	 * when input comes in. */
-	in_vq = vdev->config->find_vq(vdev, 0, NULL);
+	in_vq = vdev->config->find_vq(vdev, 0, hvc_handle_input);
 	if (IS_ERR(in_vq)) {
 		err = PTR_ERR(in_vq);
 		goto free;
@@ -173,15 +196,18 @@ static int __devinit virtcons_probe(stru
 	/* Start using the new console output. */
 	virtio_cons.get_chars = get_chars;
 	virtio_cons.put_chars = put_chars;
+	virtio_cons.notifier_add = notifier_add_vio;
+	virtio_cons.notifier_del = notifier_del_vio;
 
 	/* The first argument of hvc_alloc() is the virtual console number, so
-	 * we use zero.  The second argument is the interrupt number; we
-	 * currently leave this as zero: it would be better not to use the
-	 * hvc mechanism and fix this (FIXME!).
+	 * we use zero.  The second argument is the parameter for the
+	 * notification mechanism (like irq number). We currently leave this
+	 * as zero, virtqueues have implicit notifications.
 	 *
 	 * The third argument is a "struct hv_ops" containing the put_chars()
-	 * and get_chars() pointers.  The final argument is the output buffer
-	 * size: we can do any size, so we put PAGE_SIZE here. */
+	 * get_chars(), notifier_add() and notifier_del() pointers.
+	 * The final argument is the output buffer size: we can do any size,
+	 * so we put PAGE_SIZE here. */
 	hvc = hvc_alloc(0, 0, &virtio_cons, PAGE_SIZE);
 	if (IS_ERR(hvc)) {
 		err = PTR_ERR(hvc);
