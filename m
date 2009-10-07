Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbZJGTP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbZJGTP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZJGTPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:15:55 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:11952 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbZJGTPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:15:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 5/7] x86/PCI: print resources consistently with %pRt
Date: Wed, 7 Oct 2009 13:15:15 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20091006213259.4272.68068.stgit@bob.kio> <20091006213349.4272.65914.stgit@bob.kio> <86802c440910071143y7ba8b0f8y9efff738eba9d30b@mail.gmail.com>
In-Reply-To: <86802c440910071143y7ba8b0f8y9efff738eba9d30b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200910071315.16250.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009 12:43:09 pm Yinghai Lu wrote:
> On Tue, Oct 6, 2009 at 2:33 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > This uses %pRt to print additional resource information (type, size,
> > prefetchability, etc.) consistently.
> >
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > ---
> >  arch/x86/pci/acpi.c |   14 +++++++++++---
> >  arch/x86/pci/i386.c |   12 +++++-------
> >  2 files changed, 16 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > index 2297280..4d4f1df 100644
> > --- a/arch/x86/pci/acpi.c
> > +++ b/arch/x86/pci/acpi.c
> > @@ -7,6 +7,7 @@
> >  #include <asm/pci_x86.h>
> >
> >  struct pci_root_info {
> > +       struct acpi_device *bridge;
> >        char *name;
> >        unsigned int res_num;
> >        struct resource *res;
> > @@ -107,12 +108,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> >        res->child = NULL;
> >
> >        if (insert_resource(root, res)) {
> > -               printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
> > -                       "from %s for %s\n", (unsigned long) res->start,
> > -                       (unsigned long) res->end, root->name, info->name);
> > +               dev_err(&info->bridge->dev, "can't allocate %pRt\n", res);
> 
> better to keep that root name ?

The message changes like this:

  -PCI: Failed to allocate to allocate 0x0-0x3fff from PCI IO for PCI Bus 0000:00
  +pci_root PNP0A03:01: can't allocate [io  0x0000-0x3fff]

I don't think changing "PCI IO" to "io" is really a problem.  In fact,
strictly speaking, "PCI IO" is the wrong name for ioport_resource --
we're talking about a host bridge, and the upstream side is not PCI
at all.

However, I do think it would be more useful to mention the fact that
we failed to allocate a *window*, e.g., 

  pci_root PNP0A03:00: can't allocate host bridge window [io  0x0000-0x3fff]

I did consider keeping the PCI bus ("0000:00"), but I decided we
already have that information here:

  ACPI: PCI Root Bridge [PCI0] (0000:00)

and it doesn't seem worthwhile to me to repeat the bus number in all
the host bridge-related messages.  Right now, there's nothing to tie
the PCI0 to the PNP0A03:00 (and "PCI0" shouldn't be exposed to users
anyway), but someday when I finally convince Len to use dev_printk
in ACPI, it could look something like this:

  pci_root PNP0A03:00: PCI host bridge to pci_bus 0000:00

Bjorn
