Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbYCSWXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbYCSWXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbYCSVAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:00:18 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:20449 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763443AbYCSVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:00:15 -0400
Message-ID: <1ba2fa240803181043v511df0b6tbe43174feb2f7537@mail.gmail.com>
Date: Tue, 18 Mar 2008 19:43:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: SDIO: IO-Ready Bit
Cc: lkml <linux-kernel@vger.kernel.org>, benzizbit@gmail.com
In-Reply-To: <20080318123325.0843b854@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
	 <20080318123325.0843b854@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 1:33 PM, Pierre Ossman <drzeus@drzeus.cx> wrote:
> On Tue, 18 Mar 2008 13:00:34 +0200
>  "Tomas Winkler" <tomasw@gmail.com> wrote:
>
>  > I'm working on SDIO multi function device.  One of the subdevices  a
>  > system device (SYS) who's  purpose among the others is to initialize
>  > the whole combo, mainly it's loads the firmware of the devices and
>  > kick the sub devices. Each of the sub devices has it's own driver.
>  > This dictates the order of the driver initialization and SYS device
>  > has to compete it's work before other subdeivces drivers can access
>  > the hardware. From hardware perspective device is ready when IO-Ready
>  > bit in SDIO is set.
>
>  What a delightfully unfriendly design...

Yes, but it's damage is already done.

>
>  > The first problem is that currently there is hard code timeout  in
>  > sdio_enable_func instead of using TPLFE_ENABLE_TIMEOUT_VAL
>  > /*
>  >        * FIXME: This should timeout based on information in the CIS,
>  >        * but we don't have card to parse that yet.
>  >        */
>  >       timeout = jiffies + HZ
>  >
>  > This can be probably easily fixed. The significant issue is that this
>  > is done in busy wait loop and that probe functions are called in
>  > serially.
>
>  The SDIO spec doesn't really allow such a card to exist. So it's not surprising that things break.

Not sure to which part of the above paragraph you refer here. The
timeout is defined by spec.

> Does any stack support this odd-ball card?

>
>
>  >
>  > Since we cannot ensure that enumeration of SYS devices will be first
>  > the other sub devices will fail in their probe functions while calling
>  > sido_enable_func
>  >
>  > One option is to move the sdio_enable_func to be called from a work
>  > queue kicked from probe. This still requires non-busy wait timeout on
>  > IO-Ready bit and we cannot fail probe func
>  > if something goes wrong.
>  > Second option would be somehow split the sdio probe function across
>  > the enabled timeout.
>
>  I think it's a bit more complex than that. There are likely locks all over the place, both in the relevant driver and the driver model core, that makes this very difficult. Not to mention the fact that the correct timeout will be finite, and you never know how long it will take you to load the firmware.

Good point but IMHO the timeout can got to minutes so it's converging
to infinite in this case.



>
>  A better approach is to simply have the drivers for your subfunctions synchronize things. Make sure noone calls sdio_enable_func() until the firmware has been loaded.

This could even be done from user space in case you want to use a
standard driver.

Won't this prevent us from compiling the drivers into kernel?
Second how this possible especially with standard driver as they are
loaded. I know you can enforce module loading but how can you enforce
probing order form user space?

Thanks
Tomas

>  Rgds
>  Pierre
>
>
