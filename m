Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZIOO3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZIOO3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbZIOO3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:29:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZIOO3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:29:03 -0400
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <4AAF9E30.5030705@redhat.com>
References: <4AAF6728.6010807@bk.jp.nec.com>
	 <1253022224.20020.102.camel@gandalf.stny.rr.com>
	 <4AAF9E30.5030705@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 10:29:04 -0400
Message-Id: <1253024944.20020.109.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 10:01 -0400, Masami Hiramatsu wrote:
> Steven Rostedt wrote:

> > Now I know of two ways to fix this.
> > 
> > 1) The simple way. Up the module ref count so once it registers a
> > function it can never be disabled. Of course there's the "force module
> > unload" but people should not do that anyway.
> > 
> > 2) Create a second hook handler for modules. That is the function caller
> > for modules will go to a wrapper first. This wrapper could disable
> > interrupts or grab a lock or something that would prevent a module from
> > being unloaded as the hooks are being called. Perhaps even disabling
> > preemption while calling the hooks will be enough (this is not something
> > I want the normal function caller to do).
> 
> I think this is better solution.
> Out of curiously, is disabling preemption so harmful?

Yes ;-)

I don't want to disable preemption when I don't have to. The function
tracer that is called can. But actually, it's ever more that that. If
you only register a single function, it will call that function
directly. Then there will always be a race window between when the
function gets called and disabling preemption, even if the called
function disables preemption as the first thing it does.

> 
> > And the current function
> > tracer will optimize that if only one function is registered to mcount,
> > then the mcount caller will call that function directly.
> 
> Would you mean that current mcount hook supports only one handler?

Yes, currently a branch can only got to a single function ;-)

What ftrace does, is if you register a single function, the mcount
location will call that function directly. But if you register an second
function, it changes the mcount call site to call a wrapper that loops
to through all the functions that are registered.

Thus a module version would need to call that wrapper every time. Even
if only one function is called. And this wrapper would have to disable
preemption for the entire loop.


> 
> > 
> > It will still need to up the mod ref count when a probe is added, but it
> > can also remove it.
> > 
> > 
> > The problem with the current method, is that a probe can be executing at
> > anytime. Here's an example if we did it your way.
> > 
> > 1. module installed
> > 2. module adds probe
> > 3. function X in kernel calls probe but gets preempted.
> > 4. module removes probe
> > 5. module unistalled
> > 6. function X in kernel continues to run probe but probe no longer
> > exists --- Oops!
> 
> Agreed, if mcount doesn't disable preemption, this will happen.

And it does not.

-- Steve


