Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZIXCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZIXCPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZIXCPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 22:15:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:41643 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZIXCPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 22:15:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,442,1249282800"; 
   d="scan'208";a="191030967"
Subject: Re: [BUGFIX 2/2] x86, mce, inject: Make injected mce valid only
 during faked handler call
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090923185333.GA24251@elte.hu>
References: <1253601358.15717.758.camel@yhuang-dev.sh.intel.com>
	 <20090922152347.GB31702@elte.hu>
	 <1253697228.15717.952.camel@yhuang-dev.sh.intel.com>
	 <20090923185333.GA24251@elte.hu>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:15:41 +0800
Message-Id: <1253758541.15717.1029.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip] 
> > > What we want instead is a cleaner design for MCE injection.
> > > 
> > > A cleaner, more workable approach would be to create clean function call 
> > > interfaces for low level hardware that we extract MCE information from. 
> > > Incidentally, such a clean abstraction is mostly what is needed for 
> > > adding generic events as well - so the two go hand in hand.
> > > 
> > > So for example, right now machine_check_poll() does the following, in a 
> > > nutshell:
> > > 
> > >  - reads the global status
> > >  - in a loop:
> > >    - reads the bank status
> > >    - [optional] reads misc
> > >    - [optional] reads addr
> > >    - logs the event
> > >    - writes status
> > > 
> > > the current injector logic is incomplete because it does not allow the 
> > > proper simulation of all aspects of this loop - for example multiple, 
> > > different events pending are not supported.
> > > 
> > > The reason is a bug in its design: it has been shoe-horned into the 
> > > limited concept of write()-ing to /dev/mcelog and building something 
> > > from there - while in reality an MCE message is not demux-able in the 
> > > multi-message scenario.
> > > 
> > > A cleaner structure of this code would be:
> > > 
> > >  - reads the global status
> > >  - in a loop:
> > >    - reads the bank status
> > >    - [optional] reads misc
> > >    - [optional] reads addr
> > >    - lowlevel_mce_event(gstatus, status, misc, addr);
> > >    - writes status
> > > 
> > > And then hooking up the injector with lowlevel_mce_event(), not by 
> > > trying to shoehorn it into at the MSR level via mce_rdmsr().
> > > 
> > > I.e. first minimally extract raw hardware info - then pass that to a mid 
> > > level function. The injector can then interface into this mid level 
> > > function.
> > > 
> > > Note, there wouldnt be need for the 'injectm' mess either - which caused 
> > > this bug to begin with. The injector injects into the mid level function 
> > > - which from that point on does not care whether it's an injected 
> > > message or not. (_maybe_ pass along a status flag that directs the 
> > > mid-level function to for example not panic the system - but otherwise 
> > > dont do this kind of messy injectm driven global state logic.)
> > > 
> > > A _real_ injector would work at the hardware level anyway, or could 
> > > perhaps be done as a KVM extension to simulate the MCE MSR environment 
> > > much more fully - there's no way to simulate all aspects of MCEs and 
> > > doing it at the rdmsr level here with simulated state from an injected 
> > > struct mce is pretty limiting and incomplete.
> > 
> > So the error record processing logic should be in 
> > lowlevel_mce_event()? If so, one issue of this solution is that 
> > sometimes we need look at all events before deciding what to do. For 
> > example, there is one corrected error, one recoverable error and one 
> > fatal error in error banks, we should go panic directly instead of 
> > trying to recover firstly.
> 
> Correct - and the way the current code does it is absolutely messy. It 
> mixes the 'have to panic' logic with the message construction logic and 
> does a loop over all banks to see whether there's a panic message there 
> - missing the crutial fact that if we are going to panic there's no 
> message to deliver ...
> 
> The other thing it misses is that MCE conditions are fundamentally 
> asynchronous. The MCE message might have a propagation delay to begin 
> with - plus there's the corrected messages that we poll. And even 
> assuming totally instant MCE propagation a new bank condition might pop 
> up with a new error right while we are processing an exception.

Yes. MCE is asynchronous. If the new-coming MCE message is:

- uncorrected MC, according to IA-32 software developer's manual v3a
15.3.1.2, if MCIP is set, system will go shutdown, if MCIP is cleared by
software upon entering MCE handler, another MC exception will be
triggered, which will make situation more complex. Because new MC seldom
comes in MCE handler, I think it is easier to let system go shutdown for
this situation.

- corrected MC, your method will log more corrected messages. But there
may be too many corrected messages, so I think we should set a threshold
to deal with this.

> So the whole logic in do_machine_check() is misguided from the get go.
> 
> > For supporting injecting multiple MCE on one cpu with injectm, we have 
> > plan to do this. May need more inject flags to make this works.
> 
> Fixing the code can remove limitations.
> 
> > All in all, I think current MCE handling and injecting design just 
> > works. And it is quite simple. I think your design and current design 
> > is different mainly on flavor. Do you think so?
> 
> No, i dont.
> 
> It should all be done and coded cleanly first and foremost. Would you be 
> willing to help out with that?
> 
> The very first step must be to clean up the data structures. 'struct 
> mce' is a misnomer and one big layering violation. It can contain bank 
> state, message to user-space, message from user-space and injection 
> state - and it also contains global state, and even configuration state. 
> It's sometimes named 'm', sometimes 'a', sometimes 'msg' - it is one big 
> mess.
> 
> Instead there should be clearly named structures with one, well-defined 
> purpose per structure. Such as:
> 
>  struct cpu_mce_state {
> 	u64	global_status;
> 	u64	global_ctrl;
> 	u64	capabilities;
>  };
> 
>  struct mce_error_state {
> 	u64	status;
> 	u64	misc;
> 	u64	addr;
> 	u64	ip;
> 	u64	cs;
>  };
> 
> etc. - and then work from such a simple and clear core of abstractions.
> 
> The whole do_machine_check() bank reading code should be restructured to 
> be a 'retry until all banks are clear' loop - to allow for asynchronous 
> events to be recognized during the pass. Especially if an action that 
> has to be taken takes some time to do, we will act properly.
> 
> The hardware itself will redo the MCE in that case as well - but it's 
> better to recognize this in the main event loop already.
> 
> Furthermore, such a loop would allow the clean prioritization of banks, 
> by separating out an extra function for that purpose:
> 
> 	for (;;) {
> 		bank_id = get_highest_prio_bank();
> 		if (bank_nr < 0)
> 			break;
> 
> 		process_bank_event(bank_id);
> 	}
> 
> The current code is clearly buggy as it incorrectly assumes that no new 
> events may arrive while we are processing events.

As I described above, it seems that we need not worry too much about at
least uncorrected new coming events.

Best Regards,
Huang Ying


