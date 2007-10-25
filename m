Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbXJYPHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbXJYPHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbXJYPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:07:05 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:46675 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760502AbXJYPHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:07:01 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
Date: Thu, 25 Oct 2007 09:06:22 -0600
User-Agent: KMail/1.9.6
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
References: <1193236319.4590.225.camel@queen.suse.de>
In-Reply-To: <1193236319.4590.225.camel@queen.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200710250906.23003.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 08:31:59 am Thomas Renninger wrote:
> In ACPI, AML can define accesses to IO ports and System Memory by
> Operation Regions. Those are not registered as done by PNPACPI using
> resource templates (and _CRS/_SRS methods).
> The IO ports and System Memory regions may get accessed by arbitrary AML
> code. When native drivers are accessing the same resources bad things
> can happen (e.g. a critical shutdown temperature of 3000 C every 2
> months or so).

> It is not really possible to register the operation regions via
> request_resource, as they often overlap with pnp or other resources
> (e.g. statically setup IO resources below 0x100).

But we really *should* reserve things used by opregions, shouldn't
we?  After all, the whole point of resource reservation is to prevent
conflicts.

If these opregion resources aren't reserved, but are only put in the
ACPI resource_list, we will only find conflicts with drivers that use
acpi_check_resource_conflict().  Any driver unmodified by your changeset
could still have a conflict, and we'd never find it.

Isn't the real problem that we have a bunch of drivers that use some of
the same resources, and if ACPI reserved all the right resources, all
those drivers would break?

I think it would be better to:

  - Make ACPI reserve resources used by opregions unless
    acpi_enforce_resources == no.

  - Change the drivers so if their request_region() fails, they
    check acpi_enforce_resources and either fail (in strict mode)
    or print the warning and continue (in lax mode).

Admittedly, this is harder for the drivers that use the shiny new
platform device stuff.

> This approach stores all Operation Region declarations (IO and System
> Memory only) at ACPI table parse time. It offers a similar functionality
> like request_region and let drivers which are known to possibly use the
> same IO ports and Memory which are also often used by ACPI (hwmon and
> i2c) check for ACPI interference.
> 
> A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
> is default set to lax:
>   - strict: let conflicting drivers fail to load with an error message
>   - lax:    let conflicting driver work normal with a warning message
>   - no:     no functional change at all
> Depending on the feedback and the kind of interferences we see, this
> should be set to strict at later time.
> 
> Goal of this patch set is:
>   - Identify ACPI interferences in bug reports (very hard to reproduce
>     and to identify)
>   - Find BIOSes for that an ACPI driver should exist for specific HW
>     instead of a native one.
>   - stability in general
