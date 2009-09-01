Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZIAGjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZIAGjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 02:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZIAGjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 02:39:13 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36352 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZIAGjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 02:39:13 -0400
Date: Tue, 1 Sep 2009 12:08:45 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>, David Gibson <dwg@au1.ibm.com>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090901063845.GB25221@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu> <20090826033637.GB6245@nowhere> <20090826091642.GB7743@elte.hu> <20090826114954.GA6009@nowhere> <20090826180245.GA4438@in.ibm.com> <20090829134107.GD24123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090829134107.GD24123@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 03:41:07PM +0200, Ingo Molnar wrote:
> 
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
> > I am not sure if pmus can handle, (or want to handle) all the 
> > intricacies involved with the hw-breakpoint layer [...]
> 
> Which are those intricacies? It's all rather straightforward 
> register scheduling and reservation stuff - which perfcounters 
> already solves in a very rich way.
> 
> 	Ingo

While it is quite true that debug register scheduling and reservation
(using exclusive/pinned properties) are possible through the perf's
implementation, breakpoint exception handling and a provision to invoke
user-defined callback require an extension to the existing perf
implementation (which allows only counting and sampling upon an event,
as I presently understand).

Breakpoint exception handling involving tasks such as filtering stray
exceptions (arising out of breakpoint length limitations), user-defined
callback invocation and signal generation are, as I see not in common
with perf-counter's functionality. And on architectures like PPC64 whose
exception behaviour is 'trigger-before-execute' making it difficult to
bring a 'continuous-trigger' behaviour, sufficient interlocking is necessary
with single-step exception (required for a
bkpt_exception-->disable_bp-->single_step-->enable_bp-->invoke_callback+signal
process).

And post integration, in-kernel users like ptrace, kgdb* and xmon*
which hitherto have interacted directly with the debug registers
(through set_debugreg()/set_dabr()) should route their requests through the
perf-layer. It is difficult to imagine ptrace's idempotent requests
(through ptrace_<get><set>_debugreg()) having to pass through perf-layer
(and becoming dependant on CONFIG_PERF_COUNTERS), not to mention the
tricks required to synchronise signal generation timing with exception
behaviour (especially on PPC64).
* - Not converted to use hw-breakpoint layer yet

With debugging and performance monitoring being two primary uses of
hw-breakpoints (apart from the many niche uses that one can think of),
it would be prudent to retain the breakpoints as a separate layer
allowing exploitation by applications with either needs than to tightly
integrate with perf-counters.

With plenty of users exploiting the breakpoint layer's debugging
capabilities - like SystemTap http://lwn.net/Articles/343581/
(extensible for user-space), ftrace, ptrace and potentially gdbstub
(http://tinyurl.com/gdbstub-prototype), it is but a sad state to keep
the hw-breakpoint layer waiting in-queue for want of performance
monitoring (through perf-counter exploitation/integration).

Thanks,
K.Prasad

