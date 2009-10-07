Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbZJGM51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbZJGM51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbZJGM51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:57:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933115AbZJGM50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:57:26 -0400
Subject: Re: [PATCH 1/4] jump label - make init_kernel_text() global
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ak@suse.de,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
In-Reply-To: <20091007023251.GA4664@Krystal>
References: <cover.1253831945.git.jbaron@redhat.com>
	 <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com>
	 <20091001112003.GA2962@elte.hu> <20091001203905.GD2660@redhat.com>
	 <20091003104335.GB15919@elte.hu> <20091003123900.GA22046@Krystal>
	 <1254880478.1696.104.camel@gandalf.stny.rr.com>
	 <20091007023251.GA4664@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 08:56:38 -0400
Message-Id: <1254920198.1696.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 22:32 -0400, Mathieu Desnoyers wrote:

> 
> Hi Steven,
> 
> OK, I'll make the explanation as straightforward as possible. I'll use a
> race example to illustrate what we try to avoid by using the
> breakpoint+ipi scheme. After that, I present the same scenario with the
> breakpoint+ipi in place.
> 
> Each step shows what is executed, and what is the memory values seen by
> the CPU. CPU A is doing the code patching, CPU B executing the code.
> I intentionally left out some sfence required on CPU A for simplicity.)
> 
> Initially, let's say we have:
> (1)  (2)
> 0xeb 0xe5    (jmp to offset 0xe5)
> 
> And we want to change this to:
> (1)  (2)
> 0xeb 0xf0    (jmp to offset 0xf0)
> 
> (scenario "buggy")
> 
> CPU A       |       CPU B  (this is about as far as my ascii-art skills go)
> -------------------------    ;)
> 0xeb 0xe5     0xeb 0xe5
> 0:            CPU B instruction pointer is earlier than (1)
>               CPU B pipeline speculatively predicts branches,
>               prefetches data, calculates speculated values.
> 1:            CPU B loads 0xeb
> 2:            CPU B loads 0xe5
> 3:
> Write to (2)
> 0xeb 0xf0     0xeb 0xf0
> 4:            CPU B instruction pointer gets to (1), needs to validate
>               all the pipeline speculation.
>               But ! The CPU does not expect code to change underneath.
>               General protection fault (or any other fault.. random..)
> 
> 
> Now with the breakpoint+ipi/mb() scheme:
> (scenario A: CPU B does not hit the breakpoint)
> 
> CPU A       |       CPU B
> -------------------------
> 0xeb 0xe5     0xeb 0xe5
> 0:            CPU B instruction pointer is earlier than (1)
>               CPU B pipeline speculatively predicts branches,
>               prefetches data, calculates speculated values.
> 1:            CPU B loads 0xeb
> 2:            CPU B loads 0xe5
> 3:
> Write to (1)
> 0xcc 0xe5     0xcc 0xe5  # breakpoint inserted
> 4: send IPI
> 5:            mfence     # serializing instruction. Flushes CPU B's
>                          # pipeline
> 6:
> Write to (2)
> 0xcc 0xf0     0xcc 0xf0
> 7:
> Write to (1)
> 0xeb 0xf0     0xeb 0xf0
> 8:            CPU B instruction pointer gets to (1), needs to validate
>               all the pipeline speculation. Because we flushed any
>               speculation prior to the mfence, we're ok.
> 
> 
> Now, I'll show why just using the breakpoint, without IPI, is
> problematic:
> 
> CPU A       |       CPU B
> -------------------------
> 0xeb 0xe5     0xeb 0xe5
> 0:            CPU B instruction pointer is earlier than (1)
>               CPU B pipeline speculatively predicts branches,
>               prefetches data, calculates speculated values.
> 1:            CPU B loads 0xeb
> 2:            CPU B loads 0xe5
> 3:
> Write to (1)
> 0xcc 0xe5     0xcc 0xf0  # breakpoint inserted
> 4:
> Write to (2)
> 0xcc 0xf0     0xeb 0xf0  # Silly CPU B. Did not see nor use the breakpoint.
>                          # Same problem as scenario "buggy".
> 5:
> Write to (1)
> 0xeb 0xf0     0xeb 0xf0
> 4:            CPU B instruction pointer gets to (1), needs to validate
>               all the pipeline speculation.
>               But ! The CPU does not expect code to change underneath.
>               General protection fault (or any other fault.. random..)
> 
> So, basically, we ensure that the only transitions CPU B will see are
> either:
> 
> 0xeb 0xe5 -> 0xcc 0xe5 : OK, adding breakpoint
> 0xcc 0xe5 -> 0xcc 0xf0 : OK, not using the operand anyway, it's a
>                              breakpoint!
> 0xcc 0xf0 -> 0xeb 0xf0 : OK, removing breakpoint
> 
> *but*, the transition we guarantee that CPU B will *never* see without
> having a mfence executed between the old and the new version is:
> 
> 0xeb 0xe5 -> 0xeb 0xf0  <----- buggy.
> 
> Hope the explanation helps,

Thanks Mathieu,

This does help explain a lot.

So, basically the IPI is to make sure the int3 is seen by other CPUS
before you modify the jump. Otherwise you risk setting up the int3 and
the other CPU does not see it but still executes the change to the jmp
destination.

I'm assuming that the int3 handler will make the process on CPU B jump
to the next op (one not being modified).

Now we must get from Intel and AMD that it is OK to remove the int3.

-- Steve


