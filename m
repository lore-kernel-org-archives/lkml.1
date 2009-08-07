Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZHGNfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZHGNfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZHGNfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:35:21 -0400
Received: from mail-bw0-f215.google.com ([209.85.218.215]:47182 "EHLO
	mail-bw0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZHGNfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sHYFhOwrgKPUrYuaewrf7dXFsB9U9VCmk62Z7GHR+NEtIgq6fn/qHnQTSTe19FRGH6
         HKEyucejACdqeN+h/qLvoM9yLxsRm/ztXbdXLZc7pWAs+qmVdHMW0ASif5UMBoUQ4Aqz
         9SW6A9P01kceBNiKdfq+mbfJYbimZZGfXsXMQ=
MIME-Version: 1.0
In-Reply-To: <20090806125631.GI19257@buzzloop.caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
	 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
	 <200908052149.55567.elendil@planet.nl>
	 <20090805222920.GF19257@buzzloop.caiaq.de>
	 <74d0deb30908060452k1fc0e982jf14be2e895e9a805@mail.gmail.com>
	 <20090806125631.GI19257@buzzloop.caiaq.de>
Date: Fri, 7 Aug 2009 15:35:19 +0200
Message-ID: <74d0deb30908070635s2fa76e5t954742239b8592a4@mail.gmail.com>
Subject: Re: [PATCH 2/5] pda-power: switch to new dev_pm_ops
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, spyro@f2s.com, cbou@mail.ru,
       mreimer@vpop.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 2:56 PM, Daniel Mack<daniel@caiaq.de> wrote:
> On Thu, Aug 06, 2009 at 01:52:41PM +0200, pHilipp Zabel wrote:
>> On Thu, Aug 6, 2009 at 12:29 AM, Daniel Mack<daniel@caiaq.de> wrote:
>> > On Wed, Aug 05, 2009 at 09:49:52PM +0200, Frans Pop wrote:
>> >> Daniel Mack wrote:
>> >> > +static struct dev_pm_ops pda_power_pm_ops = {
>> >> > +       .suspend        = pda_power_suspend,
>> >> > +       .freeze         = pda_power_freeze,
>> >>
>> >> Hmmm. Where's pda_power_freeze defined? Forgot to (compile)test the
>> >> patches?
>> >
>> > Yes, sorry. I can't test hibernation, so I didn't pay enough attention.
>> > I'll resend them anyway with Rafael's new macro used.
>>
>> After Rafael's comments on gpio_keys, I believe also here
>> .freeze/.thaw should be empty. enable/disable_irq_wake should be
>> called from .poweroff/.restore.
>
> Yes. See the version below.
>
> Thanks,
> Daniel
>
>
> From 6b534fb029f4623a8ddd60a4ea636bd626d6382a Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Wed, 5 Aug 2009 15:31:23 +0200
> Subject: [PATCH 1/3] pda-power: switch to new dev_pm_ops
>
> The callbacks for the implemented functions are .poweroff and .restore,
> as they only care for {dis,en}able_irq(). Renamed the functions to
> reflect that.
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ian Molton <spyro@f2s.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: Matt Reimer <mreimer@vpop.net>
> ---
>  drivers/power/pda_power.c |   25 ++++++++++++++++---------
>  1 files changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index a232de6..c46a6dc 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -402,9 +402,9 @@ static int pda_power_remove(struct platform_device *pdev)
>  static int ac_wakeup_enabled;
>  static int usb_wakeup_enabled;
>
> -static int pda_power_suspend(struct platform_device *pdev, pm_message_t state)
> +static int pda_power_poweroff(struct device *dev)
>  {
> -       if (device_may_wakeup(&pdev->dev)) {
> +       if (device_may_wakeup(dev)) {
>                if (ac_irq)
>                        ac_wakeup_enabled = !enable_irq_wake(ac_irq->start);
>                if (usb_irq)
> @@ -414,9 +414,9 @@ static int pda_power_suspend(struct platform_device *pdev, pm_message_t state)
>        return 0;
>  }
>
> -static int pda_power_resume(struct platform_device *pdev)
> +static int pda_power_restore(struct device *dev)
>  {
> -       if (device_may_wakeup(&pdev->dev)) {
> +       if (device_may_wakeup(dev)) {
>                if (usb_irq && usb_wakeup_enabled)
>                        disable_irq_wake(usb_irq->start);
>                if (ac_irq && ac_wakeup_enabled)
> @@ -425,21 +425,28 @@ static int pda_power_resume(struct platform_device *pdev)
>
>        return 0;
>  }
> +
> +static struct dev_pm_ops pda_power_pm_ops = {
> +       .poweroff       = pda_power_poweroff,
> +       .restore        = pda_power_restore,
> +};

No no, now you're missing .suspend/.resume. As I understand it, the
suspend and hibernation codepaths are now completely separate.

Also, I'm not sure using .restore here is quite correct.
enable_irq_wake is called in .poweroff, after .freeze + creation of
the memory image. So if this memory image is restored during the next
boot, there is no trace of irq wakup ever being enabled and thus no
need to call disable_irq_wake.

I think just .suspend/.poweroff and .resume need to be used for this driver.

> +
> +#define PDA_POWER_PM_OPS (&pda_power_pm_ops)
> +
>  #else
> -#define pda_power_suspend NULL
> -#define pda_power_resume NULL
> +#define PDA_POWER_PM_OPS NULL
>  #endif /* CONFIG_PM */
>
>  MODULE_ALIAS("platform:pda-power");
>
>  static struct platform_driver pda_power_pdrv = {
>        .driver = {
> -               .name = "pda-power",
> +               .name   = "pda-power",
> +               .owner  = THIS_MODULE,
> +               .pm     = PDA_POWER_PM_OPS,
>        },
>        .probe = pda_power_probe,
>        .remove = pda_power_remove,
> -       .suspend = pda_power_suspend,
> -       .resume = pda_power_resume,
>  };
>
>  static int __init pda_power_init(void)
> --
> 1.6.3.3
>
>

regards
Philipp
