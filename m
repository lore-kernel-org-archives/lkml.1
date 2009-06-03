Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZFCIp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZFCIp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZFCIpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:45:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZFCIpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:45:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
Date: Wed, 3 Jun 2009 10:45:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se> <200906012133.32074.rjw@sisk.pl> <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
In-Reply-To: <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031045.45005.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009, Magnus Damm wrote:
> 2009/6/2 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday 01 June 2009, Rafael J. Wysocki wrote:
> >> On Monday 01 June 2009, Magnus Damm wrote:
> >> > From: Magnus Damm <damm@igel.co.jp>
> >> >
> >> > Allow architecture specific data in struct platform_device V2.
> >> > The structure pdev_archdata is added to struct platform_device,
> >> > similar to struct dev_archdata in struct device.
> >> >
> >> > Useful for architecture code that needs to keep extra data
> >> > associated with each platform device. This data shall not
> >> > be accessed by platform drivers, only architecture code.
> >> >
> >> > Needed for platform device runtime PM.
> >>
> >> What exactly do you need this data for?
> 
> I'd like to keep a hardware block id associated with each platform
> device on our SoC.
> Please have a look at "PATCH [04/04] sh: Runtime platform device PM mockup",
> http://patchwork.kernel.org/patch/26421/
> 
> > Anyway, I think you can introduce something like:
> >
> > struct <your arch>_platform_device {
> >    struct platform_device dev;
> >    <some type> <your arch data>;
> >    ...
> > };
> >
> > define your platform devices using the struct above and pass its dev member to
> > the functions that need 'struct platform_device' as an argument.
> >
> > Then you won't need to add arch members to 'struct platform_device' itself.
> 
> Thanks for your suggestion. I'm usually a friend of wrapping
> structures and using offsetof(), but in this case I don't think it
> will work very well.
> 
> I'd like to keep a SoC specific hardware block id in this architecture
> specific struct. Then let the arch specific functions
> platform_device_idle() and platform_device_wakeup() use this hardware
> block id to locate which clocks to stop and which power domains to
> fiddle with within the SoC. If we only consider this on-SoC case then
> wrapping and offsetof() works well.
> 
> However, a typical embedded system has a wide range of platform
> devices. Some are for the SoC itself and some are for external
> devices, like on board ethernet controlllers (not on chip like the SoC
> platform devices).

Why don't we use the arch-specific wrapping for all platform devices on this
arch, the SoC ones and the non-SoC ones?  Is there any particular reason not
to do that? 

If idle() and wakeup() are supposed to be platform-specific, and quite frankly
I don't see how they could be implemented in a generic way, they don't even
need to operate on struct platform_device objects.

> And since idle() and wakeup() work with struct
> platform device, with a wrapped data structure we need some way to
> check if the platform data is actually wrapped and offsetof() is
> valid. I guess we could use some platform device specific flag for
> this, but that seems overly complicated in my opinion. And modifying
> idle() and wakup() to take arch specific structures is not so good
> since we want to use the same platform driver on multiple
> architectures.
> 
> My mockup code that keeps keeps the hardware block id in the platform
> device arch specific data works well since the hardware block id with
> value zero is a special case. The value zero means "external non-soc
> device", so a "regular" board specific struct platform_device that do
> not setup arch specific data can just be skipped in idle()/wakeup().
> 
> If you guys dislike adding arch specific data to struct platform
> device then for SuperH we can just (mis)use the arch specific data in
> struct device instead. I'm afraid that solution wastes memory since
> the data will only be used for platform devices anyway. So I prefer
> adding arch specific data to struct platform_device instead of struct
> device if possible.

That's generally OK, but I'd like to get convinced that there's no better
way indeed.

What I personally don't like about the patch is the duplication of empty
struct pdev_archdata for quite a number of architectures.  It's not nice and
I wonder if there's a way to avoid it.

Thanks,
Rafael
