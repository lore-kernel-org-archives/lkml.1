Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbZAOMgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbZAOMgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZAOMgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:36:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:34382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbZAOMgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:36:10 -0500
Date: Thu, 15 Jan 2009 13:36:07 +0100
From: Olaf Dabrunz <od@suse.de>
To: Jon Masters <jcm@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Stefan Assmann <sassmann@suse.de>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090115123607.GS25512@suse.de>
Mail-Followup-To: Jon Masters <jcm@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Stefan Assmann <sassmann@suse.de>, Len Brown <lenb@kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>
References: <200901121151.53195.bjorn.helgaas@hp.com> <m1d4esxfk2.fsf@frodo.ebiederm.org> <1231806563.4094.25.camel@perihelion.bos.jonmasters.org> <20090113014723.GA11366@elte.hu> <m1prirx3xn.fsf@frodo.ebiederm.org> <1231820798.4094.34.camel@perihelion.bos.jonmasters.org> <20090114114006.GF8625@elte.hu> <1231960709.23174.0.camel@londonpacket.bos.redhat.com> <m11vv5wlug.fsf@frodo.ebiederm.org> <1231973760.23174.33.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231973760.23174.33.camel@londonpacket.bos.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-Jan-09, Jon Masters wrote:
> On Wed, 2009-01-14 at 14:42 -0800, Eric W. Biederman wrote:
> > Jon Masters <jcm@redhat.com> writes:
> > 
> > > On Wed, 2009-01-14 at 12:40 +0100, Ingo Molnar wrote:
> > >
> > >> it's not just -rt, but it is also needed for the concept of threaded IRQ 
> > >> handlers - which was discussed at the Kernel Summit to be desired for 
> > >> mainline.
> > >
> > > Right. I'm poking at Thomas' patches and hope to post something soon on
> > > that front - I'm acutely aware that this will be impacted aswell but
> > > because it's vaguely RT related had banded it under that banner.
> > 
> > Stepping back a moment.  The only way I can see this working reliably
> > is if we disable the boot interrupt.  Anything that leaves the boot interrupt
> > enabled means that when we disable the primary interrupt the boot interrupt
> > will scream, and thus we must disable it as well.
> > 
> > Which leads to my problem with the entire development process of this feature.
> > 
> >  People want the feature.
> >  People don't want to pay attention to the limits of the hardware.
> >  Which leads to countless broken patches proposed.
> 
> Is a patch broken because hardware has limitations? If that were always
> true then many of the patches we see in the kernel wouldn't be there.
> 
> > Which leads me to conclude.
> > - IRQ handling in the RT kernel is hopelessly broken.
> 
> Nope. It's done in a very similar way to other real time kernels already
> out there - really there are only so many ways to do this.
> 
> > - IRQ threads are a bad idea.
> 
> Why? IRQ threads actually make life so much easier - you have a task
> context, you can do everything inside that rather than scheduling all
> kinds of deferred work (that in RT will be done in another task later),
> and so forth.
> 
> > None of this works reliably on level triggered ioapic irqs.

Actually it works very well. The patches are also not _that_
complicated. We have two kinds of patches:

    1) if possible on the chipset, disable boot irqs (if in APIC mode)

       - this works as designed and has no problems

       - we cover up for broken BIOSes here that forget to disable boot
         irqs

    2) if we cannot disable boot irqs, disable the original interrupt
       line and only use the boot irq line -> no duplicated interrupts,
       but increased interrupt sharing

       - this is a hack for older, but widely used chipsets

       - we cover up for broken hardware (wrt threaded IRQ handling)

       - when the broken hardware falls out of use, this is not needed
         anymore


The only limitations we have so far:

    - For newer chipsets, we have to make sure that we find the disable
      bit. Vendors should put this bit in a common place.

    - It is a lot of work to describe all of the findings and
      experimental results we had, in a digestable way.

> Level triggered IOAPIC IRQs have quirks, film at 11!

Love this. *grin* :)

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

