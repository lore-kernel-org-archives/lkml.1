Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZJ0WKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZJ0WKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZJ0WKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:10:22 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:52408 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZJ0WKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:10:20 -0400
From: Dhananjay Phadke <dhananjay.phadke@qlogic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       netdev <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Tue, 27 Oct 2009 15:09:24 -0700
Subject: RE: [PATCH -next] netxen: fix builds for SYSFS=n or MODULES=n
Thread-Topic: [PATCH -next] netxen: fix builds for SYSFS=n or MODULES=n
Thread-Index: AcpWiZOx7OSTHKKlTsW/F2l9iyr7CgAxzHJw
Message-ID: <7608421F3572AB4292BB2532AE89D5658B0B8903CB@AVEXMB1.qlogic.org>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
 <20091026150945.3f35a811.randy.dunlap@oracle.com>
In-Reply-To: <20091026150945.3f35a811.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Oct 2009 22:09:26.0899 (UTC) FILETIME=[25F15C30:01CA5752]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, seems like I am keeping you busy with the build errors.
Thanks for fixing it again (may be I need to setup all different build configs).

Acked-by: Dhananjay Phadke <dhananjay@netxen.com>

-----Original Message-----
From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
Sent: Monday, October 26, 2009 3:10 PM
To: Stephen Rothwell; netdev
Cc: linux-next@vger.kernel.org; LKML; davem@davemloft.net; Dhananjay Phadke
Subject: [PATCH -next] netxen: fix builds for SYSFS=n or MODULES=n

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_MODULES=n:
drivers/net/netxen/netxen_nic_main.c:2751: error: dereferencing pointer to incomplete type
drivers/net/netxen/netxen_nic_main.c:2764: error: dereferencing pointer to incomplete type

Also needs addition of <linux/sysfs.h> for sysfs function prototypes or
stubs when CONFIG_SYSFS=n.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/netxen/netxen_nic_main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-next-20091026.orig/drivers/net/netxen/netxen_nic_main.c
+++ linux-next-20091026/drivers/net/netxen/netxen_nic_main.c
@@ -34,6 +34,7 @@
 #include <net/ip.h>
 #include <linux/ipv6.h>
 #include <linux/inetdevice.h>
+#include <linux/sysfs.h>
 
 MODULE_DESCRIPTION("NetXen Multi port (1/10) Gigabit Network Driver");
 MODULE_LICENSE("GPL");
@@ -2500,6 +2501,7 @@ static struct bin_attribute bin_attr_mem
 	.write = netxen_sysfs_write_mem,
 };
 
+#ifdef CONFIG_MODULES
 static ssize_t
 netxen_store_auto_fw_reset(struct module_attribute *mattr,
 		struct module *mod, const char *buf, size_t count)
@@ -2534,6 +2536,7 @@ static struct module_attribute mod_attr_
 	.show = netxen_show_auto_fw_reset,
 	.store = netxen_store_auto_fw_reset,
 };
+#endif
 
 static void
 netxen_create_sysfs_entries(struct netxen_adapter *adapter)
@@ -2739,7 +2742,9 @@ static struct pci_driver netxen_driver =
 
 static int __init netxen_init_module(void)
 {
+#ifdef CONFIG_MODULES
 	struct module *mod = THIS_MODULE;
+#endif
 
 	printk(KERN_INFO "%s\n", netxen_nic_driver_string);
 
@@ -2748,9 +2753,11 @@ static int __init netxen_init_module(voi
 	register_inetaddr_notifier(&netxen_inetaddr_cb);
 #endif
 
+#ifdef CONFIG_MODULES
 	if (sysfs_create_file(&mod->mkobj.kobj, &mod_attr_fw_reset.attr))
 		printk(KERN_ERR "%s: Failed to create auto_fw_reset "
 				"sysfs entry.", netxen_nic_driver_name);
+#endif
 
 	return pci_register_driver(&netxen_driver);
 }
@@ -2759,9 +2766,11 @@ module_init(netxen_init_module);
 
 static void __exit netxen_exit_module(void)
 {
+#ifdef CONFIG_MODULES
 	struct module *mod = THIS_MODULE;
 
 	sysfs_remove_file(&mod->mkobj.kobj, &mod_attr_fw_reset.attr);
+#endif
 
 	pci_unregister_driver(&netxen_driver);
 
