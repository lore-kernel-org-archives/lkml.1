Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106Ab0ATTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0ATTen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063Ab0ATTem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:34:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40678 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0ATTel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:34:41 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87wrzc39ww.fsf@basil.nowhere.org>
References: <1263740593.557.20967.camel@twins>
	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>	<20100118124419.GC1628@linux.vnet.ibm.com>
	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	 <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi>
	 <1263852957.2266.38.camel@localhost.localdomain>
	 <4B556855.6040800@redhat.com>
	 <1263923265.4998.28.camel@localhost.localdomain>
	 <87wrzc39ww.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Wed, 20 Jan 2010 11:34:12 -0800
Message-Id: <1264016052.5122.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-01-20 at 19:31 +0100, Andi Kleen wrote:
> Jim Keniston <jkenisto@us.ibm.com> writes:
> >
> > I don't know of any such plans, but I'd be interested to read more of
> > your thoughts here.  As I understand it, you've suggested replacing the
> > probed instruction with a jump into an instrumentation vma (the XOL
> > area, or something similar).  Masami has demonstrated -- through his
> > djprobes enhancement to kprobes -- that this can be done for many x86
> > instructions.
> 
> The big problem when doing this in user space is that for 64bit
> it has to be within 2GB of the probed code, otherwise you would
> need to rewrite the instruction to not use any rip relative addressing,
> which can be rather complicated (needs registers, but the instruction
> might already use them, so you would need a register allocator/spilling etc.)

I'm probably telling you stuff you already know, but...

Re: jumps longer than 2GB: The following 14-byte sequence seems to work:
  jmpq *(%rip)
  .quad next_insn
where next_insn is the address of the instruction to which we want to
jump.  We'd need this for boosting, anyway -- to jump from the XOL area
back to the probed instruction stream.

I think djprobes inserts a 5-byte jump at the probepoint; I don't know
whether a 14-byte jump would introduce new difficulties.

Re: rewriting instructions that use rip-relative addressing.  We do that
now.  See handle_riprel_insn() in patch #2.  (As far as we can tell, it
works, but we'd appreciate your review of it.)

> 
> And that 2GB can be anywhere in the address space for shared
> libraries, which might well be already used. A lot of programs
> need large VM areas without holes.
> 
> Also I personally would be unconfortable to let the instruction
> decoder be used by unpriviledged code. Who knows how
> many buffer overflows it has?

The instruction decoder is used only during instruction analysis, while
registering the probe -- i.e., in kernel space.

> 
> In general the trend has been also to make traps faster in the CPU, make 
> sure you're not optimizing for some old CPU here.

I won't argue with that.  What Avi seems to be proposing buys us a
speedup, but at the cost of increased complexity -- among other things,
splitting the instrumentation code between user space (in the "XOL" area
-- which would then be used for much more than XOL instruction slots)
and kernel space.  The splitting would presumably be handled by
higher-level code -- SystemTap, perf, or whatever.  It's a neat idea,
but it seems like a v2 kind of feature.

> 
> -Andi

Jim

