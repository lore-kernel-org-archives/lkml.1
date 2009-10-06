Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZJFWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZJFWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbZJFWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:11:52 -0400
Received: from claw.goop.org ([74.207.240.146]:37951 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283AbZJFWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:11:51 -0400
Message-ID: <4ACBC082.8070305@goop.org>
Date: Tue, 06 Oct 2009 15:11:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Kay, Allen M" <allen.m.kay@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "chris@sous-sol.org" <chris@sous-sol.org>
Subject: [PATCH] xen: move Xen-testing predicates to common header
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com> <4ACBB8B0.9030102@goop.org> <57C9024A16AD2D4C97DC78E552063EA3E30224B7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E30224B7@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move xen_domain and related tests out of asm-x86 to xen/xen.h so they
can be included whenever they are necessary.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
--
 arch/x86/include/asm/xen/hypervisor.h |   27 ---------------------------
 arch/x86/xen/enlighten.c              |    1 +
 drivers/block/xen-blkfront.c          |    1 +
 drivers/char/hvc_xen.c                |    2 ++
 drivers/input/xen-kbdfront.c          |    3 +++
 drivers/net/xen-netfront.c            |    1 +
 drivers/video/xen-fbfront.c           |    3 +++
 drivers/xen/balloon.c                 |    2 ++
 drivers/xen/cpu_hotplug.c             |    1 +
 drivers/xen/evtchn.c                  |    2 ++
 drivers/xen/grant-table.c             |    1 +
 drivers/xen/sys-hypervisor.c          |    1 +
 drivers/xen/xenbus/xenbus_probe.c     |    2 ++
 drivers/xen/xenfs/super.c             |    2 ++
 include/xen/xen.h                     |   32 ++++++++++++++++++++++++++++++++

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index d5b7e90..396ff4c 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,31 +37,4 @@
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
-enum xen_domain_type {
-	XEN_NATIVE,		/* running on bare hardware    */
-	XEN_PV_DOMAIN,		/* running in a PV domain      */
-	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
-};
-
-#ifdef CONFIG_XEN
-extern enum xen_domain_type xen_domain_type;
-#else
-#define xen_domain_type		XEN_NATIVE
-#endif
-
-#define xen_domain()		(xen_domain_type != XEN_NATIVE)
-#define xen_pv_domain()		(xen_domain() &&			\
-				 xen_domain_type == XEN_PV_DOMAIN)
-#define xen_hvm_domain()	(xen_domain() &&			\
-				 xen_domain_type == XEN_HVM_DOMAIN)
-
-#ifdef CONFIG_XEN_DOM0
-#include <xen/interface/xen.h>
-
-#define xen_initial_domain()	(xen_pv_domain() && \
-				 xen_start_info->flags & SIF_INITDOMAIN)
-#else  /* !CONFIG_XEN_DOM0 */
-#define xen_initial_domain()	(0)
-#endif	/* CONFIG_XEN_DOM0 */
-
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index eb33aaa..f0db2b9 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -28,6 +28,7 @@
 #include <linux/highmem.h>
 #include <linux/console.h>
 
+#include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index e532847..1e5baf7 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -42,6 +42,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
+#include <xen/xen.h>
 #include <xen/xenbus.h>
 #include <xen/grant_table.h>
 #include <xen/events.h>
diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index eba999f..93d3381 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -25,6 +25,8 @@
 #include <linux/types.h>
 
 #include <asm/xen/hypervisor.h>
+
+#include <xen/xen.h>
 #include <xen/page.h>
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index b115726..c721c0a 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -21,7 +21,10 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/input.h>
+
 #include <asm/xen/hypervisor.h>
+
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/page.h>
 #include <xen/interface/io/fbif.h>
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 8d88dae..c2567ad 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -42,6 +42,7 @@
 #include <linux/mm.h>
 #include <net/ip.h>
 
+#include <xen/xen.h>
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/page.h>
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 54cd916..966b226 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -25,7 +25,10 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
+
 #include <asm/xen/hypervisor.h>
+
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/page.h>
 #include <xen/interface/io/fbif.h>
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f5bbd9e..3a27e68 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -52,6 +52,8 @@
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+
+#include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
 #include <xen/xenbus.h>
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index bdfd584..6625ffe 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -1,5 +1,6 @@
 #include <linux/notifier.h>
 
+#include <xen/xen.h>
 #include <xen/xenbus.h>
 
 #include <asm/xen/hypervisor.h>
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index af03195..8356843 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -49,6 +49,8 @@
 #include <linux/gfp.h>
 #include <linux/mutex.h>
 #include <linux/cpu.h>
+
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/evtchn.h>
 #include <asm/xen/hypervisor.h>
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 7d8f531..4c6c0bd 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 
+#include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index 88a60e0..ae5cb05 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -14,6 +14,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/xen.h>
 #include <xen/xenbus.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index d42e25d..08638ad 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -49,6 +49,8 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/xen/hypervisor.h>
+
+#include <xen/xen.h>
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/page.h>
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 6559e0c..8924d93 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -13,6 +13,8 @@
 #include <linux/fs.h>
 #include <linux/magic.h>
 
+#include <xen/xen.h>
+
 #include "xenfs.h"
 
 #include <asm/xen/hypervisor.h>
diff --git a/include/xen/xen.h b/include/xen/xen.h
new file mode 100644
index 0000000..a164024
--- /dev/null
+++ b/include/xen/xen.h
@@ -0,0 +1,32 @@
+#ifndef _XEN_XEN_H
+#define _XEN_XEN_H
+
+enum xen_domain_type {
+	XEN_NATIVE,		/* running on bare hardware    */
+	XEN_PV_DOMAIN,		/* running in a PV domain      */
+	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
+};
+
+#ifdef CONFIG_XEN
+extern enum xen_domain_type xen_domain_type;
+#else
+#define xen_domain_type		XEN_NATIVE
+#endif
+
+#define xen_domain()		(xen_domain_type != XEN_NATIVE)
+#define xen_pv_domain()		(xen_domain() &&			\
+				 xen_domain_type == XEN_PV_DOMAIN)
+#define xen_hvm_domain()	(xen_domain() &&			\
+				 xen_domain_type == XEN_HVM_DOMAIN)
+
+#ifdef CONFIG_XEN_DOM0
+#include <xen/interface/xen.h>
+#include <asm/xen/hypervisor.h>
+
+#define xen_initial_domain()	(xen_pv_domain() && \
+				 xen_start_info->flags & SIF_INITDOMAIN)
+#else  /* !CONFIG_XEN_DOM0 */
+#define xen_initial_domain()	(0)
+#endif	/* CONFIG_XEN_DOM0 */
+
+#endif	/* _XEN_XEN_H */


