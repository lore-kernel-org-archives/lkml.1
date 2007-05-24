Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXEXILA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXEXILA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbXEXIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:10:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbXEXIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:10:46 -0400
Date: Thu, 24 May 2007 10:09:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070524080959.GA29151@elte.hu>
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524064235.GA2386@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Hi, Ingo,
> 
> I've implemented a patch on top of v14 for better accounting of 
> sched_info statistics. Earlier, sched_info relied on jiffies for 
> accounting and I've seen applications that show "0" cpu usage 
> statistics (in delay accounting and from /proc) even though they've 
> been running on the CPU for a long time. The basic problem is that 
> accounting in jiffies is too coarse to be accurate.
> 
> The patch below uses sched_clock() for sched_info accounting.

nice! I've merged your patch and it built/booted fine so it should show 
up in -v15. This should also play well with Andi's sched_clock() 
enhancements in -mm, slated for .23.

btw., i think some more consolidation could be done in this area. We've 
now got the traditional /proc/PID/stat metrics, schedstats, taskstats 
and delay accounting and with CFS we've got /proc/sched_debug and 
/proc/PID/sched. There's a fair amount of overlap.

btw., CFS does this change to fs/proc/array.c:

@@ -410,6 +408,14 @@ static int do_task_stat(struct task_stru
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
+	/*
+	 * Use CFS's precise accounting, if available:
+	 */
+	if (!has_rt_policy(task)) {
+		utime = nsec_to_clock_t(task->sum_exec_runtime);
+		stime = 0;
+	}
+
 	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %lu %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
 %lu %lu %lu %lu %lu %lu %lu %lu %d %d %lu %lu %llu\n",

if you have some spare capacity to improve this code, it could be 
further enhanced by not setting 'stime' to zero, but using the existing 
jiffies based utime/stime statistics as a _ratio_ to split up the 
precise p->sum_exec_runtime. That way we dont have to add precise 
accounting to syscall entry/exit points (that would be quite expensive), 
but still the sum of utime+stime would be very precise. (and that's what 
matters most anyway)

	Ingo
