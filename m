Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXG0STD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXG0STD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXG0SSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:18:54 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:59021 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXG0SSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:18:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Fri, 27 Jul 2007 12:16:59 -0600
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       =?utf-8?q?S=C3=A9bastien_Dugu=C3=A9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com> <1185416466.31345.1.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185416466.31345.1.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707271217.00164.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 08:21:06 pm Shaohua Li wrote:
> On Wed, 2007-07-25 at 17:37 -0700, Yinghai Lu wrote:
> > On 7/25/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > On Wednesday 25 July 2007 07:32:53 am Sébastien Dugué wrote:
> > > > On Wed, 25 Jul 2007 07:16:44 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > >
> > > > > The _DDN is a "DOS device name", and the _UID is a "logical device ID
> > > > > that does not change across reboots."  Both are optional, and PNPACPI
> > > > > ignores them.  But maybe we could change PNPACPI to sort by them if
> > > > > they are present.  I'll think about this a bit.
> > > >
> > > >   That would be nice, but I wish you good luck with all those
> > > > crappy BIOSes out there.
> > >
> > > Yeah, it's an ugly world we live in.  Would you be able to try the
> > > attached patch just for testing?  It should sort devices with the
> > > same _HID by their _UID.  It doesn't have any effect on my systems,
> > > because my devices are already ordered by _UID by default.  But I
> > > think it should switch your COM1/COM2 ports back to the order you
> > > expect.
> > >
> > > Yinghai, you mentioned the same issue on boxes with multiple root
> > > bridges.  Any chance you could try this out there as well?
> > >
> > it doesn't solve pci_root_bus reverse problem.
> > 
> > is that too late for PNP0A03?
> > 
> > I wonder if we need to modify acpi_device_register to sort them.
> The pci root driver is an acpi driver not a pnp driver, so Bjorn's patch
> will not work. Maybe the ACPI core (ACPICA) should do the sort?

I talked to Adam about this yesterday.  He convinced me that we
shouldn't rely on device ordering to determine names.  For one
thing, that would make threaded probing difficult.  Better to
rely on a unique identifier, and let udev take care of user-space
persistent naming issues.

I don't think udev solves the problem for built-in drivers like
serial, where you need to be able to do "console=ttyS0" and have
it mean something predictable.  But possibly we could expose the
_DDN and/or _UID through PNP and have 8250_pnp give a hint about
what the ttyS device should be when it registers with 8250.

For example, 8250_pnp could have rules like "COM1 should always
be ttyS0" or "a port at 0x3f8 should always be ttyS0."

That doesn't help with Yinghai's PCI root ordering issue, of course.
But I hope that can be addressed with udev, because there's not so
much need for a persistent kernel name.  If that's not enough, can
you explain more about the problem?

Bjorn
