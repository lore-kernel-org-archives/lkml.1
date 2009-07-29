Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbZG2Ut2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbZG2Ut2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZG2Ut1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:49:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49546 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbZG2Ut0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:49:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Wed, 29 Jul 2009 22:49:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Manuel Lauss <manuel.lauss@gmail.com>,
       Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <1248648663.3718.7.camel@green> <1248824367.4112.31.camel@green>
In-Reply-To: <1248824367.4112.31.camel@green>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907292249.47761.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Arnaud Faucher wrote:
> On Sun, Jul 26, 2009 at 18:51 -0400, Arnaud Faucher wrote :
> > On dim, 2009-07-26 at 14:33 -0700, Dmitry Torokhov wrote:
> > > On Jul 26, 2009, at 1:28 PM, Arnaud Faucher <arnaud.faucher@gmail.com>  
> > > wrote:
> > > 
> > > > On dim, 2009-07-26 at 19:35 +0100, Carlos Corbacho wrote:
> > > >> On Sunday 26 July 2009 19:08:09 Dmitry Torokhov wrote:
> > > >>> On Sun, Jul 26, 2009 at 03:23:29PM +0100, Carlos Corbacho wrote:
> > > >>>> [Removing linux-mips from CC - I don't know why they'd be  
> > > >>>> interested in
> > > >>>> an x86 only platform driver...]
> > > >>>>
> > > >>>> On Sunday 26 July 2009 14:53:33 Arnaud Faucher wrote:
> > > >>>>> Gets rid of the following warning:
> > > >>>>> Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> > > >>>>>
> > > >>>>> Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM  
> > > >>>>> issue on
> > > >>>>> hibernation when using dev_pm_ops blindly.
> > > >>>>>
> > > >>>>> This patch was tested against suspendand hibernation (Acer mail  
> > > >>>>> led
> > > >>>>> status).
> > > >>>>>
> > > >>>>> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> > > >>>>> ---
> > > >>>>> drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
> > > >>>>> 1 files changed, 12 insertions(+), 5 deletions(-)
> > > >>>>>
> > > >>>>> diff --git a/drivers/platform/x86/acer-wmi.c
> > > >>>>> b/drivers/platform/x86/acer-wmi.c
> > > >>>>> index be2fd6f..29374bc 100644
> > > >>>>> --- a/drivers/platform/x86/acer-wmi.c
> > > >>>>> +++ b/drivers/platform/x86/acer-wmi.c
> > > >>>>> @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> > > >>>>> platform_device *device)
> > > >>>>>    return 0;
> > > >>>>> }
> > > >>>>>
> > > >>>>> -static int acer_platform_suspend(struct platform_device *dev,
> > > >>>>> -pm_message_t state)
> > > >>>>> +static int acer_platform_suspend(struct device *dev)
> > > >>>>> {
> > > >>>>>    u32 value;
> > > >>>>>    struct acer_data *data = &interface->data;
> > > >>>>> @@ -1174,7 +1173,7 @@ pm_message_t state)
> > > >>>>>    return 0;
> > > >>>>> }
> > > >>>>>
> > > >>>>> -static int acer_platform_resume(struct platform_device *device)
> > > >>>>> +static int acer_platform_resume(struct device *dev)
> > > >>>>> {
> > > >>>>>    struct acer_data *data = &interface->data;
> > > >>>>>
> > > >>>>> @@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
> > > >>>>> platform_device *device)
> > > >>>>>    return 0;
> > > >>>>> }
> > > >>>>>
> > > >>>>> +static struct dev_pm_ops acer_platform_pm_ops = {
> > > >>>>> +    .suspend = acer_platform_suspend,
> > > >>>>> +    .resume = acer_platform_resume,
> > > >>>>
> > > >>>> Are these necessary? For suspend-to-RAM, I've never needed these.  
> > > >>>> The old
> > > >>>> callbacks here were just for suspend-to-disk.
> > > >>>
> > > >>> That is not correct. Old suspend and resume callbacks were called  
> > > >>> for
> > > >>> both S2R and S2D. Whether it is actually needed for S2R I don't  
> > > >>> know but
> > > >>> looking at the code they should not hurt.
> > > >>
> > > >> I'm aware they were called for S2RAM as well, but that was just a  
> > > >> limitation
> > > >> of the old calls - as I say, they're not needed for it (at least on  
> > > >> my
> > > >> hardware anyway).
> > > >>
> > > >
> > > > I was looking for similar functionality.
> > > >
> > > >>>>> +    .freeze = acer_platform_suspend,
> > > >>>>> +    .thaw = acer_platform_resume,
> > > >>>>
> > > >>>> If we only need these callbacks for freeze & thaw, they should be
> > > >>>> rebamed.
> > > >>>>
> > > >>>>> +    .poweroff = acer_platform_suspend,
> > > >>>>> +    .restore = acer_platform_resume,
> > > >>>>
> > > >>>> What do poweroff and restore mean in this context. Do my comments  
> > > >>>> above
> > > >>>> apply again (i.e. are the callbacks necessary here)?
> > > >>>
> > > >>> I don't think poweroff handler is needed.
> > > >
> > > > After testing many combinations, I observed that I had to use that  
> > > > much
> > > > callbacks. For example, when omitting to wire .poweroff/.restore,
> > > > with .freeze/.thaw linked to suspend()/resume(), the state (of the  
> > > > mail
> > > > led) is not restored correctly after S2D.
> > > 
> > > 
> > > Have you tried with just 3 - freeze, thaw and restore?
> > > 
> > 
> > State restoration seems to be OK with only those three ones (tested
> > against both S2RAM and S2D on my Acer Aspire 5680).
> > 
> > BTW, in the "struct dev_pm_ops" documentation, it would be interesting
> > to know which callback sequence occurs in case of S2RAM and S2D events.
> > 
> > 
> 
> Here are my observations regarding PM events and callbacks:
> 
> S2RAM ("Suspend"):
> event trigged -> .suspend gets called
> recover from S2RAM -> .resume gets called

