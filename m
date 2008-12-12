Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYLLL1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYLLL1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYLLL1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:27:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:63851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYLLL1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:27:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yCJStJNz8/QNWtly188gPsvRA0Z55uyCpDcQLhDq1I7TENhMhMnentsHoWL013FXRi
         UlyzRFGkZAXInf8q8gPmx0lACtKoSHUL3o50IcO5CuMmgEK5Xw772uZphCaODmE9D4W/
         HFuvUtS2WBSSlEZkOvXofRlzOIBtgTt6PQpEM=
Message-ID: <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com>
Date: Fri, 12 Dec 2008 12:27:32 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt triggering on output
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081212101448.GE18152@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com>
	 <20081212101448.GE18152@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/12 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Frederic Weisbecker wrote:
>> > This patchset adds all the features to draw hardirq triggering on output
>> > for the function graph tracer.
>> > An example is given on the third patch.
>> >
>> > Just one question, on recordmcount.pl:
>> >
>> > my %text_sections = (
>> >       ".text" => 1,
>> >       ".sched.text" => 1,
>> >       ".spinlock.text" => 1,
>> >
>> > The .sched.text section is included inside .text, it's a subsection, I'm not sure
>> > it's necessary to add it in text_sections. In doubt I added the new .irqentry.text
>> >
>> > The stat of the patchset:
>> >
>> >  arch/x86/kernel/apic.c               |    3 +-
>> >  arch/x86/kernel/irq_64.c             |    3 +-
>> >  arch/x86/kernel/vmlinux_64.lds.S     |    1 +
>> >  include/asm-generic/vmlinux.lds.h    |   10 +++++
>> >  include/linux/ftrace.h               |   11 ++++++
>> >  kernel/trace/trace_functions_graph.c |   66 +++++++++++++++++++++++++++++++--
>> >  scripts/recordmcount.pl              |    1 +
>> >  7 files changed, 89 insertions(+), 6 deletions(-)
>
> applied to tip/tracing/function-graph-tracer, thanks Frederic!
>
> The output looks really nice.
>
>        Ingo
>

Thanks :-)

If anyone  has other needs or suggestions about this tracer, don't
hesitate to request it.
I remember Peter suggested that the preempt count could be output.
Actually, to make the things more humans, I would suggest to simply
output the fact that preempt is disabled or not.

I could for example give three more fields with one letter for each
(as a default-off trace option):

_interrupt disabled
_preempt disabled
_in atomic context

I guess those could help for the -rt tree for example.
What do you think?

When I worked on this hardirq signal, I wanted to print the current
code context for each function:

Interrupt:
_ Hardirq
_ Softirq (with subclasses like tasklets)
_ Nmi (not yet traced, if there are still plans for the ring buffer to
be lockless, that will be easy).

Task:
_Syscall
_Workqueue
_kernel thread

But actually, those things are easy to find if the current task/pid is
output. "ksoftirqd", "events" are here to give
the hints about the softirq and workqueue context. Syscalls are easy
to find along the code flow. Kernel threads are
recognized through their name. And hardirqs have their arrows....

But if you think such a column could be useful for you or anyone, just tell me.

There is still some work remaining, the braces on leaf functions have
to disappear on the trace_pipe (but it requires
to read the ring-buffer on more than one entry forward, just two actually).

And a port to other archs. I will try to acquire a low cost arm board
if I can (I wouldn't feel comfortable with qemu).

Anyway, most of these things will be for 2.6.30 I guess :-)
