Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbZCTAKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbZCTAKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZCTAKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:10:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbZCTAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:10:06 -0400
Date: Thu, 19 Mar 2009 20:10:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 0/9] tracing: kprobe-based event tracer
In-Reply-To: <49C2B4A4.5060109@redhat.com>
Message-ID: <alpine.DEB.2.00.0903192008450.13615@gandalf.stny.rr.com>
References: <49C2B4A4.5060109@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Mar 2009, Masami Hiramatsu wrote:

> Hi,
> 
> This is a series of patches which introduce a proof-of concept of
> kprobe-based event tracer to ftrace. I think that we could port some
> tracing features from systemtap on this vehicle.
> This can be applied on the linux-2.6-tip tree.
> 
> This patchset includes following changes:
> - Add kprobe-tracer plugin
> - Add kernel_trap_sp() on x86, ia64, power, s390, arm which are
>   ported from systemtap runtime.
> - Add module_*probe api for repawning/removing kprobes when target
>   module is coming/going.
> 
> It's still not unclear that the last module_*probe would better be
> provided as APIs or just embed it in trace_kprobe.c.
> 
> Future items:
> - Use binary print.
> - Add kernel_trap_sp() on other archs.
> - Support symbol-based memory fetching (for global variables)
> - Support primitive types(long, ulong, int, uint, etc) for args.
> - Support indirect memory fetch from register etc.
> - Check insertion point safety by using instruction decoder.
> 
> kprobe-based event tracer
> ---------------------------
> 
> This tracer is similar to the events tracer which is based on Tracepoint
> infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
> and kretprobe). It probes anywhere where kprobes can probe(this means, all
> functions body except for __kprobes functions).
> 
> Unlike the function tracer, this tracer can probe instructions inside of
> kernel functions. It allows you to check which instruction has been executed.
> 
> Unlike the Tracepoint based events tracer, this tracer can add new probe points
> on the fly.
> 
> Similar to the events tracer, this tracer doesn't need to be activated via
> current_tracer, instead of that, just set probe points via
> /debug/tracing/kprobe_probes.
> 
> Synopsis of kprobe_probes:
>   p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]     : set a probe
>   r SYMBOL[+0] [FETCHARGS]                      : set a return probe
> 
>  FETCHARGS:
>   rN    : Fetch Nth register (N >= 0)
>   sN    : Fetch Nth entry of stack (N >= 0)
>   mADDR : Fetch memory at ADDR (ADDR should be in kernel)
>   aN    : Fetch function argument. (N >= 1)(*)
>   rv    : Fetch return value.(**)
>   rp    : Fetch return address.(**)
> 
>   (*) aN may not correct on asmlinkaged functions and at function body.
>   (**) only for return probe.
> 
> E.g.
>   echo p do_sys_open a1 a2 a3 a4 > /debug/tracing/kprobe_probes
> 
>  This sets a kprobe on the top of do_sys_open() function with recording
> 1st to 3rd arguments.

Do you mean 1st to 4th?

> 
>   echo r do_sys_open rv rp >> /debug/tracing/kprobe_probes
> 
>  This sets a kretprobe on the return point of do_sys_open() function with
> recording return value and return address.
> 
>   echo > /debug/tracing/kprobe_probes
> 
>  This clears all probe points. and you can see the traced information via
> /debug/tracing/trace.
> 
>   echo /debug/tracing/trace
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>            <...>-2376  [001]   262.389131: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
>            <...>-2376  [001]   262.391166: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
>            <...>-2376  [001]   264.384876: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
>            <...>-2376  [001]   264.386880: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
>            <...>-2084  [001]   265.380330: do_sys_open: @do_sys_open+0 0xffffff9c 0x804be3e 0x0 0x1b6
>            <...>-2084  [001]   265.380399: sys_open: <-do_sys_open+0 0x3 0xc06e8ebb
> 
>  @SYMBOL means that kernel hits a probe, and <-SYMBOL means kernel returns
> from SYMBOL(e.g. "sysenter_do_call: <-sys_open+0" means kernel returns from
> sys_open to sysenter_do_call).
> 


This looks cool. I'll have to start playing with it.

Thanks,

-- Steve

