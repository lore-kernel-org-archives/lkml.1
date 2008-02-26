Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbYBZXfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbYBZXfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764044AbYBZXet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:34:49 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:62379 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762670AbYBZXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:34:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALcwxEdMQWRV/2dsb2JhbACBVpBdm3U
Date: Tue, 26 Feb 2008 18:34:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20080226233445.GA1297@Krystal>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080226231248.GA32455@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080226231248.GA32455@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:33:18 up 15 days, 19:33,  3 users,  load average: 1.84, 1.32,
	0.86
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > On Sat, Feb 02, 2008 at 04:08:29PM -0500, Mathieu Desnoyers wrote:
> > > Changelog:
> > > 
> > > - section __imv is already SHF_ALLOC
> > > - Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
> > >   the if (immediateindex) is unnecessary here.
> > > - Remove module_mutex usage: depend on functions implemented in module.c for
> > >   that.
> > 
> > hi,
> > 
> > In testing this patch, i've run across a deadlock...apply_imv_update() can get
> > called again before, ipi_busy_loop() has had a chance to finsh, and set 
> > wait_sync back to its initial value. This causes ipi_busy_loop() to get stuck
> > indefinitely and the subsequent apply_imv_update() hangs. I've shown this 
> > deadlock below using nmi_watchdog=1 in item 1). 
> > 
> 
> Hrm, yes, Jan pointed out the exact same problem in my ltt-test-tsc TSC
> test module in LTTng a few days ago. His fix implied to add another
> barrier upon which the smp_call_function() caller must wait for the ipis
> to finish. Since this immediate value code does the same I did in my
> ltt-test-tsc code, the same fix will likely apply.
> 
> I'll cook something.
> 

This should work. Untested for now. Can you give it a try ?

Fix Immediate Deadlock

Jason Baron <jbaron@redhat.com> :

In testing this patch, i've run across a deadlock...apply_imv_update() can get
called again before, ipi_busy_loop() has had a chance to finsh, and set
wait_sync back to its initial value. This causes ipi_busy_loop() to get stuck
indefinitely and the subsequent apply_imv_update() hangs. I've shown this
deadlock below using nmi_watchdog=1 in item 1).

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> :

Hrm, yes, Jan pointed out the exact same problem in my ltt-test-tsc TSC
test module in LTTng a few days ago. His fix implied to add another
barrier upon which the smp_call_function() caller must wait for the ipis
to finish. Since this immediate value code does the same I did in my
ltt-test-tsc code, the same fix will likely apply.

Thanks to Jason Baron for finding this bug and proposing an initial
implementation.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jason Baron <jbaron@redhat.com>
---
 kernel/immediate.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2008-02-26 18:16:10.000000000 -0500
+++ linux-2.6-lttng/kernel/immediate.c	2008-02-26 18:29:32.000000000 -0500
@@ -53,12 +53,12 @@ static void ipi_busy_loop(void *arg)
 	do {
 		/* Make sure the wait_sync gets re-read */
 		smp_mb();
-	} while (atomic_read(&wait_sync) > loop_data.value);
+	} while (atomic_read(&wait_sync) > 2 * loop_data.value);
 	atomic_dec(&wait_sync);
 	do {
 		/* Make sure the wait_sync gets re-read */
 		smp_mb();
-	} while (atomic_read(&wait_sync) > 0);
+	} while (atomic_read(&wait_sync) > loop_data.value);
 	/*
 	 * Issuing a synchronizing instruction must be done on each CPU before
 	 * reenabling interrupts after modifying an instruction. Required by
@@ -67,6 +67,7 @@ static void ipi_busy_loop(void *arg)
 	sync_core();
 	flush_icache_range(loop_data.imv->imv,
 		loop_data.imv->imv + loop_data.imv->size);
+	atomic_dec(&wait_sync);
 	local_irq_restore(flags);
 }
 
@@ -113,7 +114,7 @@ static int apply_imv_update(const struct
 		kernel_text_lock();
 		get_online_cpus();
 		online_cpus = num_online_cpus();
-		atomic_set(&wait_sync, 2 * online_cpus);
+		atomic_set(&wait_sync, 3 * online_cpus);
 		loop_data.value = online_cpus;
 		loop_data.imv = imv;
 		smp_call_function(ipi_busy_loop, NULL, 1, 0);
@@ -122,7 +123,7 @@ static int apply_imv_update(const struct
 		do {
 			/* Make sure the wait_sync gets re-read */
 			smp_mb();
-		} while (atomic_read(&wait_sync) > online_cpus);
+		} while (atomic_read(&wait_sync) > 2 * online_cpus);
 		text_poke((void *)imv->imv, (void *)imv->var,
 				imv->size);
 		/*
@@ -133,6 +134,12 @@ static int apply_imv_update(const struct
 		atomic_dec(&wait_sync);
 		flush_icache_range(imv->imv,
 				imv->imv + imv->size);
+		/*
+		 * Wait until all other CPUs are done so that we don't overwrite
+		 * loop_data or wait_sync prematurely.
+		 */
+		while (unlikely(atomic_read(&wait_sync) > 1))
+			cpu_relax();
 		local_irq_restore(flags);
 		put_online_cpus();
 		kernel_text_unlock();

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
