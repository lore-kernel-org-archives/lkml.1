Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYGNRRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYGNRRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYGNRRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:17:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:55151 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbYGNRRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:17:24 -0400
Date: Mon, 14 Jul 2008 19:17:22 +0200
From: Olaf Dabrunz <od@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Message-ID: <20080714171722.GL9434@suse.de>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Stefan Assmann <sassmann@suse.de>,
	LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
	Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
	Felix Foerster <ffoerster@suse.de>
References: <12155255883170-git-send-email-od@suse.de> <20080713210133.GA12362@elte.hu> <200807140924.59023.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807140924.59023.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-Jul-08, Jesse Barnes wrote:
> On Sunday, July 13, 2008 2:01 pm Ingo Molnar wrote:
> > * Olaf Dabrunz <od@suse.de> wrote:
> > > This is against linux-2.6-tip, branch pci-ioapic-boot-irq-quirks.
> > >
> > > The corrected versions of the Broadcom and AMD/ATI boot IRQ quirks,
> > > and a patch that uses DECLARE_PCI_FIXUP_FINAL instead of *_EARLY, and
> > > adds *_RESUME.
> > >
> > > The AMD/ATI SB700S does not need a quirk. The boot IRQs here are
> > > active even when the IO-APIC lines are not masked. So even for
> > > traditional IRQ handling that does not use masking, the boot IRQs need
> > > to be disabled by the BIOS. If there are actual cases of BIOSes that
> > > do not disable these boot IRQs in APIC mode, we could consider
> > > including an SB700S patch. But I doubt this will be needed, as this
> > > problem would quickly surface during testing with any general-purpose
> > > OS.
> > >
> > > The quirk for the AMD 8131 and AMD 8132 takes identical action as an
> > > existing quirk for the AMD 8131 rev. A0 and B0. The existing quirk is
> > > due to an AMD erratum to fix IO-APIC mode. Our patch now deletes the
> > > older quirk and adds a comment to the new one that describes the two
> > > purposes of the quirk.
> >
> > applied to tip/x86/pci-ioapic-boot-irq-quirks, thanks Olaf.
> >
> > Jesse, what do you think about this topic? We are keeping it separate
> > for the time being. They are not particularly pretty, but being able to
> > mask/unmask irqs (without generating those legacy IRQs and creating an
> > IRQ storm) is essential to -rt.
> 
> See my other reply; the branch looks good.  I agree that making sure -rt can 
> work is an important feature.  My only concern is that this is touching so 
> much hardware specific code that *something* is likely to break.  But as long 
> as Olaf & co. can help track down any issues, I'm ok with it.

We should be able to help with issues. We do not think it will be
necessary often.

Here is why we are confident:

We believe the patches that disable boot IRQs are safe. In general this
is code that should be part of the _PIC method in ACPI BIOSes. Some
BIOSes already integrate such code. We basically cover up for BIOSes
that are broken or that simply do not care about RT / threaded IRQs.

The chipsets that do not have an option for disabling the boot IRQs are
handled by the "reroute" workaround. It may increase interrupt sharing
(depending on the IRQ routing of other devices), but makes sure that the
boot IRQ mechanism does not generate two separate IRQs.

This workaround is also pretty safe, as we can follow the IRQ routing
through the chips. One or two recent/upcoming north bridges have
different IRQ handling capabilities, so we need to update the reroute
patch for them. This is WIP.

We take much care to only improve the situation:

    - By default, the safest setting is used. No actions are taken in
      PIC mode. In APIC mode: disable boot IRQs whenever we can,
      "reroute" for RT/threaded IRQ handling, don't reroute for vanilla.
      (The mechanism for the rerouting defaults is in the upcoming
      CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS patch. RT should "select"
      this config option.)

    - Kernel command line options can be used to disable the reroute
      quirks or all quirks.

    - Only known chipsets are handled (-- the reroute patch will be
      updated to also check and handle the north bridge, if necessary).

We are also preparing a paper that should clarify the whole thing, so
the information will not "die with us".

Thanks,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

