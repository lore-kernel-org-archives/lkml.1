Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYG3H2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYG3H2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYG3H2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:28:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYG3H2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:28:46 -0400
Subject: Re: [PATCH 0/5] ftrace: do not trace NMI handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20080730012939.885172468@goodmis.org>
References: <20080730012939.885172468@goodmis.org>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 09:28:05 +0200
Message-Id: <1217402885.6364.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 21:29 -0400, Steven Rostedt wrote:
> The dynamic ftrace code modifies code text at run time. Arjan informed
> me that there is no safe way to modify code text on an SMP system when
> the other CPUs might execute that same code. The reason has to do with
> pipeline caches and CPUs might do funny things if the code being pushed
> in the pipeline also happens to be modified at that same time. (Arjan
> correct me if I'm wrong here).

How does the immediate value stuff get around this issue?

> We use kstop_machine to put the system into a UP like mode. This prevents
> other CPUs from executing code while we modify it. Under stress testing
> Ingo discovered that NMIs can cause the system to crash. This was due
> to NMIs calling code that is being modified. Some boxes are more prone to
> failure than others.
> 
> This series of patches performs two tasks:
> 
>  1) Add notrace to functions called by NMI, or simply remove the tracing
>     completely from files that are primarily used by NMI.
> 
>  2) Add a warning when code that will be modified is called by an NMI.
>     This also disables ftraced when it is detected, to prevent the
>     race with the NMI and code modification from happneing.
> 
> The warning looks something like this:
> 
> --------------- cut here ---------------
> WARNING: ftraced code called from NMI context lapic_wd_event+0xd/0x65
>          Please report this to the ftrace maintainer.
>          Disabling ftraced. Boot with ftrace_keep_on_nmi to not disable.
> Pid: 0, comm: swapper Not tainted 2.6.26-tip #96
> 
> Call Trace:
>  <NMI>  [<ffffffff8021c6d0>] ? lapic_wd_event+0xd/0x65
>  [<ffffffff8027b9c1>] ftrace_record_ip+0xa3/0x357
>  [<ffffffff8020c0f4>] mcount_call+0x5/0x31
>  [<ffffffff8021c6d5>] ? lapic_wd_event+0x12/0x65
>  [<ffffffff804b90d4>] nmi_watchdog_tick+0x21b/0x230
>  [<ffffffff804b8487>] default_do_nmi+0x73/0x1e0
>  [<ffffffff804b8a04>] do_nmi+0x64/0x91
>  [<ffffffff804b80bf>] nmi+0x7f/0x80
>  [<ffffffff80212c14>] ? default_idle+0x35/0x4f
>  <<EOE>>  [<ffffffff8020ae42>] cpu_idle+0x8a/0xc9
>  [<ffffffff804b15a6>] start_secondary+0x172/0x177
> 
> --------------- end cut here ---------------
> 
> 
> This appears once when it is caught. We are hoping that this will not
> appear often, and are running code to catch it as it does.
> 
> -- Steve
> 

