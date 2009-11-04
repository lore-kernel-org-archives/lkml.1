Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZKDQ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZKDQ2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZKDQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:28:42 -0500
Received: from mga06.intel.com ([134.134.136.21]:59996 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755917AbZKDQ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:28:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,680,1249282800"; 
   d="scan'208";a="464300419"
Date: Wed, 4 Nov 2009 17:30:16 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Convert wm8350 IRQ handlers to irq_handler_t
Message-ID: <20091104163015.GF3607@sortiz.org>
References: <1257351052-32375-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257351052-32375-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Nov 04, 2009 at 04:10:51PM +0000, Mark Brown wrote:
> This is done as simple code transformation, the semantics of the
> IRQ API provided by the core are are still very different to those
> of genirq (mainly with regard to masking).
Both patches applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-irq.c             |    6 ++--
>  drivers/power/wm8350_power.c         |   39 +++++++++++++++++++++------------
>  drivers/regulator/wm8350-regulator.c |    7 ++++-
>  drivers/rtc/rtc-wm8350.c             |   18 ++++++++++-----
>  include/linux/mfd/wm8350/core.h      |    8 +++---
>  sound/soc/codecs/wm8350.c            |   15 ++++++++----
>  6 files changed, 59 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
> index d9abfc9..2ea2b8b 100644
> --- a/drivers/mfd/wm8350-irq.c
> +++ b/drivers/mfd/wm8350-irq.c
> @@ -371,7 +371,7 @@ static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
>  	mutex_lock(&wm8350->irq_mutex);
>  
>  	if (wm8350->irq[irq].handler)
> -		wm8350->irq[irq].handler(wm8350, irq, wm8350->irq[irq].data);
> +		wm8350->irq[irq].handler(irq, wm8350->irq[irq].data);
>  	else {
>  		dev_err(wm8350->dev, "irq %d nobody cared. now masked.\n",
>  			irq);
> @@ -431,8 +431,8 @@ static irqreturn_t wm8350_irq(int irq, void *irq_data)
>  }
>  
>  int wm8350_register_irq(struct wm8350 *wm8350, int irq,
> -			void (*handler) (struct wm8350 *, int, void *),
> -			void *data)
> +			irq_handler_t handler, unsigned long flags,
> +			const char *name, void *data)
>  {
>  	if (irq < 0 || irq > WM8350_NUM_IRQ || !handler)
>  		return -EINVAL;
> diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
> index 28b0299..6e634cf 100644
> --- a/drivers/power/wm8350_power.c
> +++ b/drivers/power/wm8350_power.c
> @@ -184,8 +184,9 @@ static ssize_t charger_state_show(struct device *dev,
>  
>  static DEVICE_ATTR(charger_state, 0444, charger_state_show, NULL);
>  
> -static void wm8350_charger_handler(struct wm8350 *wm8350, int irq, void *data)
> +static irqreturn_t wm8350_charger_handler(int irq, void *data)
>  {
> +	struct wm8350 *wm8350 = data;
>  	struct wm8350_power *power = &wm8350->power;
>  	struct wm8350_charger_policy *policy = power->policy;
>  
> @@ -238,6 +239,8 @@ static void wm8350_charger_handler(struct wm8350 *wm8350, int irq, void *data)
>  	default:
>  		dev_err(wm8350->dev, "Unknown interrupt %d\n", irq);
>  	}
> +
> +	return IRQ_HANDLED;
>  }
>  
>  /*********************************************************************
> @@ -387,45 +390,53 @@ static void wm8350_init_charger(struct wm8350 *wm8350)
>  {
>  	/* register our interest in charger events */
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0, "Battery hot", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0, "Battery cold", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0, "Battery fail", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Charger timeout", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_TO);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Charge end", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_END);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Charge start", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_START);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Fast charge ready", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Battery <3.9V", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Battery <3.1V", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0,
> +			    "Battery <2.85V", wm8350);
> +
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
>  
>  	/* and supply change events */
>  	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0, "USB", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0, "Wall", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
> -			    wm8350_charger_handler, NULL);
> +			    wm8350_charger_handler, 0, "Battery", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
>  }
>  
> diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
> index 768bd0e..8c289fd 100644
> --- a/drivers/regulator/wm8350-regulator.c
> +++ b/drivers/regulator/wm8350-regulator.c
> @@ -1330,9 +1330,10 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
>  	 },
>  };
>  
> -static void pmic_uv_handler(struct wm8350 *wm8350, int irq, void *data)
> +static irqreturn_t pmic_uv_handler(int irq, void *data)
>  {
>  	struct regulator_dev *rdev = (struct regulator_dev *)data;
> +	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
>  
>  	mutex_lock(&rdev->mutex);
>  	if (irq == WM8350_IRQ_CS1 || irq == WM8350_IRQ_CS2)
> @@ -1344,6 +1345,8 @@ static void pmic_uv_handler(struct wm8350 *wm8350, int irq, void *data)
>  					      REGULATOR_EVENT_UNDER_VOLTAGE,
>  					      wm8350);
>  	mutex_unlock(&rdev->mutex);
> +
> +	return IRQ_HANDLED;
>  }
>  
>  static int wm8350_regulator_probe(struct platform_device *pdev)
> @@ -1388,7 +1391,7 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
>  
>  	/* register regulator IRQ */
>  	ret = wm8350_register_irq(wm8350, wm8350_reg[pdev->id].irq,
> -				  pmic_uv_handler, rdev);
> +				  pmic_uv_handler, 0, "UV", rdev);
>  	if (ret < 0) {
>  		regulator_unregister(rdev);
>  		dev_err(&pdev->dev, "failed to register regulator %s IRQ\n",
> diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
> index c91edc5..56e56e5 100644
> --- a/drivers/rtc/rtc-wm8350.c
> +++ b/drivers/rtc/rtc-wm8350.c
> @@ -315,9 +315,9 @@ static int wm8350_rtc_update_irq_enable(struct device *dev,
>  	return 0;
>  }
>  
> -static void wm8350_rtc_alarm_handler(struct wm8350 *wm8350, int irq,
> -				     void *data)
> +static irqreturn_t wm8350_rtc_alarm_handler(int irq, void *data)
>  {
> +	struct wm8350 *wm8350 = data;
>  	struct rtc_device *rtc = wm8350->rtc.rtc;
>  	int ret;
>  
> @@ -330,14 +330,18 @@ static void wm8350_rtc_alarm_handler(struct wm8350 *wm8350, int irq,
>  		dev_err(&(wm8350->rtc.pdev->dev),
>  			"Failed to disable alarm: %d\n", ret);
>  	}
> +
> +	return IRQ_HANDLED;
>  }
>  
> -static void wm8350_rtc_update_handler(struct wm8350 *wm8350, int irq,
> -				      void *data)
> +static irqreturn_t wm8350_rtc_update_handler(int irq, void *data)
>  {
> +	struct wm8350 *wm8350 = data;
>  	struct rtc_device *rtc = wm8350->rtc.rtc;
>  
>  	rtc_update_irq(rtc, 1, RTC_IRQF | RTC_UF);
> +
> +	return IRQ_HANDLED;
>  }
>  
>  static const struct rtc_class_ops wm8350_rtc_ops = {
> @@ -459,10 +463,12 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
>  	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_PER);
>  
>  	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
> -			    wm8350_rtc_update_handler, NULL);
> +			    wm8350_rtc_update_handler, 0,
> +			    "RTC Seconds", wm8350);
>  
>  	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
> -			    wm8350_rtc_alarm_handler, NULL);
> +			    wm8350_rtc_alarm_handler, 0,
> +			    "RTC Alarm", wm8350);
>  	wm8350_unmask_irq(wm8350, WM8350_IRQ_RTC_ALM);
>  
>  	return 0;
> diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
> index ffce508..4386889 100644
> --- a/include/linux/mfd/wm8350/core.h
> +++ b/include/linux/mfd/wm8350/core.h
> @@ -15,7 +15,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/mutex.h>
> -#include <linux/workqueue.h>
> +#include <linux/interrupt.h>
>  
>  #include <linux/mfd/wm8350/audio.h>
>  #include <linux/mfd/wm8350/gpio.h>
> @@ -601,7 +601,7 @@ extern const u16 wm8352_mode3_defaults[];
>  struct wm8350;
>  
>  struct wm8350_irq {
> -	void (*handler) (struct wm8350 *, int, void *);
> +	irq_handler_t handler;
>  	void *data;
>  };
>  
> @@ -678,8 +678,8 @@ int wm8350_block_write(struct wm8350 *wm8350, int reg, int size, u16 *src);
>   * WM8350 internal interrupts
>   */
>  int wm8350_register_irq(struct wm8350 *wm8350, int irq,
> -			void (*handler) (struct wm8350 *, int, void *),
> -			void *data);
> +			irq_handler_t handler, unsigned long flags,
> +			const char *name, void *data);
>  int wm8350_free_irq(struct wm8350 *wm8350, int irq);
>  int wm8350_mask_irq(struct wm8350 *wm8350, int irq);
>  int wm8350_unmask_irq(struct wm8350 *wm8350, int irq);
> diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
> index 593d5b9..2803913 100644
> --- a/sound/soc/codecs/wm8350.c
> +++ b/sound/soc/codecs/wm8350.c
> @@ -1340,9 +1340,10 @@ static int wm8350_resume(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static void wm8350_hp_jack_handler(struct wm8350 *wm8350, int irq, void *data)
> +static irqreturn_t wm8350_hp_jack_handler(int irq, void *data)
>  {
>  	struct wm8350_data *priv = data;
> +	struct wm8350 *wm8350 = priv->codec.control_data;
>  	u16 reg;
>  	int report;
>  	int mask;
> @@ -1365,7 +1366,7 @@ static void wm8350_hp_jack_handler(struct wm8350 *wm8350, int irq, void *data)
>  
>  	if (!jack->jack) {
>  		dev_warn(wm8350->dev, "Jack interrupt called with no jack\n");
> -		return;
> +		return IRQ_NONE;
>  	}
>  
>  	/* Debounce */
> @@ -1378,6 +1379,8 @@ static void wm8350_hp_jack_handler(struct wm8350 *wm8350, int irq, void *data)
>  		report = 0;
>  
>  	snd_soc_jack_report(jack->jack, report, jack->report);
> +
> +	return IRQ_HANDLED;
>  }
>  
>  /**
> @@ -1421,7 +1424,7 @@ int wm8350_hp_jack_detect(struct snd_soc_codec *codec, enum wm8350_jack which,
>  	wm8350_set_bits(wm8350, WM8350_JACK_DETECT, ena);
>  
>  	/* Sync status */
> -	wm8350_hp_jack_handler(wm8350, irq, priv);
> +	wm8350_hp_jack_handler(irq, priv);
>  
>  	wm8350_unmask_irq(wm8350, irq);
>  
> @@ -1485,9 +1488,11 @@ static int wm8350_probe(struct platform_device *pdev)
>  	wm8350_mask_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L);
>  	wm8350_mask_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L,
> -			    wm8350_hp_jack_handler, priv);
> +			    wm8350_hp_jack_handler, 0, "Left jack detect",
> +			    priv);
>  	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R,
> -			    wm8350_hp_jack_handler, priv);
> +			    wm8350_hp_jack_handler, 0, "Right jack detect",
> +			    priv);
>  
>  	ret = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
>  	if (ret < 0) {
> -- 
> 1.6.5.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
