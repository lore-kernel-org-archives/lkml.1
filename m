Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbXGFReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbXGFReR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbXGFReH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:34:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762129AbXGFReF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:34:05 -0400
Date: Fri, 6 Jul 2007 19:33:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [patch] CFS scheduler, -v19
Message-ID: <20070706173319.GA2356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v19 of the CFS scheduler patchset.

The rolled-up CFS patch against today's -git kernel, v2.6.22-rc7, 
v2.6.22-rc6-mm1, v2.6.21.5 or v2.6.20.14 can be downloaded from the 
usual place:

    http://people.redhat.com/mingo/cfs-scheduler/
 
The biggest user-visible change in -v19 is reworked sleeper fairness: 
it's similar in behavior to -v18 but works more consistently across nice 
levels. Fork-happy workloads (like kernel builds) should behave better 
as well. There are also a handful of speedups: unsigned math, 32-bit 
speedups, O(1) task pickup, debloating and other micro-optimizations.

Changes since -v18:

 - merged the group-scheduling CFS-core changes from Srivatsa Vaddagiri. 
   This makes up for the bulk of the changes in -v19 but has no
   behavioral impact. The final group-fairness enabler patch is now a 
   small and lean add-on patch to CFS.

 - fix the bloat noticed by Andrew. On 32-bit it's now this:

      text    data     bss     dec     hex   filename
     24362    3905      24   28291    6e83   sched.o-rc7
     33015    2538      20   35573    8af5   sched.o-v18
     25805    2426      20   28251    6e5b   sched.o-v19

   so it's a net win compared to vanilla. On 64-bit it's even better:

      text    data     bss     dec     hex   filename
     35732   40314    2168   78214   13186   sched.o.x64-rc7
     41397   37642    2168   81207   13d37   sched.o.x64-v18
     36132   37410    2168   75710   127be   sched.o.x64-v19

   ( and there's also a +1.5K data win per CPU on x32, which is not
     shown here. [+3.0K data win per CPU on x64.] )

 - good number of core code updates, cleanups and streamlining.
   (Mike Galbraith, Srivatsa Vaddagiri, Dmitry Adamushko, me.)

 - use unsigned data types almost everywhere in CFS. This produces 
   faster and smaller code, and simplifies the logic.

 - turn as many 'u64' data types into 'unsigned long' as possible, to 
   reduce the 32-bit footprint and to reduce 64-bit arithmetics.

 - replaced the nr_running based 'sleep fairness' logic with a more 
   robust concept. The end-result is similar in behavior to v18, but 
   negative nice levels are handled much better in this scheme.

 - speedup: O(1) task pickup by Srivatsa Vaddagiri. [sleep/wakeup is
   O(log2(nr_running)).] This gives 5-10% better hackbench 100/500
   results on a 4-way box.

 - fix: set idle->sched_class back to &idle_sched_class in 
   migration_call(). (Dmitry Adamushko)

 - cleanup: use an enum for the sched_feature flags. (suggested by 
   Andrew Morton)

 - cleanup: turn the priority macros into inlines. (suggested by
   Andrew Morton)

 - (other cleanups suggested by Andrew Morton)

 - debug: split out the debugging data into CONFIG_SCHED_DEBUG.
 
As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!
 
	Ingo
