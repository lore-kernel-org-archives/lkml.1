Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXJYWzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXJYWzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXJYWzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:55:13 -0400
Received: from ns.suse.de ([195.135.220.2]:35093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbXJYWzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:55:11 -0400
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with
	ACPI Operation Region resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <200710250906.23003.bjorn.helgaas@hp.com>
References: <1193236319.4590.225.camel@queen.suse.de>
	 <200710250906.23003.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 00:55:07 +0200
Message-Id: <1193352907.3665.37.camel@fanta4.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 09:06 -0600, Bjorn Helgaas wrote:
> On Wednesday 24 October 2007 08:31:59 am Thomas Renninger wrote:
> > In ACPI, AML can define accesses to IO ports and System Memory by
> > Operation Regions. Those are not registered as done by PNPACPI using
> > resource templates (and _CRS/_SRS methods).
> > The IO ports and System Memory regions may get accessed by arbitrary AML
> > code. When native drivers are accessing the same resources bad things
> > can happen (e.g. a critical shutdown temperature of 3000 C every 2
> > months or so).
> 
> > It is not really possible to register the operation regions via
> > request_resource, as they often overlap with pnp or other resources
> > (e.g. statically setup IO resources below 0x100).
> 
> But we really *should* reserve things used by opregions, shouldn't
> we?  After all, the whole point of resource reservation is to prevent
> conflicts.
> 
> If these opregion resources aren't reserved, but are only put in the
> ACPI resource_list, we will only find conflicts with drivers that use
> acpi_check_resource_conflict().  Any driver unmodified by your changeset
> could still have a conflict, and we'd never find it.
> 
> Isn't the real problem that we have a bunch of drivers that use some of
> the same resources, and if ACPI reserved all the right resources, all
> those drivers would break?
Yes, but:
It is really impossible to register them just like that.
I only tried on one machine I implemented on, Jean tested with more
machines. Even there the resources did not only interfere, but overlap.
The Operation Region declarations in ACPI don't belong to a real driver,
but may be used in all kind of functions.
E.g. the thermal driver can't know which operation regions it may use
later, e.g. by invoking _THM which in turn invokes a couple of other
functions where IO ports are addressed via operation regions.
Also the BIOS developers seem to choose the regions in a very dump way
sometimes.
Just some imaginary values, but I saw similar (overlapping):
 - For a PNP device IO ports from 0x400-0x410 are reserved
 - A operation region is declared from 0x399-0x401
My first approach was to register the regions via request_resource and
failed on the first machine.
I then thought about acpi exporting it's own request/check_acpi_region
and add it into request_region..., but this also did not work out.
IMO this is the only way, at least for getting an overview how regions
are used and where we might need an ACPI driver and have interference as
a first step. There might be more steps we could take in future, maybe
someone gets a better idea, but as said, there are no rules how BIOS
developers make use of those regions.

Also the current request_resource interface (not the interface but the
callers), need to be polished up first.
1) E.g. PNPACPI needs to dynamically allocate its resources (as we
already discussed, I hope to be able to send something soon. Already
works, but this will also affect PNPBIOS and ISAPNP, a lot old code and
this needs careful review/testing).
2) I have no idea why e.g. i386/x86_64 kernel/setup.c code statically
requests some ports below 0x100 and whether it can be ripped out or gets
requested via the operation regions then in a sane way. I know they
interfere on some systems with operation regions.

It's just too much to solve in one step, if it can be resolved at all.

    Thomas

> I think it would be better to:
> 
>   - Make ACPI reserve resources used by opregions unless
>     acpi_enforce_resources == no.
> 
>   - Change the drivers so if their request_region() fails, they
>     check acpi_enforce_resources and either fail (in strict mode)
>     or print the warning and continue (in lax mode).
> 
> Admittedly, this is harder for the drivers that use the shiny new
> platform device stuff.
> 
> > This approach stores all Operation Region declarations (IO and System
> > Memory only) at ACPI table parse time. It offers a similar functionality
> > like request_region and let drivers which are known to possibly use the
> > same IO ports and Memory which are also often used by ACPI (hwmon and
> > i2c) check for ACPI interference.
> > 
> > A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
> > is default set to lax:
> >   - strict: let conflicting drivers fail to load with an error message
> >   - lax:    let conflicting driver work normal with a warning message
> >   - no:     no functional change at all
> > Depending on the feedback and the kind of interferences we see, this
> > should be set to strict at later time.
> > 
> > Goal of this patch set is:
> >   - Identify ACPI interferences in bug reports (very hard to reproduce
> >     and to identify)
> >   - Find BIOSes for that an ACPI driver should exist for specific HW
> >     instead of a native one.
> >   - stability in general

