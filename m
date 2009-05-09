Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZEIRdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZEIRdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZEIRdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:33:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZEIRdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:33:06 -0400
Message-ID: <4A05BE81.8070306@redhat.com>
Date: Sat, 09 May 2009 13:33:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip v5 4/7] tracing: add kprobe-based event tracer
References: <20090509004829.5505.38720.stgit@localhost.localdomain>	 <20090509004859.5505.18729.stgit@localhost.localdomain> <c62985530905090936v22f6ab1s867d8f8d6a74b95a@mail.gmail.com>
In-Reply-To: <c62985530905090936v22f6ab1s867d8f8d6a74b95a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> Hi,
> 
> 2009/5/9 Masami Hiramatsu <mhiramat@redhat.com>:
[...]
>> +
>> +/* event recording functions */
>> +static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
>> +                               struct pt_regs *regs)
>> +{
>> +       __trace_bprintk(ip, "%s%s%+ld\n",
>> +                       probe_is_return(tp) ? "<-" : "@",
>> +                       probe_symbol(tp), probe_offset(tp));
>> +}
> 
> 
> 
> What happens here if you have:
> 
> kprobe_trace_record() {
>       probe_symbol() {
>             ....                         probes_open() {
>                                               cleanup_all_probes() {
>                                                          free_trace_probe();
>      return tp->symbol ? ....; //crack!
>
> I wonder if you shouldn't use a per_cpu list of probes,
> spinlocked/irqsaved  accessed
> and also a kind of prevention against nmi.

Sure, cleanup_all_probes() invokes unregister_kprobe() via
unregister_trace_probe(), which waits running probe-handlers by
using synchronize_sched()(because kprobes disables preemption
around its handlers), before free_trace_probe().

So you don't need any locks there :-)

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

