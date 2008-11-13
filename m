Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYKMTg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYKMTg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYKMTeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:10 -0500
Received: from gw.goop.org ([64.81.55.164]:34384 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbYKMTeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:04 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 38] xen: clean up asm-x86/xen/hypervisor.h
X-Mercurial-Node: 1f3a43fef28cb05384c13aa93f53b83eae50795c
Message-Id: <1f3a43fef28cb05384c1.1226603404@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hypervisor.h had accumulated a lot of crud, including lots of spurious
#includes.  Clean it all up, and go around fixing up everything else
accordingly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/hypercall.h  |    6 +++++
 arch/x86/include/asm/xen/hypervisor.h |   39 ++++++---------------------------
 arch/x86/include/asm/xen/page.h       |    5 ++++
 arch/x86/xen/enlighten.c              |    1
 drivers/xen/balloon.c                 |    4 ++-
 drivers/xen/features.c                |    6 ++++-
 drivers/xen/grant-table.c             |    1
 include/xen/interface/event_channel.h |    2 +
 8 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -33,8 +33,14 @@
 #ifndef _ASM_X86_XEN_HYPERCALL_H
 #define _ASM_X86_XEN_HYPERCALL_H
 
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/types.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -33,39 +33,10 @@
 #ifndef _ASM_X86_XEN_HYPERVISOR_H
 #define _ASM_X86_XEN_HYPERVISOR_H
 
-#include <linux/types.h>
-#include <linux/kernel.h>
-
-#include <xen/interface/xen.h>
-#include <xen/interface/version.h>
-
-#include <asm/ptrace.h>
-#include <asm/page.h>
-#include <asm/desc.h>
-#if defined(__i386__)
-#  ifdef CONFIG_X86_PAE
-#   include <asm-generic/pgtable-nopud.h>
-#  else
-#   include <asm-generic/pgtable-nopmd.h>
-#  endif
-#endif
-#include <asm/xen/hypercall.h>
-
 /* arch/i386/kernel/setup.c */
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
-/* arch/i386/mach-xen/evtchn.c */
-/* Force a proper event-channel callback from Xen. */
-extern void force_evtchn_callback(void);
-
-/* Turn jiffies into Xen system time. */
-u64 jiffies_to_st(unsigned long jiffies);
-
-
-#define MULTI_UVMFLAGS_INDEX 3
-#define MULTI_UVMDOMID_INDEX 4
-
 enum xen_domain_type {
 	XEN_NATIVE,
 	XEN_PV_DOMAIN,
@@ -74,9 +45,15 @@
 
 extern enum xen_domain_type xen_domain_type;
 
+#ifdef CONFIG_XEN
 #define xen_domain()		(xen_domain_type != XEN_NATIVE)
-#define xen_pv_domain()		(xen_domain_type == XEN_PV_DOMAIN)
+#else
+#define xen_domain()		(0)
+#endif
+
+#define xen_pv_domain()		(xen_domain() && xen_domain_type == XEN_PV_DOMAIN)
+#define xen_hvm_domain()	(xen_domain() && xen_domain_type == XEN_HVM_DOMAIN)
+
 #define xen_initial_domain()	(xen_pv_domain() && xen_start_info->flags & SIF_INITDOMAIN)
-#define xen_hvm_domain()	(xen_domain_type == XEN_HVM_DOMAIN)
 
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -1,11 +1,16 @@
 #ifndef _ASM_X86_XEN_PAGE_H
 #define _ASM_X86_XEN_PAGE_H
 
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
+#include <asm/page.h>
 #include <asm/pgtable.h>
 
+#include <xen/interface/xen.h>
 #include <xen/features.h>
 
 /* Xen machine address */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -28,6 +28,7 @@
 #include <linux/console.h>
 
 #include <xen/interface/xen.h>
+#include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
 #include <xen/features.h>
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -44,13 +44,15 @@
 #include <linux/list.h>
 #include <linux/sysdev.h>
 
-#include <asm/xen/hypervisor.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
 
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
 #include <xen/xenbus.h>
 #include <xen/features.h>
diff --git a/drivers/xen/features.c b/drivers/xen/features.c
--- a/drivers/xen/features.c
+++ b/drivers/xen/features.c
@@ -8,7 +8,11 @@
 #include <linux/types.h>
 #include <linux/cache.h>
 #include <linux/module.h>
-#include <asm/xen/hypervisor.h>
+
+#include <asm/xen/hypercall.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/version.h>
 #include <xen/features.h>
 
 u8 xen_features[XENFEAT_NR_SUBMAPS * 32] __read_mostly;
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -40,6 +40,7 @@
 #include <xen/interface/xen.h>
 #include <xen/page.h>
 #include <xen/grant_table.h>
+#include <asm/xen/hypercall.h>
 
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
diff --git a/include/xen/interface/event_channel.h b/include/xen/interface/event_channel.h
--- a/include/xen/interface/event_channel.h
+++ b/include/xen/interface/event_channel.h
@@ -9,6 +9,8 @@
 #ifndef __XEN_PUBLIC_EVENT_CHANNEL_H__
 #define __XEN_PUBLIC_EVENT_CHANNEL_H__
 
+#include <xen/interface/xen.h>
+
 typedef uint32_t evtchn_port_t;
 DEFINE_GUEST_HANDLE(evtchn_port_t);
 


