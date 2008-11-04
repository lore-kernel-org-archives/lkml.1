Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYKDU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYKDU6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYKDU6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:58:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45598 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYKDU6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:58:11 -0500
Date: Tue, 4 Nov 2008 22:06:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104210643.GH29626@one.firstfloor.org>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104204400.GC10825@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 09:44:00PM +0100, Ingo Molnar wrote:
> 
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > On Tue, 4 Nov 2008 18:05:01 +0100, "Andi Kleen" <andi@firstfloor.org>
> > said:
> > > > not taking into account the cost of cs reading (which I
> > > > don't suspect to be that expensive apart from writting,
> > > 
> > > GDT accesses have an implied LOCK prefix. Especially
> > > on some older CPUs that could be slow.
> > > 
> > > I don't know if it's a problem or not but it would need
> > > some careful benchmarking on different systems to make sure interrupt 
> > > latencies are not impacted.
> 
> That's not a real issue on anything produced in this decade as we have 
> had per CPU GDTs in Linux for about a decade as well.
> 
> It's only an issue on ancient CPUs that export all their LOCKed cycles 
> to the bus. Pentium and older or so. The PPro got it right already.

???  LOCK slowness is not because of the bus. And I know you know 
that Ingo, so I don't know why you wrote that bogosity above.

> What matters is what i said before: the actual raw cycle count before 
> and after the patch, on the two main classes of CPUs, and the amount 

iirc there are at least between three and five classes of CPUs that
matter (P6, K8, P4 and possibly Atom and C3). But I would only
expect P4 to be a real problem.

> > That's good to know. I assume this LOCKed bus cycle only occurs if 
> > the (hidden) segment information is not cached in some way? How many 
> > segments are typically cached? In particular, does it optimize 
> > switching between two segments?
> > 
> > > Another reason I would be also careful with this patch is that it 
> > > will likely trigger slow paths in JITs like qemu/vmware/etc.
> > 
> > Software can be fixed ;).
> 
> Yes, and things like vmware were never a reason to hinder Linux.

Hopefully the users agree with you on that.

But anyways having to fix the JIT for saving 3-5k of memory would seem
like a bad payoff in terms of effort:gain. Yes I know you personally
wouldn't need to fix them, but wasting other engineer's time is nearly
as bad as your own.

> > > An alternative BTW to having all the stubs in the executable would 
> > > be to just dynamically generate them when the interrupt is set up. 
> > > Then you would only have the stubs around for the interrupts which 
> > > are actually used.
> > 
> > I was trying to simplify things, not make it even less transparent 
> > ;).

Doesn't make sense to me. The current code is not complex at all,
just not particularly efficient. Yours might be better (at some 
risk), but simpler is probably not the right word to describe it.

> 
> yep, the complexity of dynamic stubs is the last thing we need here.

I don't think it's particularly complex. You just have a few bytes
and you fill in the number and the target.

-Andi
