Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbYDELpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbYDELpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 07:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYDELpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 07:45:05 -0400
Received: from tim.rpsys.net ([194.106.48.114]:47149 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYDELpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 07:45:03 -0400
Subject: Re: Clarifying platform_device_unregister
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <20080401104533.ZZRA012@mailhub.coreip.homeip.net>
References: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
	 <20080401051947.GD18041@anvil.corenet.prv>
	 <45a44e480804010047m36a9b8e3p97910308ed5677fb@mail.gmail.com>
	 <20080401104533.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain
Date: Sat, 05 Apr 2008 12:44:52 +0100
Message-Id: <1207395892.5021.20.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-01 at 10:54 -0400, Dmitry Torokhov wrote:
> On Tue, Apr 01, 2008 at 12:47:54AM -0700, Jaya Kumar wrote:
> > That's interesting. I noticed though that a lot of platform device
> > code assigns a statically allocated structure to platform_data. For
> > example:
> > 
> > arch/arm/mach-pxa/corgi_pm.c
> > static struct sharpsl_charger_machinfo corgi_pm_machinfo = {
> > ...
> > }
> >         corgipm_device->dev.platform_data = &corgi_pm_machinfo;
> > 
> > same with spitz_pm.c.
> > 
> > egrep "platform_data.*=.*\&" *.c shows quite a lot of users doing
> > that. I guess most of these below are probably okay since these
> > drivers can't be rmmoded.
> > 
> 
> Hmm, are you sure they can't be removed? Why do they all have
> module_exit methods?
> 
> Even if they can't be unloaded the whole thing will blow to pieces
> if registration fails. Consider this:
> 
> static int __devinit spitzpm_init(void)
> {
>         int ret;
> 
>         spitzpm_device = platform_device_alloc("sharpsl-pm", -1);
>         if (!spitzpm_device)
>                 return -ENOMEM;
> 
>         spitzpm_device->dev.platform_data = &spitz_pm_machinfo;
>         ret = platform_device_add(spitzpm_device);
> 
>         if (ret)
>                 platform_device_put(spitzpm_device);
> 		^^^^^^^^^^^
> This will try to kfree(spitzpm_device->dev.platform_data) and it gonna
> blow. We need to do spitzpm_device->dev.platform_data = NULL before doing
> put.
> 
> Also  spitzpm_init() shoudl be marked __init, not __devinit and
> spitzpm_exit() should be __exit() if it is event needed at all.
> 
> Richard, I think you work with spitz and corgi, any comments?

Looking at this I agree there are some problems there.

In the real world the spitz/corgi devices are pretty useless without
power management and therefore these code paths aren't well used. I
think this has happened since the platform data was a later addition to
the code and the internal use of kfree on platform_data wasn't realised.

I'll make sure some patches are submitted to address these issues.

Cheers,

Richard


