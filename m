Return-Path: <linux-kernel-owner+w=401wt.eu-S934411AbZKXXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbZKXXYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbZKXXYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:24:19 -0500
Received: from mga05.intel.com ([192.55.52.89]:61839 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934372AbZKXXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:24:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,281,1257148800"; 
   d="scan'208";a="750108187"
Date: Wed, 25 Nov 2009 00:26:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091124232602.GH8290@sortiz.org>
References: <20091105235349.GA22519@pengutronix.de>
 <1257465368-24012-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091106002847.GC22366@sortiz.org>
 <20091124214452.GC21466@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091124214452.GC21466@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Tue, Nov 24, 2009 at 10:44:52PM +0100, Uwe Kleine-König wrote:
> Hi Samuel,
> 
> On Fri, Nov 06, 2009 at 01:28:50AM +0100, Samuel Ortiz wrote:
> > On Fri, Nov 06, 2009 at 12:56:08AM +0100, Uwe Kleine-König wrote:
> > > This fixes several things while still providing the old API:
> > > 
> > >  - simplify and fix locking
> > >  - better error handling
> > >  - don't ack all irqs making it impossible to detect a reset of the
> > >    rtc
> > >  - use a timeout variant to wait for completion of ADC conversion
> > >  - provide platform-data to regulator subdevice (This allows making
> > >    struct mc13783 opaque for other drivers after the regulator driver is
> > >    updated to use its platform_data.)
> > >  - expose all interrupts
> > >  - use threaded irq
> > Thanks Uwe, patch applied to my for-next branch.
> 
> I now worked on the touch interface for the mc13783 and found some
> non-critical but non-nice things in the mc13783_adc_do_conversion
> function.
> 
> If it looks OK for you, can you please squash the patch below into the
> original commit?  
That's fine with me, I'll do it.

Cheers,
Samuel.

> I think the changes are not worth to be mentioned in
> the commit log.
> 
> Intensions are:
>  - Request and ack irq before provoking the next to behave if there was
>    already an ADCDONE irq pending.
> 
>  - restore TSMOD only after conversions are read out
> 
>  - assert return value is 0 or -E...
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mfd/mc13783-core.c |   20 ++++++++++++--------
>  1 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
> index 99267ed..dc1add0 100644
> --- a/drivers/mfd/mc13783-core.c
> +++ b/drivers/mfd/mc13783-core.c
> @@ -483,12 +483,13 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
>  		return -EINVAL;
>  	}
>  
> -	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, adc0);
> -	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, adc1);
> -
>  	dev_dbg(&mc13783->spidev->dev, "%s: request irq\n", __func__);
>  	mc13783_irq_request(mc13783, MC13783_IRQ_ADCDONE,
>  			mc13783_handler_adcdone, __func__, &adcdone_data);
> +	mc13783_ackirq(mc13783, MC13783_IRQ_ADCDONE);
> +
> +	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, adc0);
> +	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, adc1);
>  
>  	mc13783_unlock(mc13783);
>  
> @@ -501,15 +502,18 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
>  
>  	mc13783_irq_free(mc13783, MC13783_IRQ_ADCDONE, &adcdone_data);
>  
> +	if (ret > 0)
> +		for (i = 0; i < 4; ++i) {
> +			ret = mc13783_reg_read(mc13783,
> +					MC13783_REG_ADC_2, &sample[i]);
> +			if (ret)
> +				break;
> +		}
> +
>  	if (mode == MC13783_ADC_MODE_TS)
>  		/* restore TSMOD */
>  		mc13783_reg_write(mc13783, MC13783_REG_ADC_0, old_adc0);
>  
> -	if (ret > 0)
> -		for (i = 0; i < 4; ++i)
> -			mc13783_reg_read(mc13783,
> -					MC13783_REG_ADC_2, &sample[i]);
> -
>  	mc13783->flags &= ~MC13783_ADC_WORKING;
>  out:
>  	mc13783_unlock(mc13783);
> -- 
> 1.6.5.2
> 
> 
> -- 
> Pengutronix e.K.                              | Uwe Kleine-König            |
> Industrial Linux Solutions                    | http://www.pengutronix.de/  |

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
