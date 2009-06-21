Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbZFUIUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbZFUIUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 04:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZFUIT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 04:19:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:51287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZFUITy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 04:19:54 -0400
Date: Sun, 21 Jun 2009 08:18:37 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090619085909.GJ5218@alberich.amd.com>
References: <20090619085909.GJ5218@alberich.amd.com>
Subject: [tip:x86/urgent] x86: Set cpu_llc_id on AMD CPUs
Message-ID: <tip-99bd0c0fc4b04da54cb311953ef9489931c19c63@git.kernel.org>
Git-Commit-ID: 99bd0c0fc4b04da54cb311953ef9489931c19c63
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 21 Jun 2009 08:18:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99bd0c0fc4b04da54cb311953ef9489931c19c63
Gitweb:     http://git.kernel.org/tip/99bd0c0fc4b04da54cb311953ef9489931c19c63
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 19 Jun 2009 10:59:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 21 Jun 2009 10:13:32 +0200

x86: Set cpu_llc_id on AMD CPUs

This counts when building sched domains in case NUMA information
is not available.

( See cpu_coregroup_mask() which uses llc_shared_map which in turn is
  created based on cpu_llc_id. )

Currently Linux builds domains as follows:
(example from a dual socket quad-core system)

 CPU0 attaching sched-domain:
  domain 0: span 0-7 level CPU
   groups: 0 1 2 3 4 5 6 7

  ...

 CPU7 attaching sched-domain:
  domain 0: span 0-7 level CPU
   groups: 7 0 1 2 3 4 5 6

Ever since that is borked for multi-core AMD CPU systems.
This patch fixes that and now we get a proper:

 CPU0 attaching sched-domain:
  domain 0: span 0-3 level MC
   groups: 0 1 2 3
   domain 1: span 0-7 level CPU
    groups: 0-3 4-7

  ...

 CPU7 attaching sched-domain:
  domain 0: span 4-7 level MC
   groups: 7 4 5 6
   domain 1: span 0-7 level CPU
    groups: 4-7 0-3

This allows scheduler to assign tasks to cores on different sockets
(i.e. that don't share last level cache) for performance reasons.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20090619085909.GJ5218@alberich.amd.com>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/amd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e5b27d8..28e5f59 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -258,13 +258,15 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits;
+	int cpu = smp_processor_id();
 
 	bits = c->x86_coreid_bits;
-
 	/* Low order bits define the core id (index of core in socket) */
 	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
 	/* Convert the initial APIC ID into the socket ID */
 	c->phys_proc_id = c->initial_apicid >> bits;
+	/* use socket ID also for last level cache */
+	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 #endif
 }
 
