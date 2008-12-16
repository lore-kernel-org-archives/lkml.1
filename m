Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYLPMun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYLPMun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYLPMue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:50:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYLPMud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:50:33 -0500
Date: Tue, 16 Dec 2008 13:50:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20081216125000.GC25019@elte.hu>
References: <20081214212829.GA9435@elte.hu> <20081216122229.GA1430@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216122229.GA1430@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> Hmm, if I timec some setuid program, what happens?

yes, i already had a quick look at that a few days ago when i implemented 
counter inheritance (for different reasons) and couldnt find the cleanest 
place to put the exec() flushing into so i procrastinated that a bit :)

> Performance counters seem like great tool to pull secret keys out of 
> other processes :-).

if you worry about _that_ angle you also have to:

 - turn off the cycle counter

 - turn off precise utimes

 - plus you have to forbid SMT CPUs as well. On HT a task could
   co-schedule with your setuid task and observe its timing
   characteristics via its _own_ behavior. (which is impacted by whatever
   is running on another SMT/HT thread.)

the real exec() worry are: active, IRQ driven samples/events. Not possible 
yet via the current iteration of counter inheritance (hence my 
procrastination) - but it makes sense and that's why i was looking at the 
exec() angle.

and that will flush simple counters too, removing your theoretical attack 
angle as well.

So how about the patch below?

	Ingo

--------------->
Subject: perfcounters: flush on setuid exec
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Dec 16 13:40:44 CET 2008

Pavel Machek pointed out that performance counters should be flushed
when crossing protection domains on setuid execution.

Reported-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/exec.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/fs/exec.c
===================================================================
--- linux.orig/fs/exec.c
+++ linux/fs/exec.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/perf_counter.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
@@ -1015,6 +1016,13 @@ int flush_old_exec(struct linux_binprm *
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
+	/*
+	 * Flush performance counters when crossing a
+	 * security domain:
+	 */
+	if (!get_dumpable(current->mm))
+		perf_counter_exit_task(current);
+
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
