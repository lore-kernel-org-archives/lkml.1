Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZKEOal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZKEOal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZKEOal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:30:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:33035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756655AbZKEOak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:30:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+qV9Npg1WqJ1pGzi5ckyVjr7kTskpY8eLXS0Jz31
	7ILiIaW9DpEm0F
Subject: Re: There is something with scheduler (was Re: [patch] Re:
 [regression bisect -next] BUG: using smp_processor_id() in preemptible
 [00000000] code: rmmod)
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1257430388.6437.31.camel@marge.simson.net>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>
	 <1257190811.19608.2.camel@marge.simson.net>
	 <4AF2AC30.4000003@cn.fujitsu.com>
	 <1257430388.6437.31.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 15:30:37 +0100
Message-Id: <1257431437.7016.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, with (only) the full scheduler pull request applied, it also acts
sane, and this little hunk is responsible... somehow.  But if that's the
problem, why does locking the runqueue fix it too??

Index: linux-2.6.32.git/kernel/sched.c
===================================================================
--- linux-2.6.32.git.orig/kernel/sched.c
+++ linux-2.6.32.git/kernel/sched.c
@@ -9552,13 +9584,13 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();


