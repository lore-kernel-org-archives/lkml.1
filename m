Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbZFXQTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbZFXQTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZFXQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:18:59 -0400
Received: from www.tglx.de ([62.245.132.106]:36631 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbZFXQS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:18:59 -0400
Date: Wed, 24 Jun 2009 18:17:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
In-Reply-To: <1245858948.3216.4.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906241802170.2767@localhost.localdomain>
References: <4A418254.9050607@lwfinger.net>  <1245845787.3093.3.camel@localhost.localdomain>  <alpine.LFD.2.00.0906241643510.2767@localhost.localdomain> <1245858948.3216.4.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Jaswinder Singh Rajput wrote:
> On Wed, 2009-06-24 at 16:51 +0200, Thomas Gleixner wrote:
> > On Wed, 24 Jun 2009, Jaswinder Singh Rajput wrote:
> > > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/pci/acpi.c |   16 ++++++++++------
> > >  1 files changed, 10 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > > index 16c3fda..0bc015f 100644
> > > --- a/arch/x86/pci/acpi.c
> > > +++ b/arch/x86/pci/acpi.c
> > > @@ -69,6 +69,9 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> > >  	struct resource *root;
> > >  	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
> > >  
> > > +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> > > +		return AE_OK;
> > > +
> 
> We need to test this otherwise we will get another oops.

Right, because you would store beyond the end of the array.
 
> > >  	status = resource_to_addr(acpi_res, &addr);
> > >  	if (!ACPI_SUCCESS(status))
> > >  		return AE_OK;
> > > @@ -94,17 +97,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> > >  	if (bus_has_transparent_bridge(info->bus))
> > >  		max_root_bus_resources -= 3;
> > >  	if (info->res_num >= max_root_bus_resources) {
> > > -		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
> > > -			"from %s for %s due to _CRS returning more than "
> > > -			"%d resource descriptors\n", (unsigned long) res->start,
> > > -			(unsigned long) res->end, root->name, info->name,
> > > -			max_root_bus_resources);
> > > +		pr_warning("PCI: Failed to allocate 0x%lx-0x%lx "
> > > +			   "from %s for %s due to _CRS returning more than "
> > > +			   "%d resource descriptors\n",
> > > +			   (unsigned long)res->start, (unsigned long)res->end,
> > > +			   root->name, info->name, max_root_bus_resources);
> > 
> > Can you please avoid mixing cleanup patches with bug fixes ? I almost
> > did not see the line below.
> > 
> > > +		info->bus->resource[info->res_num] = res;
> > 
> 
> We need to set the resource even it is transparent bridge, otherwise pci
> will fail and system will not able to boot.

The fact that the system does boot with that patch is not making the
patch more correct. It fixes the boot problem at hand, but it does not
fix the root cause of the problem.

You stick the resource into the resource array, but it does not call
insert_resource(). Also you print a warning while the system seems to
be happy to use the device.

This is just inconsistent and the patch simply papers over the root
cause of the problem.

The reservation of the last 3 resources in the transparent case is
more likely the real reason as it reduces the number of available
slots in bus->resource[].

Can you please increase PCI_BUS_NUM_RESOURCES by at least 3 and test
with the one liner patch which removes the increment applied.

Also please provide the output of lspci on 2.6.30 (which does not have
f9cde5f applied).

Thanks,

	tglx

