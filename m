Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbZDQOwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbZDQOwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbZDQOv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:51:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:40397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761940AbZDQOvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:51:25 -0400
Date: Fri, 17 Apr 2009 14:50:01 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090417142447.GA23759@sgi.com>
References: <20090417142447.GA23759@sgi.com>
Subject: [tip:x86/urgent] x86/uv: fix init of cpu-less nodes
Message-ID: <tip-1466083f6cce2aff147b4ebeab33ab20f661906d@git.kernel.org>
Git-Commit-ID: 1466083f6cce2aff147b4ebeab33ab20f661906d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 14:50:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1466083f6cce2aff147b4ebeab33ab20f661906d
Gitweb:     http://git.kernel.org/tip/1466083f6cce2aff147b4ebeab33ab20f661906d
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Fri, 17 Apr 2009 09:24:47 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 16:45:29 +0200

x86/uv: fix init of cpu-less nodes

Fix an endcase in the UV initialization code for the "UV large system mode"
of apicids.  If node zero contains no cpus, cpus on another node will be the
boot cpu.  The percpu data that contains the extra apicid bits was not
being initialized early enough.

[ Impact: fix potential boot crash on cpu-less UV nodes ]

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090417142447.GA23759@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1248318..49d2f5c 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
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
@@ -42,6 +54,8 @@ static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		else if (!strcmp(oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
+			__get_cpu_var(x2apic_extra_bits) =
+				early_get_nodeid() << (UV_APIC_PNODE_SHIFT - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
