Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZINPf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZINPf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZINPf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:35:26 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:50084 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZINPfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:35:25 -0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
To: linux-kernel@vger.kernel.org
Subject: Re: INGO Why you remove  set_user_nice() from kernel/kthread.c
Date: Mon, 14 Sep 2009 19:35:24 +0400
User-Agent: KMail/1.9.10
References: <200909141742.45487.pavel@pavlinux.ru> <1252937140.6500.11.camel@marge.simson.net> <4AAE5D60.2080703@nortel.com>
In-Reply-To: <4AAE5D60.2080703@nortel.com>
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909141935.25681.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   
   Compare 

2.6.31-git2 with KTHREAD_NICE_LEVEL = 0
2.6.31-git2 with KTHREAD_NICE_LEVEL = -5

Diff.

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5fe7099..eb8751a 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -16,6 +16,8 @@
 #include <linux/mutex.h>
 #include <trace/events/sched.h>

+#define KTHREAD_NICE_LEVEL (-5)
+
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
@@ -143,6 +145,7 @@ struct task_struct *kthread_create(int (*threadfn)(void 
*data),
                 * The kernel thread should not inherit these properties.
                 */
                sched_setscheduler_nocheck(create.result, SCHED_NORMAL, 
&param);
+         set_user_nice(create.result, KTHREAD_NICE_LEVEL);
                set_cpus_allowed_ptr(create.result, cpu_all_mask);
        }
        return create.result;
@@ -218,6 +221,7 @@ int kthreadd(void *unused)
        /* Setup a clean context for our children to inherit. */
        set_task_comm(tsk, "kthreadd");
        ignore_signals(tsk);
+ set_user_nice(tsk, KTHREAD_NICE_LEVEL);
        set_cpus_allowed_ptr(tsk, cpu_all_mask);
        set_mems_allowed(node_possible_map);
 


Used benchmarks.

# cyclictest and signaltest - 
http://www.osadl.org/Realtime-test-utilities-cyclictest-and-s.rt-test-cyclictest-signaltest.0.html

 ----------
 CYCLE TEST
 ----------

-T: 0 ( 5263) P: 0 I:1000 C:  98345 Min:      8 Act:656014 Avg:287390 Max:  
656450
-T: 1 ( 5264) P: 0 I:1500 C:  65680 Min:      7 Act:481583 Avg:236140 Max:  
482343
-T: 2 ( 5265) P: 0 I:2000 C:  49358 Min:      7 Act:286071 Avg:111300 Max:  
287453
-T: 3 ( 5266) P: 0 I:2500 C:  39453 Min:      7 Act:370028 Avg:116111 Max:  
372481
+T: 0 ( 6634) P: 0 I:1000 C:  98888 Min:      7 Act:113011 Avg:28733 Max:  
113817
+T: 1 ( 6635) P: 0 I:1500 C:  65953 Min:      8 Act:72013 Avg:25026 Max:   
73110
+T: 2 ( 6636) P: 0 I:2000 C:  49468 Min:      6 Act:66076 Avg:17455 Max:   
67486
+T: 3 ( 6637) P: 0 I:2500 C:  39580 Min:      7 Act:52514 Avg:12882 Max:   
53256

 ----------
 SIGNAL TEST
 ----------

-T: 0 ( 5285) P: 0 C: 100000 Min:     13 Act:   23 Avg:   30 Max:    9229
-T: 1 ( 5286) P: 0 C: 100000 Min:     13 Act:   99 Avg:  662 Max:   17282
-T: 2 ( 5287) P: 0 C: 100000 Min:     13 Act:  110 Avg:  662 Max:   17294
-T: 3 ( 5288) P: 0 C: 100000 Min:     13 Act:  119 Avg:  662 Max:   18645
+T: 0 ( 6698) P: 0 C: 100000 Min:     13 Act:   22 Avg:   24 Max:    7898
+T: 1 ( 6699) P: 0 C: 100000 Min:     13 Act:  104 Avg:  654 Max:   15728
+T: 2 ( 6700) P: 0 C: 100000 Min:     13 Act:  114 Avg:  654 Max:   15740
+T: 3 ( 6701) P: 0 C: 100000 Min:     13 Act:  124 Avg:  654 Max:   16102

