Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbZIDUO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbZIDUO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934137AbZIDUOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:51 -0400
Received: from kroah.org ([198.145.64.141]:36319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123AbZIDUOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:56 2009
Message-Id: <20090904200856.789824376@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 44/48] parport: quickfix the proc registration bug
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=parport-quickfix-the-proc-registration-bug.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@etchedpixels.co.uk>

commit 05ad709d04799125ed85dd816fdb558258102172 upstream

parport: quickfix the proc registration bug

Ideally we should have a directory of drivers and a link to the 'active'
driver. For now just show the first device which is effectively the existing
semantics without a warning.

This is an update on the original buggy patch that I then forgot to
resubmit. Confusingly it was proposed by Red Hat, written by Etched Pixels
fixed and submitted by Intel ...

Resolves-Bug: http://bugzilla.kernel.org/show_bug.cgi?id=9749
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 drivers/parport/share.c |   13 ++++++++++---
 include/linux/parport.h |    4 ++++
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -614,7 +614,10 @@ parport_register_device(struct parport *
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
@@ -646,10 +649,14 @@ void parport_unregister_device(struct pa
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
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -326,6 +326,10 @@ struct parport {
 	int spintime;
 	atomic_t ref_count;
 
+	unsigned long devflags;
+#define PARPORT_DEVPROC_REGISTERED	0
+	struct pardevice *proc_device;	/* Currently register proc device */
+
 	struct list_head full_list;
 	struct parport *slaves[3];
 };


