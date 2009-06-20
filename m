Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZFTRki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZFTRki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 13:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZFTRk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 13:40:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZFTRk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 13:40:28 -0400
Date: Sat, 20 Jun 2009 19:40:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: Accessing user memory from NMI
Message-ID: <20090620174022.GA29685@elte.hu>
References: <19001.63708.989256.78908@cargo.ozlabs.ibm.com> <1245314169.13761.23121.camel@twins> <20090620163459.GB12127@elte.hu> <20090620165820.GA23582@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620165820.GA23582@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Thu, 2009-06-18 at 18:20 +1000, Paul Mackerras wrote:
> > >
> > > > What was the conclusion you guys came to about doing a user 
> > > > stack backtrace in an NMI handler?  Are you going to access user 
> > > > memory directly or are you going to use the 
> > > > __fast_get_user_pages approach?
> > > > 
> > > > Ben H and I were talking today about what we'd need in order to 
> > > > be able to read user memory in a PMU interrupt handler.  It 
> > > > looks like we could read user memory directly with a bit of 
> > > > care, on 64-bit at least.  Because of the MMU hash table that 
> > > > would almost always work provided the page has already been 
> > > > touched (which stack pages would have been), but there is a 
> > > > small chance that the access might fail even if the address has 
> > > > a valid PTE.  At that point we could fall back to the 
> > > > __fast_get_user_pages method, but I'm not sure it's worth it.
> > > 
> > > Currently we have the GUP based approach, but Ingo is thikning 
> > > about making the pagefault handler NMI safe on x86 for .32.
> > 
> > Vegard raised the point that making NMIs pagefault-safe is also a 
> > plus for making kmemcheck NMI-safe.
> > 
> > So besides it being faster (direct memory access versus 150 cycles 
> > GUP walk ... per frame entry!), it's also more robust in general.
> > 
> > But too ambitious for v2.6.31 i think, unless patches become ready 
> > really soon. What we have right now is the 64-bit only and 
> > paravirt-unaware half-ported solution below.
> 
> Side note: saving/restoring the cr2 register would additionally be 
> required around page faults in nmi handler in addition to the 
> patch below, both for 32 and 64-bits x86.

Correct, i just mentioned that in another mail - it is required to 
make sure we dont corrupt the main pagefault handler's cr2.

	Ingo
