Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYKGPvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYKGPvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYKGPvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:51:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbYKGPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:51:40 -0500
Date: Fri, 7 Nov 2008 07:50:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: David Howells <dhowells@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-Id: <20081107075003.fa93ccf4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811070952150.13034@xanadu.home>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org>
	<20081107052336.652868737@polymtl.ca>
	<20081107053349.861709786@polymtl.ca>
	<20081106220530.5b0e3a96.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811070256450.13034@xanadu.home>
	<25363.1226056819@redhat.com>
	<alpine.LFD.2.00.0811070952150.13034@xanadu.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 10:01:01 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:

> On Fri, 7 Nov 2008, David Howells wrote:
> 
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > As I said in the text which you deleted and ignored, this would be
> > > better if it was implemented as a C function which requires that the
> > > caller explicitly pass in a reference to the state storage.
> 
> The whole purpose of that thing is to be utterly fast and lightweight.  

Well I'm glad it wasn't designed to demonstrate tastefulness.

btw, do you know how damned irritating and frustrating it is for a code
reviewer to have his comments deliberately ignored and deleted in
replies?

> Having an out of line C call would trash the major advantage of this 
> code.

Not really.

> > I'd be quite happy if it was:
> > 
> > 	static inline u64 cnt32_to_63(u32 cnt_lo, u32 *__m_cnt_hi)
> > 	{
> > 		union cnt32_to_63 __x;
> > 		__x.hi = *__m_cnt_hi;
> > 		__x.lo = cnt_lo;
> > 		if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
> > 			*__m_cnt_hi =
> > 				__x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
> > 		return __x.val;
> > 	}
> > 
> > I imagine this would compile pretty much the same as the macro.
> 
> Depends.  As everybody has noticed now, the read ordering is important, 
> and if gcc decides to not inline this 

If gcc did that then it would need to generate static instances of
inlined functions within individual compilation units.  It would be a
disaster for the kernel.  For a start, functions which are "inlined" in kernel
modules wouldn't be able to access their static storage and modprobing
them would fail.

> for whatever reason then the 
> ordering is lost.

Uninlining won't affect any ordering I can see.

>  This is why this was a macro to start with.
> 
> > I think it
> > would make it more obvious about the independence of the storage.
> 
> I don't think having the associated storage be outside the macro make 
> any sense either.  There is simply no valid reason for having it shared 
> between multiple invokations of the macro, as well as making its 
> interface more complex for no gain.

oh god.

> > Alternatively, perhaps Nicolas just needs to mention this in the comment more
> > clearly.
> 
> I wrote that code so to me it is cristal clear already.  Any suggestions 
> as to how this could be improved?
> 

Does mn10300's get_cycles() really count backwards?  The first two
callsites I looked at (crypto/tcrypt.c and fs/ext4/mballoc.c) assume
that it is an upcounter.

