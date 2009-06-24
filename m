Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZFXQZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZFXQZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZFXQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:25:12 -0400
Received: from outbound-mail-114.bluehost.com ([69.89.24.4]:38547 "HELO
	outbound-mail-114.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754233AbZFXQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:25:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YDbrmo97iWA4OO9NB0vEkUzHpyTmUlD8Pw9d7va1sGS2eG5hlh6bR4OBiDHr5yWnkQs/DteQIlxI/H63qwpJNDTS6Ts353PSY2gRqHZIVFQljm6mLXZeYOtj+HF4bELg;
Date: Wed, 24 Jun 2009 09:25:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624092511.337d9c64@jbarnes-g45>
In-Reply-To: <20090624155632.GB7239@us.ibm.com>
References: <4A418254.9050607@lwfinger.net>
	<1245845787.3093.3.camel@localhost.localdomain>
	<alpine.LFD.2.00.0906241643510.2767@localhost.localdomain>
	<20090624155632.GB7239@us.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 08:56:32 -0700
Gary Hade <garyhade@us.ibm.com> wrote:

> On Wed, Jun 24, 2009 at 04:51:48PM +0200, Thomas Gleixner wrote:
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
> > > @@ -69,6 +69,9 @@ setup_resource(struct acpi_resource *acpi_res,
> > > void *data) struct resource *root;
> > >  	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
> > >  
> > > +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> > > +		return AE_OK;
> > > +
> > >  	status = resource_to_addr(acpi_res, &addr);
> > >  	if (!ACPI_SUCCESS(status))
> > >  		return AE_OK;
> > > @@ -94,17 +97,18 @@ setup_resource(struct acpi_resource
> > > *acpi_res, void *data) if (bus_has_transparent_bridge(info->bus))
> > >  		max_root_bus_resources -= 3;
> > >  	if (info->res_num >= max_root_bus_resources) {
> > > -		printk(KERN_WARNING "PCI: Failed to allocate
> > > 0x%lx-0x%lx "
> > > -			"from %s for %s due to _CRS returning
> > > more than "
> > > -			"%d resource descriptors\n", (unsigned
> > > long) res->start,
> > > -			(unsigned long) res->end, root->name,
> > > info->name,
> > > -			max_root_bus_resources);
> > > +		pr_warning("PCI: Failed to allocate 0x%lx-0x%lx "
> > > +			   "from %s for %s due to _CRS returning
> > > more than "
> > > +			   "%d resource descriptors\n",
> > > +			   (unsigned long)res->start, (unsigned
> > > long)res->end,
> > > +			   root->name, info->name,
> > > max_root_bus_resources);
> > 
> > Can you please avoid mixing cleanup patches with bug fixes ? I
> > almost did not see the line below.
> > 
> > > +		info->bus->resource[info->res_num] = res;
> > 
> > Storing the resource in defeats the purpose of the original patch,
> > which makes sure that we do _NOT_ use the last 3 slots of the
> > resource array for a root bus with a transparent bridge.
> > 
> > >  		info->res_num++;
> > 
> > This is the real bug. info->res_num should not be incremented when
> > we run out of resources already.
> 
> This probably isn't needed but I don't think it is the cause of
> the problem.  It is just counting the number of _CRS returned
> resources and I believe subsequent visits to setup_resource()
> for additional returned resources will generate the same warning
> as it also would if the instruction were removed and no longer
> being used to keep an accurate count.
> 
> I suspect that the resource array is simply not large enough
> for that system (and possibly others) and will have to be made
> larger by increasing PCI_BUS_NUM_RESOURCES.

Larry, have you been able to confirm that?  Do we just need to bump the
PCI_BUS_NUM_RESOURCES on your machine?

-- 
Jesse Barnes, Intel Open Source Technology Center
