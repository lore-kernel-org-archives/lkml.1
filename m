Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbXJUBwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbXJUBwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXJUBwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:10 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3759 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXJUBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:08 -0400
Date: Sat, 20 Oct 2007 14:41:18 -0500 (CDT)
From: "Milton D. Miller II" <miltonm@realtime.net>
Message-Id: <200710201941.l9KJfIGL008482@sullivan.realtime.net>
Subject: [PATCH] Fix sched_domain sysctl registration again
To: Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit  029190c515f15f512ac85de8fc686d4dbd0ae731 (cpuset
sched_load_balance flag) was not tested SCHED_DEBUG enabled as
committed as it dereferences NULL when used and it reordered
the sysctl registration to cause it to never show any domains
or their tunables.

Fixes:

1) restore arch_init_sched_domains ordering
	we can't walk the domains before we build them

	presently we register cpus with empty directories (no domain
	directories or files).

2) make unregister_sched_domain_sysctl do nothing when already unregistered
	detach_destroy_domains is now called one set of cpus at a time
	unregister_syctl dereferences NULL if called with a null.

	While the the function would always dereference null if called
	twice, in the previous code it was always called once and then
	was followed a register.  So only the hidden bug of the
	sysctl_root_table not being allocated followed by an attempt to
	free it would have shown the error.

3) always call unregister and register in partition_sched_domains
	The code is "smart" about unregistering only needed domains.
	Since we aren't guaranteed any calls to unregister, always 
	unregister.   Without calling register on the way out we
	will not have a table or any sysctl tree.

4) warn if register is called without unregistering
	The previous table memory is lost, leaving pointers to the
	later freed memory in sysctl and leaking the memory of the
	tables.


Signed-off-by: Milton Miller <miltonm@bga.com>
--- 
against e8b8c977734193adedf2b0f607d6252c78e86394

Before this patch on a 2-core 4-thread box compiled for SMT and NUMA,
the domains appear empty (there are actually 3 levels per cpu).  And as
soon as two domains a null pointer is dereferenced (unreliable in this
case is stack garbage):

bu19a:~# ls -R /proc/sys/kernel/sched_domain/
/proc/sys/kernel/sched_domain/:
cpu0  cpu1  cpu2  cpu3

/proc/sys/kernel/sched_domain/cpu0:

/proc/sys/kernel/sched_domain/cpu1:

/proc/sys/kernel/sched_domain/cpu2:

/proc/sys/kernel/sched_domain/cpu3:

bu19a:~# mkdir /dev/cpuset
bu19a:~# mount -tcpuset cpuset /dev/cpuset/
bu19a:~# cd /dev/cpuset/
bu19a:/dev/cpuset# echo 0 > sched_load_balance 
bu19a:/dev/cpuset# mkdir one
bu19a:/dev/cpuset# echo 1 > one/cpus               
bu19a:/dev/cpuset# echo 0 > one/sched_load_balance 
Unable to handle kernel paging request for data at address 0x00000018
Faulting instruction address: 0xc00000000006b608
NIP: c00000000006b608 LR: c00000000006b604 CTR: 0000000000000000
REGS: c000000018d973f0 TRAP: 0300   Not tainted  (2.6.23-bml)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 28242442  XER: 00000000
DAR: 0000000000000018, DSISR: 0000000040000000
TASK = c00000001912e340[1987] 'bash' THREAD: c000000018d94000 CPU: 2
..
NIP [c00000000006b608] .unregister_sysctl_table+0x38/0x110
LR [c00000000006b604] .unregister_sysctl_table+0x34/0x110
Call Trace:
[c000000018d97670] [c000000007017270] 0xc000000007017270 (unreliable)
[c000000018d97720] [c000000000058710] .detach_destroy_domains+0x30/0xb0
[c000000018d977b0] [c00000000005cf1c] .partition_sched_domains+0x1bc/0x230
[c000000018d97870] [c00000000009fdc4] .rebuild_sched_domains+0xb4/0x4c0
[c000000018d97970] [c0000000000a02e8] .update_flag+0x118/0x170
[c000000018d97a80] [c0000000000a1768] .cpuset_common_file_write+0x568/0x820
[c000000018d97c00] [c00000000009d95c] .cgroup_file_write+0x7c/0x180
[c000000018d97cf0] [c0000000000e76b8] .vfs_write+0xe8/0x1b0
[c000000018d97d90] [c0000000000e810c] .sys_write+0x4c/0x90
[c000000018d97e30] [c00000000000852c] syscall_exit+0x0/0x40



diff --git a/kernel/sched.c b/kernel/sched.c
index afe76ec..2af50ec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5463,11 +5463,12 @@ static void register_sched_domain_sysctl(void)
 	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
 	char buf[32];
 
+	WARN_ON(sd_ctl_dir[0].child);
+	sd_ctl_dir[0].child = entry;
+
 	if (entry == NULL)
 		return;
 
-	sd_ctl_dir[0].child = entry;
-
 	for_each_online_cpu(i) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
@@ -5475,14 +5476,19 @@ static void register_sched_domain_sysctl(void)
 		entry->child = sd_alloc_ctl_cpu_table(i);
 		entry++;
 	}
+
+	WARN_ON(sd_sysctl_header);
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
 
+/* may be called multiple times per register */
 static void unregister_sched_domain_sysctl(void)
 {
-	unregister_sysctl_table(sd_sysctl_header);
+	if (sd_sysctl_header)
+		unregister_sysctl_table(sd_sysctl_header);
 	sd_sysctl_header = NULL;
-	sd_free_ctl_entry(&sd_ctl_dir[0].child);
+	if (sd_ctl_dir[0].child)
+		sd_free_ctl_entry(&sd_ctl_dir[0].child);
 }
 #else
 static void register_sched_domain_sysctl(void)
@@ -6426,13 +6432,17 @@ static cpumask_t fallback_doms;
  */
 static int arch_init_sched_domains(const cpumask_t *cpu_map)
 {
+	int err;
+
 	ndoms_cur = 1;
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
 	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
-	return build_sched_domains(doms_cur);
+
+	return err;
 }
 
 static void arch_destroy_sched_domains(const cpumask_t *cpu_map)
@@ -6481,6 +6491,9 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)
 {
 	int i, j;
 
+	/* always unregister in case we don't destroy any domains */
+	unregister_sched_domain_sysctl();
+
 	if (doms_new == NULL) {
 		ndoms_new = 1;
 		doms_new = &fallback_doms;
@@ -6516,6 +6529,8 @@ match2:
 		kfree(doms_cur);
 	doms_cur = doms_new;
 	ndoms_cur = ndoms_new;
+
+	register_sched_domain_sysctl();
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
