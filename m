Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbZJFUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbZJFUIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933119AbZJFUIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:08:44 -0400
Received: from www.tglx.de ([62.245.132.106]:34019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117AbZJFUIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:08:43 -0400
Date: Tue, 6 Oct 2009 22:07:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 2.6.31.2-rt13
In-Reply-To: <alpine.LFD.2.00.0910062122230.5950@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910062202590.5950@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>  <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>  <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> 
 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>  <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>  <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>  <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> 
 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>  <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <3efb10970910061123k2b6826bci11f0f42509173b26@mail.gmail.com> <alpine.LFD.2.00.0910062122230.5950@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Thomas Gleixner wrote:

> On Tue, 6 Oct 2009, Remy Bohmer wrote:
> > But I was wondering if you missed this one:
> > http://patchwork.kernel.org/patch/50044/
> 
> Yup, slipped through. Queued for the next release.

Correction. I dropped the patch as it is just a sloppy work around. 
Why creating the thread in the first place ? Real fix below.

Thanks,

	tglx
---
diff --git a/kernel/softirq.c b/kernel/softirq.c
index aae8d45..3526976 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -1161,6 +1161,8 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 			per_cpu(ksoftirqd, hotcpu)[i].tsk = NULL;
 		}
 		for (i = 0; i < NR_SOFTIRQS; i++) {
+			if (!softirq_names[i])
+				continue;
 			p = kthread_create(ksoftirqd,
 					   &per_cpu(ksoftirqd, hotcpu)[i],
 					   "sirq-%s/%d", softirq_names[i],
@@ -1177,8 +1179,11 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 	break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		for (i = 0; i < NR_SOFTIRQS; i++)
-			wake_up_process(per_cpu(ksoftirqd, hotcpu)[i].tsk);
+		for (i = 0; i < NR_SOFTIRQS; i++) {
+			p = per_cpu(ksoftirqd, hotcpu)[i].tsk;
+			if (p)
+				wake_up_process(p);
+		}
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
@@ -1192,9 +1197,11 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 		for (i = 0; i < NR_SOFTIRQS; i++) {
 			param.sched_priority = MAX_RT_PRIO-1;
 			p = per_cpu(ksoftirqd, hotcpu)[i].tsk;
-			sched_setscheduler(p, SCHED_FIFO, &param);
-			per_cpu(ksoftirqd, hotcpu)[i].tsk = NULL;
-			kthread_stop(p);
+			if (p) {
+				sched_setscheduler(p, SCHED_FIFO, &param);
+				per_cpu(ksoftirqd, hotcpu)[i].tsk = NULL;
+				kthread_stop(p);
+			}
 		}
 		takeover_tasklets(hotcpu);
 		break;
