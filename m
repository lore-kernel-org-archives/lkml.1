Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZFBO7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZFBO7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZFBO7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:59:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57001 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754668AbZFBO7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:59:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] parport: quickfix the proc registration bug
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Tue, 02 Jun 2009 16:58:10 +0100
Message-ID: <20090602155718.12461.87554.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@etchedpixels.co.uk>

Ideally we should have a directory of drivers and a link to the 'active'
driver. For now just show the first device which is effectively the existing
semantics without a warning.

This is an update on the original buggy patch that I then forgot to
resubmit. Confusingly it was proposed by Red Hat, written by Etched Pixels
fixed and submitted by Intel ...

Resolves-Bug: http://bugzilla.kernel.org/show_bug.cgi?id=9749
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/parport/share.c |   13 ++++++++++---
 include/linux/parport.h |    4 ++++
 2 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index 0ebca45..dffa5d4 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -614,7 +614,10 @@ parport_register_device(struct parport *port, const char *name,
 	 * pardevice fields. -arca
 	 */
 	port->ops->init_state(tmp, tmp->state);
-	parport_device_proc_register(tmp);
+	if (!test_and_set_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags)) {
+		port->proc_device = tmp;
+		parport_device_proc_register(tmp);
+	}
 	return tmp;
 
  out_free_all:
@@ -646,10 +649,14 @@ void parport_unregister_device(struct pardevice *dev)
 	}
 #endif
 
-	parport_device_proc_unregister(dev);
-
 	port = dev->port->physport;
 
+	if (port->proc_device == dev) {
+		port->proc_device = NULL;
+		clear_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags);
+		parport_device_proc_unregister(dev);
+	}
+
 	if (port->cad == dev) {
 		printk(KERN_DEBUG "%s: %s forgot to release port\n",
 		       port->name, dev->name);
diff --git a/include/linux/parport.h b/include/linux/parport.h
index e1f83c5..38a423e 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -324,6 +324,10 @@ struct parport {
 	int spintime;
 	atomic_t ref_count;
 
+	unsigned long devflags;
+#define PARPORT_DEVPROC_REGISTERED	0
+	struct pardevice *proc_device;	/* Currently register proc device */
+
 	struct list_head full_list;
 	struct parport *slaves[3];
 };

