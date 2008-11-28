Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYK1TXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYK1TXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYK1TXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:23:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbYK1TW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:22:59 -0500
Date: Fri, 28 Nov 2008 20:22:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the
	trace informations
Message-ID: <20081128192249.GA22263@elte.hu>
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu> <20081128092553.GA7040@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128092553.GA7040@elte.hu>
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


another detail: it would be nice to annotate IRQ entries some more.

right now if a syscall is interrupted by a hardware interrupt, it looks 
like this:

 0)               |              skb_dequeue() {
 0)      0.365 us |                _spin_lock_irqsave();
 0)      0.422 us |                _spin_unlock_irqrestore();
 0)      1.912 us |              }
 0)               |              memcpy_toiovec() {
 0)               |                copy_to_user() {
 0)               |                  smp_apic_timer_interrupt() {
 0)      0.450 us |                    native_apic_mem_write();
 0)               |                    irq_enter() {
 0)      0.410 us |                      idle_cpu();
 0)      1.167 us |                    }
 0)               |                    hrtimer_interrupt() {

the natural nesting is nice, but easy to miss. It would be nice to have 
something like:

 0)               |              skb_dequeue() {
 0)      0.365 us |                _spin_lock_irqsave();
 0)      0.422 us |                _spin_unlock_irqrestore();
 0)      1.912 us |              }
 0)               |              memcpy_toiovec() {
 0)               |                copy_to_user() {
 0)             =====>               smp_apic_timer_interrupt() {
 0)      0.450 us |                    native_apic_mem_write();
 0)               |                    irq_enter() {
 0)      0.410 us |                      idle_cpu();
 0)      1.167 us |                    }
 0)               |                    hrtimer_interrupt() {

and perhaps something like this at the end of the irq frame:

 0)      0.408 us |                          _local_bh_enable();
 0) +   13.139 us |                        }
 0) +   13.887 us |                      }
 0)      0.406 us |                      idle_cpu();
 0) +   15.373 us |                    }
 0) +   74.564 us |                  }
 0)               |                  _cond_resched() {
 0)               |                    need_resched() {
 0)      0.423 us |                      constant_test_bit();
 0)      1.164 us |                    }
 0)      1.915 us <===               } /* IRQ 1 end */
 0) +   78.396 us |                }
 0) +   79.123 us |              }
 0)      0.387 us |              skb_pull();
 0)               |              kfree_skb() {

?

	Ingo
