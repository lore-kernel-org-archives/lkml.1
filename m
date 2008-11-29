Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYK2Dkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYK2Dkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 22:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYK2Dkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 22:40:39 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:53619 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYK2Dki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 22:40:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gHDUA9dTgzc7JbKh3fGWypJGkr2TtIbLGxaBM9vhwao1vWonngNhUtUDzjwZfkhaXN
         g9XmGPbfFwp+52BrcSgOx8Ccp95qnpS+pn8JXYLCQ/zoTvefgt8hlldHcjXnsLvpeVT7
         +cGZEGxc9JYj6uLZ8IjmSw6AFtePoPcITG+h8=
Message-ID: <c62985530811281940w4542546t5a1235ad8e5a24bf@mail.gmail.com>
Date: Sat, 29 Nov 2008 04:40:37 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the trace informations
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081128192249.GA22263@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu>
	 <20081128092553.GA7040@elte.hu> <20081128192249.GA22263@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/28 Ingo Molnar <mingo@elte.hu>:
>
> another detail: it would be nice to annotate IRQ entries some more.
>
> right now if a syscall is interrupted by a hardware interrupt, it looks
> like this:
>
>  0)               |              skb_dequeue() {
>  0)      0.365 us |                _spin_lock_irqsave();
>  0)      0.422 us |                _spin_unlock_irqrestore();
>  0)      1.912 us |              }
>  0)               |              memcpy_toiovec() {
>  0)               |                copy_to_user() {
>  0)               |                  smp_apic_timer_interrupt() {
>  0)      0.450 us |                    native_apic_mem_write();
>  0)               |                    irq_enter() {
>  0)      0.410 us |                      idle_cpu();
>  0)      1.167 us |                    }
>  0)               |                    hrtimer_interrupt() {
>
> the natural nesting is nice, but easy to miss. It would be nice to have
> something like:
>
>  0)               |              skb_dequeue() {
>  0)      0.365 us |                _spin_lock_irqsave();
>  0)      0.422 us |                _spin_unlock_irqrestore();
>  0)      1.912 us |              }
>  0)               |              memcpy_toiovec() {
>  0)               |                copy_to_user() {
>  0)             =====>               smp_apic_timer_interrupt() {
>  0)      0.450 us |                    native_apic_mem_write();
>  0)               |                    irq_enter() {
>  0)      0.410 us |                      idle_cpu();
>  0)      1.167 us |                    }
>  0)               |                    hrtimer_interrupt() {
>
> and perhaps something like this at the end of the irq frame:
>
>  0)      0.408 us |                          _local_bh_enable();
>  0) +   13.139 us |                        }
>  0) +   13.887 us |                      }
>  0)      0.406 us |                      idle_cpu();
>  0) +   15.373 us |                    }
>  0) +   74.564 us |                  }
>  0)               |                  _cond_resched() {
>  0)               |                    need_resched() {
>  0)      0.423 us |                      constant_test_bit();
>  0)      1.164 us |                    }
>  0)      1.915 us <===               } /* IRQ 1 end */
>  0) +   78.396 us |                }
>  0) +   79.123 us |              }
>  0)      0.387 us |              skb_pull();
>  0)               |              kfree_skb() {
>
> ?


I tried to figure out a way to signal a hardirq in a trace, I like
this arrow but It
breaks the indentation.
I would suggest:

  0)               |              skb_dequeue() {
  0)      0.365 us |                _spin_lock_irqsave();
  0)      0.422 us |                _spin_unlock_irqrestore();
  0)      1.912 us |              }
  0)               |              memcpy_toiovec() {
  0)               |                copy_to_user() {
             =====>
  0)               |               smp_apic_timer_interrupt() {
  0)      0.450 us |                    native_apic_mem_write();
  0)               |                    irq_enter() {
  0)      0.410 us |                      idle_cpu();
  0)      1.167 us |                    }
  0)               |                    hrtimer_interrupt() {

Your idea solves a part of one of the features I wanted to add: why
not using a single character column to print
the current context: workqueue, syscall, kernel thread, tasklet, hardirq .....
