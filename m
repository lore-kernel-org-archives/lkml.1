Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbZLQJrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbZLQJrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764248AbZLQJra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:47:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41472 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZLQJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:47:28 -0500
Date: Thu, 17 Dec 2009 10:47:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Paul Mundt <lethal@linux-sh.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/7] ASoC: sh: FSI:: don't check platform_get_irq's
	return value against zero
Message-ID: <20091217094723.GB19548@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-7-git-send-email-u.kleine-koenig@pengutronix.de> <uk4wmtlz2.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <uk4wmtlz2.wl%morimoto.kuninori@renesas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:42:25AM +0900, Kuninori Morimoto wrote:
> 
> Dear Uwe
> 
> > platform_get_irq returns -ENXIO on failure, so !irq was probably
> > always true.  Better use (int)irq <= 0.  Note that a return value of
> > zero is still handled as error even though this could mean irq0.
> (snip)
> > -	if (!res || !irq) {
> > +	if (!res || (int)irq <= 0) {
> 
> Ohh..
> Thank you for checking.
> 
> Hmm..  now I tried to check about platform_get_irq in Linux kernel.
> In my easy check, I can find a lot of drivers which are...
> 
> o doesn't check irq value          ex) request_irq(platform_get_irq(...))
This is probably worth fixing.

> o checked irq but it have miss (?) ex) if (irq >= 0) OK
>                                        if (irq) OK
>                                        if (irq == -Exxx ) NG
For some drivers if (irq >= 0) is OK.  if (irq) is wrong.  if (irq ==
-Exxx ) IMHO isn't carefully enough.

> o checked irq but don't care zero  ex) if (irq < 0) NG
Same as if (irq >= 0)

> ---- it use !irq  ------------------------
> 
>  arch/avr32/mach-at32ap/extint.c :: 200
>  drivers/media/video/mx1_camera.c :: 651
>  drivers/media/video/sh_mobile_ceu_camera.c :: 1655
>  drivers/misc/atmel-ssc.c :: 110
>  drivers/net/can/at91_can.c :: 1071
>  drivers/net/sni_82596.c :: 112
>  drivers/pcmcia/bfin_cf_pcmcia.c :: 207
>  drivers/spi/spi_imx.c :: 553
>  drivers/spi/spi_mpc8xxx.c :: 885
>  drivers/usb/gadget/fsl_udc_core.c :: 2303
Most of these are fixed in this series.  I seem to have missed

	drivers/misc/atmel-ssc.c
	drivers/net/sni_82596.c
	drivers/usb/gadget/fsl_udc_core.c

and I found sound/soc/sh/fsi.c and drivers/spi/spi_imx.c should already
be fixed in Linus' Tree.

I wait to see the result for the already existing patches.  If they are
taken I might look for the others, too.  If you want to prepare some
more patches, feel free to do it.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
