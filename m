Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZIWSxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZIWSxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIWSxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:53:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZIWSxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:53:45 -0400
Date: Wed, 23 Sep 2009 20:53:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX 2/2] x86, mce, inject: Make injected mce valid only
	during faked handler call
Message-ID: <20090923185333.GA24251@elte.hu>
References: <1253601358.15717.758.camel@yhuang-dev.sh.intel.com> <20090922152347.GB31702@elte.hu> <1253697228.15717.952.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253697228.15717.952.camel@yhuang-dev.sh.intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> On Tue, 2009-09-22 at 23:23 +0800, Ingo Molnar wrote: 
> > * Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > In current implementation, injected mce is valid from MCE is injected 
> > > to MCE is processed by faked handler call. It is possible for it to be 
> > > consumed by real machine_check_poll. This may confuse real system 
> > > error and mce test suite.
> > > 
> > > To fix this, this patch introduces another flag MCJ_VALID to indacate 
> > > the MCE entry is valid for injector but not for handler, while 
> > > mce.finished is used to indicate the MCE entry is valid for handler. 
> > > mce.finished is enabled only during faked MCE handler call and 
> > > protected by IRQ disabling. This make it impossible for real 
> > > machine_check_poll to consume it.
> > > 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > here's a fixed up changelog for that, please use it for subsequent 
> > submissions:
> > 
> >  In the current implementation, injected MCE is valid from the point
> >  the MCE is injected to the point the MCE is processed by the faked
> >  handler call.
> > 
> >  This has an undesired side-effect: it is possible for it to be
> >  consumed by real machine_check_poll. This may confuse a real system
> >  error and may confuse the mce test suite.
> > 
> >  To fix this, this patch introduces another flag MCJ_VALID to
> >  indicate that the MCE entry is valid for injector but not for the
> >  handler. Another flag, mce.finished is used to indicate the MCE
> >  entry is valid for the handler.
> > 
> >  mce.finished is enabled only during faked MCE handler call and
> >  protected by IRQ disabling. This make it impossible for real
> >  machine_check_poll to consume it.
> 
> Thank you. I will use this. Sorry for my poor English. 
> 
> > > ---
> > >  arch/x86/include/asm/mce.h              |   17 +++++++++++------
> > >  arch/x86/kernel/cpu/mcheck/mce-inject.c |   23 ++++++++++++++++-------
> > >  2 files changed, 27 insertions(+), 13 deletions(-)
> > > 
> > > --- a/arch/x86/include/asm/mce.h
> > > +++ b/arch/x86/include/asm/mce.h
> > > @@ -38,13 +38,18 @@
> > >  #define MCM_ADDR_MEM	 3	/* memory address */
> > >  #define MCM_ADDR_GENERIC 7	/* generic */
> > >  
> > > -#define MCJ_CTX_MASK		3
> > > +#define _MCJ_NMI_BROADCAST	2    /* do NMI broadcasting */
> > > +#define _MCJ_EXCEPTION		3    /* raise as exception */
> > > +#define _MCJ_VALID		4    /* entry is valid for injector */
> > > +
> > > +#define MCJ_CTX_MASK		0x03
> > >  #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
> > > -#define MCJ_CTX_RANDOM		0    /* inject context: random */
> > > -#define MCJ_CTX_PROCESS		1    /* inject context: process */
> > > -#define MCJ_CTX_IRQ		2    /* inject context: IRQ */
> > > -#define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
> > > -#define MCJ_EXCEPTION		8    /* raise as exception */
> > > +#define MCJ_CTX_RANDOM		0x00    /* inject context: random */
> > > +#define MCJ_CTX_PROCESS		0x01    /* inject context: process */
> > > +#define MCJ_CTX_IRQ		0x02    /* inject context: IRQ */
> > > +#define MCJ_NMI_BROADCAST	(1 << _MCJ_NMI_BROADCAST)
> > > +#define MCJ_EXCEPTION		(1 << _MCJ_EXCEPTION)
> > > +#define MCJ_VALID		(1 << _MCJ_VALID)
> > 
> > This is ugly and fragile. MCJ_VALID and _MCJ_VALID are both integers and 
> > just a single unremarkable character of a typo away from doing the wrong 
> > thing.
> > 
> > Please use the standard kernel convention to distinguish to name bits 
> > and masks:
> > 
> >   MCJ_VALID_BIT
> >   MCJ_VALID_MASK
> 
> OK. I will change this.
> 
> > That makes it far less likely to typo them - and it also makes the end 
> > result far more readable.
> > 
> > Furthermore, please use better names for these constants.
> > 
> > For example MJC_VALID is a misnomer: it indicates that the message is 
> > 'valid'. While in reality it wants to say that the message is 
> > 'artificial' and should not be handled by a real #MC event.
> > 
> > Also, what does MCJ mean? It has absolutely zero first-glance meaning, 
> > which is not good.
> 
> MCJ_ stands for "MCe inJect", this is not a good abbreviate, maybe
> MCE_INJ_ is better.
> 
> About MCJ_VALID, what about MCE_INJ_LOADED?
> 
> > >  /* Fields are zero when not available */
> > >  struct mce {
> > > --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > > +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> > > @@ -32,16 +32,16 @@ static void inject_mce(struct mce *m)
> > >  
> > >  	/* Make sure noone reads partially written injectm */
> > >  	i->finished = 0;
> > > +	clear_bit(_MCJ_VALID, (unsigned long *)&i->inject_flags);
> > 
> > Most of arch/x86/kernel/cpu/mcheck/mce-inject.c is rather ugly. 
> > mce->inject_flag is u8 due to a silly ABI and (unsigned long *)
> > casts now litter the code.
> 
> mce->inject_flag is u8, because we do not need many flags. In
> fact, /dev/mcelog is extensible as for error record (struct mce) size.
> It is possible to make mce->inject_flag larger, just not necessary.
> 
> > What we want instead is a cleaner design for MCE injection.
> > 
> > A cleaner, more workable approach would be to create clean function call 
> > interfaces for low level hardware that we extract MCE information from. 
> > Incidentally, such a clean abstraction is mostly what is needed for 
> > adding generic events as well - so the two go hand in hand.
> > 
> > So for example, right now machine_check_poll() does the following, in a 
> > nutshell:
> > 
> >  - reads the global status
> >  - in a loop:
> >    - reads the bank status
> >    - [optional] reads misc
> >    - [optional] reads addr
> >    - logs the event
> >    - writes status
> > 
> > the current injector logic is incomplete because it does not allow the 
> > proper simulation of all aspects of this loop - for example multiple, 
> > different events pending are not supported.
> > 
> > The reason is a bug in its design: it has been shoe-horned into the 
> > limited concept of write()-ing to /dev/mcelog and building something 
> > from there - while in reality an MCE message is not demux-able in the 
> > multi-message scenario.
> > 
> > A cleaner structure of this code would be:
> > 
> >  - reads the global status
> >  - in a loop:
> >    - reads the bank status
> >    - [optional] reads misc
> >    - [optional] reads addr
> >    - lowlevel_mce_event(gstatus, status, misc, addr);
> >    - writes status
> > 
> > And then hooking up the injector with lowlevel_mce_event(), not by 
> > trying to shoehorn it into at the MSR level via mce_rdmsr().
> > 
> > I.e. first minimally extract raw hardware info - then pass that to a mid 
> > level function. The injector can then interface into this mid level 
> > function.
> > 
> > Note, there wouldnt be need for the 'injectm' mess either - which caused 
> > this bug to begin with. The injector injects into the mid level function 
> > - which from that point on does not care whether it's an injected 
> > message or not. (_maybe_ pass along a status flag that directs the 
> > mid-level function to for example not panic the system - but otherwise 
> > dont do this kind of messy injectm driven global state logic.)
> > 
> > A _real_ injector would work at the hardware level anyway, or could 
> > perhaps be done as a KVM extension to simulate the MCE MSR environment 
> > much more fully - there's no way to simulate all aspects of MCEs and 
> > doing it at the rdmsr level here with simulated state from an injected 
> > struct mce is pretty limiting and incomplete.
> 
> So the error record processing logic should be in 
> lowlevel_mce_event()? If so, one issue of this solution is that 
> sometimes we need look at all events before deciding what to do. For 
> example, there is one corrected error, one recoverable error and one 
> fatal error in error banks, we should go panic directly instead of 
> trying to recover firstly.

Correct - and the way the current code does it is absolutely messy. It 
mixes the 'have to panic' logic with the message construction logic and 
does a loop over all banks to see whether there's a panic message there 
- missing the crutial fact that if we are going to panic there's no 
message to deliver ...

The other thing it misses is that MCE conditions are fundamentally 
asynchronous. The MCE message might have a propagation delay to begin 
with - plus there's the corrected messages that we poll. And even 
assuming totally instant MCE propagation a new bank condition might pop 
up with a new error right while we are processing an exception.

So the whole logic in do_machine_check() is misguided from the get go.

> For supporting injecting multiple MCE on one cpu with injectm, we have 
> plan to do this. May need more inject flags to make this works.

Fixing the code can remove limitations.

> All in all, I think current MCE handling and injecting design just 
> works. And it is quite simple. I think your design and current design 
> is different mainly on flavor. Do you think so?

No, i dont.

It should all be done and coded cleanly first and foremost. Would you be 
willing to help out with that?

The very first step must be to clean up the data structures. 'struct 
mce' is a misnomer and one big layering violation. It can contain bank 
state, message to user-space, message from user-space and injection 
state - and it also contains global state, and even configuration state. 
It's sometimes named 'm', sometimes 'a', sometimes 'msg' - it is one big 
mess.

Instead there should be clearly named structures with one, well-defined 
purpose per structure. Such as:

 struct cpu_mce_state {
	u64	global_status;
	u64	global_ctrl;
	u64	capabilities;
 };

 struct mce_error_state {
	u64	status;
	u64	misc;
	u64	addr;
	u64	ip;
	u64	cs;
 };

etc. - and then work from such a simple and clear core of abstractions.

The whole do_machine_check() bank reading code should be restructured to 
be a 'retry until all banks are clear' loop - to allow for asynchronous 
events to be recognized during the pass. Especially if an action that 
has to be taken takes some time to do, we will act properly.

The hardware itself will redo the MCE in that case as well - but it's 
better to recognize this in the main event loop already.

Furthermore, such a loop would allow the clean prioritization of banks, 
by separating out an extra function for that purpose:

	for (;;) {
		bank_id = get_highest_prio_bank();
		if (bank_nr < 0)
			break;

		process_bank_event(bank_id);
	}

The current code is clearly buggy as it incorrectly assumes that no new 
events may arrive while we are processing events.

Ok?
 	
	Ingo
