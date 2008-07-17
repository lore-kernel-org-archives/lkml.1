Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYGQN4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYGQN4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbYGQNzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:55:46 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9435 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755633AbYGQNzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:55:44 -0400
Date: Thu, 17 Jul 2008 17:55:42 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717135542.GA15503@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1216133032.5345.73.camel@dax.rpnet.com> <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <Pine.LNX.4.64.0807162143460.26314@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807162143460.26314@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 10:13:06PM -0700, Trent Piepho wrote:
> on Wed, 16 Jul 2008, Grant Likely wrote:
> > On Wed, Jul 16, 2008 at 04:18:52PM -0700, Trent Piepho wrote:
> >> On Tue, 15 Jul 2008, Anton Vorontsov wrote:
> >>> Despite leds-gpio and leds-openfirmware-gpio similar purposes, there
> >>> is not much code can be shared between the two drivers (both are mostly
> >>> driver bindings anyway).
> >>
> >> Why can't this driver use the existing gpio-led driver?  Basically, do
> >> something like this:
> >>
> >
> > Ugh; that means registering *2* 'struct device' with the kernel instead of
> > one.  One as a platform device and one as an of_platform device.
> > It's bad enough that the LED scheme we're using for OF bindings has a
> > separate registration for every single LED.
> 
> Ok, how about adding code the existing leds-gpio driver so that it can creates
> LEDs from of_platform devices too?

Few comments below.

> I've made a patch to do this and it works ok.  The code added to leds-gpio is
> about half what was involved in Anton's new driver. 

This isn't true.

> What I did was re-factor
> the existing platform device probe function to use a new function that creates
> a single led.  Then a new of_platform probe function can use it too.  That way
> most of the probe code is shared.  remove, suspend and resume aren't shared,
> but they're short.  And the existing code to actually drive the led gets
> reused as is.
> 
> There is still one of_platform device per led because of how the bindings work
> (but that could be changed with new bindings), but there are zero extra
> platform devices created.

You didn't count extra platform driver. You can't #ifdef it. The only way
you can avoid this is creating leds-gpio-base.c or something, and place the
helper functions there.

> Here's an example patch.  It won't apply to the git kernel as is, but should
> make it clear how this works.
> 
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index a4a2838..12e681e 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -71,11 +71,45 @@ static int gpio_blink_set(struct led_classdev *led_cdev,
>   	return led_dat->platform_gpio_blink_set(led_dat->gpio, delay_on, delay_off);
>   }
> 
> +static int create_gpio_led(struct gpio_led *cur_led,

The create_gpio_led() interface is also quite weird, since it implies that
we have to pass two GPIO LED "handles": struct gpio_led_data (that we
allocated) and temporary struct gpio_led. And this helper function will
just assign things from one struct to another, and then will register the
led.

With OF driver I don't need "struct gpio_led". Only the platform driver
need this so platforms could pass gpio led info through it, while with OF
we're getting all information from the device tree.

I'm not opposed to another struct used in the OF driver though, I'm rather
opposed to the indirectness it introduces. But I also believe that we
can refactor the code so it will look neat. I just don't want to do
all this churn to save mere 30 lines of code.

> +	struct gpio_led_data *led_dat, struct device *parent,
> +	int (*blink_set)(unsigned, unsigned long *, unsigned long *))

We don't need blink_set. Personally I think that accepting blink
support in leds-gpio driver was... um, not right. In OF driver we'll
never use it. We support just GPIO LEDs, not PWM LEDs.

