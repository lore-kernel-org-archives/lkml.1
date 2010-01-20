Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510Ab0ATU3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0ATU3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015Ab0ATU3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:29:07 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46871 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab0ATU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:29:06 -0500
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
In-Reply-To: <20100120195826.GB24355@basil.fritz.box>
References: <4B545146.3080001@redhat.com>
	 <20100118124419.GC1628@linux.vnet.ibm.com>
	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	 <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi>
	 <1263852957.2266.38.camel@localhost.localdomain>
	 <4B556855.6040800@redhat.com>
	 <1263923265.4998.28.camel@localhost.localdomain>
	 <87wrzc39ww.fsf@basil.nowhere.org>
	 <1264016052.5122.40.camel@localhost.localdomain>
	 <20100120195826.GB24355@basil.fritz.box>
Content-Type: text/plain
Date: Wed, 20 Jan 2010 12:28:45 -0800
Message-Id: <1264019325.5122.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-01-20 at 20:58 +0100, Andi Kleen wrote:
> > Re: rewriting instructions that use rip-relative addressing.  We do that
> > now.  See handle_riprel_insn() in patch #2.  (As far as we can tell, it
> > works, but we'd appreciate your review of it.)
> 
> Yes, but how do you get within 2GB of it?

I'm not sure what you're asking.

To jump between the probed instruction stream and the XOL area, I've
proposed
  jmpq *(%rip)
  .quad next_insn
next_insn is a 64-bit address, which presumably allows you to jump to
anywhere in the address space.

To read/write the memory addressed by a rip-relative instruction, we
convert the rip-relative addressing to indirect addressing through a
64-bit scratch register (whose saved value we restore before returning
to the probed instruction stream).

> Add lots of holes
> in the address space? 

No.

> 
> > The instruction decoder is used only during instruction analysis, while
> > registering the probe -- i.e., in kernel space.
> 
> Registering the user probe? That means if there's a buffer overflow
> in there it would be exploitable.

Certainly a poorly written probe handler would be a problem.  Could you
explain further what you mean?  Are you talking about a buffer overflow
in the probed program?  in the probe handler?  in uprobes?

> 
> > > 
> > > In general the trend has been also to make traps faster in the CPU, make 
> > > sure you're not optimizing for some old CPU here.
> > 
> > I won't argue with that.  What Avi seems to be proposing buys us a
> > speedup, but at the cost of increased complexity -- among other things,
> > splitting the instrumentation code between user space (in the "XOL" area
> > -- which would then be used for much more than XOL instruction slots)
> 
> You can't have a single XOL area, at least not if you want to support
> shared libraries on 64bit & rip relative.

I disagree.  See above.

> 
> > and kernel space.  The splitting would presumably be handled by
> > higher-level code -- SystemTap, perf, or whatever.  It's a neat idea,
> > but it seems like a v2 kind of feature.
> 
> I'm not sure it can even work, unless you severly limited the allowed
> instructions.

I'm not sure it can work, either.  But I still believe that we've
addressed the known issues wrt the big x86_64 address space.

> 
> -Andi
> 

Thanks.
Jim

