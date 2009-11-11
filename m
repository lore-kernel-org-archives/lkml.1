Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZKKUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZKKUFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZKKUFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:05:39 -0500
Received: from web58401.mail.re3.yahoo.com ([68.142.236.169]:41359 "HELO
	web58401.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757171AbZKKUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:05:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=X6ieqIKVO/4geXl0yZxBVV3XvksWU8JMzAacd39V2pOvPbZIuuDL3lr0AeOBgyBxaXby1jISNQGDaygLgVlOhNAPn7Yaq4WcvPCMMycJ4sYz62+7xCy+Wmh4U3yftM5BNASU/csF9XnJG6PoCZVmNTxuNGtjLnqEXISuKIO+Vbc=;
Message-ID: <800885.42568.qm@web58401.mail.re3.yahoo.com>
X-YMail-OSG: 6DTED3kVM1ntKnWBn4b3lZd44KsKXzt8iTJtdl9ml3D6p25I39AmiEQaw1jUKr9IfB4WlUnUfDoYuGMIBu27x039rzczhXX9jiIDr83tn6ehOLmfF7UPQWmLNAbeiu8NRZOkCMM3BPW2E7FvcSEg5mWyKQk8JSp8isrDePBg2h9OXPFgh4UKDrW8VAiLkJP.lOu1KAHtY9Vjf3hH1SvEMsbzE7LwqXyiX9Gc5n_421joIV37RhZmIv_4rxZ3Y7Wi4fW7aBhpgBbYj4TBga7ZrigPZfhJB1XAzE2g
X-Mailer: YahooMailRC/211.6 YahooMailWebService/0.7.361.4
References: <761296.29412.qm@web58402.mail.re3.yahoo.com> <20091111095218.GA3654@core.coreip.homeip.net>
Date: Wed, 11 Nov 2009 12:05:42 -0800 (PST)
From: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: keyboard leds not restored after s2ram in 2.6.32-rc6-00166-g799dd75
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091111095218.GA3654@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> > my laptop shows the caps lock and scroll lock leds as being on after s2ram
> > (and resume), even though they are off. If I press the caps lock key, the caps
> > lock led stays on, the num lock led turns off, and the screen unlock screen
> > warns about the caps lock being on.
> > 
> 
> Thank you for the report. Could youplease tell me if the patch below
> fixes the problem?

Yes, it does. Thanks, now my HP-dv5 is happy.

I did some tests suspending with the caps lock actually on, and it seems that
in that case the user might still be confused (caps lock is on but led is off).
At least on this machine this patch doesn't affect this theoretical problem
either way (2.6.31 behaves similarly), so it is ok.


Mikko


> 
> Thanks!
> 
> -- 
> Dmitry
> 
> 
> Input: force LED reset on resume
> 
> From: Dmitry Torokhov 
> 
> We should be sending EV_LED event down to drivers upon resume even in cases
> when in-kernel state of the LED is off since device could come up with some
> leds turned on.
> 
> Reported-by: Mikko Vinni 
> Signed-off-by: Dmitry Torokhov 
> ---
> 
> drivers/input/input.c |   29 ++++++++++++++++++-----------
> 1 files changed, 18 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 61069b2..77b6efe 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1298,17 +1298,24 @@ static int input_dev_uevent(struct device *device, 
> struct kobj_uevent_env *env)
>     return 0;
> }
> 
> -#define INPUT_DO_TOGGLE(dev, type, bits, on)            \
> -    do {                            \
> -        int i;                        \
> -        if (!test_bit(EV_##type, dev->evbit))        \
> -            break;                    \
> -        for (i = 0; i < type##_MAX; i++) {        \
> -            if (!test_bit(i, dev->bits##bit) ||    \
> -                !test_bit(i, dev->bits))        \
> -                continue;            \
> -            dev->event(dev, EV_##type, i, on);    \
> -        }                        \
> +#define INPUT_DO_TOGGLE(dev, type, bits, on)                \
> +    do {                                \
> +        int i;                            \
> +        bool active;                        \
> +                                    \
> +        if (!test_bit(EV_##type, dev->evbit))            \
> +            break;                        \
> +                                    \
> +        for (i = 0; i < type##_MAX; i++) {            \
> +            if (!test_bit(i, dev->bits##bit))        \
> +                continue;                \
> +                                    \
> +            active = test_bit(i, dev->bits);        \
> +            if (!active && !on)                \
> +                continue;                \
> +                                    \
> +            dev->event(dev, EV_##type, i, on ? active : 0);    \
> +        }                            \
>     } while (0)
> 
> #ifdef CONFIG_PM



      
