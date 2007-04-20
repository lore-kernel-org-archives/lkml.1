Return-Path: <linux-kernel-owner+w=401wt.eu-S2992761AbXDTNBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992761AbXDTNBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992741AbXDTNBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:01:47 -0400
Received: from www.osadl.org ([213.239.205.134]:42387 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992761AbXDTNBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:01:46 -0400
Subject: Re: preempt_rt bug or warn on arm v4t
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: Manfred Gruber <m.gruber@tirol.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200704201306.08066.m.gruber@tirol.com>
References: <200704201306.08066.m.gruber@tirol.com>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 15:01:42 +0200
Message-Id: <1177074102.3636.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

> I am using 2.6.21-rc7 with Preempt_rt Patch 2.6.20-rc6-rt0 on ep93xx.

Do you mean 2.6.21-rc6-rt0?

> This oops does not trigger in preempt_rt patch is applied. 

It does only appear, when the preempt_rt patch is applied. Did I get you
right?

> On startup i get following oops when preemption is none.
> 
> Mount-cache hash table entries: 512
> CPU: Testing write buffer coherency: ok
> BUG: at kernel/sched.c:4285 __schedule()
> [<c006d404>] (dump_stack+0x0/0x14) from [<c02eeea4>] (__schedule+0x844/0x8e0)
> [<c02ee660>] (__schedule+0x0/0x8e0) from [<c02ef038>] (schedule+0xd0/0x118)
> [<c02eef68>] (schedule+0x0/0x118) from [<c02ef3e0>] 
> (wait_for_completion+0x94/0xf0)
>  r4 = C042DE88 
> [<c02ef34c>] (wait_for_completion+0x0/0xf0) from [<c0099c14>] 
> (keventd_create_kthread+0x3c/0x74)
>  r7 = 00000000  r6 = 00000002  r5 = C042DED4  r4 = C042DF18
> [<c0099bd8>] (keventd_create_kthread+0x0/0x74) from [<c0099ccc>] 
> (kthread_create+0x80/0xc8)
>  r6 = C001C320  r5 = C042DED4  r4 = 00000000 
> [<c0099c4c>] (kthread_create+0x0/0xc8) from [<c009ad48>] 
> (posix_cpu_thread_call+0x40/0xb8)
>  r3 = 00000000  r2 = C0352BD0 
>  r5 = 00000000  r4 = 00000000 
> [<c009ad08>] (posix_cpu_thread_call+0x0/0xb8) from [<c000dd10>] 
> (posix_cpu_thread_init+0x24/0x40)
>  r5 = 00000000  r4 = C03A7F74 
> [<c000dcec>] (posix_cpu_thread_init+0x0/0x40) from [<c00088b0>] 
> (init+0x38/0x30c)
>  r4 = 00000000 
> [<c0008878>] (init+0x0/0x30c) from [<c0087b90>] (do_exit+0x0/0x80c)

This WARN_ON in __schedule seems to be triggered:

 if (!irqs_disabled()) {
                static int once = 1;
                if (once) {
                        once = 0;
                        print_irqtrace_events(current);
                        WARN_ON(1);
                }
        }

I've seen this on an Atmel AT91SAM9261EK board a few days ago, when I
was implementing GENERIC_TIME and GENERIC_CLOCKEVENTS. I've tested with
2.6.20-rt8 and 2.6.21-rc6-rt0.
(an early version of the patch can be found here:
http://www.tglx.de/private/jan/at91sam/at91sam9260-generic-time-2.6.21-rc6-rt0.diff)

	Jan

