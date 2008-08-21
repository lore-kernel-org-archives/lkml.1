Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYHUQba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYHUQba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYHUQbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:31:22 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30617 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYHUQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:31:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Thu, 21 Aug 2008 10:31:15 -0600
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <200808181540.25286.elendil@planet.nl> <200808210914.27516.bjorn.helgaas@hp.com> <1219333105.20723.45.camel@lgn.site>
In-Reply-To: <1219333105.20723.45.camel@lgn.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211031.16248.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 09:38:25 am Kay Sievers wrote:
> On Thu, 2008-08-21 at 09:14 -0600, Bjorn Helgaas wrote:
> > Can somebody elaborate on why we need to add "acpi*" aliases for all
> > PNP devices?  That broadens the kernel/user interface, so I'd like
> > to understand why we need it.

Sorry, I should have prefaced my question with "I'm completely ignorant
of this modalias stuff."  Is there a "complete idiot's guide to modules
and udev"?  There's precious little in Documentation/ other than a bunch
of sample rules for various subsystems.

> We already do ACPI module autoloading by MODALIAS for other things than
> pnp. ACPI exports the pnp devices with modalias, but the modules do not
> have a matching alias, this add them.

I'm guessing this has something to do with acpi_device_uevent().

> PNP has no MODALIAS support at all, and the current pnp-aliases would
> not work for the standard modalias method, they would need to change
> their format.

pnp_bus_type has no .uevent method.  What if I added one?  Would that
help this situation?

It seems wrong for file2alias.c to take every PNP device (even if it's
an ISAPNP or PNPBIOS device) and add "acpi*" aliases for it.

> The plan is to replace the current pnp modprobe shell script hack in
> udev, when ACPI devices load the right modules without any special
> userspace mangling.

Is this the shell hack you mean (from etc/udev/rules.d/80-drivers.rules
in udev-117)?

  SUBSYSTEM=="pnp", DRIVER!="?*", ENV{MODALIAS}!="?*", \
    RUN{ignore_error}+="/bin/sh -c '/sbin/modprobe -a $$(while read id; do echo pnp:d$$id; done < /sys$devpath/id)'"

I agree that's gross.  Could I fix this by implementing pnp_device_uevent()?

Bjorn
