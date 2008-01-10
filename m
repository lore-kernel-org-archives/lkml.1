Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYAJAbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYAJAbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYAJAa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:30:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:60354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYAJAa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:30:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,264,1196668800"; 
   d="scan'208";a="363019828"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
Date: Wed, 9 Jan 2008 16:12:23 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE554130@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1199911330.975.3.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
Thread-Index: AchTAMulN41K/Qv0Qn6o6r2yA3G1fgAGog+A
References: <1199759244.26343.35.camel@localhost.localdomain> <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, "Adam Belay" <abelay@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 10 Jan 2008 00:11:33.0625 (UTC) FILETIME=[5B9D4690:01C8531D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Steven Rostedt [mailto:rostedt@goodmis.org] 
>Sent: Wednesday, January 09, 2008 12:42 PM
>To: LKML
>Cc: Linus Torvalds; Andrew Morton; Ingo Molnar; Thomas 
>Gleixner; Brown, Len; Pallipadi, Venkatesh; Adam Belay; Peter 
>Zijlstra; Andi Kleen
>Subject: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
>
>This patch is different than the first patch I sent out.
>This one just sends an IPI to all CPUS that don't check in after 1 sec.
>
>
>Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
>already in idle, have no tasks waiting to run and have no interrupts
>going to them.  This is common on bootup when switching cpu idle
>governors.
>
>This patch gives those CPUS that don't check in an IPI kick.
>

I think your RFC patch is the right solution here. As I see it, there is
no race with your RFC patch.
As long as you call a dummy smp_call_function on all CPUs, we should be
OK. We can get rid of cpu_idle_state
and the current wait forever logic altogether with dummy
smp_call_function. And so there wont be any wait forever scenario.

The whole point of cpu_idle_wait() is to make all CPUs come out of idle
loop atleast once.
The caller will use cpu_idle_wait something like this.

// Want to change idle handler
- Switch global idle handler to always present default_idle
- call cpu_idle_wait so that all cpus come out of idle for an instant
and stop using old idle pointer and start using default idle
- Change the idle handler to a new handler
- optional cpu_idle_wait if you want all cpus to start using the new
handler immediately.

May be the below 1s patch is safe bet for .24. But for .25, I would say
we just replace all complicated logic by simple dummy smp_call_function
and remove cpu_idle_state altogether.

Thanks,
Venki

>Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>---
> arch/x86/kernel/process_32.c |   11 +++++++++++
> arch/x86/kernel/process_64.c |   11 +++++++++++
> 2 files changed, 22 insertions(+)
>
>Index: linux-compile-i386.git/arch/x86/kernel/process_32.c
>===================================================================
>--- linux-compile-i386.git.orig/arch/x86/kernel/process_32.c	
>2008-01-09 14:09:36.000000000 -0500
>+++ linux-compile-i386.git/arch/x86/kernel/process_32.c	
>2008-01-09 14:09:45.000000000 -0500
>@@ -204,6 +204,10 @@ void cpu_idle(void)
> 	}
> }
> 
>+static void do_nothing(void *unused)
>+{
>+}
>+
> void cpu_idle_wait(void)
> {
> 	unsigned int cpu, this_cpu = get_cpu();
>@@ -228,6 +232,13 @@ void cpu_idle_wait(void)
> 				cpu_clear(cpu, map);
> 		}
> 		cpus_and(map, map, cpu_online_map);
>+		/*
>+		 * We waited 1 sec, if a CPU still did not call idle
>+		 * it may be because it is in idle and not waking up
>+		 * because it has nothing to do.
>+		 * Give all the remaining CPUS a kick.
>+		 */
>+		smp_call_function_mask(map, do_nothing, 0, 0);
> 	} while (!cpus_empty(map));
> 
> 	set_cpus_allowed(current, tmp);
>Index: linux-compile-i386.git/arch/x86/kernel/process_64.c
>===================================================================
>--- linux-compile-i386.git.orig/arch/x86/kernel/process_64.c	
>2008-01-09 14:09:36.000000000 -0500
>+++ linux-compile-i386.git/arch/x86/kernel/process_64.c	
>2008-01-09 15:17:20.000000000 -0500
>@@ -135,6 +135,10 @@ static void poll_idle (void)
> 	cpu_relax();
> }
> 
>+static void do_nothing(void *unused)
>+{
>+}
>+
> void cpu_idle_wait(void)
> {
> 	unsigned int cpu, this_cpu = get_cpu();
>@@ -160,6 +164,13 @@ void cpu_idle_wait(void)
> 				cpu_clear(cpu, map);
> 		}
> 		cpus_and(map, map, cpu_online_map);
>+		/*
>+		 * We waited 1 sec, if a CPU still did not call idle
>+		 * it may be because it is in idle and not waking up
>+		 * because it has nothing to do.
>+		 * Give all the remaining CPUS a kick.
>+		 */
>+		smp_call_function_mask(map, do_nothing, 0, 0);
> 	} while (!cpus_empty(map));
> 
> 	set_cpus_allowed(current, tmp);
>
>
>
