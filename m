Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbXHRKmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbXHRKmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXHRKl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:41:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:55803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXHRKl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:41:56 -0400
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>,
       David Zeuthen <david@fubar.dk>
In-Reply-To: <200708172106.52940.david-b@pacbell.net>
References: <200708170823.15894.david-b@pacbell.net>
	 <200708171250.09653.david-b@pacbell.net>
	 <1187404839.4419.5.camel@lov.localdomain>
	 <200708172106.52940.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 12:45:39 +0200
Message-Id: <1187433939.4419.42.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19zy8hSPjZvyDGtFCw0i/1qitbonWWEzOJGEOM
 3eim8eqcp6OosJSuXoK39FNrCAQqF35UkOejv26kTd7q4qHWSv
 slMbVCBFkhGBWFxRrYqtpDNRymEgM4w
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 21:06 -0700, David Brownell wrote:
> On Friday 17 August 2007, Kay Sievers wrote:
> > 
> > > I'm not the one who's advocating a change here.  If you want to
> > > first change/break and then fix things, all of that is up to you.
> > 
> > I'm happy to do that. Patch is attached.
> 
> NAK.  That wasn't even a serious attempt at the "fix" part,
> though it does the "break" part well enough to cause severe
> regressions.

You disabled uevents which breaks udev and HAL setups, because we can't
track the existence of the devices, You can't just disable device events
to disable module loading. Uevents have are by far not only about module
loading.

> (As well as leaving all my technical points about your pushback
> un-addressed.  As I noted before, the evident fact that you don't
> have technical responses to them says to me that your pushback
> has no real technical basis ...)

It has. Disabling uevents to control module loading is just the totally
wrong thing to do. Uevents are there to let userspace know that a device
exists. Only the existence of MODALIAS and the "modalias" file controls
module loading, not the enabling and disabling of uevents, which is a
completely broken hack.

My patch fixes tons of issues, and that is "technical basis" enough. It
makes platform play nice with userspace, by behaving like the rest of 
the kernel.

Userspace udev/HAL relies entirely on uevents, for hot- and for
coldplug. Coldplug is done by writing "add" to all "uevent" files during
early boot, that does not work anymore with platform, and needs to be
fixed.

> Out of around 300 platform drivers in the tree (and many more
> not yet merged upstream), this makes it so that only *THREE* of
> them can hotplug ... versus in the current tree, essentially
> everything that's not a legacy driver is hotplugging just fine.
> 
> That's one heck of a regression.  Just shy of 100% ...

So where are the 100's of drivers that send an uevent? I'll go and fix them.

> Plus it treats rtc-ds1742 as if it's a platform_driver not
> an i2c_driver.

Wrong, the whole model is the other way around. MODALIAS does not tie
other drivers to a device. A driver matches on a device, and the ds1742
driver triggers on the existence of a platform driver. The alias strings
don't "treat" anything.
The whole kernel works that way, a lot of drivers get loaded by matching
on "dmi:*" or "acpi:*" strings by not letting the driver be a dmi driver
or acpi driver.

Please stop doing adding weird hacks to the kernel to fit your personal
taste and breaking all assumptions existing tools rely on. Fix the stuff
you broke and enable uevent for _all_ devices again. And let userspace
make the decision what to do with the event, like all other subsystems
in the kernel do.

Thanks,
Kay

