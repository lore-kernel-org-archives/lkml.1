Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0BJNuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:50:44 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:58850 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab0BJNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:50:42 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2010 08:50:42 EST
Message-ID: <4B72B7E1.40907@billgatliff.com>
Date: Wed, 10 Feb 2010 07:42:57 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: "Stanislav O. Bezzubtsev" <stas@lvk.cs.msu.su>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 2/7] Emulates PWM hardware using a high-resolution
 timer and a GPIO pin
References: <cover.1265748263.git.bgat@billgatliff.com> <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com> <7178097a5a8af15f61656f11b6bef68b0da71498.1265748264.git.bgat@billgatliff.com> <8B7FF140-BE6E-4AD1-86BC-161488675DFB@lvk.cs.msu.su>
In-Reply-To: <8B7FF140-BE6E-4AD1-86BC-161488675DFB@lvk.cs.msu.su>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav O. Bezzubtsev wrote:
>> +
>> +struct gpio_pwm {
>> +	struct pwm_device pwm;
>> +	struct hrtimer t;
>>     
>
> Wouldn't a little bit longer name "timer" instead of simple "t" increase readability?
>   

Couldn't hurt.  Done.

>> +static void
>> +gpio_pwm_work (struct work_struct *work)
>> +{
>> +	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
>> +
>> +	if (gp->active)
>> +		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
>> +	else
>> +		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
>>     
>
> Maybe the following would be better:
> gpio_direction_output(gp->gpio, gp->polarity ^ gp->active)
> Instead of doing several comparisons.
>   

... except that I'm trying to guarantee that only the values '1' or '0'
get sent to gpio_direction_output.  There's nothing in the spec that
says other values are legal, although I'll admit that any nonzero value
is unlikely to cause problems.  Should I be pedantic here?

>> +
>> +	if (gp->active)
>> +		hrtimer_start(&gp->t,
>> +			      ktime_set(0, gp->pwm.channels[0].duty_ticks),
>> +			      HRTIMER_MODE_REL);
>> +	else
>> +		hrtimer_start(&gp->t,
>> +			      ktime_set(0,gp->pwm.channels[0].period_ticks
>> +					- gp->pwm.channels[0].duty_ticks),
>> +			      HRTIMER_MODE_REL);
>>     
>
> if (gp->active)
> 	t =  ktime_set(0, gp->pwm.channels[0].duty_ticks));
> else
> 	t = ktime_set(0, gp->pwm.channels[0].period_ticks - gp->pwm.channels[0].duty_ticks));
>
> htimer_start(&gp->t, t, HRTIMER_MODE_REL);
>   

Excellent.


>> +
>> +	ret = pwm_register(&gp->pwm);
>> +	if (ret)
>> +		goto err_pwm_register;
>> +
>> +	return 0;
>> +
>> +err_pwm_register:
>>     
>
> platform_set_drvdata(pdev, 0);
>   

Good catch!


>> +static int __devexit
>> +gpio_pwm_remove(struct platform_device *pdev)
>> +{
>> +	struct gpio_pwm *gp = platform_get_drvdata(pdev);
>> +	int ret;
>> +
>> +	ret = pwm_unregister(&gp->pwm);
>> +	hrtimer_cancel(&gp->t);
>> +	cancel_work_sync(&gp->work);
>>     
>
> platform_set_drvdata(pdev, 0);
>   

Ditto.

> And there are too much pr_debug & dev_dbg calls. Several of them are inside critical sections or in functions called from critical sections (inside spin_lock_irqsave - spin_lock_irqrestore block I mean). Don't think it is good.
>   

Ok.  Now that the code is relatively mature, they're unnecessary anyway.


b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com

