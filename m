Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0BRA3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:29:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57693 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0BRA3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W/NZdRl45w6u9g3EWBnPnKazawFzKdQayn5EVctogWywoCpkjU73PHBnXp5hMhInIz
         FMOV1jxOfIVKE7c4kyVomKGU2Qa9XLd//d3MTJYL914InAYiUvn1atWi+rZfjxcaPMfS
         GwFp0JOa870TUo95/jJu9of6OWbZmmMrXP1hY=
MIME-Version: 1.0
In-Reply-To: <201002172320.57491.rjw@sisk.pl>
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
	 <201002172152.39255.rjw@sisk.pl>
	 <74fd948d1002171410l5688c3dfy125ac5c7e80ad1a1@mail.gmail.com>
	 <201002172320.57491.rjw@sisk.pl>
Date: Thu, 18 Feb 2010 00:29:46 +0000
Message-ID: <74fd948d1002171629v7e86371cna4441e8feb27c326@mail.gmail.com>
Subject: Re: 2.6.33-rc8 regression on i915: resume from hibernate locks up 
	every 2nd time
From: Pedro Ribeiro <pedrib@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2010 22:20, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
>> 2010/2/17 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Wednesday 17 February 2010, Rafael J. Wysocki wrote:
>> >> On Wednesday 17 February 2010, Pedro Ribeiro wrote:
>> >> > Hi,
>> >> >
>> >> > commit 84b79f8d2882b0a84330c04839ed4d3cefd2ff77 (drm/i915: Fix crash
>> >> > while aborting hibernation) introduced two new issues which were not
>> >> > present in 2.6.33-rc7:
>> >> >
>> >> > - every second resume from hibernate results in a blank screen
>> >> > - the annoying flash at the end of atomic copy/restore during the
>> >> > hibernate process is back (present in kernels < 2.6.33)
>> >> >
>> >> > The first issue is serious, the second is just an annoyance.
>> >>
>> >> The second one is an expected price of fixing the aborted hibernation
>> >> regression.
>> >>
>> >> The first one shouldn't happen, though.
>> >>
>> >> I'll see if I can reproduce that locally.
>> >
>> > No, I can't.
>> >
>> > Is the driver compiled directly into the kernel or modular?
>>
>> The driver is modular.
>> And sorry, I forgot to tell you I'm using TuxOnIce, it certainly makes
>> a difference.
>
> It shouldn't in fact, although I'm not sure.
>
>> However, every since I reverted that commit I've done 10 test
>> hibernations and no hang so far.
>
> First, please try if you can reproduce it with non-modular driver.
>
> Second, please check if the appended patch helps.
>
> Rafael
>
> ---
>  drivers/gpu/drm/i915/i915_drv.c |   30 +++++++++---------------------
>  1 file changed, 9 insertions(+), 21 deletions(-)
>
> Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
> ===================================================================
> --- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
> +++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
> @@ -177,6 +177,8 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
>
>  static int i915_drm_freeze(struct drm_device *dev)
>  {
> +       struct drm_i915_private *dev_priv = dev->dev_private;
> +
>        pci_save_state(dev->pdev);
>
>        /* If KMS is active, we do the leavevt stuff here */
> @@ -192,17 +194,12 @@ static int i915_drm_freeze(struct drm_de
>
>        i915_save_state(dev);
>
> -       return 0;
> -}
> -
> -static void i915_drm_suspend(struct drm_device *dev)
> -{
> -       struct drm_i915_private *dev_priv = dev->dev_private;
> -
>        intel_opregion_free(dev, 1);
>
>        /* Modeset on resume, not lid events */
>        dev_priv->modeset_on_lid = 0;
> +
> +       return 0;
>  }
>
>  static int i915_suspend(struct drm_device *dev, pm_message_t state)
> @@ -222,8 +219,6 @@ static int i915_suspend(struct drm_devic
>        if (error)
>                return error;
>
> -       i915_drm_suspend(dev);
> -
>        if (state.event == PM_EVENT_SUSPEND) {
>                /* Shut down the device */
>                pci_disable_device(dev->pdev);
> @@ -238,6 +233,10 @@ static int i915_drm_thaw(struct drm_devi
>        struct drm_i915_private *dev_priv = dev->dev_private;
>        int error = 0;
>
> +       i915_restore_state(dev);
> +
> +       intel_opregion_init(dev, 1);
> +
>        /* KMS EnterVT equivalent */
>        if (drm_core_check_feature(dev, DRIVER_MODESET)) {
>                mutex_lock(&dev->struct_mutex);
> @@ -264,10 +263,6 @@ static int i915_resume(struct drm_device
>
>        pci_set_master(dev->pdev);
>
> -       i915_restore_state(dev);
> -
> -       intel_opregion_init(dev, 1);
> -
>        return i915_drm_thaw(dev);
>  }
>
> @@ -424,8 +419,6 @@ static int i915_pm_suspend(struct device
>        if (error)
>                return error;
>
> -       i915_drm_suspend(drm_dev);
> -
>        pci_disable_device(pdev);
>        pci_set_power_state(pdev, PCI_D3hot);
>
> @@ -465,13 +458,8 @@ static int i915_pm_poweroff(struct devic
>  {
>        struct pci_dev *pdev = to_pci_dev(dev);
>        struct drm_device *drm_dev = pci_get_drvdata(pdev);
> -       int error;
> -
> -       error = i915_drm_freeze(drm_dev);
> -       if (!error)
> -               i915_drm_suspend(drm_dev);
>
> -       return error;
> +       return i915_drm_freeze(drm_dev);
>  }
>
>  const struct dev_pm_ops i915_pm_ops = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

The patch fixes this issue for me.

Thanks for your help.

Pedro
