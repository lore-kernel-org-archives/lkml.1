Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZIJVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZIJVP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZIJVP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:15:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZIJVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:15:57 -0400
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       roland@redhat.com, rth@redhat.com, mingo@elte.hu
In-Reply-To: <20090907170619.GB6968@Krystal>
References: <cover.1252007851.git.jbaron@redhat.com>
	 <20090907154824.GA1085@Krystal>  <20090907170619.GB6968@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 17:15:59 -0400
Message-Id: <1252617359.18996.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 13:06 -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> [...]
> > > Solution:
> > > 
> > > In discussing this problem with Roland McGrath and Richard Henderson, we came 
> > > up with a new 'asm goto' statement that allows branching to a label. Thus, this
> > > patch set introdues a 'STATIC_JUMP_IF()' macro as follows:
> > > 
> > > #ifdef HAVE_STATIC_JUMP
> > > 
> > > #define STATIC_JUMP_IF(tag, label, cond)                               \
> > >        asm goto ("1:"   /* 5-byte insn */                              \
> > >           P6_NOP5                                                      \
> > 
> > Hrm, be careful there. P6_NOP5 is not always a single instruction. If
> > you are preempted in the middle of it, bad things could happen, even
> > with stop_machine, if you iret in the middle the of the new jump
> > instruction. It could cause an illegal instruction fault. You should use
> > an atomic nop5. I think the function tracer already does, since I
> > told Steven about this exact issue.
> > 
> 
> Just to clarify this statement:
> 
> P6_NOP5 happens to be an atomic nop, but nothing states this requirement
> in arch/x86/include/asm/nops.h. Other 5-bytes nops are defined as
> multiple instructions (e.g. 2 bytes + 3 bytes nops). So I recommend to
> create a family of ATOMIC_P6_NOP5 (and other ATOMIC_*_NOP5 defines) to
> document this atomicity requirement.

Although I agree that we probably should place a comment in that file, I
highly doubt anyone will change that. But who knows?

> 
> Ftrace could probably handle this more gracefully than it does at the
> moment. It basically assumes that P6_NOP5 is atomic, and falls back on a
> 5-bytes jmp if it detects that P6_NOP5 faults.
> 
> That's coherent with the
> "TODO: check the cpuid to determine the best nop."
> 
> present in x86 ftrace.c.
> 
> So, at the very least, if we rely on nops.h having a single-instruction
> P6_NOP5 5 bytes nop, a comment to that effect should be added to nops.h.

I might as well go add one.

-- Steve


