Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYAYH0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYAYH0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbYAYHQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:16:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:47535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbYAYHQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:16:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Anton Blanchard <anton@au.ibm.com>,
       Paul Mackerras <paulus@au.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 036/196] kobject: convert icom to use kref, not kobject
Date: Thu, 24 Jan 2008 23:09:34 -0800
Message-Id: <1201245134-4876-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBM icom serial driver is using a kobject only for reference
counting, nothing else.  So switch it to use a kref instead, which is
all that is needed, and is much smaller.

Cc: Anton Blanchard <anton@au.ibm.com>
Cc: Paul Mackerras <paulus@au.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ryan S. Arnold <rsa@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/icom.c |   24 ++++++++++--------------
 drivers/serial/icom.h |    2 +-
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 9d3105b..9c2df5c 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -48,7 +48,7 @@
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
-#include <linux/kobject.h>
+#include <linux/kref.h>
 #include <linux/firmware.h>
 #include <linux/bitops.h>
 
@@ -65,7 +65,7 @@
 #define ICOM_VERSION_STR "1.3.1"
 #define NR_PORTS	       128
 #define ICOM_PORT ((struct icom_port *)port)
-#define to_icom_adapter(d) container_of(d, struct icom_adapter, kobj)
+#define to_icom_adapter(d) container_of(d, struct icom_adapter, kref)
 
 static const struct pci_device_id icom_pci_table[] = {
 	{
@@ -141,6 +141,7 @@ static inline void trace(struct icom_port *, char *, unsigned long) {};
 #else
 static inline void trace(struct icom_port *icom_port, char *trace_pt, unsigned long trace_data) {};
 #endif
+static void icom_kref_release(struct kref *kref);
 
 static void free_port_memory(struct icom_port *icom_port)
 {
@@ -1063,11 +1064,11 @@ static int icom_open(struct uart_port *port)
 {
 	int retval;
 
-	kobject_get(&ICOM_PORT->adapter->kobj);
+	kref_get(&ICOM_PORT->adapter->kref);
 	retval = startup(ICOM_PORT);
 
 	if (retval) {
-		kobject_put(&ICOM_PORT->adapter->kobj);
+		kref_put(&ICOM_PORT->adapter->kref, icom_kref_release);
 		trace(ICOM_PORT, "STARTUP_ERROR", 0);
 		return retval;
 	}
@@ -1088,7 +1089,7 @@ static void icom_close(struct uart_port *port)
 
 	shutdown(ICOM_PORT);
 
-	kobject_put(&ICOM_PORT->adapter->kobj);
+	kref_put(&ICOM_PORT->adapter->kref, icom_kref_release);
 }
 
 static void icom_set_termios(struct uart_port *port,
@@ -1485,18 +1486,14 @@ static void icom_remove_adapter(struct icom_adapter *icom_adapter)
 	pci_release_regions(icom_adapter->pci_dev);
 }
 
-static void icom_kobj_release(struct kobject *kobj)
+static void icom_kref_release(struct kref *kref)
 {
 	struct icom_adapter *icom_adapter;
 
-	icom_adapter = to_icom_adapter(kobj);
+	icom_adapter = to_icom_adapter(kref);
 	icom_remove_adapter(icom_adapter);
 }
 
-static struct kobj_type icom_kobj_type = {
-	.release = icom_kobj_release,
-};
-
 static int __devinit icom_probe(struct pci_dev *dev,
 				const struct pci_device_id *ent)
 {
@@ -1592,8 +1589,7 @@ static int __devinit icom_probe(struct pci_dev *dev,
 		}
 	}
 
-	kobject_init(&icom_adapter->kobj);
-	icom_adapter->kobj.ktype = &icom_kobj_type;
+	kref_init(&icom_adapter->kref);
 	return 0;
 
 probe_exit2:
@@ -1619,7 +1615,7 @@ static void __devexit icom_remove(struct pci_dev *dev)
 		icom_adapter = list_entry(tmp, struct icom_adapter,
 					  icom_adapter_entry);
 		if (icom_adapter->pci_dev == dev) {
-			kobject_put(&icom_adapter->kobj);
+			kref_put(&icom_adapter->kref, icom_kref_release);
 			return;
 		}
 	}
diff --git a/drivers/serial/icom.h b/drivers/serial/icom.h
index e8578d8..0274554 100644
--- a/drivers/serial/icom.h
+++ b/drivers/serial/icom.h
@@ -270,7 +270,7 @@ struct icom_adapter {
 #define V2_ONE_PORT_RVX_ONE_PORT_IMBED_MDM	0x0251
 	int numb_ports;
 	struct list_head icom_adapter_entry;
-	struct kobject kobj;
+	struct kref kref;
 };
 
 /* prototype */
-- 
1.5.3.8

