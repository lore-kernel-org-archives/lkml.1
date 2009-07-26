Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZGZSIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZGZSIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 14:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZGZSIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 14:08:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:24794 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZGZSIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 14:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wmElwuVEnxUUG86/hpDm2G03eXN0hZgxqO5OgGxq/zc32azX0850WQKoymndXQ8Lsc
         5i5jX6oIuY5OvP6TTmQILn5MndzKS/lA+iUEbHej9HbPUe92tKIkyfNqDJTj78XKruUn
         WWVCg+qr8dQuBdroDax82jK80c/4d/eEsZ4AA=
Date: Sun, 26 Jul 2009 11:08:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Message-ID: <20090726180809.GA31396@dtor-d630.eng.vmware.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <200907252204.44875.rjw@sisk.pl> <1248616413.3922.7.camel@green> <200907261523.30378.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907261523.30378.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 03:23:29PM +0100, Carlos Corbacho wrote:
> [Removing linux-mips from CC - I don't know why they'd be interested in an x86 
> only platform driver...]
> 
> On Sunday 26 July 2009 14:53:33 Arnaud Faucher wrote:
> > Gets rid of the following warning:
> > Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> >
> > Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM issue on
> > hibernation when using dev_pm_ops blindly.
> >
> > This patch was tested against suspendand hibernation (Acer mail led
> > status).
> >
> > Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> > ---
> >  drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
> >  1 files changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/platform/x86/acer-wmi.c
> > b/drivers/platform/x86/acer-wmi.c
> > index be2fd6f..29374bc 100644
> > --- a/drivers/platform/x86/acer-wmi.c
> > +++ b/drivers/platform/x86/acer-wmi.c
> > @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> > platform_device *device)
> >  	return 0;
> >  }
> >
> > -static int acer_platform_suspend(struct platform_device *dev,
> > -pm_message_t state)
> > +static int acer_platform_suspend(struct device *dev)
> >  {
> >  	u32 value;
> >  	struct acer_data *data = &interface->data;
> > @@ -1174,7 +1173,7 @@ pm_message_t state)
> >  	return 0;
> >  }
> >
> > -static int acer_platform_resume(struct platform_device *device)
> > +static int acer_platform_resume(struct device *dev)
> >  {
> >  	struct acer_data *data = &interface->data;
> >
> > @@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
> > platform_device *device)
> >  	return 0;
> >  }
> >
> > +static struct dev_pm_ops acer_platform_pm_ops = {
> > +	.suspend = acer_platform_suspend,
> > +	.resume = acer_platform_resume,
> 
> Are these necessary? For suspend-to-RAM, I've never needed these. The old 
> callbacks here were just for suspend-to-disk.
>

That is not correct. Old suspend and resume callbacks were called for
both S2R and S2D. Whether it is actually needed for S2R I don't know but
looking at the code they should not hurt.

 
> > +	.freeze = acer_platform_suspend,
> > +	.thaw = acer_platform_resume,
> 
> If we only need these callbacks for freeze & thaw, they should be rebamed.
> 
> > +	.poweroff = acer_platform_suspend,
> > +	.restore = acer_platform_resume,
> 
> What do poweroff and restore mean in this context. Do my comments above apply 
> again (i.e. are the callbacks necessary here)?
>

I don't think poweroff handler is needed.

BTW, why so we retuen -ENOMEM from these methods if interface->data is
missing? I'd say we should not fail suspend resume in that case or if we
fail then with somethig like -EINVAL - we did not have mempry allocation
failure.

-- 
Dmitry
