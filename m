Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZJZH1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZJZH1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZJZH1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:27:03 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:65469 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbZJZH1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KKhKuZtKHjiTZmJ2stNWACM7JBzjgZTXrCNGlvDrYmBUKt2j9JVJT5y88u2kp0Duq6
         Gc7B20RHcsvp7UeTL7Lgepa4BCcB+8+rmwmedV7/DP8s7MY9qnrutgHVckOQ0Pkr5/ay
         6g39wZ8b/VQJfulgFiObjtFayfClfn9+7HIKs=
Subject: Re: [PATCH -v5 09/11] tracing: add IRQENTRY_EXIT for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <c62985530910251736ye7551c4l1a62a1ba242a191f@mail.gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <cover.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
	 <c62985530910251736ye7551c4l1a62a1ba242a191f@mail.gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 26 Oct 2009 15:26:40 +0800
Message-Id: <1256542000.5642.118.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-10-26 at 01:36 +0100, Frederic Weisbecker wrote:
> 2009/10/25 Wu Zhangjin <wuzhangjin@gmail.com>:
> > This patch fix the following error with FUNCTION_GRAPH_TRACER=y:
> >
> > kernel/built-in.o: In function `print_graph_irq':
> > trace_functions_graph.c:(.text+0x6dba0): undefined reference to `__irqentry_text_start'
> > trace_functions_graph.c:(.text+0x6dba8): undefined reference to `__irqentry_text_start'
> > trace_functions_graph.c:(.text+0x6dbd0): undefined reference to `__irqentry_text_end'
> > trace_functions_graph.c:(.text+0x6dbd4): undefined reference to `__irqentry_text_end'
> >
> > (This patch is need to support function graph tracer of MIPS)
> 
> 
> If you want to enjoy this section, you'd need to tag the
> mips irq entry functions with "__irq_entry"  :)
> 
> I guess there is a do_IRQ() in mips that is waiting for that (and
> probably some others).
> The effect is that interrupt areas are cut with a pair of arrows
> in the trace, so that you more easily spot interrupts in the traces
> 
> May be I missed this part in another patch in this series though...

ooh, Sorry, only this patch added(I stopped after fixing the compiling
errors, no more check! so lazy a guy!).

Just checked the source code of MIPS, the do_IRQ() is defined as a
macro, so, I must move the macro to a C file, and also, there is a
irq_enter...irq_exit block in a "big" function, I need to split it out.

[...]
/*
 * do_IRQ handles all normal device IRQ's (the special
 * SMP cross-CPU interrupts have their own specific
 * handlers).
 *
 * Ideally there should be away to get this into kernel/irq/handle.c to
 * avoid the overhead of a call for just a tiny function ...
 */
#define do_IRQ(irq)
\
do {
\
        irq_enter();
\
        __DO_IRQ_SMTC_HOOK(irq);
\
        generic_handle_irq(irq);
\
        irq_exit();
\
} while (0)
[...]

But The comment told us: do not make this tiny function be a standalone
function, so???

the same to do_IRQ_no_affinity.

and, about the following function, I need to split the
irq_enter()...irq_exit() block out.

void ipi_decode(struct smtc_ipi *pipi)
{
	[...]
        switch (type_copy) {
        case SMTC_CLOCK_TICK:
                irq_enter();
                kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
                cd = &per_cpu(mips_clockevent_device, cpu);
                cd->event_handler(cd);
                irq_exit();
                break;

        case LINUX_SMP_IPI:
                switch ((int)arg_copy) {
                case SMP_RESCHEDULE_YOURSELF:
                        ipi_resched_interrupt();
                        break;
                case SMP_CALL_FUNCTION:
                        ipi_call_interrupt();
                        break;
	[...]

Regards,
	Wu Zhangjin

