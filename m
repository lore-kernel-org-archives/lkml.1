Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYFIIkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYFIIkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYFIIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:40:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYFIIkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:40:04 -0400
Date: Mon, 9 Jun 2008 10:39:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: lockdep internal warning in linux-next
Message-ID: <20080609083952.GA32746@elte.hu>
References: <20080609010917.c00d5225.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609010917.c00d5225.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> When I boot the 2-way using
> http://userweb.kernel.org/~akpm/config-vmm.txt

this is probably the same as the known problem fixed by the patch below.

	Ingo

----------------->
Subject: sched: sched_clock() lockdep fix
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Jun 05 15:04:17 CEST 2008

Sitsofe Wheeler reported a lockdep warning and bisected it down to:

> commit c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon May 12 21:21:14 2008 +0200
>
>     sched: do not trace sched_clock

do not use raw irq flags in cpu_clock() as it causes lockdep to lose
track of the true state of the IRQ flag.

Reported-and-bisected-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -862,7 +862,7 @@ unsigned long long notrace cpu_clock(int
 	unsigned long long prev_cpu_time, time, delta_time;
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
 	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
 	delta_time = time-prev_cpu_time;
@@ -871,7 +871,7 @@ unsigned long long notrace cpu_clock(int
 		time = __sync_cpu_clock(time, cpu);
 		per_cpu(prev_cpu_time, cpu) = time;
 	}
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return time;
 }
