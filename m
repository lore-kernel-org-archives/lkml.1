Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZE2MfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZE2MfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZE2MfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:35:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZE2MfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:35:14 -0400
Date: Fri, 29 May 2009 14:35:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
	locked mutex
Message-ID: <20090529123504.GA32299@elte.hu>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com> <1243584388.23657.156.camel@twins> <1243584793.23657.168.camel@twins> <1243585721.23657.177.camel@twins> <20090529085916.GA21461@elte.hu> <20090529091608.GA15278@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529091608.GA15278@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> try the latest Git repo (i tried 95110d7) and do this:
> 
>   make clean
>   perf stat -- make -j
> 
> that locks up for me, very quickly, with permanently stuck tasks:
> 
>    PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM   TIME    COMMAND        
>  10748 mingo     20   0     0    0    0 R 100.4  0.0   0:06.44 chmod         
>  10756 mingo     20   0     0    0    0 R 100.4  0.0   0:06.43 touch         
> 
> looping in the remove-context retry loop.

ok, after muchos debugging and tracing this turned out to be the 
perf_counter_task_exit() in kernel/fork.c, in the fork() failure 
path. That zapped the task ctx in cpuctx and caused the next 
schedule (which is rare) to not schedule the real context out. Then, 
when the task was scheduled back in again later, we scheduled in 
already active counters. Much mayhem followed and the lockup was a 
common incarnation of that. I pushed out a couple of fixes for this.

Pekka, the symptoms appear to match your 'stuck Xorg while make -j' 
symptoms pretty accurately - so if you try latest perfcounters/core 
it might solve some of those problems as well.

	Ingo
