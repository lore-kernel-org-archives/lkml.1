Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYBDNF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYBDNF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYBDNEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:04:54 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:47000 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYBDNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:04:52 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 2/2] ehea: add memory remove hotplug support
Date: Mon, 4 Feb 2008 14:04:49 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802041404.49960.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory remove hotplug support

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---
 Comment: This patch depends on the following patch that
 exports the symbols
  register_memory_notifier()
  unregister_memory_notifier()

 http://lkml.org/lkml/2008/2/1/293


 drivers/net/ehea/ehea_main.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 21af674..b75afcc 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -35,6 +35,7 @@
 #include <linux/if_ether.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/memory.h>
 #include <asm/kexec.h>
 
 #include <net/ip.h>
@@ -3480,6 +3481,24 @@ void ehea_crash_handler(void)
 					      0, H_DEREG_BCMC);
 }
 
+static int ehea_mem_notifier(struct notifier_block *nb,
+                             unsigned long action, void *data)
+{
+	switch (action) {
+	case MEM_OFFLINE:
+		ehea_info("memory has been removed");
+		ehea_rereg_mrs(NULL);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ehea_mem_nb = {
+	.notifier_call = ehea_mem_notifier,
+};
+
 static int ehea_reboot_notifier(struct notifier_block *nb,
 				unsigned long action, void *unused)
 {
@@ -3559,6 +3578,10 @@ int __init ehea_module_init(void)
 	if (ret)
 		ehea_info("failed registering reboot notifier");
 
+	ret = register_memory_notifier(&ehea_mem_nb);
+	if (ret)
+		ehea_info("failed registering memory remove notifier");
+
 	ret = crash_shutdown_register(&ehea_crash_handler);
 	if (ret)
 		ehea_info("failed registering crash handler");
@@ -3582,6 +3605,7 @@ int __init ehea_module_init(void)
 out3:
 	ibmebus_unregister_driver(&ehea_driver);
 out2:
+	unregister_memory_notifier(&ehea_mem_nb);
 	unregister_reboot_notifier(&ehea_reboot_nb);
 	crash_shutdown_unregister(&ehea_crash_handler);
 out:
@@ -3599,6 +3623,7 @@ static void __exit ehea_module_exit(void)
 	ret = crash_shutdown_unregister(&ehea_crash_handler);
 	if (ret)
 		ehea_info("failed unregistering crash handler");
+	unregister_memory_notifier(&ehea_mem_nb);
 	kfree(ehea_fw_handles.arr);
 	kfree(ehea_bcmc_regs.arr);
 	ehea_destroy_busmap();
-- 
1.5.2

