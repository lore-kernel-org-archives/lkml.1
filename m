Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYHAUg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYHAUg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHAUgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:36:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:34355 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbYHAUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uzV8rj9dvJYKHzuzu01/oFyCyFrQs2cKWiZEXeX2K2OidBA27fDmrDEGkpqlE//1Hr
         a4O7Adgni313cbjFQWAIkBuSZtK8vqu7KwODX6/DMqhzjAhTeDrOFmx7RumFDHXyUGYU
         CUPdxfUXXkW++atoswJGorNRE9vJwSTeaMKiU=
Message-ID: <2c0942db0808011336h32112df2v706a452a6db518ba@mail.gmail.com>
Date: Fri, 1 Aug 2008 13:36:22 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Sven Wegener" <sven.wegener@stealer.net>
Subject: Re: [PATCH] leds: Avoid needless strlen() for attributes
Cc: "Richard Purdie" <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0808012226560.2294@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0808012226560.2294@titan.stealer.net>
X-Google-Sender-Auth: 1714e56d9ed21e2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 1:30 PM, Sven Wegener <sven.wegener@stealer.net> wrote:
> There's no need for the additional call to strlen(), we can directly return the
> value returned by sprintf(). We now return a length value that doesn't include
> the final '\0', but user space shouldn't bother about it anyway.

Why not just add 1 to the return value of sprintf, and guarantee that
userspace sees the same thing before and after? It's simple enough to
do, and avoids guessing about what userspace may or may not be doing.

> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> ---
>  drivers/leds/led-class.c     |    5 +----
>  drivers/leds/ledtrig-timer.c |    8 ++------
>  2 files changed, 3 insertions(+), 10 deletions(-)
>
> Patch is based on your current (024e8ac) leds git tree head.
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 559a408..1aa24d3 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -34,14 +34,11 @@ static ssize_t led_brightness_show(struct device *dev,
>                struct device_attribute *attr, char *buf)
>  {
>        struct led_classdev *led_cdev = dev_get_drvdata(dev);
> -       ssize_t ret = 0;
>
>        /* no lock needed for this */
>        led_update_brightness(led_cdev);
> -       sprintf(buf, "%u\n", led_cdev->brightness);
> -       ret = strlen(buf) + 1;
>
> -       return ret;
> +       return sprintf(buf, "%u\n", led_cdev->brightness);
>  }
>
>  static ssize_t led_brightness_store(struct device *dev,
> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> index 5c99f4f..db68196 100644
> --- a/drivers/leds/ledtrig-timer.c
> +++ b/drivers/leds/ledtrig-timer.c
> @@ -70,9 +70,7 @@ static ssize_t led_delay_on_show(struct device *dev,
>        struct led_classdev *led_cdev = dev_get_drvdata(dev);
>        struct timer_trig_data *timer_data = led_cdev->trigger_data;
>
> -       sprintf(buf, "%lu\n", timer_data->delay_on);
> -
> -       return strlen(buf) + 1;
> +       return sprintf(buf, "%lu\n", timer_data->delay_on);
>  }
>
>  static ssize_t led_delay_on_store(struct device *dev,
> @@ -116,9 +114,7 @@ static ssize_t led_delay_off_show(struct device *dev,
>        struct led_classdev *led_cdev = dev_get_drvdata(dev);
>        struct timer_trig_data *timer_data = led_cdev->trigger_data;
>
> -       sprintf(buf, "%lu\n", timer_data->delay_off);
> -
> -       return strlen(buf) + 1;
> +       return sprintf(buf, "%lu\n", timer_data->delay_off);
>  }
>
>  static ssize_t led_delay_off_store(struct device *dev,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
