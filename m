Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0BWMlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:41:40 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:37751 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0BWMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:40:58 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 23 Feb 2010 13:40:30 +0100
Message-Id: <1266928835-5435-2-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266928835-5435-1-git-send-email-giometti@linux.it>
References: <1266928835-5435-1-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 1/6] pps: LinuxPPS clients support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each PPS source can be registered/deregistered into the system by
using special modules called "clients". They simply define the PPS
sources' attributes and implement the time signal registartion
mechanism.

This patch adds a special directory for such clients and adds a dummy
client that can be useful to test system integrity on real systems.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/Kconfig          |    2 +
 drivers/pps/Makefile         |    1 +
 drivers/pps/clients/Kconfig  |   18 ++++++
 drivers/pps/clients/Makefile |    9 +++
 drivers/pps/clients/ktimer.c |  123 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pps/clients/Kconfig
 create mode 100644 drivers/pps/clients/Makefile
 create mode 100644 drivers/pps/clients/ktimer.c

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index cc2eb8e..1afe4e0 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -30,4 +30,6 @@ config PPS_DEBUG
 	  messages to the system log.  Select this if you are having a
 	  problem with PPS support and want to see more of what is going on.
 
+source drivers/pps/clients/Kconfig
+
 endmenu
diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
index 19ea582..98960dd 100644
--- a/drivers/pps/Makefile
+++ b/drivers/pps/Makefile
@@ -4,5 +4,6 @@
 
 pps_core-y			:= pps.o kapi.o sysfs.o
 obj-$(CONFIG_PPS)		:= pps_core.o
+obj-y				+= clients/
 
 ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
new file mode 100644
index 0000000..60b83be
--- /dev/null
+++ b/drivers/pps/clients/Kconfig
@@ -0,0 +1,18 @@
+#
+# PPS clients configuration
+#
+
+if PPS
+
+comment "PPS clients support"
+
+config PPS_CLIENT_KTIMER
+	tristate "Kernel timer client (Testing client, use for debug)"
+	help
+	  If you say yes here you get support for a PPS debugging client
+	  which uses a kernel timer to generate the PPS signal.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ktimer.ko.
+
+endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
new file mode 100644
index 0000000..f3c1e39
--- /dev/null
+++ b/drivers/pps/clients/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for PPS clients.
+#
+
+obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+
+ifeq ($(CONFIG_PPS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff --git a/drivers/pps/clients/ktimer.c b/drivers/pps/clients/ktimer.c
new file mode 100644
index 0000000..6de5dfc
--- /dev/null
+++ b/drivers/pps/clients/ktimer.c
@@ -0,0 +1,123 @@
+/*
+ * ktimer.c -- kernel timer test client
+ *
+ *
+ * Copyright (C) 2005-2006   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <linux/pps_kernel.h>
+
+/*
+ * Global variables
+ */
+
+static int source;
+static struct timer_list ktimer;
+
+/*
+ * The kernel timer
+ */
+
+static void pps_ktimer_event(unsigned long ptr)
+{
+	struct timespec __ts;
+	struct pps_ktime ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	pr_info("PPS event at %lu\n", jiffies);
+
+	/* ... and translate it to PPS time data struct */
+	ts.sec = __ts.tv_sec;
+	ts.nsec = __ts.tv_nsec;
+
+	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
+
+	mod_timer(&ktimer, jiffies + HZ);
+}
+
+/*
+ * The echo function
+ */
+
+static void pps_ktimer_echo(int source, int event, void *data)
+{
+	pr_info("echo %s %s for source %d\n",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "",
+		source);
+}
+
+/*
+ * The PPS info struct
+ */
+
+static struct pps_source_info pps_ktimer_info = {
+	.name		= "ktimer",
+	.path		= "",
+	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+			  PPS_ECHOASSERT | \
+			  PPS_CANWAIT | PPS_TSFMT_TSPEC,
+	.echo 		= pps_ktimer_echo,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Module staff
+ */
+
+static void __exit pps_ktimer_exit(void)
+{
+	del_timer_sync(&ktimer);
+	pps_unregister_source(source);
+
+	pr_info("ktimer PPS source unregistered\n");
+}
+
+static int __init pps_ktimer_init(void)
+{
+	int ret;
+
+	ret = pps_register_source(&pps_ktimer_info,
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
+	if (ret < 0) {
+		printk(KERN_ERR "cannot register ktimer source\n");
+		return ret;
+	}
+	source = ret;
+
+	setup_timer(&ktimer, pps_ktimer_event, 0);
+	mod_timer(&ktimer, jiffies + HZ);
+
+	pr_info("ktimer PPS source registered at %d\n", source);
+
+	return  0;
+}
+
+module_init(pps_ktimer_init);
+module_exit(pps_ktimer_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("dummy PPS source by using a kernel timer (just for debug)");
+MODULE_LICENSE("GPL");
-- 
1.6.3.3

