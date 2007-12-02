Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXLBNcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXLBNcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXLBNcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:32:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:60622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbXLBNcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:32:10 -0500
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <200711301652.42110.bjorn.helgaas@hp.com>
References: <1196442277.23251.318.camel@queen.suse.de>
	 <47509EB6.20300@keyaccess.nl>  <200711301652.42110.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Sun, 02 Dec 2007 14:32:07 +0100
Message-Id: <1196602327.4049.48.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-30 at 16:52 -0700, Bjorn Helgaas wrote:
> On Friday 30 November 2007 04:37:26 pm Rene Herman wrote:
> > On 30-11-07 18:04, Thomas Renninger wrote:
> > > If I have not overseen something, it should be rather obvious that those
> > > can all be declared __init...
> > > ---------------
> > > 
> > > Declare PNP option parsing functions as __init
> > > 
> > > There are three kind of parse functions provided by PNP acpi/bios:
> > >  - get current resources
> > >  - set resources
> > >  - get possible resources
> > > The first two may be needed later at runtime.
> > > The possible resource settings should never change dynamically.
> > > And even if this would make any sense (I doubt it), the current implementation
> > > only parses possible resource settings at early init time:
> > >   -> declare all the option parsing __init
> > > 
> > > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > 
> > Yes. Obviousness aside,
> > 
> > (0) pnpacpi_add_device                          is only caller of
> > ...
> 
> I agree this is probably safe in the current implementation.
> 
> However, I think the current implementation is just broken because
> we can't really handle hotplug of ACPI devices.  Specifically, I think
> the first TBD in acpi_bus_check_device() should be fleshed out so it
> does something like pnpacpi_add_device().
Yes, making the ACPI layer more hotplug capable is something that should
be worked on again.

> So my dissenting opinion is that this patch would just get reverted
> soon anyway when somebody finishes implementing ACPI hotplug, and
> therefore it's not worth doing.

Yes you are right. I thought _PSR could always be called at init time,
whether present or not (which would certainly work for most/all devices
as _PSR info should be kind of static), but ACPI spec forbids it:

6.3.7 _STA (Status)
If bit 0 is cleared, then bit 1 must also be cleared (in other words, a
device that is not present cannot be enabled).
A device can only decode its hardware resources if both bits 0 and 1 are
set. If the device is not present (bit 0 cleared) or not enabled (bit 1
cleared), then the device must not decode its resources.

I only saw:
6.2.10 _PRS (Possible Resource Settings):
If the device is disabled when _PRS is called, it must remain disabled.

But disabled and not present are different things...


It's stupid as the possible resources of a device will always remain the
same, whether it is present or not, but if it is written down in the
spec, there is not much to argue about it...

Thanks,

    Thomas

