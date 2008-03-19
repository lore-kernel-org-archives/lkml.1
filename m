Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbYCSUXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbYCSUXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYCSTj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269AbYCSTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:04 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 61/79] [PATCH] move {un}map_cpu_to_logical_apicid to smpboot.c
Date: Wed, 19 Mar 2008 14:25:56 -0300
Message-Id: <1205947850822-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478452071-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Move map_cpu_to_logical_apicid() and unmap_cpu_to_logical_apicid()
to smpboot.c. They take together all the bunch of static functions
they rely upon

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   60 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   59 +---------------------------------------
 2 files changed, 62 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 253be86..5bff87e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -50,6 +50,66 @@ static cpumask_t cpu_sibling_setup_map;
 /* Set if we find a B stepping CPU */
 int __cpuinitdata smp_b_stepping;
 
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
+
+/* which logical CPUs are on which nodes */
+cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly =
+				{ [0 ... MAX_NUMNODES-1] = CPU_MASK_NONE };
+EXPORT_SYMBOL(node_to_cpumask_map);
+/* which node each logical CPU is on */
+int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };
+EXPORT_SYMBOL(cpu_to_node_map);
+
+/* set up a mapping between cpu and node. */
+static void map_cpu_to_node(int cpu, int node)
+{
+	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
+	cpu_set(cpu, node_to_cpumask_map[node]);
+	cpu_to_node_map[cpu] = node;
+}
+
+/* undo a mapping between cpu and node. */
+static void unmap_cpu_to_node(int cpu)
+{
+	int node;
+
+	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
+	for (node = 0; node < MAX_NUMNODES; node++)
+		cpu_clear(cpu, node_to_cpumask_map[node]);
+	cpu_to_node_map[cpu] = 0;
+}
+#else /* !(CONFIG_NUMA && CONFIG_X86_32) */
+#define map_cpu_to_node(cpu, node)	({})
+#define unmap_cpu_to_node(cpu)	({})
+#endif
+
+#ifdef CONFIG_X86_32
+u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
+					{ [0 ... NR_CPUS-1] = BAD_APICID };
+
+void map_cpu_to_logical_apicid(void)
+{
+	int cpu = smp_processor_id();
+	int apicid = logical_smp_processor_id();
+	int node = apicid_to_node(apicid);
+
+	if (!node_online(node))
+		node = first_online_node;
+
+	cpu_2_logical_apicid[cpu] = apicid;
+	map_cpu_to_node(cpu, node);
+}
+
+void unmap_cpu_to_logical_apicid(int cpu)
+{
+	cpu_2_logical_apicid[cpu] = BAD_APICID;
+	unmap_cpu_to_node(cpu);
+}
+#else
+#define unmap_cpu_to_logical_apicid(cpu) do {} while (0)
+#define map_cpu_to_logical_apicid()  do {} while (0)
+#endif
+
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 33758a2..1eb7b73 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -74,7 +74,8 @@ EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-static void map_cpu_to_logical_apicid(void);
+extern void map_cpu_to_logical_apicid(void);
+extern void unmap_cpu_to_logical_apicid(int cpu);
 
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
@@ -262,62 +263,6 @@ extern struct {
 	unsigned short ss;
 } stack_start;
 
-#ifdef CONFIG_NUMA
-
-/* which logical CPUs are on which nodes */
-cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly =
-				{ [0 ... MAX_NUMNODES-1] = CPU_MASK_NONE };
-EXPORT_SYMBOL(node_to_cpumask_map);
-/* which node each logical CPU is on */
-int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };
-EXPORT_SYMBOL(cpu_to_node_map);
-
-/* set up a mapping between cpu and node. */
-static inline void map_cpu_to_node(int cpu, int node)
-{
-	printk("Mapping cpu %d to node %d\n", cpu, node);
-	cpu_set(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = node;
-}
-
-/* undo a mapping between cpu and node. */
-static inline void unmap_cpu_to_node(int cpu)
-{
-	int node;
-
-	printk("Unmapping cpu %d from all nodes\n", cpu);
-	for (node = 0; node < MAX_NUMNODES; node ++)
-		cpu_clear(cpu, node_to_cpumask_map[node]);
-	cpu_to_node_map[cpu] = 0;
-}
-#else /* !CONFIG_NUMA */
-
-#define map_cpu_to_node(cpu, node)	({})
-#define unmap_cpu_to_node(cpu)	({})
-
-#endif /* CONFIG_NUMA */
-
-u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = BAD_APICID };
-
-static void map_cpu_to_logical_apicid(void)
-{
-	int cpu = smp_processor_id();
-	int apicid = logical_smp_processor_id();
-	int node = apicid_to_node(apicid);
-
-	if (!node_online(node))
-		node = first_online_node;
-
-	cpu_2_logical_apicid[cpu] = apicid;
-	map_cpu_to_node(cpu, node);
-}
-
-static void unmap_cpu_to_logical_apicid(int cpu)
-{
-	cpu_2_logical_apicid[cpu] = BAD_APICID;
-	unmap_cpu_to_node(cpu);
-}
-
 static inline void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-- 
1.5.0.6

