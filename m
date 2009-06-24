Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbZFXQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbZFXQdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZFXQdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:33:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43351 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZFXQdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:33:12 -0400
Date: Wed, 24 Jun 2009 09:33:10 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624163310.GD7239@us.ibm.com>
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <alpine.LFD.2.00.0906241643510.2767@localhost.localdomain> <20090624155632.GB7239@us.ibm.com> <1245860100.3216.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245860100.3216.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:45:00PM +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-06-24 at 08:56 -0700, Gary Hade wrote:
> > On Wed, Jun 24, 2009 at 04:51:48PM +0200, Thomas Gleixner wrote:
> > > On Wed, 24 Jun 2009, Jaswinder Singh Rajput wrote:
> > > > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > > ---
> > > >  arch/x86/pci/acpi.c |   16 ++++++++++------
> > > >  1 files changed, 10 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > > > index 16c3fda..0bc015f 100644
> > > > --- a/arch/x86/pci/acpi.c
> > > > +++ b/arch/x86/pci/acpi.c
> > > > @@ -69,6 +69,9 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> > > >  	struct resource *root;
> > > >  	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
> > > >  
> > > > +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> > > > +		return AE_OK;
> > > > +
> > > >  	status = resource_to_addr(acpi_res, &addr);
> > > >  	if (!ACPI_SUCCESS(status))
> > > >  		return AE_OK;
> > > > @@ -94,17 +97,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> > > >  	if (bus_has_transparent_bridge(info->bus))
> > > >  		max_root_bus_resources -= 3;
> > > >  	if (info->res_num >= max_root_bus_resources) {
> > > > -		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
> > > > -			"from %s for %s due to _CRS returning more than "
> > > > -			"%d resource descriptors\n", (unsigned long) res->start,
> > > > -			(unsigned long) res->end, root->name, info->name,
> > > > -			max_root_bus_resources);
> > > > +		pr_warning("PCI: Failed to allocate 0x%lx-0x%lx "
> > > > +			   "from %s for %s due to _CRS returning more than "
> > > > +			   "%d resource descriptors\n",
> > > > +			   (unsigned long)res->start, (unsigned long)res->end,
> > > > +			   root->name, info->name, max_root_bus_resources);
> > > 
> > > Can you please avoid mixing cleanup patches with bug fixes ? I almost
> > > did not see the line below.
> > > 
> > > > +		info->bus->resource[info->res_num] = res;
> > > 
> > > Storing the resource in defeats the purpose of the original patch,
> > > which makes sure that we do _NOT_ use the last 3 slots of the resource
> > > array for a root bus with a transparent bridge.
> > > 
> > > >  		info->res_num++;
> > > 
> > > This is the real bug. info->res_num should not be incremented when we
> > > run out of resources already.
> > 
> > This probably isn't needed but I don't think it is the cause of
> > the problem.  It is just counting the number of _CRS returned
> > resources and I believe subsequent visits to setup_resource()
> > for additional returned resources will generate the same warning
> > as it also would if the instruction were removed and no longer
> > being used to keep an accurate count.
> > 
> 
> Yes, this count is needed to avoid PCI failure.

With your proposed change that allows the last three slots
of the resource array to be populated, this is true.  Without
your change I believe removal of this instriction is benign.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

