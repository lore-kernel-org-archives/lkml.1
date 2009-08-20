Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZHTInS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZHTInS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZHTInR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:43:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55373 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZHTInQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:43:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 20 Aug 2009 17:41:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, balbir@linux.vnet.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: [PATCH] better align percpu counter (Was Re: [tip:sched/core]
 sched: cpuacct: Use bigger percpu counter batch values for stats counters
Message-Id: <20090820174123.afa43c48.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090820062451.GH21100@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	<20090512102939.GB11714@elte.hu>
	<20090512193656.D647.A69D9226@jp.fujitsu.com>
	<20090716081010.GB3134@in.ibm.com>
	<20090716083948.GA2950@kryten>
	<20090820051038.GF21100@kryten>
	<20090820052605.GC26265@balbir.in.ibm.com>
	<1250747579.8282.110.camel@twins>
	<20090820060528.GG21100@kryten>
	<20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090820062451.GH21100@kryten>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 16:24:51 +1000
Anton Blanchard <anton@samba.org> wrote:

>  
> Hi,
> 
> > Could you share contex-switch-test program ?
> > I'd like to play with it to find out what I can do against percpu counter.
> 
> Sure:
> 
> http://ozlabs.org/~anton/junkcode/context_switch.c
> 
> Very simple, just run it once per core:
> 
> for i in `seq 0 31`
> do
> 	taskset -c $i ./context_switch &
> done
> 
> Then look at the context switch rates in vmstat.
> 
Thank you for test program.

Before adjusting batch counter (I think you should modify it),
Could you try this ?

I only have 8cpu(2socket) host but works well.
(But...my host is x86-64 and has not virt-cpu-accouting.)

with your program
before patch.
cpuacct off : 414000-416000 ctsw per sec.
cpuacct on  : 401000-404000 ctsw per sec.

after patch
cpuacct on  : 412000-413000 ctsw per sec.

Maybe I should check cache-miss late ;)
==
It's bad to place pointer for array of per-cpu-data on the
same cache line of spinlock. This patch moves percpu_counter's
cacheline to reduce false sharing.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/percpu_counter.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.31-rc6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.31-rc6.orig/include/linux/percpu_counter.h	2009-08-20 12:09:27.000000000 +0900
+++ linux-2.6.31-rc6/include/linux/percpu_counter.h	2009-08-20 17:31:13.000000000 +0900
@@ -14,14 +14,24 @@
 #include <linux/types.h>
 
 #ifdef CONFIG_SMP
+struct __percpu_counter_padding {
+	char x[0];
+} ____cacheline_internodealigned_in_smp;
+#define CACHELINE_PADDING(name)  struct __percpu_counter_padding name
 
 struct percpu_counter {
+	/*
+	 * This pointer is persistent and accessed firstly.
+	 * Then, should not be purged by locking in other cpus.
+	 */
+	s32 *counters;
+	CACHELINE_PADDING(pad);
 	spinlock_t lock;
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
+	/* rarely accessed field */
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
-	s32 *counters;
 };
 
 extern int percpu_counter_batch;


