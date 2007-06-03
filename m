Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbXFCPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbXFCPLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXFCPLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:11:07 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:41116 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751819AbXFCPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:11:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qVTTY4d6Q76vjqo15xrZAFOVVbned/lPkyEq9rjit9+EP6Fao52VrLc4HZ25uA8QpdYUUK63vx1Nz00hlkkJVWPsLiuQM1VPGOZtOpcZheP9Ev2QhE99uCm2J/xqb8w1PNzBkiSuL1LJDIoPVDszEDhXIOgmjsFX0GGJCuh5G88=;
X-YMail-OSG: zr9BTkMVM1m1rLqlCd10xRZu3TijCA4wiz38UvJf
Date: Sun, 3 Jun 2007 08:11:02 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 12/36] drivers edac add nmi ecc harvesting
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <866076.60576.qm@web50110.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Dave Jiang <djiang@mvista.com>

Provides a way for NMI reported errors on x86 to notify the EDAC
subsystem pending ECC errors by writing to a software state variable.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>

---

Here's the reworked patch. I added an EDAC stub to the kernel so we can
have variables that are in the kernel even if EDAC is a module. I also
implemented the idea of using the chip driver to select error detection
mode via module parameter and eliminate the kernel compile option.
Please review/test. Thx!

Also, I only made changes to some of the chipset drivers since I am
unfamiliar with the other ones. We can add similar changes as we go.


 arch/i386/kernel/traps.c   |   12 ++++++++++++
 arch/x86_64/kernel/traps.c |   11 +++++++++++
 drivers/edac/Kconfig       |   17 ++---------------
 drivers/edac/Makefile      |    1 +
 drivers/edac/e752x_edac.c  |   14 +++++++++++++-
 drivers/edac/e7xxx_edac.c  |   14 ++++++++++++++
 drivers/edac/edac_mc.c     |    4 +++-
 drivers/edac/edac_module.c |   24 ++++++++++++++++++++++--
 drivers/edac/edac_stub.c   |   44
++++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/i5000_edac.c  |   13 +++++++++++++
 include/linux/edac.h       |   29 +++++++++++++++++++++++++++++
 11 files changed, 164 insertions(+), 19 deletions(-)

---

Index: linux-2.6.22-rc1/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6.22-rc1.orig/arch/i386/kernel/traps.c
+++ linux-2.6.22-rc1/arch/i386/kernel/traps.c
@@ -41,6 +41,10 @@
 #include <linux/mca.h>
 #endif
 
