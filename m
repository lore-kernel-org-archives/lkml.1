Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZIBJXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZIBJXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZIBJXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:23:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:47464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZIBJW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:22:59 -0400
Message-ID: <4A9E396A.8070205@kernel.org>
Date: Wed, 02 Sep 2009 18:22:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Shane Huang <Shane.Huang@amd.com>
CC: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 2/2] pci-stub: add pci_stub.ids parameter
References: <4A9E38FA.3000506@kernel.org>
In-Reply-To: <4A9E38FA.3000506@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 09:22:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ids module parameter which allows specifying initial IDs for the
pci-stub driver.  When built into the kernel, pci-stub is linked
before any real pci drivers and by setting up IDs from initialization
it can prevent built-in drivers from attaching to specific devices.

While at it, make pci_stub_probe() print out about devices it grabbed
to weed out "but my controller isn't being probed" bug reports.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
---
Sorry the first one was missing 1/2 in the title.

 drivers/pci/pci-stub.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

Index: ata/drivers/pci/pci-stub.c
===================================================================
--- ata.orig/drivers/pci/pci-stub.c
+++ ata/drivers/pci/pci-stub.c
@@ -19,8 +19,16 @@
 #include <linux/module.h>
 #include <linux/pci.h>

+static char ids[1024] __initdata;
+
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the stub driver, format is "
+		 "\"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\""
+		 " and multiple comma separated entries can be specified");
+
 static int pci_stub_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	dev_printk(KERN_INFO, &dev->dev, "claimed by stub\n");
 	return 0;
 }

@@ -32,7 +40,42 @@ static struct pci_driver stub_driver = {

 static int __init pci_stub_init(void)
 {
-	return pci_register_driver(&stub_driver);
+	char *p, *id;
+	int rc;
+
+	rc = pci_register_driver(&stub_driver);
+	if (rc)
+		return rc;
+
+	/* add ids specified in the module parameter */
+	p = ids;
+	while ((id = strsep(&p, ","))) {
+		unsigned int vendor, device, subvendor = PCI_ANY_ID,
+			subdevice = PCI_ANY_ID, class=0, class_mask=0;
+		int fields;
+
+		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
+				&vendor, &device, &subvendor, &subdevice,
+				&class, &class_mask);
+
+		if (fields < 2) {
+			printk(KERN_WARNING
+			       "pci-stub: invalid id string \"%s\"\n", id);
+			continue;
+		}
+
+		printk(KERN_INFO
+		       "pci-stub: add %04X:%04X sub=%04X:%04X cls=%08X/%08X\n",
+		       vendor, device, subvendor, subdevice, class, class_mask);
+
+		rc = pci_add_dynid(&stub_driver, vendor, device,
+				   subvendor, subdevice, class, class_mask, 0);
+		if (rc)
+			printk(KERN_WARNING
+			       "pci-stub: failed to add dynamic id (%d)\n", rc);
+	}
+
+	return 0;
 }

 static void __exit pci_stub_exit(void)
