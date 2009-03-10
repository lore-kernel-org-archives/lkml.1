Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZCJR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZCJR0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZCJR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:26:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZCJR02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:26:28 -0400
Date: Tue, 10 Mar 2009 18:26:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090310172605.GA28767@elte.hu>
References: <20090310151828.GM3850@elte.hu> <Pine.LNX.4.44L0.0903101244140.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101244140.3979-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > > > why this redirection, why dont just use the structure as-is? 
> > > > If there's any arch weirdness then that arch should have 
> > > > arch-special accessors - not the generic code.
> > > 
> > > These _are_ the arch-specific accessors.  Look at the 
> > > filename: arch/x86/include/asm/hw_breakpoint.h.
> > 
> > I very well know which file this is, you need to read my reply 
> > again.
> > 
> > These are very generic-sounding fields and they should not be 
> > hidden via pointless wrappers by the generic code. Dont let the 
> > tail wag the dog. If there's architecture weirdness that does 
> > not fit the generic code, then _that_ architecture should have 
> > the ugliness - not the generic code. (note that these accessors 
> > are used by the generic code so the uglification spreads there)
> 
> Hm.  I haven't been keeping careful track of all the updates 
> Prasad has been making.  In my fairly-old copy of the 
> hw-breakpoint work, the accessors are _not_ used by the 
> generic code.  They are there for future users of the API, not 
> for internal use by the API itself.  Is there something I'm 
> missing?

Right, they do seem unused at the moment. I was going over the 
patches and this stuck out as wrong.

> I have the feeling that this doesn't really address your 
> comment, but I'm not sure if that's because I don't understand 
> your point or you don't understand mine...

Removing them addresses my comment.

> > These are very generic-sounding fields ...
> 
> Would you be happier if the field names were changed to be 
> less generic-sounding?

Not sure what to make of this kind of reply. This isnt about me 
being happier. Generic-sounding accessors for generic-sounding 
fields is an easily recognizable pattern for broken design.

> > > > > + int num_installed; /* Number of installed bps */ + 
> > > > > unsigned gennum; /* update-generation number */
> > > > 
> > > > i suspect the gennum we can get rid of if we get rid of the 
> > > > notion of priorities, right?
> > > 
> > > No.  gennum has nothing to do with priorities.
> > 
> > Well it's introduced because we have a priority-sorted list of 
> > breakpoints not an array.
> 
> More generally, it's there because kernel & userspace 
> breakpoints can be installed and uninstalled while a task is 
> running -- and yes, this is partially because breakpoints are 
> prioritized.  (Although it's worth pointing out that even your 
> suggestion of always prioritizing kernel breakpoints above 
> userspace breakpoints would have the same effect.)  However 
> the fact that the breakpoints are stored in a list rather than 
> an array doesn't seem to be relevant.
> 
> > A list needs to be maintained and when updated it's 
> > reloaded.
> 
> The same is true of an array.

Not if what we do what the previous code did: reloaded the full 
array unconditionally. (it's just 4 entries)

> > I was thinking about possibly getting rid of that list 
> > complication and go back to the simpler array. But it's hard 
> > because the lifetime of a kernel space breakpoint spans 
> > context-switches so there has to be separation.
> 
> Yes, kernel breakpoints have to be kept separate from 
> userspace breakpoints.  But even if you focus just on 
> userspace breakpoints, you still need to use a list because 
> debuggers can try to register an arbitrarily large number of 
> breakpoints.

That 'arbitrarily larg number of breakpoints' worries me. It's a 
pretty broken concept for a 4-items resource that cannot be 
time-shared and hence cannot be overcommitted.

Seems to me that much of the complexity of this patchset:

 28 files changed, 2439 insertions(+), 199 deletions(-)

Could be eliminated via a very simple exclusive reservation 
mechanism.

	Ingo
