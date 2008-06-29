Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYF2WzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYF2WzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 18:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYF2WzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 18:55:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46458 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYF2WzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 18:55:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Mon, 30 Jun 2008 00:56:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806292123.16237.rjw@sisk.pl> <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806300056.16399.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 of June 2008, Maciej W. Rozycki wrote:
> On Sun, 29 Jun 2008, Rafael J. Wysocki wrote:
> 
> > >  It is the reverse -- checking the DSDT ID is coarser, matching all the
> > > systems that use the broken firmware.
> > 
> > How can you tell which DSDTs are broken until somebody reports them?
> 
>  We know the DSDT matching OEM ID: "HP ", OEM Table ID: "SB400" and OEM
> Revision: 10000 is broken, because it has already been reported.  If these
> properties are checked, there is no need to for further reports providing
> us with DMI IDs of systems using the same DSDT.  The revision can be used
> to make sure a good one is not selected inadvertently.
> 
> > > With DMI we may face both false positives and false negatives which imply
> > > further maintenance actions.   
> > 
> > With DSDT matching you're likely to end up breaking systems the users of
> > which have not reported problems.
> 
>  s/breaking/fixing/

No.

If your patch is applied in its present form, all of the boxes from HP
nx6x25 series won't work any more, although they worked before.

If you use DSDT matching and all of the DSDTs of these boxes are similarly
broken, which is quite possible, some of them will not be matched and will be
broken.  If you use DMI matching, there's a chance we'll cover all of them.

>  Besides, there is nothing to break here -- the mixed interrupt mode will
> be used when the workaround is selected and the mode has to work or pieces
> of legacy software, such as DOS, which make use of the 8259A would not
> work.

I'm not sure what you mean here.

> > >  Have you tried to report the issue through the usual manufacturer's
> > > support channels, BTW?
> > 
> > My experience with HP indicates that it would have been a loss of time.
> 
>  Well, if you do not report problems, they may never know of their
> existence and obviously will have no way to fix them.  They may ignore
> your report, but at least you can say you have done your part.  Based on
> the experience the next time you may choose another manufacturer when
> making a purchase decision.

Surely I will, but as long as I have the HP box here, I need to live with it.
Also, there are other people who happen to use the affected boxes and do not
expect them to stop working with future kernel releases.

> > Apart from this, I've always been against forcing people to upgrade their
> > BIOSes just because we just had a briliant idea that made the kernel stop
> > working on their systems.  IMO it's extremely user-unfriendly and plain wrong.
> 
>  The BIOS is broken and should be fixed -- it is not our mission to fix up
> somebody else's faults.  As a courtesy to users we may try to work around
> problems that are hard for them to cope with, but in a sense this is
> promoting bad quality of hardware: "Don't bother doing this properly --
> they will fix it up somehow in the OS anyway."
> 
>  You may argue this is a regression,

This IS a regression.

The patch breaks a perfectly working configuration and something like this
_always_ is a regression.  The root cause of this regression may be a BIOS
breakage, but you have to take this into account, this way or another.

We can't really afford breaking working configurations.

>  but this is simply the cost paid for progress -- 

Sorry, with this philosophy I could reject 90% of suspend-related bug reports.

>  the kernel stays within the spec as defined both by ACPI and 
> MPS, we have just started using a different configuration now and an
> interrupt source override provided by the manufacturer explicitly states
> INTIN2 is good to use.  In a sense you were simply lucky previously the
> kernel was bad enough with the way it configured the timer through the I/O
> APIC it failed completely avoiding the bug in your firmware.  Now the bug
> has got uncovered.

No, you are wrong.  The kernel previously _worked_ on the affected boxes and
now it _doesn't_.  The reason why it worked before doesn't matter one whit.

If we did something that made it work despite the BIOS brokenness, we have to
continue doing it on these particular boxes.

>  And last but not least, you can always specify "noapic" to get away --
> that's a perfectly good workaround.

Which was unnecessary before your patch.

>  I'll cook up the part I promised shortly and leave it up to the others to
> "wire" it to some breakage detection logic.

Please do, perhaps I'll be able to fix it up.

Still, you should pay more attention to what your patches may break, IMO,
although those systems may contain broken BIOSes or something.  If they worked
before, they are expected to continue to work and everything that violates this
expectation is a regression.  Sorry, but that's how it goes.

Thanks,
Rafael
