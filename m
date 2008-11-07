Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYKGQJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYKGQJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYKGQJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:09:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36459 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYKGQJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:09:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0811070952150.13034@xanadu.home>
References: <alpine.LFD.2.00.0811070952150.13034@xanadu.home> <20081107003816.9b0f947a.akpm@linux-foundation.org> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org> <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <25363.1226056819@redhat.com> 
To: Nicolas Pitre <nico@cam.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 16:07:34 +0000
Message-ID: <8106.1226074054@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> wrote:

> The whole purpose of that thing is to be utterly fast and lightweight.  
> Having an out of line C call would trash the major advantage of this 
> code.

No argument there.

> > I imagine this would compile pretty much the same as the macro.

Having said that, I realise it's wrong.  The macro potentially takes a h/w
read operation (cnt_lo) and does it at a place of its choosing - which the
compiler may not be permitted to move if cnt_lo resolves to a bit of volatile
inline asm with memory constraints.  Converting it to an inline function
forces cnt_lo to be resolved first.

> Depends.  As everybody has noticed now, the read ordering is important, 
> and if gcc decides to not inline this for whatever reason then the 
> ordering is lost.  This is why this was a macro to start with.

Good point.  I wonder if you should've put a compiler barrier in there to at
least make the point.

> I don't think having the associated storage be outside the macro make any
> sense either.

It can have a comment attached to it to say what it represents.  On the other
hand, it'd probably need further comments attaching to it to fend off people
who start thinking they can make use of this variable in other ways...


> > Alternatively, perhaps Nicolas just needs to mention this in the comment
> > more clearly.
> 
> I wrote that code so to me it is cristal clear already.  Any suggestions 
> as to how this could be improved?

It ought to be, but clearly it isn't.  Sometimes the obvious is all too easy to
overlook.  I'll think about it, but perhaps something like:

 * This macro uses a static internal variable to retain the upper counter.
 * This has two consequences: firstly, it may be used in multiple ways by
 * different callers for different things without interference; and secondly,
 * each caller will get its own, independent counter, and so an out of line
 * wrapper must be used if multiple callers want to use the same pair of
 * counters.

It's a bit heavy-handed, but...

David
