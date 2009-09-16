Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZIPNEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZIPNEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIPNEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:04:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZIPNEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:04:14 -0400
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <4AB08133.4070504@bk.jp.nec.com>
References: <4AAF6728.6010807@bk.jp.nec.com>
	 <1253022224.20020.102.camel@gandalf.stny.rr.com>
	 <4AAF9E30.5030705@redhat.com>
	 <1253024944.20020.109.camel@gandalf.stny.rr.com>
	 <4AB08133.4070504@bk.jp.nec.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 09:04:15 -0400
Message-Id: <1253106255.20020.191.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 15:09 +0900, Atsushi Tsuji wrote:

> > I don't want to disable preemption when I don't have to. The function
> > tracer that is called can. But actually, it's ever more that that. If
> > you only register a single function, it will call that function
> > directly. Then there will always be a race window between when the
> > function gets called and disabling preemption, even if the called
> > function disables preemption as the first thing it does.
> 
> Thank you for detailed explanation.
> 
> I may be wrong, but I think function_trace_probe_call using 
> register_ftrace_function_probe is almost enough for modules,

Heh, I forgot about function_probe. Yeah, looking at that, it does seem
that it would be safe for modules.

> since it disables preemption while a probe is calling and it
> called every time even if only one probe function is registered.
> So is it enough to make a new registering function using
> it and upping module ref count for module safe?  

Yes, upping the module ref count for every function probe would be
required. Unfortunately, this would require adding another variable to
struct ftrace_func_probe, which I hate to do.


> 
> Or should I make another handler for modules not using
> function_trace_probe_call?

Maybe another handler might be better. But it may be similar to
function_probe.

> 
> >>> It will still need to up the mod ref count when a probe is added, but it
> >>> can also remove it.
> >>>
> >>>
> >>> The problem with the current method, is that a probe can be executing at
> >>> anytime. Here's an example if we did it your way.
> >>>
> >>> 1. module installed
> >>> 2. module adds probe
> >>> 3. function X in kernel calls probe but gets preempted.
> >>> 4. module removes probe
> >>> 5. module unistalled
> >>> 6. function X in kernel continues to run probe but probe no longer
> >>> exists --- Oops!
> >> Agreed, if mcount doesn't disable preemption, this will happen.
> > 
> > And it does not.
> 
> I think the preemption is disabled in not register_ftrace_function
> but register_ftrace_function_probe, is that wrong?

No that's correct. It's been a while since I worked on the probe code,
so I forgot about it :-)

-- Steve


