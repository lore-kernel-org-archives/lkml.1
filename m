Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbZDQOY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbZDQOY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbZDQOYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:24:49 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34867 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbZDQOYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:24:49 -0400
Date: Fri, 17 Apr 2009 09:24:47 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 - UV Nodes without cpus
Message-ID: <20090417142447.GA23759@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an endcase in the UV initialization code for the "UV large system mode"
of apicids.  If node zero contains no cpus, cpus on another node will be the
boot cpu. The percpu data that contains the extra apicid bits was not
being initialized early enough.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-04-13 11:21:41.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-04-13 11:22:12.000000000 -0500
@@ -19,6 +19,7 @@
 #include <linux/timer.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
+#include <linux/io.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -34,6 +35,17 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 
+static int early_get_nodeid(void)
+{
+	union uvh_node_id_u node_id;
+	unsigned long *mmr;
+
+	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
+	node_id.v = *mmr;
+	early_iounmap(mmr, sizeof(*mmr));
+	return node_id.s.node_id;
+}
+
 static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
@@ -42,6 +54,8 @@ static int uv_acpi_madt_oem_check(char *
 		else if (!strcmp(oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
+			__get_cpu_var(x2apic_extra_bits) =
+				early_get_nodeid() << (UV_APIC_PNODE_SHIFT - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
