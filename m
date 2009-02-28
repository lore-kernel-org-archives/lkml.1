Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZB1Fvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZB1Fvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZB1Fvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:51:42 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:18292 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZB1Fvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:51:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Iokeoxm1d6TWXAjRaIs6NeBp05EiMyMKrNBlSw43xdc7HDarZDNE2Ijf51o3wXWlnE
         7zOGBRLH1ymUQoTXmWK2cWNDarZVwqUAGnNym8mm1Hr/uDM4xSyJzzkKrU/hFZ2oufLY
         4qFbxQBjcOMJXditipOK5FAOljn7y5YlR+XIo=
MIME-Version: 1.0
In-Reply-To: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
Date: Sat, 28 Feb 2009 11:21:39 +0530
Message-ID: <5d5443650902272151g7595deb4gc91145a4c6938b74@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -0,0 +1,147 @@
> +/**
> + * drivers/i2c/chips/twl4030-pwrbutton.c
> + *

Please remove this file path.

> +
> +static struct input_dev *powerbutton_dev;
> +static struct device *dbg_dev;
> +
> +static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> +{
> +       int err;
> +       u8 value;
> +
> +#ifdef CONFIG_LOCKDEP
> +       /* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> +        * we don't want and can't tolerate.  Although it might be
> +        * friendlier not to borrow this thread context...
> +        */
> +       local_irq_enable();
> +#endif
> +
> +       err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> +                                 STS_HW_CONDITIONS);
> +       if (!err)  {
> +               input_report_key(powerbutton_dev, KEY_POWER,
> +                                value & PWR_PWRON_IRQ);


input_sync(...) please.

> +       } else {
> +               dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
> +                       " PM_MASTER STS_HW_CONDITIONS register\n", err);
> +       }
> +

> +static int __devexit twl4030_pwrbutton_remove(struct platform_device *pdev)
> +{
> +       int irq = platform_get_irq(pdev, 0);
> +
> +       free_irq(irq, NULL);
> +       input_unregister_device(powerbutton_dev);
> +       input_free_device(powerbutton_dev);

No need of input_free_device after input_unregister_device.

> +
> +       return 0;
> +}
> +
> +struct platform_driver twl4030_pwrbutton_driver = {
> +       .probe          = twl4030_pwrbutton_probe,
> +       .remove         = twl4030_pwrbutton_remove,

__devexit_p(...)



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
