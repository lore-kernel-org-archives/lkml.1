Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCFKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCFKwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZCFKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:52:24 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56756 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZCFKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VtGwcHW96v15XP6LlzZiTIX+Do9raHx8H92bz37J4t3tNKWbXi/3zyHZdtZPv/1H+d
         canIfg9BqUyLHtAUlCVo/gBnbYshYtLAGox59fseRsSXpBW12hIT/ngMfVgx2rGnkOVE
         c0KbjCMGEHsKxjCtZ0XQw4qAS3x1Kx4PSc9M4=
Date: Fri, 6 Mar 2009 11:52:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] Binary ftrace_printk
Message-ID: <20090306105217.GB5988@nowhere>
References: <49af5ecb.1c07d00a.32d5.2f45@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49af5ecb.1c07d00a.32d5.2f45@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 05:53:58AM +0100, Frederic Weisbecker wrote:
> 
> This new iteration addresses Steven's reviews.
> Notably:
> 
> - only build the ftrace_printk format section if CONFIG_TRACING is set
> - be scheduler tracing safe (don't use preempt_enable directly from
>   ftrace_printk to avoid tracing recursion)
> - fix a loss of format string when a module is unloaded. Since we can loose
>   it on the ring-buffer if it is in overwrite mode, we don't keep track
>   of the format given by the modules to free them. We just copy their
>   ftrace_printk string format forever. Note that it is safe against duplicate
>   strings since we verify if the string is already present in our list before
>   allocating a new one.
> 
> ---


tip:master has seen some changes concerning the tracing bits since this patchset
submission, notably the movement of ftrace_printk to include/kernel.h

These patches probably won't anymore apply properly.
Do you want me to rebase them against latest tip/master?

Or perhaps you prefer to wait for a Acked-by from Linus or Andrew?

Frederic.


> An new optimization is making its way to ftrace. Its purpose is to
> make ftrace_printk() consuming less memory and become faster.
> 
> Written by Lai Jiangshan, the approach is to delay the formatting
> job from tracing time to output time.
> Currently, a call to ftrace_printk will format the whole string and
> insert it into the ring buffer. Then you can read it on /debug/tracing/trace
> file.
> 
> The new implementation stores the address of the format string and
> the binary parameters into the ring buffer, making the packet more compact
> and faster to insert.
> Later, when the user exports the traces, the format string is retrieved
> with the binary parameters and the formatting job is eventually done.
> 
> Here is the result of a small comparative benchmark while putting the following
> ftrace_printk on the timer interrupt. ftrace_printk is the old implementation,
> ftrace_bprintk is a the new one:
> 
> ftrace_printk("This is the timer interrupt: %llu", jiffies_64);
> 
> After some time running on low load (no X, no really active processes):
> 
> ftrace_printk:  duration average: 2044 ns, avg of bytes stored per entry: 39
> ftrace_bprintk: duration average: 1426 ns, avg of bytes stored per entry: 16
> 
> Higher load (started X and launched a cat running on a X console looping on
> traces printing):
> 
> ftrace_printk:  duration average: 8812 ns
> ftrace_bprintk: duration average: 2611 ns
> 
> Which means the new implementation can be 70 % faster on higher load.
> And it consumes lesser memory on the ring buffer.
> 
> The three first patches rebase against latest -tip the ftrace_bprintk work done
> by Lai few monthes ago.
> 
> The two others integrate ftrace_bprintk as a replacement for the old
> ftrace_printk implementation and factorize the printf style format decoding
> which is now used by three functions.
> 
> Frederic Weisbecker (2):
>   tracing/core: drop the old ftrace_printk implementation in favour of
>     ftrace_bprintk
>   vsprintf: unify the format decoding layer for its 3 users
> 
> Lai Jiangshan (3):
>   add binary printf
>   ftrace: infrastructure for supporting binary record
>   ftrace: add ftrace_bprintk()
> 
>  include/asm-generic/vmlinux.lds.h    |    3 +
>  include/linux/ftrace.h               |   44 ++-
>  include/linux/module.h               |    5 +
>  include/linux/string.h               |    7 +
>  kernel/module.c                      |    6 +
>  kernel/trace/Kconfig                 |    1 +
>  kernel/trace/Makefile                |    1 +
>  kernel/trace/trace.c                 |  141 +++---
>  kernel/trace/trace.h                 |    8 +-
>  kernel/trace/trace_functions_graph.c |    6 +-
>  kernel/trace/trace_mmiotrace.c       |    9 +-
>  kernel/trace/trace_output.c          |   31 +-
>  kernel/trace/trace_output.h          |    2 +
>  kernel/trace/trace_printk.c          |  138 +++++
>  lib/Kconfig                          |    3 +
>  lib/vsprintf.c                       | 1006 ++++++++++++++++++++++++++--------
>  16 files changed, 1087 insertions(+), 324 deletions(-)
>  create mode 100644 kernel/trace/trace_printk.c
> 
> 

