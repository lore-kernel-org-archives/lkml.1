Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYLMO0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYLMO0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYLMO0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:26:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:14075 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYLMO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:26:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KWpqfGVYEtZ8PcQPdiBBPctA8r2C4Cnb9hKeoMMD3BXDu/pjaFhWnjqrmDmHDEXALb
         G6h14YzZJB34HvXnST8Z+Zgf/YpuzI7s4rYXQ9zkSlIZPdHgsAtUNxMxqXZl5crhWDYb
         mYvAPZ3pTF6SiEwPGIjF8FdckYwR/kfot7QME=
Message-ID: <c62985530812130626m75fea357wa24499bc72e63609@mail.gmail.com>
Date: Sat, 13 Dec 2008 15:26:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt triggering on output
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081213074930.GA4205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com>
	 <20081212101448.GE18152@elte.hu>
	 <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com>
	 <20081213074930.GA4205@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Ingo Molnar <mingo@elte.hu>:
> that reminds me ... did you know about hardirq_count()? We could use it
> to detect IRQ entries in a more generic way, instead of the section
> trick?


No I didn't know it but thought about it indirectly.
This counter is inc/dec on irq_enter and irq_exit. I wanted first to
send some special events
while entering irq_enter/exit to notice interrupt events. The problem
is that the irq is raised a bit sooner.
If I used I would have:

    foo() {
        smp_apic_timer_interrupt() {
            irq_enter() {
                 ===> //hardirq_count() is incremented here
            }
        }
    }

We would loose so the sense of the arrow here. Its role is to explain
the breakage into
the code flow by the interrupt. The role of the arrow is to explain
that smp_apic_timer_interrupt is not called
by foo().

One thing I would suggest would be to move these irq_enter/exit on entry_xx.S

> Another thing, i just noticed that ftrace_print() is broken in certain
> situations, for example a plain newline:
>
>        ftrace_printk("\n");
>
> printed via trace_pipe will print some weirdly concatenated line:
>
>           <...>-2994  [007]   406.498986: debug_show:          <...>-2994  [007]   406.498986:            <...>-2994  [007]   406.498986: debug_show:
>
> not via a separate, standalone, empty line.

Ok, I will send a patch.

>
> Another thing: it would be nice to have a trace_option to leave out this
> preamble:
>
>           <...>-2994  [007]   406.498986: debug_show:  test printk
>
> and just give this output:
>
>  test printk
>
> i.e. some 'printk compatibility' mode. That way i could use
> ftrace_printk() as a pure replacement for printk, during development.
>
>        Ingo
>

Ok. I will add a flag for that too.
