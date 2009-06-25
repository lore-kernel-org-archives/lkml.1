Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZFYMz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZFYMz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZFYMzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:55:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZFYMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:55:49 -0400
Date: Thu, 25 Jun 2009 08:55:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ben Gamari <bgamari.foss@gmail.com>
cc: linux-kernel@vger.kernel.org, "Stone, Joshua I" <joshua.i.stone@intel.com>,
       Rober Richter <robert.richter@amd.com>, anil.s.keshavamurthy@intel.com,
       ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com,
       SystemTap <systemtap@sources.redhat.com>, Eric Anholt <eric@anholt.net>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       intel-gfx@lists.freedesktop.org
Subject: Re: Infrastructure for tracking driver performance events
In-Reply-To: <20090624172912.GB5565@ben-laptop>
Message-ID: <alpine.DEB.2.00.0906241549170.15398@gandalf.stny.rr.com>
References: <20090624172912.GB5565@ben-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Ben Gamari wrote:
> 
> I am investigating how this might be accomplished with existing kernel
> infrastructure. At first, ftrace looked like a promising option, as the
> sysprof profiler is driven by ftrace and provides exactly the type of
> full system backtraces we need. We could probably even accomplish an
> approximation of our desired result by calling a function when we begin
> and another when we end waiting and using a script to look for these
> events. I haven't looked into how we could get a usermode trace with
> this approach, but it seems possible as sysprof already does it.
> 
> While this approach would work, it has a few shortcomings:
> 1) Function graph tracing must be enabled on the entire machine to debug
>    stalls

You can filter on functions to trace. Or add a list of functions
in set_graph_function to just graph a specific list.

> 2) It is difficult to extract the kernel mode callgraph with no natural
>    way to capture the usermode callgraph

Do you just need a backtrace of some point, or a full user mode graph?

> 3) A large amount of usermode support is necessary (which will likely be
>    the case for any option; listed here for completeness)
> 
> Another option seems to be systemtap. It has already been documented[3]
> that this option could provide both user-mode and kernel-mode
> backtraces. The driver could provide a kernel marker at every potential
> wait point (or a single marker in a function called at each wait point,
> for that matter) which would be picked up by systemtap and processed in
> usermode, calling ptrace to acquire a usermode backtrace. This approach
> seems slightly cleaner as it doesn't require the tracing on the entire
> machine to catch what should be reasonably rare events (hopefully).

Enabling the userstacktrace will give userspace stack traces at event
trace points. The thing is that the userspace utility must be built with 
frame pointers.

-- Steve

> 
> Unfortunately, the systemtap approach described in [3] requires that
> each process have an associated "driver" process to get a usermode
> backtrace. It would be nice to avoid this requirement as there are
> generally far more gpu clients than just the X server (i.e. direct
> rendering clients) and tracking them all could get tricky.
> 
> These are the two options I have seen thusfar. It seems like getting
> this sort of information will be increasingly important as more and more
> drivers move into kernel-space and it is likely that the intel
> implementation will be a model for future drivers, so it would be nice
> to implement it correctly the first time. Does anyone see an option
> which I have missed?  Are there any thoughts on any new generic services
> that the kernel might provide that might make this task easier? Any
> comments, questions, or complaints would be greatly appreciated.
> 
