Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbZBESnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbZBESnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZBESmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:42:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35671 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZBESmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:42:36 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       akataria@vmware.com, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 1/2] show hypervisor information on cpuinfo
Date: Thu,  5 Feb 2009 13:42:20 -0500
Message-Id: <1233859341-10419-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1233859341-10419-1-git-send-email-glommer@redhat.com>
References: <1233859341-10419-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

It is useful to easily grab information about whether or not
we're running on top of a hypervisor. And in case affirmative,
which one.

This patch shows it in a newly added "hypervisor" field to cpuinfo.
This seems to me like the best suited place for this.

We currently differentiate between vmware and none.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c  |    8 ++++++++
 arch/x86/kernel/cpu/proc.c        |    8 ++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 369f5c5..a0c0b0f 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -22,5 +22,6 @@
 
 extern unsigned long get_hypervisor_tsc_freq(void);
 extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern char *hypervisor_str(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index fb5b86a..8c3fca7 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -51,6 +51,14 @@ hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
 	}
 }
 
+char * __cpuinit hypervisor_str(struct cpuinfo_x86 *c)
+{
+	if (c->x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
+		return "VMWare";
+	else
+		return "none";
+}
+
 void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
 {
 	detect_hypervisor_vendor(c);
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 01b1244..3700607 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -4,6 +4,8 @@
 #include <linux/seq_file.h>
 #include <linux/cpufreq.h>
 
+#include <asm/hypervisor.h>
+
 /*
  *	Get CPU information for use by the procfs.
  */
@@ -90,12 +92,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   "vendor_id\t: %s\n"
 		   "cpu family\t: %d\n"
 		   "model\t\t: %u\n"
-		   "model name\t: %s\n",
+		   "model name\t: %s\n"
+		   "hypervisor\t: %s\n",
 		   cpu,
 		   c->x86_vendor_id[0] ? c->x86_vendor_id : "unknown",
 		   c->x86,
 		   c->x86_model,
-		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
+		   c->x86_model_id[0] ? c->x86_model_id : "unknown",
+		   hypervisor_str(c));
 
 	if (c->x86_mask || c->cpuid_level >= 0)
 		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
-- 
1.5.6.5

