Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYIWNmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYIWNmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYIWNmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:42:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751459AbYIWNmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:42:08 -0400
Date: Tue, 23 Sep 2008 08:42:05 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Fix ordering of calls to uv_system_init & uv_cpu_init
Message-ID: <20080923134205.GA26688@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix problem caused by reordering of the calls to uv_cpu_init() &
uv_system_init. Originally, uv_cpu_init() was called AFTER uv_system_init.
This order was recently broken as a side-effect of other patches.

With this patch, initialization of cpu 0 is now done by the system_init
call.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
Note. Only added a couple of lines. Most of the patch is moving uv_cpu_init()
to come earlier in the file.

Patch based on x86/tip....

 arch/x86/kernel/genx2apic_uv_x.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-09-22 10:55:02.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-09-22 13:23:12.000000000 -0500
@@ -357,7 +357,22 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
-static bool uv_system_inited;
+/*
+ * Called on each cpu to initialize the per_cpu UV data area.
+ * 	ZZZ hotplug not supported yet
+ */
+void __cpuinit uv_cpu_init(void)
+{
+	/* CPU 0 initilization will be done via uv_system_init. */
+	if (!uv_blade_info)
+		return;
+
+	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
+
+	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
+		set_x2apic_extra_bits(uv_hub_info->pnode);
+}
+
 
 void __init uv_system_init(void)
 {
@@ -449,21 +464,6 @@ void __init uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
-	uv_system_inited = true;
-}
 
-/*
- * Called on each cpu to initialize the per_cpu UV data area.
- * 	ZZZ hotplug not supported yet
- */
-void __cpuinit uv_cpu_init(void)
-{
-	BUG_ON(!uv_system_inited);
-
-	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
-
-	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
-		set_x2apic_extra_bits(uv_hub_info->pnode);
+	uv_cpu_init();
 }
-
-
