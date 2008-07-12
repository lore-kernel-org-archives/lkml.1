Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYGLLO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYGLLO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 07:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYGLLOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 07:14:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2918 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYGLLOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 07:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DlRdyDIlDVOf3sIu2ap/aWa2E0QExDngNT7zx5ZK/t+Wf+nDfxO+IKvRd6Fh2jQfNN
         NUBvHCSAcyUxo7O7/B5W2cPyALqlMDQncI/Lr3ZRJ5wtZBgEKUjvyXmT55vb9+mU7Zb8
         JXRiZpJ/6gf7THwzH8ME+xrgE6XB5MRFRXGJ0=
Subject: Re: current linux-2.6.git: cpusets completely broken
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1215859526.5405.3.camel@earth>
References: <1215859526.5405.3.camel@earth>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 13:14:45 +0200
Message-Id: <1215861285.5405.6.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-12 at 12:45 +0200, Dmitry Adamushko wrote:
> 2008/7/12 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> > 2008/7/12 Linus Torvalds <torvalds@linux-foundation.org>:
> >>
> >>
> >> On Sat, 12 Jul 2008, Vegard Nossum wrote:
> >>>
> >>> Can somebody else please test/ack/review it too? This should eventually
> >>> go into 2.6.26 if it doesn't break anything else.
> >>
> >> And Dmitry, _please_ also explain what was going on. Why did things break
> >> from calling common_cpu_mem_hotplug_unplug() too much? That function is
> >> called pretty randomly anyway (for just about any random CPU event), so
> >> why did it fail in some circumstances?
> >
> > Upon CPU_DOWN_PREPARE, update_sched_domains() ->
> > detach_destroy_domains(&cpu_online_map) ;
> > does the following:
> >
> > /*
> >  * Force a reinitialization of the sched domains hierarchy. The domains
> >  * and groups cannot be updated in place without racing with the balancing
> >  * code, so we temporarily attach all running cpus to the NULL domain
> >  * which will prevent rebalancing while the sched domains are recalculated.
> >  */
> >
> > The sched-domains should be rebuilt when a CPU_DOWN ops. is completed,
> > effectivelly either upon CPU_DEAD{_FROZEN} (upon success) or
> > CPU_DOWN_FAILED{_FROZEN} (upon failure -- restore the things to their
> > initial state). That's what update_sched_domains() also does but only
> > for !CPUSETS case.
> >
> > With Max's patch, sched-domains' reinitialization is delegated to CPUSETS code:
> >
> > cpuset_handle_cpuhp() -> common_cpu_mem_hotplug_unplug() ->
> > rebuild_sched_domains()
> >
> > which as you've said "called pretty randomly anyway", e.g. for CPU_UP_PREPARE.
> >
> > [ ah, then rebuild_sched_domains() should not be there. It should be
> > nop for MEMPLUG events I presume - should make another patch. ]
> 
> I had in mind something like this:
> 
> [ yes, probably the patch makes things somewhat uglier. I tried to bring a minimal amount of changes so far, just to emulate the 'old' behavior of update_sched_domains().
> I guess, common_cpu_mem_hotplug_unplug() needs to be split up into cpu- and mem-hotplug parts to make it cleaner ]
> 
> (not tested yet)
> 
> ---

argh, this one compiles (will test shortly).


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9fceb97..798b3ab 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1882,7 +1882,7 @@ static void scan_for_empty_cpusets(const struct
cpuset *root)
  * in order to minimize text size.
  */
 
-static void common_cpu_mem_hotplug_unplug(void)
+static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
 {
 	cgroup_lock();
 
@@ -1894,7 +1894,8 @@ static void common_cpu_mem_hotplug_unplug(void)
 	 * Scheduler destroys domains on hotplug events.
 	 * Rebuild them based on the current settings.
 	 */
-	rebuild_sched_domains();
+	if (rebuild_sd)
+		rebuild_sched_domains();
 
 	cgroup_unlock();
 }
@@ -1912,11 +1913,22 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
-	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+	switch (phase) {
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		common_cpu_mem_hotplug_unplug(1);
+		break;
+	default:
 		return NOTIFY_DONE;
+	}
 
-	common_cpu_mem_hotplug_unplug();
-	return 0;
+	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -1929,7 +1941,7 @@ static int cpuset_handle_cpuhp(struct
notifier_block *unused_nb,
 
 void cpuset_track_online_nodes(void)
 {
-	common_cpu_mem_hotplug_unplug();
+	common_cpu_mem_hotplug_unplug(0);
 }
 #endif
 



