Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYAMSu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYAMSu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYAMSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:50:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:43513 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYAMSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pwga9iKdugKCf2UR4/ta56XvaOaX2HWZDGLB5XCHmyF6p+suIK6rZnk+gOvn9Oy8u4DF0/2WHx/BZ+JxhXGHQ+8Dugamz0IW4HlCg6PSBP/5pgwaXz8PWEPOCS5OiIeGqk31EvNFjR/Pwww+r7m+H5DvHCMGzJ/b4fKMR886/+Q=
Message-ID: <9e4733910801131050h5349f3c7g459f5dfb07724b19@mail.gmail.com>
Date: Sun, 13 Jan 2008 13:50:46 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 1/5] Implement module aliasing for i2c to translate from device tree names
Cc: "Greg KH" <greg@kroah.com>, linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080113194523.51683e97@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220044136.20091.70984.stgit@terra.home>
	 <20071220044138.20091.31417.stgit@terra.home>
	 <20080111202015.65c3c160@hyperion.delvare>
	 <20080112094658.197acb08@hyperion.delvare>
	 <9e4733910801120826haa8905dk863ed1c8e9f420c9@mail.gmail.com>
	 <20080113154114.4a1c5166@hyperion.delvare>
	 <9e4733910801130824i547b65a9n64e415f9626d6ab5@mail.gmail.com>
	 <20080113184017.7e3b409f@hyperion.delvare>
	 <9e4733910801131001o604c1474vc2fd021d32b8c2a3@mail.gmail.com>
	 <20080113194523.51683e97@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Jon,
>
> On Sun, 13 Jan 2008 13:01:06 -0500, Jon Smirl wrote:
> > On 1/13/08, Jean Delvare wrote:
> > > On Sun, 13 Jan 2008 11:24:29 -0500, Jon Smirl wrote:
> > > > The kernel automatically exposes modalias as a sysfs attribute so the
> > > > string must be recorded further down in the driver support layers. No
> > > > need to keep a copy in the i2c structure.
> > >
> > > Really? I didn't know that. So that's another thing that the i2c
> > > subsystem is not doing like the rest of the kernel? Can you please
> > > point me to the code that does this?
> >
> > I never noticed it before either. Just do find | grep modalias in /sys
> > and see that every driver has a modalias attribute. It is probably
> > implement in drivers/base.
>
> This doesn't mean that the kernel does this automatically! It could
> also be that each subsystem does it on its own. Given that the format of
> the modalias depends on the bus type, it wouldn't be all that
> surprising. Anyway, I'll go look at how the other subsystems handle it
> before going on.
>
> > > > Standard devices don't export a 'name' attribute. To see the driver
> > > > name for a device in sysfs look at the 'driver' link.
> > >
> > > The driver name and the device name are different things! The "name"
> > > attribute that i2c devices have tells user-space the device name, not
> > > the driver name.
> >
> > For this system my i2c device names are:
> > 0-0050  0-0051  0-0052  0-0053
>
> These are not device names, these are device bus IDs. They tell you how
> to access the devices, but they do not tell you what these devices are.
>
> > How does the name=eeprom attribute interact with this? All four of my
> > devices have name=eeprom. What is the name field used for in user
> > space?
>
> The eeprom case might be a bit confusing because that i2c driver
> supports a single device type, so the driver name is the same as the
> device name. Take a look at the hwmon/lm90 driver for a better example:
> this device supports 7 different devices. The devices are mostly
> compatible so it made sense to have a single driver for them, but they
> all differ in some way. For example, the LM90 doesn't support PEC,
> while the ADM1032 does. User-space needs to be able to distinguish
> between the various types. That's the reason why we export the device
> name through sysfs.
>
> Most i2c sensor drivers support several chip types, and libsensors has
> been relying heavily on the name attribute. Less so with the lm-sensors
> 3.0.0 rewrite, where most things are automatically detected, but if
> nothing else, giving humans a way to distinguish between the different
> sensor chip types is very useful. Also, not everyone will upgrade to
> lm-sensors 3.0.0 so we need to keep supporting the previous versions.

Another way to handle this is to have the drivers register multiple
times using different names. So LM90 would register as both LM90 and
ADM1032. All the code is shared, you just register it multiple times
under different names.

-- 
Jon Smirl
jonsmirl@gmail.com
