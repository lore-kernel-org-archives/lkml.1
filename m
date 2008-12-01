Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYLAILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYLAILk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYLAILc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:11:32 -0500
Received: from ozlabs.org ([203.10.76.45]:40374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYLAILb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:11:31 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:41:27 +1030
Subject: [PATCH 1/2] cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: core
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Biederman <ebiederm@xmission.com>,
       James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011841.27839.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

In future, all cpumask ops will only be valid (in general) for bit
numbers < nr_cpu_ids.  So use that instead of NR_CPUS in iterators
and other comparisons.

This is always safe: no cpu number can be >= nr_cpu_ids, and
nr_cpu_ids is initialized to NR_CPUS at boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
---
 kernel/kexec.c               |    2 +-
 kernel/smp.c                 |    2 +-
 security/selinux/selinuxfs.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -r bb80787e9617 kernel/kexec.c
--- a/kernel/kexec.c	Fri Oct 24 00:27:01 2008 +1100
+++ b/kernel/kexec.c	Fri Oct 24 00:28:25 2008 +1100
@@ -1116,7 +1116,7 @@ void crash_save_cpu(struct pt_regs *regs
 	struct elf_prstatus prstatus;
 	u32 *buf;
 
-	if ((cpu < 0) || (cpu >= NR_CPUS))
+	if ((cpu < 0) || (cpu >= nr_cpu_ids))
 		return;
 
 	/* Using ELF notes here is opportunistic.
diff -r bb80787e9617 kernel/smp.c
--- a/kernel/smp.c	Fri Oct 24 00:27:01 2008 +1100
+++ b/kernel/smp.c	Fri Oct 24 00:28:25 2008 +1100
@@ -222,7 +222,7 @@ int smp_call_function_single(int cpu, vo
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
-	} else if ((unsigned)cpu < NR_CPUS && cpu_online(cpu)) {
+	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
 		struct call_single_data *data = NULL;
 
 		if (!wait) {
diff -r bb80787e9617 security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c	Fri Oct 24 00:27:01 2008 +1100
+++ b/security/selinux/selinuxfs.c	Fri Oct 24 00:28:25 2008 +1100
@@ -1206,7 +1206,7 @@ static struct avc_cache_stats *sel_avc_g
 {
 	int cpu;
 
-	for (cpu = *idx; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *idx; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*idx = cpu + 1;


