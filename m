Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZAIQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZAIQfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZAIQes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:34:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZAIQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:34:47 -0500
Date: Fri, 9 Jan 2009 08:34:35 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "Han, Weidong" <weidong.han@intel.com>,
       "'Grant Grundler'" <grundler@parisc-linux.org>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Arjan van de Ven'" <arjan@infradead.org>
Subject: Re: git-latest: kernel oops in IOMMU setup
Message-ID: <20090109083435.2ac20fd5@infradead.org>
In-Reply-To: <49677856.90807@intel.com>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
	<715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
	<20090108180515.2f279671@infradead.org>
	<20090108205222.2c89dcde@infradead.org>
	<715D42877B251141A38726ABF5CABF2C018E8FECAA@pdsmsx503.ccr.corp.intel.com>
	<20090109070805.525c0de9@infradead.org>
	<49677856.90807@intel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 00:16:22 +0800
"Zhao, Yu" <yu.zhao@intel.com> wrote:

> Dirk Hohndel wrote:
> > On Fri, 9 Jan 2009 14:53:14 +0800
> > "Han, Weidong" <weidong.han@intel.com> wrote:
> > 
> >> Dirk Hohndel wrote:
> >>> On Thu, 8 Jan 2009 18:05:15 -0800
> >>> Dirk Hohndel <hohndel@infradead.org> wrote:
> >>>
> >>>> On Fri, 9 Jan 2009 08:58:46 +0800 "Han, Weidong"
> >>>>
> >>>> I updated to Linus' latest git (as your description made me
> >>>> wonder if the async stuff might play a role here). I still get
> >>>> an oops - but at a different spot and the system no longer hangs
> >>>> - it partly recovers (but things aren't too well - for example
> >>>> my USB keyboard / mouse don't work anymore).
> >>> Spoke too soon. Rebooted and had the same hard lockup again. This
> >>> time I had my camera within reach, so here's the trace:
> >>>
> >>> device_to_iommu+0x33/0x73
> >>> domain_context_mapping_one+0x37/0x335
> >>> domain_context_mapping+0x25/0xa7
> >>> iommu_prepare_identity+0xd7/0xf3
> >>> intel_iommu_init+0x4e4/0x8f3
> >>> ? mutex_lock
> >>> ? sysctl_net_init
> >>> ? pci_iommu_init
> >>> pci_iommu_init
> >>>
> >>> I also have stack, code and register values. Let me know if you
> >>> need them. Or I can just post the picture :-)
> >>>
> >>> Again, very latest git tree, VT-d enabled.
> >>>
> >>> /D
> >> I tried latest git tree, it works for me. Above call trace looks
> >> right. 
> > 
> > Spent some more time reading the code. Can't quite claim to
> > understand all of it, yet, but I notice that most everywhere else
> > drhd->devices[i] is checked to be != NULL before it is accessed.
> > Why is it safe not to do that in device_to_iommu()?
> > 
> > Would the patch below be a valid fix? It stops my system from
> > hanging at boot. But I wonder if there is an assertion that if
> > drhd->ignored is 0 then drhd->devices[0..drhd->device_cnt] is known
> > to be != NULL and therefore this test is just hiding a bug
> > somewhere else...
> > 
> > /D
> > 
> > Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
> > ---
> >  drivers/pci/intel-iommu.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > index 235fb7a..3dfecb2 100644
> > --- a/drivers/pci/intel-iommu.c
> > +++ b/drivers/pci/intel-iommu.c
> > @@ -438,7 +438,8 @@ static struct intel_iommu *device_to_iommu(u8
> > bus, u8 devfn) continue;
> >  
> >  		for (i = 0; i < drhd->devices_cnt; i++)
> > -			if (drhd->devices[i]->bus->number == bus &&
> > +			if (drhd->devices[i] &&
> > +			    drhd->devices[i]->bus->number == bus &&
> >  			    drhd->devices[i]->devfn == devfn)
> >  				return drhd->iommu;
> >  
> 
> Did you see following in the kernel message?
>                  printk(KERN_WARNING PREFIX
>                  "Device scope device [%04x:%02x:%02x.%02x] not
> found\n", segment, scope->bus, path->dev, path->fn);
> 
> If yes, then
> 		Acked-by: Yu Zhao <yu.zhao@intel.com>

Yes,

DMAR: Device scope device [0000:00:03:02] not found
DMAR: Device scope device [0000:00:03:02] not found
DMAR: Device scope device [0000:00:03:03] not found
DMAR: Device scope device [0000:00:03:03] not found

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
