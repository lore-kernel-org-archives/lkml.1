Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYFSAbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYFSAbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbYFSAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:30:25 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:38078 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbYFSAaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:30:23 -0400
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>
Subject: [RFC/PATCH 2/3] add cpu_power to machdep_calls, override
 SD_SIBLING_INIT
Date: Wed, 18 Jun 2008 19:29:33 -0500
Message-Id: <1213835374-10868-3-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1213835374-10868-1-git-send-email-ntl@pobox.com>
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: E5E91EB4-3D96-11DD-BF0E-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a cpu_power() call to machdep_calls, which will allow platforms to
override the scheduler's default cpu power calculation.  If the
platform does not provide a cpu_power() method, the scheduler's
default value is used.

Copy the default SD_SIBLING_INIT to powerpc's topology.h and add the
SD_ASYM_CPU_POWER flag, which will cause ppc_md.cpu_power() to be
invoked (via arch_cpu_power()) during sched domain initialization.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 arch/powerpc/kernel/setup-common.c |    7 +++++++
 include/asm-powerpc/machdep.h      |    2 ++
 include/asm-powerpc/topology.h     |   31 +++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index db540ea..609d09e 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -671,3 +671,10 @@ static int powerpc_debugfs_init(void)
 }
 arch_initcall(powerpc_debugfs_init);
 #endif
+
+unsigned int arch_cpu_power(int cpu, unsigned int default_power)
+{
+	if (ppc_md.cpu_power)
+		return ppc_md.cpu_power(cpu, default_power);
+	return default_power;
+}
diff --git a/include/asm-powerpc/machdep.h b/include/asm-powerpc/machdep.h
index 54ed64d..de6ff6b 100644
--- a/include/asm-powerpc/machdep.h
+++ b/include/asm-powerpc/machdep.h
@@ -260,6 +260,8 @@ struct machdep_calls {
 	void (*suspend_disable_irqs)(void);
 	void (*suspend_enable_irqs)(void);
 #endif
+	/* Override scheduler's cpu power calculation */
+	unsigned int (*cpu_power)(int cpu, unsigned int default_power);
 };
 
 extern void power4_idle(void);
diff --git a/include/asm-powerpc/topology.h b/include/asm-powerpc/topology.h
index 100c6fb..4335c15 100644
--- a/include/asm-powerpc/topology.h
+++ b/include/asm-powerpc/topology.h
@@ -72,6 +72,37 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 	.nr_balance_failed	= 0,			\
 }
 
+#define SD_SIBLING_INIT (struct sched_domain) {		\
+	.span			= CPU_MASK_NONE,	\
+	.parent			= NULL,			\
+	.child			= NULL,			\
+	.groups			= NULL,			\
+	.min_interval		= 1,			\
+	.max_interval		= 2,			\
+	.busy_factor		= 64,			\
+	.imbalance_pct		= 110,			\
+	.cache_nice_tries	= 0,			\
+	.busy_idx		= 0,			\
+	.idle_idx		= 0,			\
+	.newidle_idx		= 0,			\
+	.wake_idx		= 0,			\
+	.forkexec_idx		= 0,			\
+	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_NEWIDLE	\
+				| SD_BALANCE_FORK	\
+				| SD_BALANCE_EXEC	\
+				| SD_WAKE_AFFINE	\
+				| SD_WAKE_IDLE		\
+				| SD_SHARE_CPUPOWER	\
+				| SD_ASYM_CPU_POWER,	\
+	.last_balance		= jiffies,		\
+	.balance_interval	= 1,			\
+	.nr_balance_failed	= 0,			\
+}
+
+#define arch_cpu_power(cpu, power) arch_cpu_power(cpu, power)
+extern unsigned int arch_cpu_power(int cpu, unsigned int default_power);
+
 extern void __init dump_numa_cpu_topology(void);
 
 extern int sysfs_add_device_to_node(struct sys_device *dev, int nid);
-- 
1.5.5

