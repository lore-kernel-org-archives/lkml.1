Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYKFH6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYKFH6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYKFH6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:58:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38321 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYKFH6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:58:00 -0500
Date: Thu, 6 Nov 2008 08:57:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
Message-ID: <20081106075754.GE8459@elte.hu>
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com> <20081105130113.GB29548@elte.hu> <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> > is this some special warning you added? The stock kernel certainly 
> > does not emit this warning.
> 
> Yes - it's my personal debug checker that tries to watch wether irq 
> & irqsafe are running in pair. So it shows a warning if there is a 
> call of spin_lock_irq and irq is already dissabled.

btw., i have added lockdep instrumentation for this two years ago, 
it's in the upstream kernel:

/proc/lockdep_stats: redundant hardirq ons:                7744
/proc/lockdep_stats: redundant hardirq offs:            1873736
/proc/lockdep_stats: redundant softirq ons:                   0
/proc/lockdep_stats: redundant softirq offs:                  0

you could extend the code to trace it. See 
kernel/lockdep.c:trace_hardirqs_on_caller(). This bit does it:

        if (unlikely(curr->hardirqs_enabled)) {
                debug_atomic_inc(&redundant_hardirqs_on);
                return;
        }

you could add a ftrace_printk("redundant hardirq") call right there, 
enable ftrace, and enable stack tracing of each trace entry:

 echo stacktrace > /debug/tracing/iter_ctrl

then you should see all the call sites in /debug/tracing/trace.

	Ingo
