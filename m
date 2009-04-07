Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbZDGVma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbZDGVma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761665AbZDGVmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:42:17 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:53760 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761303AbZDGVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:42:16 -0400
X-IronPort-AV: E=Sophos;i="4.39,339,1235970000"; 
   d="scan'208";a="69210947"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Tue, 7 Apr 2009 17:44:17 -0400
User-Agent: KMail/1.9.5
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Chris Peterson" <cpeterso@cpeterso.com>
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <200904070716.25846.rgetz@blackfin.uclinux.org> <1239116251.14392.133.camel@calx>
In-Reply-To: <1239116251.14392.133.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904071744.17727.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Apr 2009 21:41:57.0791 (UTC) FILETIME=[AD2432F0:01C9B7C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 7 Apr 2009 10:57, Matt Mackall pondered:
> On Tue, 2009-04-07 at 07:16 -0400, Robin Getz wrote:
> > On Mon 6 Apr 2009 15:01, Matt Mackall pondered:
> > > On Mon, 2009-04-06 at 14:30 -0400, Robin Getz wrote:
> > > > We have lots of embedded headless systems (no keyboard/mouse, no
> > > > soundcard, no video) systems with *no* sources of entropy - and
> > > > people using SSL. 
> > > 
> > > I'd rather add a random_sample_network call somewhere reasonably
> > > central in the network stack. Then we can use the knowledge that the
> > > sample is network-connected in the random core to decide how to 
> > > measure its entropy. The trouble with IRQF_SAMPLE_RANDOM is that 
> > > many of its users are technically bogus as entropy sources in the
> > > current model. 
> > 
> > OK - that makes more sense.
> > 
> > Does that mean we also shouldn't be using IRQF_SAMPLE_RANDOM on
> > interrupt sources in subsystems which already have add_xxx_randomness()
> > in them? (block devices, and input devices?)
> > 
> > block/blk-core.c -> blk_end_io() -> add_disk_randomness()
> > drivers/input/input.c -> input_event() -> add_input_randomness()
> > 
> >  drivers/block/xen-blkfront.c, line 639
> > 
> >  drivers/input/touchscreen/wm97xx-core.c, line 374
> >  drivers/input/keyboard/gpio_keys.c, line 145
> >  drivers/input/keyboard/bf54x-keys.c, line 255
> >  drivers/input/serio/hp_sdc.c, line 881
>
> Yes. The flag needs to be taken out and shot. 

In general or just for input and block devices?

There are still some in others:

arch/arm/mach-omap1/board-palmz71.c
arch/arm/mach-pxa/lubbock.c
arch/arm/mach-pxa/magician.c
arch/arm/mach-pxa/palmtx.c
arch/arm/mach-pxa/palmz72.c
arch/arm/mach-pxa/trizeps4.c
arch/sparc/kernel/ldc.c
arch/um/drivers/line.c
arch/um/drivers/mconsole_kern.c
arch/um/drivers/port_kern.c
arch/um/drivers/xterm_kern.c
arch/um/kernel/sigio.c
arch/x86/kernel/amd_iommu_init.c
drivers/i2c/busses/i2c-pmcmsp.c
drivers/mfd/tps65010.c
drivers/power/pda_power.c
drivers/serial/bfin_sport_uart.c
drivers/serial/mpc52xx_uart.c
drivers/serial/uartlite.c
drivers/staging/comedi/interrupt.h
drivers/usb/gadget/goku_udc.c
drivers/usb/gadget/omap_udc.c
drivers/usb/gadget/pxa25x_udc.c
drivers/usb/otg/gpio_vbus.c
drivers/usb/otg/isp1301_omap.c

> Everything going into the 
> RNG should be made to go through an add_*_randomness interface only.
> Preferably not at a per-driver level.

Is that "Everything in general, with a few exceptions", or "__Everything__"?

If it is the latter I'll remove the ones that I'm responsible for, and send 
Sam something for checkpatch.pl to warn if this is used in the future.

-Robin
