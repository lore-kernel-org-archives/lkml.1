Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZHQRyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZHQRyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbZHQRyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:54:08 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45641 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbZHQRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:54:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Date: Mon, 17 Aug 2009 10:53:17 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: move dmar_table_init out of enable_IR
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Message-id: <4A89990D.4030703@sun.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on x2apic system, we got
[    1.818072] ------------[ cut here ]------------
[    1.820376] WARNING: at kernel/lockdep.c:2461
lockdep_trace_alloc+0xa5/0xe9()
[    1.835282] Hardware name: ASSY,
[    1.839006] Modules linked in:
[    1.841253] Pid: 1, comm: swapper Not tainted
2.6.31-rc5-tip-03926-g39aaa80-dirty #510
[    1.858056] Call Trace:
[    1.859913]  [<ffffffff810d13aa>] ? lockdep_trace_alloc+0xa5/0xe9
[    1.876270]  [<ffffffff81093f37>] warn_slowpath_common+0x8d/0xd0
[    1.879132]  [<ffffffff81093fa1>] warn_slowpath_null+0x27/0x3d
[    1.896823]  [<ffffffff810d13aa>] lockdep_trace_alloc+0xa5/0xe9
[    1.900659]  [<ffffffff810cf5a0>] ? lock_release_holdtime+0x2f/0x199
[    1.917188]  [<ffffffff81167a3c>] kmem_cache_alloc_notrace+0x42/0x111
[    1.922320]  [<ffffffff8106fe8c>] ? reserve_memtype+0x152/0x518
[    1.938137]  [<ffffffff8106f8b1>] ? pat_pagerange_is_ram+0x4a/0x91
[    1.941730]  [<ffffffff8106fe8c>] reserve_memtype+0x152/0x518
[    1.958115]  [<ffffffff8106ce62>] __ioremap_caller+0x1dd/0x30f
[    1.975507]  [<ffffffff81ce2c5c>] ? acpi_os_map_memory+0x2a/0x47
[    1.978987]  [<ffffffff8106d0fd>] ioremap_nocache+0x2a/0x40
[    2.031400]  [<ffffffff810d0364>] ? trace_hardirqs_off+0x20/0x36
[    2.036096]  [<ffffffff81ce2c5c>] acpi_os_map_memory+0x2a/0x47
[    2.046263]  [<ffffffff815cd642>] acpi_tb_verify_table+0x3d/0x85
[    2.050349]  [<ffffffff81d34af7>] ? _spin_unlock_irqrestore+0x50/0x76
[    2.067327]  [<ffffffff815ccad6>] acpi_get_table_with_size+0x64/0xd9
[    2.070860]  [<ffffffff81d34af7>] ? _spin_unlock_irqrestore+0x50/0x76
[    2.088000]  [<ffffffff825c88d5>] dmar_table_detect+0x33/0x70
[    2.092047]  [<ffffffff825c8a01>] dmar_table_init+0x43/0x428
[    2.106854]  [<ffffffff825a7537>] enable_IR+0x1c/0x8d
[    2.110256]  [<ffffffff825a7624>] enable_IR_x2apic+0x7c/0x19e
[    2.127139]  [<ffffffff825a4876>] native_smp_prepare_cpus+0x139/0x3b8
[    2.145175]  [<ffffffff8259678d>] kernel_init+0x71/0x1da
[    2.148913]  [<ffffffff8104305a>] child_rip+0xa/0x20
[    2.152349]  [<ffffffff810429fc>] ? restore_args+0x0/0x30
[    2.167931]  [<ffffffff8259671c>] ? kernel_init+0x0/0x1da
[    2.171671]  [<ffffffff81043050>] ? child_rip+0x0/0x20
[    2.187607] ---[ end trace a7919e7f17c0a725 ]---

Pallipadi, Venkatesh said

| Looks like the problem started with this commit
|
| commit ce69a784504222c3ab6f1b3c357d09ec5772127a
|Author: Gleb Natapov <gleb@redhat.com>
|Date:   Mon Jul 20 15:24:17 2009 +0300
|
|x86/apic: Enable x2APIC without interrupt remapping under KVM
|
|Before this commit, dmar_table_init() was getting called with interrupts
|enabled and after this commit, it is getting called with interrupts
|disabled.

so try to move out dmar_table_init out of that function.

Analyzed-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1365,14 +1365,6 @@ void enable_x2apic(void)
 int __init enable_IR(void)
 {
 #ifdef CONFIG_INTR_REMAP
-    int ret;
-
-    ret = dmar_table_init();
-    if (ret) {
-        pr_debug("dmar_table_init() failed with %d:\n", ret);
-        return 0;
-    }
-
     if (!intr_remapping_supported()) {
         pr_debug("intr-remapping not supported\n");
         return 0;
@@ -1400,6 +1392,14 @@ void __init enable_IR_x2apic(void)
     unsigned long flags;
     struct IO_APIC_route_entry **ioapic_entries = NULL;
     int ret, x2apic_enabled = 0;
+    int dmar_table_init_ret = 0;
+
+#ifdef CONFIG_INTR_REMAP
+    dmar_table_init_ret = dmar_table_init();
+    if (dmar_table_init_ret)
+        pr_debug("dmar_table_init() failed with %d:\n",
+                dmar_table_init_ret);
+#endif
 
     ioapic_entries = alloc_ioapic_entries();
     if (!ioapic_entries) {
@@ -1417,7 +1417,11 @@ void __init enable_IR_x2apic(void)
     mask_8259A();
     mask_IO_APIC_setup(ioapic_entries);
 
-    ret = enable_IR();
+    if (dmar_table_init_ret)
+        ret = 0;
+    else
+        ret = enable_IR();
+
     if (!ret) {
         /* IR is required if there is APIC ID > 255 even when running
          * under KVM
