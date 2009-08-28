Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbZH1EHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbZH1EHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZH1EHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:07:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712AbZH1EHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:07:31 -0400
Date: Thu, 27 Aug 2009 21:05:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
In-Reply-To: <4A9744F4.7010208@kernel.org>
Message-ID: <alpine.LFD.2.00.0908272059320.7223@eeepc.linux-foundation.org>
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com> <4A9744F4.7010208@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Aug 2009, Tejun Heo wrote:
> > 
> >     x86: make x86_32 use tlb_64.c
> >     
> >     Impact: less contention when issuing invalidate IPI, cleanup
> >     
> >     Make x86_32 use the same tlb code as 64bit.  The 64bit code uses
> >     multiple IPI vectors for tlb shootdown to reduce contention.  This
> >     patch makes x86_32 allocate the same 8 IPIs as x86_64 and share the
> >     code paths.
> >     
> >     Note that the usage of asmlinkage is inconsistent for x86_32 and 64
> >     and calls for further cleanup.  This has been noted with a FIXME
> >     comment in tlb_64.c.
> >     
> >     Signed-off-by: Tejun Heo <tj@kernel.org>
> > 
> > I can easily hit this bug at this commit, but I ran for a week on the 
> > commit before it. Thus I'm assuming this is the bug (but I'm not 100% 
> > sure).
> 
> Drat, why does it have to be mine?  ;-)
> 
> Joke aside, thank you very much for bisecting it.
> 
> ...
> >> [13288.222084] EIP: 0060:[<c0110821>] EFLAGS: 00000002 CPU: 0
> >> [13288.222084] EIP is at default_send_IPI_mask_logical+0x53/0x92

Is this one perhaps fixed by b04e6373d694 ("x86: don't call 
'->send_IPI_mask()' with an empty mask")

It sounds a _lot_ like that bug. Older dual-cpu x86 box, and APIC getting 
confused by the occasional empty CPU mask, and then subsequent IPI's will 
hang.

		Linus
