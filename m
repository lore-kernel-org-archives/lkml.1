Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZIBOIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZIBOIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZIBOIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:08:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZIBOIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:08:40 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH v2 2/2] add sysctl for kvm wallclock sync
Date: Wed,  2 Sep 2009 10:34:58 -0400
Message-Id: <1251902098-8660-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1251902098-8660-2-git-send-email-glommer@redhat.com>
References: <1251902098-8660-1-git-send-email-glommer@redhat.com>
 <1251902098-8660-2-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new sysctl called kvm_sync_wallclock.

It controls the behaviour of the worker that updates guest wallclock time.
The worker will fire in periods specified by its value, if it is greater than zero,
and not fire at all otherwise.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    6 ++++++
 arch/x86/kernel/kvmclock.c      |   17 ++++++++++++++++-
 kernel/sysctl.c                 |   13 +++++++++++++
 3 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index b8a3305..3a3f38f 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -47,8 +47,14 @@ struct kvm_mmu_op_release_pt {
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
+#include <linux/sysctl.h>
 
 extern void kvmclock_init(void);
+extern unsigned int kvm_wall_update_interval;
+extern int kvm_sync_wall_handler(struct ctl_table *table, int write,
+                          struct file *filp, void __user *buffer,
+                          size_t *lenp, loff_t *ppos);
+
 
 
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 555aab0..d90976b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -27,7 +27,7 @@
 #define KVM_SCALE 22
 
 static int kvmclock = 1;
-static unsigned int kvm_wall_update_interval = 0;
+unsigned int kvm_wall_update_interval = 0;
 
 static int parse_no_kvmclock(char *arg)
 {
@@ -99,6 +99,21 @@ static __init int init_updates(void)
  */
 late_initcall(init_updates);
 
+int kvm_sync_wall_handler(struct ctl_table *table, int write,
+	                  struct file *filp, void __user *buffer,
+			  size_t *lenp, loff_t *ppos)
+{
+	int ret  = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	cancel_delayed_work_sync(&kvm_sync_wall_work);
+
+	schedule_next_update();
+	return 0;
+}
+
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
  * have elapsed since the hypervisor wrote the data. So we try to account for
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 98e0232..b787c81 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -51,6 +51,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_counter.h>
+#include <linux/kvm_para.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -989,6 +990,18 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KVM_CLOCK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kvm_sync_wallclock",
+		.data		= &kvm_wall_update_interval,
+		.maxlen		= sizeof(kvm_wall_update_interval),
+		.mode		= 0644,
+		.proc_handler	= &kvm_sync_wall_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+#endif
 
 /*
  * NOTE: do not add new entries to this table unless you have read
-- 
1.6.2.2

