Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbZHKO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbZHKO6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbZHKO6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:58:49 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:53147 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZHKO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:58:49 -0400
Message-ID: <4A818756.3070406@gefanuc.com>
Date: Tue, 11 Aug 2009 15:59:34 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 4/5] Staging: vme: add Tundra TSI148 VME-PCI Bridgedriver
References: <20090809000925.GB29303@braap.org>
In-Reply-To: <20090809000925.GB29303@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emilio,

Sorry for not replying to this mail sooner - got caught in my junk 
folder for some reason.

Emilio G. Cota wrote:
>
> Greg, Martyn,
>
> please have a look at our tsi148 driver, available at:
> http://repo.or.cz/w/tsi148vmebridge.git
> Whenever you encounter a reference to 'CES', ignore it,
> it's a CERN thing for easing our lives porting drivers from
> LynxOS.
>

I've had a brief look - it seem's to provide roughtly what I am 
attempting to provide with the tsi-148 driver as part of the VME stuff 
in staging.
>
>
> I could post the driver to LKML for review if you want; I would
> remove that CES crap before posting. I put this off because
> I knew it would never get merged before there was some generic
> vme glue supporting it. However now we're getting there so
> it's probably a good time to get cracking with this task.
>
> Martyn, a few comments about your driver, haven't had much
> time to dig very deep.
>
> - again, use mutexes instead of semaphores
>

Yes - I have a patch on the way.

> - The DMA code looks rather messy; I mean stuff like this:
>

That's because it's incomplete - hence why it's in the staging tree.
>
> > +#if 0
> > +     /* XXX Still todo */
> > +     for (x = 0; x < 8; x++) {       /* vme block size */
> > +             if ((32 << x) >= vmeDma->maxVmeBlockSize) {
> > +                     break;
> > +             }
> > +     }
> > +     if (x == 8)
> > +             x = 7;
> > +     dctlreg |= (x << 12);
> > +
> > +     for (x = 0; x < 8; x++) {       /* pci block size */
> > +             if ((32 << x) >= vmeDma->maxPciBlockSize) {
> > +                     break;
> > +             }
> > +     }
> > +     if (x == 8)
> > +             x = 7;
> > +     dctlreg |= (x << 4);
> > +
> > +     if (vmeDma->vmeBackOffTimer) {
> and the ifdefs 0..
>
> - correct me if I'm wrong, but does the slave need to know the
>   window number he wants for his device? See:
> > +int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
> > +     unsigned long long *vme_base, unsigned long long *size,
> > +     dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
> > +{
> > +     unsigned int i, granularity = 0, ctl = 0;
> > +     unsigned int vme_base_low, vme_base_high;
> > +     unsigned int vme_bound_low, vme_bound_high;
> > +     unsigned int pci_offset_low, pci_offset_high;
> > +     unsigned long long vme_bound, pci_offset;
> > +
> > +
> > +     i = image->number;
>
> If that's the case, this is totally broken; in fact, even if you
> kept a list somewhere up on the generic vme layer keeping track
> of the already used windows (images?) to avoid any clashes,
>
Yes - the core layer keeps track of what is in use.

> in practice you'd very soon run out of windows: 8 modules, 8
> mappings, 8 windows. And you're dead.
>

Depends how the drivers use them.

>
> In a crate we have up to 20 modules, each of them with at least
> one address space to be mapped. To make this work we do the
> following:
>
> * The tsi148 has 1GB of address space available for mapping,
>   which is further divided into 8 windows, with a unique address
>   modifier per window.
> * Say you have 15 modules that need to map 1MB each, all of them
>   with the same address modifier (AM).
> Then what the slave driver requests is *not* a window, is what we
> call a 'vme mapping', which means "do whatever you want but give
> me a kernel address that points at this VME address, mapping with
> this size and AM".
>

With the API I have presented you could still map all 15 modules with 
one window in your driver if that makes sense.

>
> Our tsi148 driver notices then that there's already a window for
> that AM, so it just appends the mapping to the existing window.
> So at the end of the day only one window is used for all those
> mappings, which are nicely piled together.
>

If you want this kind of control, I think it would work well as a layer 
above the basic resource management built into the API I have. The two 
could live fairly happily side-by-side.

>
> Please clarify me how this is handled in your driver. The
> bottom line is to ensure that
> a) Many different modules can peacefully co-exist on a crate
>

Drivers request resources, if the resources are available, they get 
them. Resources are requested with respect to the attributes required.

> b) Drivers should know nothing about what else is on your crate
>

I agree.

Martyn
>
>
> E.
>
-- 

Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
