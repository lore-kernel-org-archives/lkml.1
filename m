Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYFCRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYFCRLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYFCRIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:08:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:39014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502AbYFCRIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:08:10 -0400
Date: Tue, 3 Jun 2008 19:08:41 +0200
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Olaf Dabrunz <od@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
Message-ID: <20080603170841.GI27585@suse.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Stefan Assmann <sassmann@suse.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <12124107071847-git-send-email-od@suse.de> <alpine.LFD.1.10.0806031201010.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0806031201010.3235@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas, :)

On 03-Jun-08, Thomas Gleixner wrote:
> Olaf,
> 
> On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> > These patches are against linux-2.6-tip, auto-x86-next.
> > 
> > When IRQ lines on secondary or higher IO-APICs are masked (as done by
> > RT and others), many chipsets redirect IRQs on this line to the PIC, and
> > thereby regularly to the first IO-APIC in the system. This causes
> > spurious interrupts and can lead to disabled IRQ lines.
> > 
> > Disabling this "boot interrupt" (as it is mostly used to supply all
> > IRQs to the legacy PIC during boot) is chipset-specific, and not
> > possible for all chips. This patchset disables the boot interrupt on
> > chipsets where this is possible and where we know how to do it.
> > 
> > When disabling the boot interrupt is not possible, the patches tell the
> > IRQ code to always use the redirected interrupt line (on the first
> > IO-APIC) instead of the "original" line on the secondary (tertiary ...)
> > IO-APIC. The original line remains masked, and IRQs always appear on
> > the boot interrupt line on the first IO-APIC instead.
> 
> Thanks for doing the research on this problem. 
> 
> We probably don't want to enable this unconditionally right away, so
> we should have a command line option which enables these quirks.

Is this part of the process (sth like: keep it disabled until we trust
it)?

Otherwise I would suggest to enable the "disable-quirks" by default
(when we use the APICs), and to disable the reroute stuff by default
until people trust it.

The "disable-quirks" are what some chipset documentation recommends to
do in the ACPI "_PIC" method anyway, when APIC mode is selected by the
operating system. I have seen a few BIOSes that do exactly the same in
the "_PIC" method. They are straightforward and simple. I believe they
are safe in APIC mode (and off in PIC mode) and we should expose them to
testing.

The reroute patch is a bit of a hack for the chips where boot interrupts
cannot be switched off. It is a simple approach, and I can think up
(so far theoretical) scenarios where it breaks.

In defense of the reroute patch:

    - we have not seen it break during our testing on more than 10 intel
      machines (with and without chips on which it is used) and

    - so far the rerouting was only necessary for some intel bridges,
      and I checked that

        1) all these bridges use the same routing for boot interrupts to
           PCI IRQs, as in the i6700PXH datasheet, section 2.15.2:

                Pin          INT

                0,4,8,12  -> INTA
                1,5,9,13  -> INTB
                2,6,10,14 -> INTC
                3,7,11,15 -> INTD

           (also note that this routing pattern is required by the PCI
           specs for _cards_ that add PCI bridges, as the BIOS cannot
           otherwise know the routing)

        2) all intel ICHxs use the same routing for external PCI IRQs to
           the ICHx's IO-APIC, as in the ICH5 datasheet, section 5.9.2:

                Direct
                from Pin     IRQ #

                PIRQA#    -> 16
                PIRQB#    -> 17
                PIRQC#    -> 18
                PIRQD#    -> 19
                PIRQE#    -> 20
                PIRQF#    -> 21
                PIRQG#    -> 22
                PIRQH#    -> 23

      and as the ICH provides a PIC, it needs to be the first interrupt
      controller in the system, unless another chip also provides a PIC.

To break the reroute patch, someone would need to connect the PCI IRQs
from an intel PCI bridge that cannot disable boot interrupts
(6700PX[VH], 8033[23] or 6300ESB) to something other than an intel ICHx.
I have never seen such a board and I doubt there will be many such
boards.

> Also is there any interaction with MSI ?

The docs for the 6700PX[VH], and IIRC also for the 8033[23] or 6300ESB
say that boot irqs are generated when the original ones are masked. So
this is independent of MSI.

We have not many boards where MSI is enabled (as there are quirks for
many chips that switch MSI off). But our testing showed no problems on
MSI-enabled machines.

> Thanks,
> 	tglx

Thanks, :)

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

