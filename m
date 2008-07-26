Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYGZCjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYGZCjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 22:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYGZCjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 22:39:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7662 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYGZCjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 22:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=L/mT2jVxPGwNIgshwBqDQfb/9OzDBg3+sLJANjwRLnofExz0HqzGPnIj0W2A1Vx023
         zQS886e3KBD5mSdLsk6C8gC/gumV+grK5h2+fvCzcnV9jN2WHR5I4MMZWd7Ghc1uv8Ne
         ewbQa7HCsnyO08346WcOEzWHPGtjY0ys7pVY4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: add apic probe for genapic 64bit - fix
Date: Fri, 25 Jul 2008 19:39:03 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807211836.27282.yhlu.kernel@gmail.com> <200807212208.22116.yhlu.kernel@gmail.com>
In-Reply-To: <200807212208.22116.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807251939.04199.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


intr_remapping_enabled get assigned later, so need to check that
in setup_apic_routing

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/genapic_64.c        |    6 ++++++
 arch/x86/kernel/genx2apic_cluster.c |    2 +-
 arch/x86/kernel/genx2apic_phys.c    |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -16,6 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/hardirq.h>
+#include <linux/dmar.h>
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
@@ -42,6 +43,11 @@ static struct genapic *apic_probe[] __in
  */
 void __init setup_apic_routing(void)
 {
+	if (genapic == &apic_x2apic_phys || genapic == &apic_x2apic_cluster) {
+		if (!intr_remapping_enabled)
+			genapic = &apic_flat;
+	}
+
 	if (genapic == &apic_flat) {
 		if (max_physical_apicid >= 8)
 			genapic = &apic_physflat;
Index: linux-2.6/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/genx2apic_cluster.c
@@ -14,7 +14,7 @@ DEFINE_PER_CPU(u32, x86_cpu_to_logical_a
 
 static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (cpu_has_x2apic && intr_remapping_enabled)
+	if (cpu_has_x2apic)
 		return 1;
 
 	return 0;
Index: linux-2.6/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6/arch/x86/kernel/genx2apic_phys.c
@@ -21,7 +21,7 @@ early_param("x2apic_phys", set_x2apic_ph
 
 static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (cpu_has_x2apic && intr_remapping_enabled && x2apic_phys)
+	if (cpu_has_x2apic && x2apic_phys)
 		return 1;
 
 	return 0;
