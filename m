Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYLJRe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYLJRe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYLJRer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:34:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48988 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYLJRep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:34:45 -0500
Date: Wed, 10 Dec 2008 18:33:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Frans Pop <elendil@planet.nl>, lenb@kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: "APIC error on CPU1: 00(40)" during resume (was: Regression
	from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500)
Message-ID: <20081210173343.GA1120@elte.hu>
References: <200812020320.31876.rjw@sisk.pl> <200812101506.45691.elendil@planet.nl> <alpine.LFD.2.00.0812100740390.3340@localhost.localdomain> <200812101705.18899.elendil@planet.nl> <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812100819570.3340@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ingo - who's the main apic person these days?

When it comes to blame someone for bugs then it's me :-)

When it comes to code details, it's multiple people: Yinghai, Suresh, 
Venki, Maciej and Thomas, Peter and me as x86 maintainers. I tried to Cc: 
everyone.

> On Wed, 10 Dec 2008, Frans Pop wrote:
> 
> > On Wednesday 10 December 2008, Linus Torvalds wrote:
> > > On Wed, 10 Dec 2008, Frans Pop wrote:
> > > > Anybody interested in persuing this issue?
> > > >
> > > > > The third thing that worries me is the _very_ early occurrence of
> > > > >
> > > > > 	ACPI: Waking up from system sleep state S3
> > > > > 	APIC error on CPU1: 00(40)
> > > > > 	ACPI: EC: non-query interrupt received, switching to interrupt
> > > > > mode
> > >
> > > Well, the "too early" part is fixed with the PCI resume changes in
> > > -next, and googling for "APIC error on CPU1: 00(40)" shows that it's
> > > actually pretty common. Which is sad, but makes it somewhat less scary.
> > >
> > > The fact that it happens at resume for you (and not randomly) does
> > > imply that we perhaps don't have a wonderful APIC wakeup sequence and
> > > are doing something slightly wrong. But it likely isn't a big deal.
> > >
> > > Is that message new? If it is, maybe you can pinpoint roughly when it
> > > started happening, and we could try guess which change triggered it.
> > 
> > It's been there since 2.6.26.3, which was the first kernel I've run on 
> > this notebook.
> 
> Hmm. Our IO-APIC reprogramming looks pretty simple, and may well be 
> correct.
> 
> However, it looks like our _local_ APIC suspend/resume is a total piece 
> of sh*t.  It's set up as a "system device" and has a single 
> suspend/resume buffer, but the local APIC is a per-CPU thing. We even 
> have a comment there (written by yours trule back in 2003!) that says:
> 
>          * FIXME! This will be wrong if we ever support suspend on
>          * SMP! We'll need to do this as part of the CPU restore!
> 
> and back then suspend/resume on SMP was just a crazy notion, but now 
> it's obviously every-day reality.
> 
> So it looks like we don't reprogram the APIC -at-all- on secondary 
> CPU's.
> 
> What am I missing?

we do reset it - local APIC timer IRQs would not be working, the NMI 
watchdog wouldnt be working, we wouldnt be able to do cross-IPIs nor TLB 
flushes etc. - so a non-working lapic is the sure way to a system lockup.
But the resume/hotplug path is still a maze, agreed.

regarding those APIC error messages:

> > > > >       ACPI: Waking up from system sleep state S3
> > > > >       APIC error on CPU1: 00(40)
> > > > >       ACPI: EC: non-query interrupt received, switching to interrupt

that does suggest that the APIC was re-enabled (we dont get any APIC 
error exceptions otherwise!), and its LVT was programmed as well, but 
somehow we got an erroneous APIC message from an illegal vector.

Illegal APIC message vectors can have two sources in practice:

 1) the system bus being thermally unstable and corrupting APIC messages 
    that would randomly contain the wrong vector (zero for example).
    I had one (old) testbox that would do this. (Maybe other hw 
    conditions can animate the southbridge to do this to us too.)

 2) _another CPU_ sending an IPI with an illegal vector field. An APIC 
    vector is 'illegal' if it is below 16 (architecturally protected 
    exception entries), or if it points to an IDT entry that is not
    present.

#2: in this case would mean another CPU has set a target vector smaller
than 16: we dont have any IDT entry that is explicitly non-existent (we 
have a dummy entry mapped for everything). That seems unlikely - but we 
could stick in a WARN_ON_ONCE() into the IPI send methods to catch this. 

[ sidenote: as weird as it might seem it is valid IPI use to trigger
  architectural exception vectors between 16 and 31. ]

#1: seems like a too easy path out to blame the hw for it :-/ By all 
means this has the appearance of kernel-induced damage to me, and seems 
to occur when we fiddle the hw and are in a sensitive path of 
resume-wakeup. I'd blame the kernel 9 times out of 10 bugs that trigger 
at this stage.

Still i have no idea how this APIC message could be kernel-inflicted - 
even assuming buggy resume time lapic setup. The lapic timer cannot 
inject 'bad' vectors to itself AFAIK. It's pretty hard to do it even 
intentionally from another CPU, and when we do it we kill the whole 
system by flooding it with bad IPIs.

Maybe we have a window of setup where one of the LVT entries has zero in 
the vector field but is still enabled, and the hw condition (lapic timer 
tick) happens that triggers the IRQ injection - but the lapic cannot do 
it due to the zero vector? I do not see such window of setup in the APIC 
re-setup codepath though.

Maybe it's the reschedule or TLB flush IPI from another CPU somehow 
hitting the lapic in the wrong moment?

Dunno. Does anyone else on the Cc: list have another theory that matches 
up with some detail of the code?

	Ingo