+#if defined(CONFIG_EDAC)
+#include <linux/edac.h>
+#endif
+
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/io.h>
@@ -635,6 +639,14 @@ mem_parity_error(unsigned char reason, s
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
 		"CPU %d.\n", reason, smp_processor_id());
 	printk(KERN_EMERG "You have some hardware problem, likely on the PCI
bus.\n");
+
+#if defined(CONFIG_EDAC)
+	if(edac_handler_set()) {
+		edac_atomic_assert_error();
+		return;
+	}
+#endif
+
 	if (panic_on_unrecovered_nmi)
                 panic("NMI: Not continuing");
 
Index: linux-2.6.22-rc1/arch/x86_64/kernel/traps.c
===================================================================
--- linux-2.6.22-rc1.orig/arch/x86_64/kernel/traps.c
+++ linux-2.6.22-rc1/arch/x86_64/kernel/traps.c
@@ -34,6 +34,10 @@
 #include <linux/bug.h>
 #include <linux/kdebug.h>
 
+#if defined(CONFIG_EDAC)
+#include <linux/edac.h>
+#endif
+
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
@@ -716,6 +720,13 @@ mem_parity_error(unsigned char reason, s
 		reason);
 	printk(KERN_EMERG "You have some hardware problem, likely on the PCI
bus.\n");
 
+#if defined(CONFIG_EDAC)
+	if(edac_handler_set()) {
+		edac_atomic_assert_error();
+		return;
+	}
+#endif
+
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
Index: linux-2.6.22-rc1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.22-rc1/drivers/edac/edac_mc.c
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
+#include <linux/edac.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
@@ -241,6 +242,7 @@ static int add_mc_to_global_list (struct
 	}
 
 	list_add_tail_rcu(&mci->link, insert_before);
+	atomic_inc(&edac_handlers);
 	return 0;
 
 fail0:
@@ -267,6 +269,7 @@ static void complete_mc_list_del(struct 
 
 static void del_mc_from_global_list(struct mem_ctl_info *mci)
 {
+	atomic_dec(&edac_handlers);
 	list_del_rcu(&mci->link);
 	init_completion(&mci->complete);
 	call_rcu(&mci->rcu, complete_mc_list_del);
Index: linux-2.6.22-rc1/drivers/edac/edac_module.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_module.c
+++ linux-2.6.22-rc1/drivers/edac/edac_module.c
@@ -1,6 +1,7 @@
 
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/edac.h>
 
 #include "edac_mc.h"
 #include "edac_module.h"
@@ -102,6 +103,25 @@ static void do_edac_check(void)
 }
 
 /*
+ * handler for EDAC to check if NMI type handler has asserted
interrupt
+ */
+static int edac_assert_error_check_and_clear(void)
+{
+	int vreg;
+
+	if(edac_op_state == EDAC_OPSTATE_POLL)
+		return 1;
+
+	vreg = atomic_read(&edac_err_assert);
+	if(vreg) {
+		atomic_set(&edac_err_assert, 0);
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
  * Action thread for EDAC to perform the POLL operations
  */
 static int edac_kernel_thread(void *arg)
@@ -109,8 +129,8 @@ static int edac_kernel_thread(void *arg)
 	int msec;
 
 	while (!kthread_should_stop()) {
-
-		do_edac_check();
+		if(edac_assert_error_check_and_clear())
+			do_edac_check();
 
 		/* goto sleep for the interval */
 		msec = (HZ * edac_get_poll_msec()) / 1000;
Index: linux-2.6.22-rc1/drivers/edac/Kconfig
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/Kconfig
+++ linux-2.6.22-rc1/drivers/edac/Kconfig
@@ -105,15 +105,4 @@ config EDAC_I5000
 	  Support for error detection and correction the Intel
 	  Greekcreek/Blackford chipsets.
 
-choice
-	prompt "Error detecting method"
-	default EDAC_POLL
-
-config EDAC_POLL
-	bool "Poll for errors"
-	help
-	  Poll the chipset periodically to detect errors.
-
-endchoice
-
 endif # EDAC
Index: linux-2.6.22-rc1/include/linux/edac.h
===================================================================
--- /dev/null
+++ linux-2.6.22-rc1/include/linux/edac.h
@@ -0,0 +1,29 @@
+/*
+ * Generic EDAC defs
+ *
+ * Author: Dave Jiang <djiang@mvista.com>
+ *
+ * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether
express
+ * or implied.
+ *
+ */
+#ifndef _LINUX_EDAC_H_
+#define _LINUX_EDAC_H_
+
+#include <asm/atomic.h>
+
+#define EDAC_OPSTATE_INVAL	-1
+#define EDAC_OPSTATE_POLL	0
+#define EDAC_OPSTATE_NMI	1
+#define EDAC_OPSTATE_INT	2
+
+extern int edac_op_state;
+extern atomic_t edac_handlers;
+extern atomic_t edac_err_assert;
+
+extern int edac_handler_set(void);
+extern void edac_atomic_assert_error(void);
+
+#endif
Index: linux-2.6.22-rc1/drivers/edac/Makefile
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/Makefile
+++ linux-2.6.22-rc1/drivers/edac/Makefile
@@ -5,9 +5,9 @@
 # This file may be distributed under the terms of the
 # GNU General Public License.
 #
-# $Id: Makefile,v 1.4.2.3 2005/07/08 22:05:38 dsp_llnl Exp $
 
 
+obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 
 edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o
edac_pci_sysfs.o
Index: linux-2.6.22-rc1/drivers/edac/edac_stub.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc1/drivers/edac/edac_stub.c
@@ -0,0 +1,42 @@
+/*
+ * common EDAC components that must be in kernel
+ *
+ * Author: Dave Jiang <djiang@mvista.com>
+ *
+ * 2007 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether
express
+ * or implied.
+ *
+ */
+#include <linux/module.h>
+#include <linux/edac.h>
+#include <asm/atomic.h>
+#include <asm/edac.h>
+
+int edac_op_state = EDAC_OPSTATE_INVAL;
+EXPORT_SYMBOL(edac_op_state);
+
+atomic_t edac_handlers = ATOMIC_INIT(0);
+EXPORT_SYMBOL(edac_handlers);
+
+atomic_t edac_err_assert = ATOMIC_INIT(0);
+EXPORT_SYMBOL(edac_err_assert);
+
+inline int edac_handler_set(void)
+{
+	if (edac_op_state == EDAC_OPSTATE_POLL)
+		return 0;
+
+	return atomic_read(&edac_handlers);
+}
+EXPORT_SYMBOL(edac_handler_set);
+
+/*
+ * handler for NMI type of interrupts to assert error
+ */
+inline void edac_atomic_assert_error(void)
+{
+	atomic_set(&edac_err_assert, 1);
+}
+EXPORT_SYMBOL(edac_atomic_assert_error);
Index: linux-2.6.22-rc1/drivers/edac/e752x_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/e752x_edac.c
+++ linux-2.6.22-rc1/drivers/edac/e752x_edac.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_mc.h"
 
 #define E752X_REVISION	" Ver: 2.0.1 " __DATE__
@@ -948,6 +949,16 @@ static int e752x_probe1(struct pci_dev *
 	debugf0("%s(): mci\n", __func__);
 	debugf0("Starting Probe1\n");
 
+	/* make sure error reporting method is sane */
+	switch(edac_op_state) {
+		case EDAC_OPSTATE_POLL:
+		case EDAC_OPSTATE_NMI:
+			break;
+		default:
+			edac_op_state = EDAC_OPSTATE_POLL;
+			break;
+	}
+
 	/* check to see if device 0 function 1 is enabled; if it isn't, we
 	 * assume the BIOS has reserved it for a reason and is expecting
 	 * exclusive access, we take care not to violate that assumption and
@@ -1123,4 +1134,5 @@ MODULE_DESCRIPTION("MC support for Intel
 module_param(force_function_unhide, int, 0444);
 MODULE_PARM_DESC(force_function_unhide, "if BIOS sets Dev0:Fun1 up as
hidden:"
 " 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1
access");
-
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state:
0=Poll,1=NMI");
Index: linux-2.6.22-rc1/drivers/edac/e7xxx_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/e7xxx_edac.c
+++ linux-2.6.22-rc1/drivers/edac/e7xxx_edac.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_mc.h"
 
 #define	E7XXX_REVISION " Ver: 2.0.1 " __DATE__
@@ -419,6 +420,17 @@ static int e7xxx_probe1(struct pci_dev *
 	struct e7xxx_error_info discard;
 
 	debugf0("%s(): mci\n", __func__);
+
+	/* make sure error reporting method is sane */
+	switch(edac_op_state) {
+		case EDAC_OPSTATE_POLL:
+		case EDAC_OPSTATE_NMI:
+			break;
+		default:
+			edac_op_state = EDAC_OPSTATE_POLL;
+			break;
+	}
+
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
@@ -565,3 +577,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh et
al\n"
 	"Based on.work by Dan Hollis et al");
 MODULE_DESCRIPTION("MC support for Intel e7xxx memory controllers");
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state:
0=Poll,1=NMI");
Index: linux-2.6.22-rc1/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.22-rc1/drivers/edac/i5000_edac.c
@@ -19,6 +19,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include <asm/mmzone.h>
 
 #include "edac_mc.h"
@@ -1285,6 +1286,16 @@ static int i5000_probe1(struct pci_dev *
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
+	/* make sure error reporting method is sane */
+	switch(edac_op_state) {
+		case EDAC_OPSTATE_POLL:
+		case EDAC_OPSTATE_NMI:
+			break;
+		default:
+			edac_op_state = EDAC_OPSTATE_POLL;
+			break;
+	}
+
 	/* Ask the devices for the number of CSROWS and CHANNELS so
 	 * that we can calculate the memory resources, etc
 	 *
@@ -1475,3 +1486,5 @@ MODULE_AUTHOR
     ("Linux Networx (http://lnxi.com) Doug Thompson
<norsk5@xmission.com>");
 MODULE_DESCRIPTION("MC Driver for Intel I5000 memory controllers - "
 		   I5000_REVISION);
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state:
0=Poll,1=NMI");

