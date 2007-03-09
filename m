Return-Path: <linux-kernel-owner+w=401wt.eu-S1767515AbXCIT0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767515AbXCIT0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767513AbXCIT0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:26:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767511AbXCIT0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:26:08 -0500
Date: Fri, 9 Mar 2007 20:24:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309192420.GA27747@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 9 Mar 2007, Ingo Molnar wrote:
> > 
> > yes - but we already support the raw hardware ABI, in the native 
> > kernel.
> 
> Why do you continue to call paravirt an ABI?
> 
> We got over that. It's not. It's an API.
> 
> VMI is an ABI.

Unfortunately i still dont see where i'm wrong, and i'm really trying to 
understand your argument. Is your argument that as long as an ABI (VMI) 
is never directly used but only used via wrapper functions 
(paravirt_ops), it has no effects whatsoever on the flexibility of the 
rest of the software and ceases to have any negative ABI effects? In my 
opinion that is an absurd (and incorrect) point so i guess you must mean 
something else, but i really cannot think what that is.

I never said paravirt_ops is an ABI. I say that the ABI(s) _behind_ 
paravirt_ops [in the backend] /does/ limit Linux, even if wrapped, 
inevitably, and that i'm simply worried about having 4-5 independent 
ABIs behind each paravirt_ops variant each creating a web of design 
constraints on the rest of the kernel. To quote a past email of mine:

|| 'paravirt ops can take care of it' - but that is just blatantly 
|| _FALSE_: the ABI 'behind' the paravirt_ops 'shines through' via 
|| functional coupling

it doesnt matter in how big letters the wrapper functions have 'freedom' 
written on them, the _real_ constraint is the user's expectation to have 
the hypervisor work with Linux that worked with that particular VMI ABI 
in v2.6.21. So the user wants to have its hypervisor 1.12 work with 
Linux v2.6.22 - without having to update the hypervisor. And Linux 
v2.6.23. Etc. /That/ is the 'ABI effect' i'm worried about. It is a 
"compatibility web" that gets more and more entangled with every new 
paravirt_ops implementation added.
 
In practice, when a problem comes up during code rewrite, 90% of the 
time we can probably find a way around it via paravirt_ops and the 
backend, but i'm simply worried about the remaining 10%. And that 10% is 
not hypothetical at all, should i cite specific examples of problems 
that i think cannot be solved via Linux-only modifications?

I'm also worried about the sheer QA inertia of having an additional 4-5 
hypervisor-ABI constraints on the correctness of the kernel, in addition 
to the 2 main CPU variants we have at the moment.

If we said "paravirt_ops must behave like real hardware" then we'd 
probably remove some of that risk (although enforcement is still an 
issue). But we _specifically_ say that no, it doesnt have to behave like 
real hardware. We allow shortcuts, we allow modifications of behavior - 
and that's good in quite many cases. But we allow really weird hacks 
like the .safe_halt() thing. Our only present requirement it appears is 
that "it works with today's hypervisor" - and that requirement 
automatically transforms itself into: "all future kernels will work with 
all past versions of the hypervisor".

	Ingo
