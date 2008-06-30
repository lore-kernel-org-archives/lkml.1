Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYF3BCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYF3BCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 21:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYF3BCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 21:02:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64294 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752064AbYF3BCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 21:02:30 -0400
Date: Mon, 30 Jun 2008 02:00:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806300056.16399.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806300003080.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806292123.16237.rjw@sisk.pl>
 <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl> <200806300056.16399.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Rafael J. Wysocki wrote:

> > > With DSDT matching you're likely to end up breaking systems the users of
> > > which have not reported problems.
> > 
> >  s/breaking/fixing/
> 
> No.
> 
> If your patch is applied in its present form, all of the boxes from HP
> nx6x25 series won't work any more, although they worked before.

 I have not proposed a patch to do DSDT matching, so you mean Matthew's 
patch, right?  Well, there are two possibilities -- either a true or a 
false positive.  For a true positive, the patch will work around the DSDT 
problem by disabling the I/O APIC route for the timer interrupt.  For a 
false positive, the effect will be the same, although unnecessary.  I am 
not sure what you think will not work anymore.

> If you use DSDT matching and all of the DSDTs of these boxes are similarly
> broken, which is quite possible, some of them will not be matched and will be
> broken.  If you use DMI matching, there's a chance we'll cover all of them.

 The DSDT is clearly associated with the SB400 southbridge.  I would not
expect a given make and model to use different southbridges across the
series, so there will only be one DSDT per model, possibly in a number of
revisions.  On the other hand different models may use the same
southbridge and hence the same DSDT.

 Note that Matthew's made a point here, that apparently there are only two 
models using this southbridge and new ones are unlikely to be released, so 
my note is for a reference only.

> >  Besides, there is nothing to break here -- the mixed interrupt mode will
> > be used when the workaround is selected and the mode has to work or pieces
> > of legacy software, such as DOS, which make use of the 8259A would not
> > work.
> 
> I'm not sure what you mean here.

 The workaround makes the system use the mixed interrupt mode (well, to 
be honest, it is a simplification, because LINT0 is tried as a native 
interrupt before falling back to ExtINTA), which means some interrupts go 
through the I/O APIC and some go through the 8259A.  The route through the 
8259A has to work, because otherwise legacy software would fail.

 Without the workaround the APIC mode would be used, where all interrupts
go through the I/O APIC (but it fails on your system).

 The third alternative is the virtual-wire mode, the default at the
bootstrap (or IOW the point control is passed to Linux from the firmware)
and then forced to stay with the "noapic" option, where all interrupts go
through the 8259A.

> >  Well, if you do not report problems, they may never know of their
> > existence and obviously will have no way to fix them.  They may ignore
> > your report, but at least you can say you have done your part.  Based on
> > the experience the next time you may choose another manufacturer when
> > making a purchase decision.
> 
> Surely I will, but as long as I have the HP box here, I need to live with it.
> Also, there are other people who happen to use the affected boxes and do not
> expect them to stop working with future kernel releases.

 There's always the "noapic" option.  It was added for the very purpose of
dealing with various kinds of breakages manufacturers have been happy to
put into I/O APIC interrupts for years and is meant to work.  Please
report if there is a problem with the option with your system.

> >  The BIOS is broken and should be fixed -- it is not our mission to fix up
> > somebody else's faults.  As a courtesy to users we may try to work around
> > problems that are hard for them to cope with, but in a sense this is
> > promoting bad quality of hardware: "Don't bother doing this properly --
> > they will fix it up somehow in the OS anyway."
> > 
> >  You may argue this is a regression,
> 
> This IS a regression.
> 
> The patch breaks a perfectly working configuration and something like this
> _always_ is a regression.  The root cause of this regression may be a BIOS
> breakage, but you have to take this into account, this way or another.
> 
> We can't really afford breaking working configurations.

 Noted, with the exception yours is not a "perfectly working
configuration" -- notice how the timer interrupt is set up twice and fails
before the third fallback recovers.  If not our persistence to keep it
going despite breakage of hardware we would have panic()ked at the very
first failure.  Now the attempts have been improved so that the second one
already succeeds, but it does not make your piece of hardware less broken.

> >  but this is simply the cost paid for progress -- 
> 
> Sorry, with this philosophy I could reject 90% of suspend-related bug reports.

 Are these genuine bugs in code you take responsibility for or bugs in
some other code?

