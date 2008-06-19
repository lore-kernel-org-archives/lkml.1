Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbYFSAas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbYFSAas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbYFSAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:30:15 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:61719 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbYFSAaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:30:12 -0400
From: Nathan Lynch <ntl@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>
Subject: [RFC/PATCH 1/3] sched: support arch override of sched_group cpu power
Date: Wed, 18 Jun 2008 19:29:32 -0500
Message-Id: <1213835374-10868-2-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1213835374-10868-1-git-send-email-ntl@pobox.com>
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
X-Pobox-Relay-ID: E06D66E8-3D96-11DD-8BD8-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new sched domain flag, SD_ASYM_CPU_POWER, which signifies that
the architecture may override the cpu power for a cpu via a hook in
init_sched_groups_power().  Add a dummy definition of arch_cpu_power()
which conforms with the existing behavior.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..cfbefca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -713,6 +713,7 @@ enum cpu_idle_type {
 #define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
 #define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
+#define SD_ASYM_CPU_POWER	4096	/* Domain members of unequal power */
 
 #define BALANCE_FOR_MC_POWER	\
 	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..3fba083 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6761,6 +6761,13 @@ static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 }
 #endif
 
+#ifndef arch_cpu_power
+static inline unsigned int arch_cpu_power(int cpu, unsigned int default_power)
+{
+	return default_power;
+}
+#endif
+
 /*
  * Initialize sched groups cpu_power.
  *
@@ -6789,6 +6796,13 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	sd->groups->__cpu_power = 0;
 
+	if (!child && (sd->flags & SD_ASYM_CPU_POWER)) {
+		unsigned int power = arch_cpu_power(cpu, SCHED_LOAD_SCALE);
+
+		sg_inc_cpu_power(sd->groups, power);
+		return;
+	}
+
 	/*
 	 * For perf policy, if the groups in child domain share resources
 	 * (for example cores sharing some portions of the cache hierarchy
-- 
1.5.5

