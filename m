Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZIXW3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZIXW3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZIXW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:29:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZIXW3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:29:04 -0400
Date: Thu, 24 Sep 2009 19:27:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090924192727.212ce46f@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

edac_mce module is an interface module that gets mcelog data and
forwards to any registered edac module that expects to receive data via
mce.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++
 drivers/edac/Kconfig             |    8 ++++-
 drivers/edac/Makefile            |    3 +-
 drivers/edac/edac_mce.c          |   58 ++++++++++++++++++++++++++++++++++++++
 include/linux/edac_mce.h         |   31 ++++++++++++++++++++
 5 files changed, 110 insertions(+), 2 deletions(-)
 create mode 100644 drivers/edac/edac_mce.c
 create mode 100644 include/linux/edac_mce.h

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2f5aab2..fefbb7c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -35,6 +35,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/debugfs.h>
+#include <linux/edac_mce.h>
 
 #include <asm/processor.h>
 #include <asm/hw_irq.h>
@@ -135,6 +136,15 @@ void mce_log(struct mce *mce)
 		entry = rcu_dereference(mcelog.next);
 		for (;;) {
 			/*
+			 * If edac_mce is enabled, it will check the error type
+			 * and will process it, if it is a known error.
+			 * Otherwise, the error will be sent through mcelog
+			 * interface
+			 */
+			if (edac_mce_parse(mce))
+				return;
+
+			/*
 			 * When the buffer fills up discard new entries.
 			 * Assume that the earlier errors are the more
 			 * interesting ones:
@@ -193,6 +203,8 @@ static void print_mce(struct mce *m)
 			m->cpuvendor, m->cpuid, m->time, m->socketid,
 			m->apicid);
 
+	edac_mce_parse(m);
+
 	decode_mce(m);
 }
 
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 0c8ca30..a69f69e 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -57,6 +57,9 @@ config EDAC_MM_EDAC
 	  occurred so that a particular failing memory module can be
 	  replaced.  If unsure, select 'Y'.
 
+config EDAC_MCE
+	tristate
+
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
 	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && CPU_SUP_AMD
@@ -150,9 +153,12 @@ config EDAC_I5400
 config EDAC_I7CORE
 	tristate "Intel i7 Core (Nehalem) processors"
 	depends on EDAC_MM_EDAC && PCI && X86
+	select EDAC_MCE
 	help
 	  Support for error detection and correction the Intel
-	  i7 Core (Nehalem) Integrated Memory Controller
+	  i7 Core (Nehalem) Integrated Memory Controller that exists on
+	  newer processors like i7 Core, i7 Core Extreme, Xeon 35xx
+	  and Xeon 55xx processors.
 
 config EDAC_I82860
 	tristate "Intel 82860"
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 6f0cfe2..5ec7e9c 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -7,8 +7,9 @@
 #
 
 
-obj-$(CONFIG_EDAC)			:= edac_stub.o
+obj-$(CONFIG_EDAC)			+= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
+obj-$(CONFIG_EDAC_MCE)			+= edac_mce.o
 
 edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
 edac_core-objs	+= edac_module.o edac_device_sysfs.o
diff --git a/drivers/edac/edac_mce.c b/drivers/edac/edac_mce.c
new file mode 100644
index 0000000..b1efa8e
--- /dev/null
+++ b/drivers/edac/edac_mce.c
@@ -0,0 +1,58 @@
+/* Provides edac interface to mcelog events
+ *
+ * This file may be distributed under the terms of the
+ * GNU General Public License version 2.
+ *
+ * Copyright (c) 2009 by:
+ *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * Red Hat Inc. http://www.redhat.com
+ */
+
+#include <linux/module.h>
+#include <linux/edac_mce.h>
+#include <asm/mce.h>
+
+int edac_mce_enabled;
+EXPORT_SYMBOL_GPL(edac_mce_enabled);
+
+
+/*
+ * Extension interface
+ */
+
+static LIST_HEAD(edac_mce_list);
+static DEFINE_MUTEX(edac_mce_lock);
+
+int edac_mce_register(struct edac_mce *edac_mce)
+{
+	mutex_lock(&edac_mce_lock);
+	list_add_tail(&edac_mce->list, &edac_mce_list);
+	mutex_unlock(&edac_mce_lock);
+	return 0;
+}
+EXPORT_SYMBOL(edac_mce_register);
+
+void edac_mce_unregister(struct edac_mce *edac_mce)
+{
+	mutex_lock(&edac_mce_lock);
+	list_del(&edac_mce->list);
+	mutex_unlock(&edac_mce_lock);
+}
+EXPORT_SYMBOL(edac_mce_unregister);
+
+
+
+int edac_mce_queue(struct mce *mce)
+{
+	struct edac_mce *edac_mce;
+
+	list_for_each_entry(edac_mce, &edac_mce_list, list) {
+		if (edac_mce->check_error(edac_mce->priv, mce))
+			return 1;
+	}
+
+	/* Nobody queued the error */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(edac_mce_queue);
diff --git a/include/linux/edac_mce.h b/include/linux/edac_mce.h
new file mode 100644
index 0000000..f974fc0
--- /dev/null
+++ b/include/linux/edac_mce.h
@@ -0,0 +1,31 @@
+/* Provides edac interface to mcelog events
+ *
+ * This file may be distributed under the terms of the
+ * GNU General Public License version 2.
+ *
+ * Copyright (c) 2009 by:
+ *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * Red Hat Inc. http://www.redhat.com
+ */
+
+#if defined(CONFIG_EDAC_MCE) || \
+			(defined(CONFIG_EDAC_MCE_MODULE) && defined(MODULE))
+
+#include <asm/mce.h>
+#include <linux/list.h>
+
+struct edac_mce {
+	struct list_head list;
+
+	void *priv;
+	int (*check_error)(void *priv, struct mce *mce);
+};
+
+int edac_mce_register(struct edac_mce *edac_mce);
+void edac_mce_unregister(struct edac_mce *edac_mce);
+int edac_mce_parse(struct mce *mce);
+
+#else
+#define edac_mce_parse(mce) (0)
+#endif
-- 
1.5.5.6

