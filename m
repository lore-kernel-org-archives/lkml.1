Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZLNLbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZLNLbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZLNLbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:31:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33232 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155AbZLNLbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:31:44 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Felipe Balbi <felipe.balbi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>
Date: Mon, 14 Dec 2009 17:01:11 +0530
Subject: RE: [RFC/PATCH 2/4] input: misc: twl4030: move to
 request_threaded_irq
Thread-Topic: [RFC/PATCH 2/4] input: misc: twl4030: move to
 request_threaded_irq
Thread-Index: Acp8qe0G3hnJd4mSRFiREyhPnqJWUAABbOGA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02BC1421BD@dbde02.ent.ti.com>
References: <20091212183410.GF3092@sirena.org.uk>
 <1260786654-13294-3-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1260786654-13294-3-git-send-email-felipe.balbi@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,
> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Felipe
> Balbi
> Sent: Monday, December 14, 2009 4:01 PM
> To: linux-kernel@vger.kernel.org
> Cc: Linux OMAP Mailing List; Tony Lindgren; Aaro Koskinen; David Brownell; Linux USB Mailing List;
> Anton Vorontsov; Grazvydas Ignotas; Chikkature Rajashekar, Madhusudhan; Greg Kroah-Hartman; Mark
> Brown; Samuel Ortiz; Felipe Balbi
> Subject: [RFC/PATCH 2/4] input: misc: twl4030: move to request_threaded_irq
> 
> move to request_threaded_irq() on twl4030 children.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
>  drivers/input/misc/twl4030-pwrbutton.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index f5fc997..cd47d9e 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -39,16 +39,6 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
>  	int err;
>  	u8 value;
> 
> -#ifdef CONFIG_LOCKDEP
> -	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> -	 * we don't want and can't tolerate since this is a threaded
> -	 * IRQ and can sleep due to the i2c reads it has to issue.
> -	 * Although it might be friendlier not to borrow this thread
> -	 * context...
> -	 */
> -	local_irq_enable();
> -#endif
> -
>  	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
>  				  STS_HW_CONDITIONS);
>  	if (!err)  {
> @@ -80,7 +70,7 @@ static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
>  	pwr->phys = "twl4030_pwrbutton/input0";
>  	pwr->dev.parent = &pdev->dev;
> 
> -	err = request_irq(irq, powerbutton_irq,
> +	err = request_threaded_irq(irq, NULL, powerbutton_irq,
>  			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>  			"twl4030_pwrbutton", pwr);
>  	if (err < 0) {
In whole of the series the ISR you have converted to threads using threaded_irq are very
small in size. They are like quick_change_handlers. So only advantage is the particular 
interrupt is masked for bit longer than with you change.

I might be wrong here but it might introduce the spurious IRQ's because of bit of delay in the processing.What is the motive for this change ? Are we using this API as it suppose to be ?
