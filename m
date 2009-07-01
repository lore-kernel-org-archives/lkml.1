Return-Path: <linux-kernel-owner+w=401wt.eu-S1762531AbZGAAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762531AbZGAAoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbZGAAc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:59 -0400
Received: from kroah.org ([198.145.64.141]:59854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760974AbZGAAc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:52 2009
Message-Id: <20090701001552.431397625@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 24/35] x86: Set cpu_llc_id on AMD CPUs
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=x86-set-cpu_llc_id-on-amd-cpus.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 99bd0c0fc4b04da54cb311953ef9489931c19c63 upstream.

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
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -207,13 +207,15 @@ static void __cpuinit amd_detect_cmp(str
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
 