> +
> +{
> +	int ret;
> +
> +	ret = gpio_request(cur_led->gpio, cur_led->name);
> +	if (ret < 0)
> +		return ret;
> +
> +	led_dat->cdev.name = cur_led->name;
> +	led_dat->cdev.default_trigger = cur_led->default_trigger;
> +	led_dat->gpio = cur_led->gpio;
> +	led_dat->can_sleep = gpio_cansleep(cur_led->gpio);
> +	led_dat->active_low = cur_led->active_low;
> +	if (blink_set) {
> +		led_dat->platform_gpio_blink_set = blink_set;
> +		led_dat->cdev.blink_set = gpio_blink_set;
> +	}
> +	led_dat->cdev.brightness_set = gpio_led_set;
> +	led_dat->cdev.brightness = cur_led->start_on ? LED_FULL : LED_OFF;
> +
> +	gpio_direction_output(led_dat->gpio,
> +			      led_dat->active_low ^ cur_led->start_on);
> +
> +	INIT_WORK(&led_dat->work, gpio_led_work);
> +
> +	ret = led_classdev_register(parent, &led_dat->cdev);
> +	if (ret < 0)
> +		gpio_free(led_dat->gpio);
> +
> +	return ret;
> +}
> +
>   static int gpio_led_probe(struct platform_device *pdev)
>   {
>   	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
> -	struct gpio_led *cur_led;
> -	struct gpio_led_data *leds_data, *led_dat;
> +	struct gpio_led_data *leds_data;
>   	int i, ret = 0;
> 
>   	if (!pdata)
> @@ -87,36 +121,10 @@ static int gpio_led_probe(struct platform_device *pdev)
>   		return -ENOMEM;
> 
>   	for (i = 0; i < pdata->num_leds; i++) {
> -		cur_led = &pdata->leds[i];
> -		led_dat = &leds_data[i];
> -
> -		ret = gpio_request(cur_led->gpio, cur_led->name);
> +		ret = create_gpio_led(&pdata->leds[i], &leds_data[i],
> +				      &pdev->dev, pdata->gpio_blink_set);
>   		if (ret < 0)
>   			goto err;
> -
> -		led_dat->cdev.name = cur_led->name;
> -		led_dat->cdev.default_trigger = cur_led->default_trigger;
> -		led_dat->gpio = cur_led->gpio;
> -		led_dat->can_sleep = gpio_cansleep(cur_led->gpio);
> -		led_dat->active_low = cur_led->active_low;
> -		if (pdata->gpio_blink_set) {
> -			led_dat->platform_gpio_blink_set = pdata->gpio_blink_set;
> -			led_dat->cdev.blink_set = gpio_blink_set;
> -		}
> -		led_dat->cdev.brightness_set = gpio_led_set;
> -		led_dat->cdev.brightness =
> -			cur_led->start_on ? LED_FULL : LED_OFF;
> -
> -		gpio_direction_output(led_dat->gpio,
> -				      led_dat->active_low ^ cur_led->start_on);
> -
> -		INIT_WORK(&led_dat->work, gpio_led_work);
> -
> -		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
> -		if (ret < 0) {
> -			gpio_free(led_dat->gpio);
> -			goto err;
> -		}
>   	}
> 
>   	platform_set_drvdata(pdev, leds_data);
> @@ -217,3 +225,105 @@ MODULE_AUTHOR("Raphael Assenat <raph@8d.com>");
>   MODULE_DESCRIPTION("GPIO LED driver");
>   MODULE_LICENSE("GPL");
>   MODULE_ALIAS("platform:leds-gpio");
> +
> +
> +/* #ifdef CONFIG_LEDS_GPIO_OF */

Heh.

> +/* OpenFirmware bindings */
> +#include <linux/of_platform.h>
> +
> +/* crap for old kernel, ignore */
> +static inline const char *dev_name(struct device *dev)
> +{ return dev->bus_id; }
> +int of_get_gpio(struct device_node *np, int index)
> +{ const u32 *pp = of_get_property(np, "gpio", NULL); return pp ? *pp : -1; }
> +
> +static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
> +					const struct of_device_id *match)
> +{
> +	struct device_node *np = ofdev->node;
> +	struct gpio_led led;
> +	struct gpio_led_data *led_dat;
> +	int ret;
> +
> +	led_dat = kzalloc(sizeof(*led_dat), GFP_KERNEL);
> +	if (!led_dat)
> +		return -ENOMEM;
> +
> +	memset(&led, 0, sizeof(led));
> +	led.gpio = of_get_gpio(np, 0);
> +	led.name = of_get_property(np, "label", NULL);
> +	if (!led.name)
> +		led.name = dev_name(&ofdev->dev);
> +
> +	ret = create_gpio_led(&led, led_dat, &ofdev->dev, NULL);
> +	if (ret < 0) {
> +		kfree(led_dat);
> +		return ret;
> +	}
> +
> +	dev_set_drvdata(&ofdev->dev, led_dat);
> +
> +	return 0;
> +}
> +
> +static int __devexit of_gpio_leds_remove(struct of_device *ofdev)
> +{
> +	struct gpio_led_data *led = dev_get_drvdata(&ofdev->dev);
> +
> +	led_classdev_unregister(&led->cdev);
> +	cancel_work_sync(&led->work);
> +	gpio_free(led->gpio);
> +	kfree(led);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int of_gpio_led_suspend(struct of_device *ofdev, pm_message_t state)
> +{
> +	struct gpio_led_data *led = dev_get_drvdata(&ofdev->dev);
> +
> +	led_classdev_suspend(&led->cdev);
> +	return 0;
> +}
> +
> +static int of_gpio_led_resume(struct of_device *ofdev)
> +{
> +	struct gpio_led_data *led = dev_get_drvdata(&ofdev->dev);
> +
> +	led_classdev_resume(&led->cdev);
> +	return 0;
> +}
> +#else
> +#define of_gpio_led_suspend NULL
> +#define of_gpio_led_resume NULL
> +#endif /* CONFIG_PM */
> +
> +static const struct of_device_id of_gpio_leds_match[] = {
> +	{ .compatible = "gpio-led", },
> +	{},
> +};
> +
> +static struct of_platform_driver of_gpio_leds_driver = {
> +	.driver = {
> +		.name = "of_gpio_leds",
> +		.owner = THIS_MODULE,
> +	},
> +	.match_table = of_gpio_leds_match,
> +	.probe = of_gpio_leds_probe,
> +	.remove = __devexit_p(of_gpio_leds_remove),
> +	.suspend = of_gpio_led_suspend,
> +	.resume = of_gpio_led_resume,
> +};
> +
> +static int __init of_gpio_leds_init(void)
> +{
> +	return of_register_platform_driver(&of_gpio_leds_driver);
> +}
> +module_init(of_gpio_leds_init);
> +
> +static void __exit of_gpio_leds_exit(void)
> +{
> +	of_unregister_platform_driver(&of_gpio_leds_driver);
> +}
> +module_exit(of_gpio_leds_exit);

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
