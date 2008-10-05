Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYJEQmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYJEQmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbYJEQiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:38:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35305 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756998AbYJEQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:38:07 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 14/19] parport: quickfix the proc registration bug
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:38:07 +0100
Message-ID: <20081005163758.3799.88465.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ideally we should have a directory of drivers and a link to the 'active'
driver. For now just show the first device which is effectively the existing
semantics without a warning.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/parport/share.c |   13 ++++++++++---
 include/linux/parport.h |    4 ++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index a8a62bb..0750dcb 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -614,7 +614,10 @@ parport_register_device(struct parport *port, const char *name,
 	 * pardevice fields. -arca
 	 */
 	port->ops->init_state(tmp, tmp->state);
-	parport_device_proc_register(tmp);
+	if (test_and_set_bit(PARPORT_DEVPROC_REGISTERED, &port->devflags)) {
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
index 6a0d7cd..986252e 100644
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

