Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZIONnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZIONnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZIONnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:43:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZIONnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:43:42 -0400
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com, "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <4AAF6728.6010807@bk.jp.nec.com>
References: <4AAF6728.6010807@bk.jp.nec.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 09:43:44 -0400
Message-Id: <1253022224.20020.102.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
> Export register_ and unresgister_ftrace_function_probe to modules. This can
> be used by SystemTap.
> 
> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
> ---
>  kernel/trace/ftrace.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5ef8f59..9c32291 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2042,6 +2042,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  
>  	return count;
>  }
> +EXPORT_SYMBOL_GPL(register_ftrace_function_probe);
>  
>  enum {
>  	PROBE_TEST_FUNC		= 1,
> @@ -2108,6 +2109,7 @@ unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  	__unregister_ftrace_function_probe(glob, ops, data,
>  					  PROBE_TEST_FUNC | PROBE_TEST_DATA);
>  }
> +EXPORT_SYMBOL_GPL(unregister_ftrace_function_probe);

I have to NAK this as is. There's a reason I never exported these to
modules, and that is because they are not module safe. There's nothing
to stop a module from registering a probe and then being removed. Then
the function probe will still be called causing a kernel panic.


Now I know of two ways to fix this.

1) The simple way. Up the module ref count so once it registers a
function it can never be disabled. Of course there's the "force module
unload" but people should not do that anyway.

2) Create a second hook handler for modules. That is the function caller
for modules will go to a wrapper first. This wrapper could disable
interrupts or grab a lock or something that would prevent a module from
being unloaded as the hooks are being called. Perhaps even disabling
preemption while calling the hooks will be enough (this is not something
I want the normal function caller to do). And the current function
tracer will optimize that if only one function is registered to mcount,
then the mcount caller will call that function directly.

It will still need to up the mod ref count when a probe is added, but it
can also remove it.


The problem with the current method, is that a probe can be executing at
anytime. Here's an example if we did it your way.

1. module installed
2. module adds probe
3. function X in kernel calls probe but gets preempted.
4. module removes probe
5. module unistalled
6. function X in kernel continues to run probe but probe no longer
exists --- Oops!

-- Steve


