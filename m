Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZGZSfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZGZSfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 14:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZGZSfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 14:35:19 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:55939 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZGZSfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 14:35:18 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Sun, 26 Jul 2009 19:35:07 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <200907261523.30378.carlos@strangeworlds.co.uk> <20090726180809.GA31396@dtor-d630.eng.vmware.com>
In-Reply-To: <20090726180809.GA31396@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907261935.08762.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 26 Jul 2009 18:35:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009 19:08:09 Dmitry Torokhov wrote:
> On Sun, Jul 26, 2009 at 03:23:29PM +0100, Carlos Corbacho wrote:
> > [Removing linux-mips from CC - I don't know why they'd be interested in
> > an x86 only platform driver...]
> >
> > On Sunday 26 July 2009 14:53:33 Arnaud Faucher wrote:
> > > Gets rid of the following warning:
> > > Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> > >
> > > Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM issue on
> > > hibernation when using dev_pm_ops blindly.
> > >
> > > This patch was tested against suspendand hibernation (Acer mail led
> > > status).
> > >
> > > Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> > > ---
> > >  drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
> > >  1 files changed, 12 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/platform/x86/acer-wmi.c
> > > b/drivers/platform/x86/acer-wmi.c
> > > index be2fd6f..29374bc 100644
> > > --- a/drivers/platform/x86/acer-wmi.c
> > > +++ b/drivers/platform/x86/acer-wmi.c
> > > @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> > > platform_device *device)
> > >  	return 0;
> > >  }
> > >
> > > -static int acer_platform_suspend(struct platform_device *dev,
> > > -pm_message_t state)
> > > +static int acer_platform_suspend(struct device *dev)
> > >  {
> > >  	u32 value;
> > >  	struct acer_data *data = &interface->data;
> > > @@ -1174,7 +1173,7 @@ pm_message_t state)
> > >  	return 0;
> > >  }
> > >
> > > -static int acer_platform_resume(struct platform_device *device)
> > > +static int acer_platform_resume(struct device *dev)
> > >  {
> > >  	struct acer_data *data = &interface->data;
> > >
> > > @@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
> > > platform_device *device)
> > >  	return 0;
> > >  }
> > >
> > > +static struct dev_pm_ops acer_platform_pm_ops = {
> > > +	.suspend = acer_platform_suspend,
> > > +	.resume = acer_platform_resume,
> >
> > Are these necessary? For suspend-to-RAM, I've never needed these. The old
> > callbacks here were just for suspend-to-disk.
>
> That is not correct. Old suspend and resume callbacks were called for
> both S2R and S2D. Whether it is actually needed for S2R I don't know but
> looking at the code they should not hurt.

I'm aware they were called for S2RAM as well, but that was just a limitation 
of the old calls - as I say, they're not needed for it (at least on my 
hardware anyway).

> > > +	.freeze = acer_platform_suspend,
> > > +	.thaw = acer_platform_resume,
> >
> > If we only need these callbacks for freeze & thaw, they should be
> > rebamed.
> >
> > > +	.poweroff = acer_platform_suspend,
> > > +	.restore = acer_platform_resume,
> >
> > What do poweroff and restore mean in this context. Do my comments above
> > apply again (i.e. are the callbacks necessary here)?
>
> I don't think poweroff handler is needed.
>
> BTW, why so we retuen -ENOMEM from these methods if interface->data is
> missing? I'd say we should not fail suspend resume in that case or if we
> fail then with somethig like -EINVAL - we did not have mempry allocation
> failure.

Ok.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
