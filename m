Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbXDQEyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbXDQEyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXDQEyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:54:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:25648 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXDQEyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j/rXECkukQPAlfBKGWFgS23o9XgUJ5nIV/fLLsgLMUper6OlWiTVREO7m7sSk/22FVB9DH5ZP0XdnY5Zm3HI4D78tgtmuCR5HT468xl2A0znKyr8D8g8wHRTGihAsN1j+mWdYCiTPIejCQsMfV9We96gGTlTgAluKippHg5kgx8=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 00:53:56 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070416220715.GA4071@elte.hu>
In-Reply-To: <20070416220715.GA4071@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704170053.58611.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007, Ingo Molnar wrote:
>this is the second release of the CFS (Completely Fair Scheduler)
>patchset, against v2.6.21-rc7:
>
>   http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
>
>i'd like to thank everyone for the tremendous amount of feedback and
>testing the v1 patch got - i could hardly keep up with just reading the
>mails! Some of the stuff people addressed i couldnt implement yet, i
>mostly concentrated on bugs, regressions and debuggability.
>
>there's a fair amount of churn:
>
>   15 files changed, 456 insertions(+), 241 deletions(-)
>
>But it's an encouraging sign that there was no crash bug found in v1,
>all the bugs were related to scheduling-behavior details. The code was
>tested on 3 architectures so far: i686, x86_64 and ia64. Most of the
>code size increase in -v2 is due to debugging helpers, they'll be
>removed later. (The new /proc/sched_debug file can be used to see the
>fine details of CFS scheduling.)
>
>Changes since -v1:
>
> - make nice levels less starvable. (reported by Willy Tarreau)
>
> - fixed child-runs first. A /proc/sys/kernel/sched_child_runs_first
>   flag can be used to turn it on/off. (This might fix the Kaffeine bug
>   reported by S.Çağlar Onur <)
>
> - changed SCHED_FAIR back to SCHED_NORMAL (suggested by Con Kolivas)
>
> - UP build fix. (reported by Gabriel C)
>
> - timer tick micro-optimization (Dmitry Adamushko)
>
> - preemption fix: sched_class->check_preempt_curr method to decide
>   whether to preempt after a wakeup (or at a timer tick). (Found via a
>   fairness-test-utility written for CFS by Mike Galbraith)
>
> - start forked children with neutral statistics instead of trying to
>   inherit them from the parent: Willy Tarreau reported that this
>   results in better behavior on extreme workloads, and it also
>   simplifies the code quite nicely. Removed sched_exit() and the
>   ->task_exit() methods.
>
> - make nice levels independent of the sched_granularity value
>
> - new /proc/sched_debug file listing runqueue details and the rbtree
>
> - new SCH-* fields in /proc/<NR>/status to see scheduling details
>
> - new cpu-hog feature (off by default) and sysctl tunable to set it:
>   /proc/sys/kernel/sched_max_hog_history_ns tunable defaults to
>   0 (off). Positive values are meant the maximum 'memory' that the
>   scheduler has of CPU hogs.
>
> - various code cleanups
>
> - added more statistics temporarily: sum_exec_runtime,
>   sum_wait_runtime.
>
> - added -CFS-v2 to EXTRAVERSION
>
>as usual, any sort of feedback, bugreports, fixes and suggestions are
>more than welcome,
>
>	Ingo

This one (v2-rc2) is not a keeper I'm sorry to say, Ingo.  v2-rc0 was much 
better.  Watching amanda run with htop, kmails composer is being subjected to 
5 to 10 second pauses, and htop says that gzip -best isn't getting more that 
15% of the cpu, and the /amandatapes drive is being written to in a regular 
pattern that seems to be the cause of the pauses  according to gkrellm, which 
also seems to track the size of the writes, and can show anything from 4.3k 
to 54 megs as being written in one cycle of its screen update.

Normally hdd will fire up and take it at about 40+M/second steady till its 
done when there is a file ready to write even if its a 7GB file.  And I can 
type right on during the disk i/o.  But not now.

In short, I seem to be heavily I/O bound.  But when the write to /dev/hdd3 is 
done, then gzip -best pops right up to 90% plus cpu and I get my machine 
back.

In between file writes I checked the drives speed with hdparm:

root@coyote ~]# hdparm -Tt /dev/hdd

/dev/hdd:
 Timing cached reads:   856 MB in  2.01 seconds = 426.15 MB/sec
 Timing buffered disk reads:  222 MB in  3.01 seconds =  73.68 MB/sec

That's not too shabby, and obviously dma is active at least for the reading.

gzip -best was running while this was executing. So I think the drive is fine 
and the scheduling is whats funkity.  Sorry.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
  After they got rid of capital punishment, they had to hang twice
  as many people as before.
