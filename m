Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZBTVnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZBTVnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZBTVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:43:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZBTVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:43:41 -0500
Date: Fri, 20 Feb 2009 13:42:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       felipe.balbi@nokia.com
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
Message-Id: <20090220134237.50086106.akpm@linux-foundation.org>
In-Reply-To: <1235045654-29025-1-git-send-email-me@felipebalbi.com>
References: <1235045654-29025-1-git-send-email-me@felipebalbi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 14:14:14 +0200
Felipe Balbi <me@felipebalbi.com> wrote:

> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> lm8323 is the keypad driver used in n810 device. This
> driver has been sitting in linux-omap for quite a long
> time, it's about time to get comments from upstream and
> get it merged.
> 

Please feed it through scripts/checkpatch.pl and review the resulting
report?


> +static ssize_t lm8323_pwm_store_time(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct lm8323_pwm *pwm = cdev_to_pwm(led_cdev);
> +	int ret;
> +	int time;
> +
> +	ret = sscanf(buf, "%d", &time);
> +	/* Numbers only, please. */
> +	if (ret)
> +		return -EINVAL;

strict_strtoul() does a better job of this.

> +	pwm->fade_time = time;
> +
> +	return strlen(buf);
> +}
> +static DEVICE_ATTR(time, 0644, lm8323_pwm_show_time, lm8323_pwm_store_time);
> +
> +static int init_pwm(struct lm8323_chip *lm, int id, struct device *dev,
> +		    const char *name)
> +{
> +	struct lm8323_pwm *pwm = NULL;
> +
> +	BUG_ON(id > 3);
> +
> +	switch (id) {
> +	case 1:
> +		pwm = &lm->pwm1;
> +		break;
> +	case 2:
> +		pwm = &lm->pwm2;
> +		break;
> +	case 3:
> +		pwm = &lm->pwm3;
> +		break;
> +	}
> +
> +	pwm->id = id;
> +	pwm->fade_time = 0;
> +	pwm->brightness = 0;
> +	pwm->desired_brightness = 0;
> +	pwm->running = 0;
> +	mutex_init(&pwm->lock);
> +	if (name) {
> +		pwm->cdev.name = name;
> +		pwm->cdev.brightness_set = lm8323_pwm_set_brightness;
> +		if (led_classdev_register(dev, &pwm->cdev) < 0) {

I did't see a dependency on LEDS in the Kconfig entry.  Will it compile
with LEDS=n?


> +			dev_err(dev, "couldn't register PWM %d\n", id);
> +			return -1;
> +		}
> +		if (device_create_file(pwm->cdev.dev,
> +					     &dev_attr_time) < 0) {
> +			dev_err(dev, "couldn't register time attribute\n");
> +			led_classdev_unregister(&pwm->cdev);
> +			return -1;
> +		}
> +		INIT_WORK(&pwm->work, lm8323_pwm_work);
> +		pwm->enabled = 1;
> +	} else {
> +		pwm->enabled = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct i2c_driver lm8323_i2c_driver;
> +
> +static ssize_t lm8323_show_disable(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct lm8323_chip *lm = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", !lm->kp_enabled);
> +}
> +
> +static ssize_t lm8323_set_disable(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	struct lm8323_chip *lm = dev_get_drvdata(dev);
> +	int ret;
> +	int i;
> +
> +	i = sscanf(buf, "%d", &ret);

Again, strict_strto*() would be better.  It will disallow input of the
form "42foo".

> +	mutex_lock(&lm->lock);
> +	lm->kp_enabled = !i;
> +	mutex_unlock(&lm->lock);
> +
> +	return count;
> +}
>
> ...
>
> +static struct i2c_driver lm8323_i2c_driver = {
> +	.driver = {
> +		.name	 = "lm8323",
> +	},
> +	.probe		= lm8323_probe,
> +	.remove		= lm8323_remove,
> +	.suspend	= lm8323_suspend,
> +	.resume		= lm8323_resume,
> +	.id_table	= lm8323_id,
> +};

Does this compile and run OK with CONFIG_PM=n?

>
> ...
>

