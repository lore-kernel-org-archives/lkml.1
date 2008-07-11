Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYGKVfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYGKVfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbYGKVfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:35:46 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:50983 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbYGKVfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:35:45 -0400
Date: Fri, 11 Jul 2008 23:37:08 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
Message-ID: <20080711213707.GA2561@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20080709104916.200210922@fluff.org> <20080709104933.101610936@fluff.org> <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com> <20080709112426.GN8489@trinity.fluff.org> <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com> <20080709115045.GK8517@trinity.fluff.org> <bc64b4640807090456u15d12378qe25375ce4a6cd100@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640807090456u15d12378qe25375ce4a6cd100@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:56:54PM +0400, Dmitry wrote:
> >> Basically we have two choises for the subdevice driver:
> >> 1) it doesn't know about cells at all (e.g. generic-bl, IIRC). Then we are safe
> >>    to loose that "cell" information
> >> 2) If it does use cell information (to get access to hooks), we pass it
> >>     via platform_data pointer in the mfd_cell and we are ok with it.
> >
> > Erm, that is complete non-answer. The driver model and various other
> > parts of the kernel are littered with examples of embedding one
> > structure within another to gain an C++ like object inheritance.
> >
> > I've supplied an reasonable example of doing this to create an mfd_cell
> > device from an platform_device without creating an large amount of code
> > and improving the efficiency and code-lineage in the process. I do not
> > see how this isn't "correct" or in any way breaing the current linux
> > model of doing things.
> 
> It isn't breaking it. OK. I'm leaving the decision to the MFD or ARM
> maintainers.
> And BTW, nearly the same patch was sent yesterday by me[1]. Is it an independant
> work, or did you miss my sign-off?
> 
> [1]: http://permalink.gmane.org/gmane.linux.ports.arm.kernel/44142
As Russel pointed out, both patches are broken as long as we support a
modular mfd-core (and there's no reason why we shouldnt).
So, so far, Mike's patch is the best candidate, even though the idea of
wrapping the platform device into an mfd_device sounded neater at first.

And again, this is definitely post merge window material.

Cheers,
Samuel.


> >
> >>
> >> > The current driver is being inefficent in the way it creates resources
> >> > on the stack and then calls a routine that does an kalloc/memcpy on
> >> > the resources.
> >>
> >> I don't see any inefficiency ATM.
> >>
> >> >> 2) Please examine the tmio-nand driver (was here on the list and on
> >> >> linux-mtd). It uses the mfd_cell
> >> >>    to call hooks from the "host" driver (tc6393xb, more to be added soon).
> >> >
> >> > The one posted in [1] does not call these hooks at-all, can ou please
> >> > explain why these hooks are needed in addition to the ones already
> >> > available in the platform device driver?
> >> >
> >> > [1] http://lists.infradead.org/pipermail/linux-mtd/2008-June/022137.html
> >>
> >> +
> >> +static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
> >> +{
> >> +     struct mfd_cell *cell = mfd_get_cell(dev);
> >> +     const struct resource *nfcr = NULL;
> >> +     unsigned long base;
> >> +     int i;
> >> +
> >> +     for (i = 0; i < cell->num_resources; i++)
> >> +             if (!strcmp((cell->resources+i)->name, TMIO_NAND_CONTROL))
> >> +                     nfcr = &cell->resources[i];
> >> +
> >> +     if (nfcr == NULL)
> >> +             return -ENOMEM;
> >> +
> >> +     if (cell->enable) {
> >> +             int rc = cell->enable(dev);
> >> +             if (rc)
> >> +                     return rc;
> >> +     }
> >>
> >> That cell->enable() is necessary to set up the host (in the tc6393xb
> >> case to enable buffers)
> >> to enable access to the nand.
> >
> > So, the enable/disable calls might be useful, however is there any
> > reason this could not be handled by the clock framework? The suspend/resume
> > entries where not used, and I belive should not be in here.
> 
> They should be here for exactly the same reason. They are used by the drivers
> that will be submitted later. E.g. OHCI driver needs such
> suspend/resume handling.
> 
> > As noted before, mfd_get_cell() got dropped by [2]
> >
> > [2] http://lists.arm.linux.org.uk/lurker/message/20080708.153450.bb33046d.en.html
> 
> Yes, and as I said before it will need some small modifications.
> 
> -- 
> With best wishes
> Dmitry
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
