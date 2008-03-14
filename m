Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYCNAVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYCNAVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYCNAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:20:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:12517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYCNAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:20:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,497,1199692800"; 
   d="scan'208";a="306082853"
Date: Thu, 13 Mar 2008 17:18:19 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ACPI lockdep warning on boot, 2.6.25-rc5
Message-ID: <20080314001819.GA32584@linux-os.sc.intel.com>
References: <E1JZOGd-00057d-BU@pomaz-ex.szeredi.hu> <200803122301.17356.rjw@sisk.pl> <200803131614.33386.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803131614.33386.lenb@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 04:14:32PM -0400, Len Brown wrote:
> On Wednesday 12 March 2008, Rafael J. Wysocki wrote:
> > On Wednesday, 12 of March 2008, Miklos Szeredi wrote:
> > > I don't know whether this is a problem in reality or not, but it does
> > > interfere with debugging the rest of the kernel, since this turns off
> > > lockdep at boottime.
> > 
> > Well, I think Venki should see it (CCed).
> > 
> > Thanks,
> > Rafael
> > 
> >  
> > > [    0.592488] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > > [    0.593038] ------------[ cut here ]------------
> > > [    0.593267] WARNING: at kernel/lockdep.c:2035 trace_hardirqs_on+0xa0/0x115()
> > > [    0.593596] Modules linked in:
> > > [    0.593756] Pid: 0, comm: swapper Not tainted 2.6.25-rc5 #8
> > > [    0.594017] 
> > > [    0.594017] Call Trace:
> > > [    0.594216]  [<ffffffff80231663>] warn_on_slowpath+0x58/0x6b
> > > [    0.594495]  [<ffffffff80495966>] ? _spin_unlock_irqrestore+0x38/0x47
> > > [    0.594809]  [<ffffffff80329a86>] ? acpi_os_release_lock+0x9/0xb
> > > [    0.595103]  [<ffffffff80337840>] ? acpi_set_register+0x161/0x173
> > > [    0.595401]  [<ffffffff8034c8d4>] ? acpi_processor_idle+0x1de/0x546
> > > [    0.595706]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > > [    0.595970]  [<ffffffff8024fc0e>] trace_hardirqs_on+0xa0/0x115
> > > [    0.596049]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
> > > [    0.596346]  [<ffffffff8034c8d4>] acpi_processor_idle+0x1de/0x546
> > > [    0.596642]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > > [    0.596912]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
> > > [    0.597209]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > > [    0.597472]  [<ffffffff8020a355>] cpu_idle+0xa7/0xd1
> > > [    0.597717]  [<ffffffff80485fa1>] rest_init+0x55/0x57
> > > [    0.597957]  [<ffffffff8062fb49>] start_kernel+0x29d/0x2a8
> > > [    0.598215]  [<ffffffff8062f1da>] _sinittext+0x1da/0x1e1
> > > [    0.598464] 
> > > [    0.598546] ---[ end trace 778e504de7e3b1e3 ]---
> 
> Venki,
> 
> this reproduces in my t61 using Miklos' config (though i had to increase
> the logbuff to catch it)
> 
> -Len

Below patch should fix this warning. I would say warning is pretty harmless.. 

Thanks,
Venki

---

This avoids the harmless WARNING by lockdep in acpi_processor_idle().

The reason for WARNING is because at the depth of idle handling code,
some of the idle handlers disable interrupts, some times, while returning from
the idle handler. After return, acpi_processor_idle and few other routines
in the file did an unconditional local_irq_enable(). With LOCKDEP, enabling
irq when it is alread enabled generates the below WARNING.

> > [    0.593038] ------------[ cut here ]------------
> > [    0.593267] WARNING: at kernel/lockdep.c:2035 trace_hardirqs_on+0xa0/0x115()
> > [    0.593596] Modules linked in:
> > [    0.593756] Pid: 0, comm: swapper Not tainted 2.6.25-rc5 #8
> > [    0.594017] 
> > [    0.594017] Call Trace:
> > [    0.594216]  [<ffffffff80231663>] warn_on_slowpath+0x58/0x6b
> > [    0.594495]  [<ffffffff80495966>] ? _spin_unlock_irqrestore+0x38/0x47
> > [    0.594809]  [<ffffffff80329a86>] ? acpi_os_release_lock+0x9/0xb
> > [    0.595103]  [<ffffffff80337840>] ? acpi_set_register+0x161/0x173
> > [    0.595401]  [<ffffffff8034c8d4>] ? acpi_processor_idle+0x1de/0x546
> > [    0.595706]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > [    0.595970]  [<ffffffff8024fc0e>] trace_hardirqs_on+0xa0/0x115
> > [    0.596049]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
> > [    0.596346]  [<ffffffff8034c8d4>] acpi_processor_idle+0x1de/0x546
> > [    0.596642]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > [    0.596912]  [<ffffffff8034c6f6>] ? acpi_processor_idle+0x0/0x546
> > [    0.597209]  [<ffffffff8020a23b>] ? default_idle+0x0/0x73
> > [    0.597472]  [<ffffffff8020a355>] cpu_idle+0xa7/0xd1
> > [    0.597717]  [<ffffffff80485fa1>] rest_init+0x55/0x57
> > [    0.597957]  [<ffffffff8062fb49>] start_kernel+0x29d/0x2a8
> > [    0.598215]  [<ffffffff8062f1da>] _sinittext+0x1da/0x1e1
> > [    0.598464] 
> > [    0.598546] ---[ end trace 778e504de7e3b1e3 ]---

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.git/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.git.orig/drivers/acpi/processor_idle.c	2008-03-12 05:17:12.000000000 -0700
+++ linux-2.6.git/drivers/acpi/processor_idle.c	2008-03-13 10:00:47.000000000 -0700
@@ -216,8 +216,10 @@
 	 * test NEED_RESCHED:
 	 */
 	smp_mb();
-	if (!need_resched())
+	if (!need_resched()) {
 		safe_halt();
+		local_irq_disable();
+	}
 	current_thread_info()->status |= TS_POLLING;
 }
 
@@ -421,7 +423,9 @@
 		else
 			acpi_safe_halt();
 
-		local_irq_enable();
+		if (irqs_disabled())
+			local_irq_enable();
+
 		return;
 	}
 
@@ -530,7 +534,9 @@
 		 *       skew otherwise.
 		 */
 		sleep_ticks = 0xFFFFFFFF;
-		local_irq_enable();
+		if (irqs_disabled())
+			local_irq_enable();
+
 		break;
 
 	case ACPI_STATE_C2:
