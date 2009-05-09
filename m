Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZEIEoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZEIEoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 00:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZEIEnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 00:43:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZEIEnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 00:43:52 -0400
Date: Sat, 9 May 2009 06:43:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
	instruction decoder
Message-ID: <20090509044302.GH8007@elte.hu>
References: <20090509004829.5505.38720.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509004829.5505.38720.stgit@localhost.localdomain>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi,
> 
> Here are the patches of kprobe-based event tracer for x86, version 
> 5, which allows you to probe various kernel events through ftrace 
> interface.
> 
> This version supports only x86(-32/-64) (but porting it on other 
> arch just needs kprobes/kretprobes and register and stack access 
> APIs).
> 
> This patchset also includes x86(-64) instruction decoder which 
> supports non-SSE/FP opcodes and includes x86 opcode map. I think 
> it will be possible to share this opcode map with KVM's decoder.
> 
> This series can be applied on the latest linux-2.6-tip tree.
> 
> This patchset includes following changes:
> - Add x86 instruction decoder [1/7]
> - Check insertion point safety in kprobe [2/7]
> - Cleanup fix_riprel() with insn decoder [3/7]
> - Add kprobe-tracer plugin [4/7]
> - Fix kernel_trap_sp() on x86 according to systemtap runtime. [5/7]
> - Add arch-dep register and stack fetching functions [6/7]
> - Support fetching various status (register/stack/memory/etc.) [7/7]
> 
> Future items:
> - .init function tracing support.
> - Support primitive types(long, ulong, int, uint, etc) for args.

Ok, this looks pretty complete already.

Two high-level comments:

 - There's no self-test - would it be possible to add one? See 
   trace_selftest* in kernel/trace/

 - No generic integration.

It would be nice if these ops:

> E.g.
>   echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events
> 
>  This sets a kprobe on the top of do_sys_open() function with recording
> 1st to 4th arguments.
> 
>   echo r do_sys_open rv rp >> /debug/tracing/kprobe_events

were just generally available in just about any other tracer - a bit 
like the event tracer.

It would also be nice to use the 'function attributes' facilities of 
the function tracer, combined with a new special syntax of the 
function-filter regex parser, to enable the recovery of return 
values (or the call arguments), for selected set of functions.

For example, today we can already do things like:

  echo 'sys_read:traceon:4' > /debug/tracing/set_ftrace_filter

for 'trace triggers': the above will trigger tracing to be enabled 
on the entry of sys_read(), 4 times.

Likewise, something like:

  echo 'sys_read:args' > /debug/tracing/set_ftrace_filter
  echo 'sys_read:return' > /debug/tracing/set_ftrace_filter

Could activate kprobes based argument and return-value tracing.

	Ingo
