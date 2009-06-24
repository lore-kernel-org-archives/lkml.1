Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbZFXP4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbZFXP4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZFXP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:56:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:44255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZFXP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:56:24 -0400
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0906241643510.2767@localhost.localdomain>
References: <4A418254.9050607@lwfinger.net>
	 <1245845787.3093.3.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0906241643510.2767@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 21:25:48 +0530
Message-Id: <1245858948.3216.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 16:51 +0200, Thomas Gleixner wrote:
> On Wed, 24 Jun 2009, Jaswinder Singh Rajput wrote:
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/pci/acpi.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > index 16c3fda..0bc015f 100644
> > --- a/arch/x86/pci/acpi.c
> > +++ b/arch/x86/pci/acpi.c
> > @@ -69,6 +69,9 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> >  	struct resource *root;
> >  	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
> >  
> > +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> > +		return AE_OK;
> > +

We need to test this otherwise we will get another oops.

> >  	status = resource_to_addr(acpi_res, &addr);
> >  	if (!ACPI_SUCCESS(status))
> >  		return AE_OK;
> > @@ -94,17 +97,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> >  	if (bus_has_transparent_bridge(info->bus))
> >  		max_root_bus_resources -= 3;
> >  	if (info->res_num >= max_root_bus_resources) {
> > -		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
> > -			"from %s for %s due to _CRS returning more than "
> > -			"%d resource descriptors\n", (unsigned long) res->start,
> > -			(unsigned long) res->end, root->name, info->name,
> > -			max_root_bus_resources);
> > +		pr_warning("PCI: Failed to allocate 0x%lx-0x%lx "
> > +			   "from %s for %s due to _CRS returning more than "
> > +			   "%d resource descriptors\n",
> > +			   (unsigned long)res->start, (unsigned long)res->end,
> > +			   root->name, info->name, max_root_bus_resources);
> 
> Can you please avoid mixing cleanup patches with bug fixes ? I almost
> did not see the line below.
> 
> > +		info->bus->resource[info->res_num] = res;
> 

We need to set the resource even it is transparent bridge, otherwise pci
will fail and system will not able to boot.

> Storing the resource in defeats the purpose of the original patch,
> which makes sure that we do _NOT_ use the last 3 slots of the resource
> array for a root bus with a transparent bridge.
> 
> >  		info->res_num++;
> 
> This is the real bug. info->res_num should not be incremented when we
> run out of resources already.
> 

No, you cannot remove it, otherwise you will get another oops.

You need all of the 3 things above otherwise system will not boot. Only
thing you can remove is cleanup ;-)

Or you need to revert f9cde5ffed17bf74f6bef

Thanks,
--
JSR