That's correct, plus there are .suspend_noirq() which is called during suspend,
after suspend_device_irqs(), and .resume_noirq() which is called during resume,
before resume_device_irqs().

> For *this module*,

What's *this module*? acer-wmi?

> these callbacks seem not necessary, because the state
> of hardware seems to be automatically restored on resume from S2RAM (by
> BIOS ???).
> 
> S2DISK ("Hibernation"):
> event trigged -> .freeze, then .thaw gets called

To be precise, the ordering is

.freeze()
  .freeze_noirq()
    create image
  .thaw_noirq()
.thaw()
  save image
.poweroff()
  .poweroff_noirq()
    enter sleep state

> recover from S2DISK -> .restore gets called

To be precise, the ordering is:

Boot kernel:
load image
.freeze()
  .freeze_noirq()
    pass control to the image kernel
Image kernel:
  .restore_noirq()
.restore()

> As per the pm.h documentation .thaw is called after RAM image has been
> created, in order to restore hardware state in case RAM image failed and
> the system cannot power off.

That's not correct (please see above).  .thaw() is called after creating the
image in case .freeze() has changed the state of the device.  This often is not
necessary, though, so .thaw() may be skipped in many cases.  Of course, you
should know exactly what you're doing.

> So this callback should be linked to
> something similar to the .restore callback. For *this module*, though it
> may not be necessary because the state of both LCD backlight and mail
> LED persist after RAM image creation, I have linked this callback
> anyway.
> 
> After around 2 days of testing, here is a third attempt for this patch.
> Please note that I renamed the functions to better reflect their use.
> Can you please stress it ?
> 
> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c
> b/drivers/platform/x86/acer-wmi.c
> index fb45f5e..331771d 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> platform_device *device)
>  	return 0;
>  }
>  
> -static int acer_platform_suspend(struct platform_device *dev,
> -pm_message_t state)
> +static int acer_platform_freeze(struct device *dev)
>  {
>  	u32 value;
>  	struct acer_data *data = &interface->data;
> @@ -1174,7 +1173,7 @@ pm_message_t state)
>  	return 0;
>  }
>  
> -static int acer_platform_resume(struct platform_device *device)
> +static int acer_platform_restore(struct device *dev)
>  {
>  	struct acer_data *data = &interface->data;
>  
> @@ -1190,15 +1189,20 @@ static int acer_platform_resume(struct
> platform_device *device)
>  	return 0;
>  }
>  
> +static struct dev_pm_ops acer_platform_pm_ops = {
> +	.freeze = acer_platform_freeze,

+	.suspend = acer_platform_freeze,

> +	.thaw = acer_platform_restore,

.thaw is not necessary AFAICS.

> +	.restore = acer_platform_restore,

+	.resume = acer_platform_restore,

> +};
> +
>  static struct platform_driver acer_platform_driver = {
>  	.driver = {
>  		.name = "acer-wmi",
>  		.owner = THIS_MODULE,
> +		.pm = &acer_platform_pm_ops,
>  	},
>  	.probe = acer_platform_probe,
>  	.remove = acer_platform_remove,
> -	.suspend = acer_platform_suspend,
> -	.resume = acer_platform_resume,
>  };
>  
>  static struct platform_device *acer_platform_device;

Thanks,
Rafael
