Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZCYHaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZCYHaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZCYH34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:29:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:34362 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753259AbZCYH3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:29:55 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+OaFR0WjuOsDhzbg9tUaTKdbVpwzHSr3awZGEWpy
	Zpd4UnlzDwuJy0
Date: Wed, 25 Mar 2009 08:29:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ming Lei <tom.leiming@gmail.com>
cc: kay.sievers@vrfy.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [PATCH] driver core: check bus->match without holding device
 lock
In-Reply-To: <d82e647a0903241815l66abfc18ldbb26abd7d2c6b4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0903250817090.5590@axis700.grange>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com> 
 <Pine.LNX.4.64.0903250039160.4451@axis700.grange>
 <d82e647a0903241815l66abfc18ldbb26abd7d2c6b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Ming Lei wrote:

> >> @@ -190,21 +184,22 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
> >>
> >>       if (!device_is_registered(dev))
> >>               return -ENODEV;
> >> -     if (drv->bus->match && !drv->bus->match(dev, drv))
> >> -             goto done;
> >
> > Previously, if no .match() was specified, the normal probing has been
> > called.
> >
> >>
> >>       pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
> >>                drv->bus->name, __func__, dev_name(dev), drv->name);
> >>
> >>       ret = really_probe(dev, drv);
> >>
> >> -done:
> >>       return ret;
> >>  }
> >>
> >>  static int __device_attach(struct device_driver *drv, void *data)
> >>  {
> >>       struct device *dev = data;
> >> +
> >> +     if (!driver_match_device(drv, dev))
> >> +             return 0;
> >> +
> >
> > Now, without .match() no probing is done. Is this an intended change and
> > soc-camera has to be fixed or is this a bug?
> 
> It is not a driver-core bug, and soc-camera should be fixed.

So, you're saying this used to be a bug and it has been fixed by this 
patch? Then why isn't this mentioned in the commit message? The commit 
text seems to suggest, that this patch shouldn't introduce any change in 
behaviour, but it does. So, before .match == NULL lead to .probe() being 
called, and now it doesn't anymore?

And in which way should soc-camera be fixed? Just provide a dummy match 
with just "return 1;" in it?

> >> diff --git a/include/linux/device.h b/include/linux/device.h
> >> index 45e5b19..3c61315 100644
> >> --- a/include/linux/device.h
> >> +++ b/include/linux/device.h
> >> @@ -466,6 +466,12 @@ static inline int device_is_registered(struct device *dev)
> >>       return dev->kobj.state_in_sysfs;
> >>  }
> >>
> >> +static inline int driver_match_device(struct device_driver *drv,
> >> +                                   struct device *dev)
> >> +{
> >> +     return drv->bus->match && drv->bus->match(dev, drv);
> >> +}
> >> +
> >>  void driver_init(void);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