> >  the kernel stays within the spec as defined both by ACPI and 
> > MPS, we have just started using a different configuration now and an
> > interrupt source override provided by the manufacturer explicitly states
> > INTIN2 is good to use.  In a sense you were simply lucky previously the
> > kernel was bad enough with the way it configured the timer through the I/O
> > APIC it failed completely avoiding the bug in your firmware.  Now the bug
> > has got uncovered.
> 
> No, you are wrong.  The kernel previously _worked_ on the affected boxes and
> now it _doesn't_.  The reason why it worked before doesn't matter one whit.
> 
> If we did something that made it work despite the BIOS brokenness, we have to
> continue doing it on these particular boxes.

 This is what the specs are for to resolve.  We keep to the spec on one
side and the hardware/firmware has to on the other -- this is a contract 
set between components.  Not some particular version of a piece of 
software or equipment.  If we stopped using parts of some spec, because 
there are broken pieces of equipment out there, then we would soon reach 
the point we could not use the spec at all.

 To give you an example: let's assume we have a class of hardware which
comes in two generations, G1 and G2.  Both generations were designed to a
separate open spec each and the newer one may optionally implement a
crippled legacy mode where the older revision of the spec is used;
initially all G2 hardware implements this mode.

 Let's assume we have version V1 of Linux which supports the legacy mode
only, which works correctly with all known G1 and G2 hardware at the time
of its release.  Now in version V2 (V2 = V1 + 1) native Linux support for
G2 hardware has been added.  Unfortunately one of the manufacturers of G2
hardware misinterpreted the spec for its H2 and an essential status bit B2
is negated compared to the spec and to all the other pieces of G2
hardware.  As a result, code updated to work with G2 natively does not
work on this H2 piece of equipment.

 This is clearly a regression, because this H2 piece of equipment used to
work flawlessly before.  What should we do then?  I think we have four
notable choices:

1. Ignore all the mix-up and blame the manufacturer.  The hardware is
   faulty and it is up to users to return it to the supplier for money 
   back.

2. Scrap all the G2 support because it introduces a regression.  We were 
   not fast enough to implement it before someone broke the spec and we
   are doomed.  Sorry.

3. Add an option that would flip the meaning of B2 or force the legacy 
   mode.  This way there is no negative impact on good G2 hardware

4. Discover and special-case H2, proceeding with the option #3 as above 
   automatically.  Likewise, no negative impact.

 In an ideal world (but not as ideal for hardware bugs not to happen) the
#1 would be the natural option -- the offender would pay the price of
their mistake.  Unfortunately we do not live in an ideal world and expect
the offender to ignore the blame.  Therefore we are left with the
remaining options.  You seem to insist on the #2 and I argue for either
the #3 or the #4.

 All of the three deal with the problem somehow.  Unfortunately I fail to
see any advantage from the #2, but I look forward to justification I may
have missed.  OTOH, the disadvantage from the #3 is negligible -- an 
additional option put somewhere -- and there is no disadvantage from the 
#4 that I would recognise.  Therefore I fail to see why the #2 would have 
to be chosen.

> >  And last but not least, you can always specify "noapic" to get away --
> > that's a perfectly good workaround.
> 
> Which was unnecessary before your patch.

 It would not be necessary with your piece of hardware running Linux 2.2
too.  My old SMP board (mentioned in another mail in this thread) stopped
working without "noapic" at one point because of its MP table breakage too
and yet "noapic" has not become the default since then.

> >  I'll cook up the part I promised shortly and leave it up to the others to
> > "wire" it to some breakage detection logic.
> 
> Please do, perhaps I'll be able to fix it up.

 Nothing to do from your side except from further testing perhaps as I
think we have agreed upon Matthew's proposal.  I'll try to get it wrapped
up today, though not necessarily before the noon. ;)

> Still, you should pay more attention to what your patches may break, IMO,
> although those systems may contain broken BIOSes or something.  If they worked
> before, they are expected to continue to work and everything that violates this
> expectation is a regression.  Sorry, but that's how it goes.

 It is not the lack of attention -- please do me a favour and try not to
give me unjustified pieces of advice.  Thank you.

 I have explicitly warned the patch may break things and was pretty much
confident it would -- see my comment accompanying the original submission
at "http://lkml.org/lkml/2008/5/27/306".  I was pretty much confident it
would fix more systems than it would break too.  We are dealing with
substandard hardware/firmware here and these painful efforts should not be
necessary at all in the first place.  Your system is an example of a
particularly degenerate breakage, where the mode of failue triggered is
not immediately disastrous, and you are lucky a culprit has been found at
all.

 In all cases thanks a lot for your testing -- you have just uncovered one
example of the inevitable and I am trying to tackle it the best way
possible.

  Maciej
