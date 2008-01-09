Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYAIUnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYAIUnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYAIUm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:42:59 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:47337 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYAIUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:42:58 -0500
Subject: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20080108033329.GI2998@bingen.suse.de>
References: <1199759244.26343.35.camel@localhost.localdomain>
	 <20080108033329.GI2998@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 15:42:10 -0500
Message-Id: <1199911330.975.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is different than the first patch I sent out.
This one just sends an IPI to all CPUS that don't check in after 1 sec.


Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
already in idle, have no tasks waiting to run and have no interrupts
going to them.  This is common on bootup when switching cpu idle
governors.

This patch gives those CPUS that don't check in an IPI kick.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/process_32.c |   11 +++++++++++
 arch/x86/kernel/process_64.c |   11 +++++++++++
 2 files changed, 22 insertions(+)

Index: linux-compile-i386.git/arch/x86/kernel/process_32.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/process_32.c	2008-01-09 14:09:36.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/process_32.c	2008-01-09 14:09:45.000000000 -0500
@@ -204,6 +204,10 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -228,6 +232,13 @@ void cpu_idle_wait(void)
 				cpu_clear(cpu, map);
 		}
 		cpus_and(map, map, cpu_online_map);
+		/*
+		 * We waited 1 sec, if a CPU still did not call idle
+		 * it may be because it is in idle and not waking up
+		 * because it has nothing to do.
+		 * Give all the remaining CPUS a kick.
+		 */
+		smp_call_function_mask(map, do_nothing, 0, 0);
 	} while (!cpus_empty(map));
 
 	set_cpus_allowed(current, tmp);
Index: linux-compile-i386.git/arch/x86/kernel/process_64.c
===================================================================
--- linux-compile-i386.git.orig/arch/x86/kernel/process_64.c	2008-01-09 14:09:36.000000000 -0500
+++ linux-compile-i386.git/arch/x86/kernel/process_64.c	2008-01-09 15:17:20.000000000 -0500
@@ -135,6 +135,10 @@ static void poll_idle (void)
 	cpu_relax();
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -160,6 +164,13 @@ void cpu_idle_wait(void)
 				cpu_clear(cpu, map);
 		}
 		cpus_and(map, map, cpu_online_map);
+		/*
+		 * We waited 1 sec, if a CPU still did not call idle
+		 * it may be because it is in idle and not waking up
+		 * because it has nothing to do.
+		 * Give all the remaining CPUS a kick.
+		 */
+		smp_call_function_mask(map, do_nothing, 0, 0);
 	} while (!cpus_empty(map));
 
 	set_cpus_allowed(current, tmp);


