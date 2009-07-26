Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGZWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGZWvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 18:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZGZWvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 18:51:09 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:54002 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZGZWvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 18:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L8VEu6KenNUoJtG/VfHnVtfF+zIxlxsWR0rd/hNS8rjP9x1JWxd8NX7VxvY6WFW94U
         TLs6ebEfKXAqubHF81usW7SVHhRROFu0SIUV2S6V/8EcuK99kksUifqxgCKu8zYxefvr
         DW3CCSNUYFyuOJNAnPZG3DIzPAGRrZNblH2MQ=
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <EF5CB084-D774-49E3-9E9F-6803ECB9862C@gmail.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com>
	 <200907261523.30378.carlos@strangeworlds.co.uk>
	 <20090726180809.GA31396@dtor-d630.eng.vmware.com>
	 <200907261935.08762.carlos@strangeworlds.co.uk>
	 <1248640128.4216.13.camel@green>
	 <EF5CB084-D774-49E3-9E9F-6803ECB9862C@gmail.com>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 18:51:03 -0400
Message-Id: <1248648663.3718.7.camel@green>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On dim, 2009-07-26 at 14:33 -0700, Dmitry Torokhov wrote:
> On Jul 26, 2009, at 1:28 PM, Arnaud Faucher <arnaud.faucher@gmail.com>  
> wrote:
> 
> > On dim, 2009-07-26 at 19:35 +0100, Carlos Corbacho wrote:
> >> On Sunday 26 July 2009 19:08:09 Dmitry Torokhov wrote:
> >>> On Sun, Jul 26, 2009 at 03:23:29PM +0100, Carlos Corbacho wrote:
> >>>> [Removing linux-mips from CC - I don't know why they'd be  
> >>>> interested in
> >>>> an x86 only platform driver...]
> >>>>
> >>>> On Sunday 26 July 2009 14:53:33 Arnaud Faucher wrote:
> >>>>> Gets rid of the following warning:
> >>>>> Platform driver 'acer-wmi' needs updating - please use dev_pm_ops
> >>>>>
> >>>>> Take 2, thanks to Dmitry, Rafael and Frans for pointing out PM  
> >>>>> issue on
> >>>>> hibernation when using dev_pm_ops blindly.
> >>>>>
> >>>>> This patch was tested against suspendand hibernation (Acer mail  
> >>>>> led
> >>>>> status).
> >>>>>
> >>>>> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> >>>>> ---
> >>>>> drivers/platform/x86/acer-wmi.c |   17 ++++++++++++-----
> >>>>> 1 files changed, 12 insertions(+), 5 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/platform/x86/acer-wmi.c
> >>>>> b/drivers/platform/x86/acer-wmi.c
> >>>>> index be2fd6f..29374bc 100644
> >>>>> --- a/drivers/platform/x86/acer-wmi.c
> >>>>> +++ b/drivers/platform/x86/acer-wmi.c
> >>>>> @@ -1152,8 +1152,7 @@ static int acer_platform_remove(struct
> >>>>> platform_device *device)
> >>>>>    return 0;
> >>>>> }
> >>>>>
> >>>>> -static int acer_platform_suspend(struct platform_device *dev,
> >>>>> -pm_message_t state)
> >>>>> +static int acer_platform_suspend(struct device *dev)
> >>>>> {
> >>>>>    u32 value;
> >>>>>    struct acer_data *data = &interface->data;
> >>>>> @@ -1174,7 +1173,7 @@ pm_message_t state)
> >>>>>    return 0;
> >>>>> }
> >>>>>
> >>>>> -static int acer_platform_resume(struct platform_device *device)
> >>>>> +static int acer_platform_resume(struct device *dev)
> >>>>> {
> >>>>>    struct acer_data *data = &interface->data;
> >>>>>
> >>>>> @@ -1190,15 +1189,23 @@ static int acer_platform_resume(struct
> >>>>> platform_device *device)
> >>>>>    return 0;
> >>>>> }
> >>>>>
> >>>>> +static struct dev_pm_ops acer_platform_pm_ops = {
> >>>>> +    .suspend = acer_platform_suspend,
> >>>>> +    .resume = acer_platform_resume,
> >>>>
> >>>> Are these necessary? For suspend-to-RAM, I've never needed these.  
> >>>> The old
> >>>> callbacks here were just for suspend-to-disk.
> >>>
> >>> That is not correct. Old suspend and resume callbacks were called  
> >>> for
> >>> both S2R and S2D. Whether it is actually needed for S2R I don't  
> >>> know but
> >>> looking at the code they should not hurt.
> >>
> >> I'm aware they were called for S2RAM as well, but that was just a  
> >> limitation
> >> of the old calls - as I say, they're not needed for it (at least on  
> >> my
> >> hardware anyway).
> >>
> >
> > I was looking for similar functionality.
> >
> >>>>> +    .freeze = acer_platform_suspend,
> >>>>> +    .thaw = acer_platform_resume,
> >>>>
> >>>> If we only need these callbacks for freeze & thaw, they should be
> >>>> rebamed.
> >>>>
> >>>>> +    .poweroff = acer_platform_suspend,
> >>>>> +    .restore = acer_platform_resume,
> >>>>
> >>>> What do poweroff and restore mean in this context. Do my comments  
> >>>> above
> >>>> apply again (i.e. are the callbacks necessary here)?
> >>>
> >>> I don't think poweroff handler is needed.
> >
> > After testing many combinations, I observed that I had to use that  
> > much
> > callbacks. For example, when omitting to wire .poweroff/.restore,
> > with .freeze/.thaw linked to suspend()/resume(), the state (of the  
> > mail
> > led) is not restored correctly after S2D.
> 
> 
> Have you tried with just 3 - freeze, thaw and restore?
> 

State restoration seems to be OK with only those three ones (tested
against both S2RAM and S2D on my Acer Aspire 5680).

BTW, in the "struct dev_pm_ops" documentation, it would be interesting
to know which callback sequence occurs in case of S2RAM and S2D events.


