Return-Path: <linux-kernel-owner+w=401wt.eu-S935187AbZLGOWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187AbZLGOWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935145AbZLGOWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:22:10 -0500
Received: from mailgw4.ericsson.se ([193.180.251.62]:54555 "EHLO
	mailgw4.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157AbZLGOWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:22:09 -0500
X-AuditID: c1b4fb3e-b7bc9ae000005cee-8f-4b1d0c16d102
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [POWER] battery calibration parameters from sysfs
Date: Mon, 7 Dec 2009 15:07:15 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
In-Reply-To: <20091207114825.GA26965@rakim.wolfsonmicro.main>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [POWER] battery calibration parameters from sysfs
Thread-Index: Acp3M2JzMJn3xfw7TWqaQOyxS8dLuQACt1Ew
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se> <20091204104930.GA28625@sirena.org.uk> <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se> <20091207114825.GA26965@rakim.wolfsonmicro.main>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: <cbou@mail.ru>, <dwmw2@infradead.org>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>
X-OriginalArrivalTime: 07 Dec 2009 14:07:16.0385 (UTC) FILETIME=[94F30110:01CA7746]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all the great attention Mark!

[Mark wrote]
> On Sat, Dec 05, 2009 at 02:08:11PM +0100, Linus Walleij wrote:
> > (...)
> > That's an easy solution of course, but then the sysfs files
> > specified by the power subsystem, i.e. all "charge_*",
> > "energy_*", "capacity" and "time_to_*" loose their meaning
> > and must be ignored by userspace.
> 
> These files should only be present if we have data for them.  
> Userspace can't be reliant on them at present since relatively few 
> systems seem to implement them, for example none of my laptops
> have time_to, energy_ or capacity attributes.

Well, yeah, we're not exactly in the laptop business.
(But my HP laptop nc2400 has the "charge_*" attributes,
4990000 uAh in "charge_now" and this corresponds to
what is shown in g-p-m converted over to Wh, but I don't
know exactly where it's getting it from...)

One of the things we're facing is Android, which has
its userspace in plain Java JNI at the end of this link:
http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob;f=s
ervices/jni/com_android_server_BatteryService.cpp;h=8e7cadc6b680fc420d34
1faa094c71922946fdab;hb=HEAD

If you browse down to line 275 you can see it parse the sysfs
attribute "capacity", then this propagates up to the battery
status indicator on *all* Android phones out there. So if
you want to run Android unmodified, this is what you need to
provide. They are effectively using the power sysfs as
their hardware abstraction layer in this case.

Note: I'm not claiming that Android is doing it right or that
we can't modify this code or so, it's just that this is the way
a few million Android devices out there are actually doing it.

> > We have other odd code. Actually we have full software-
> > controlled CC/CV charging in our driver, and that
> > would *definately* go in such a library if it was
> > to end up in kernelspace. We have actually
> > pushed that to userspace, while I still tend to think
> > that the kernel (with right parameters) should be able
> > to charge a battery. But, well.
> 
> As was previously discussed (in another thread) I do think there needs
> to be at least some in kernel part to charger code like this 
> in order to
> ensure that we're robust against userspace failure and cope well with
> suspend and resume.  There's the potential for serious hardware damage
> if the battery is mistreated.

You're right of course. In our case we have a hardware
watchdog protecting against overcharging etc, and charging will
halt when the watchdog is not periodically fed. So actually
we're on the safe side here. (I think!)

> There's other kernel filesystems that might be more 
> approprite for this
> sort of stuff, trying to fit this into sysfs really does feel like far
> too much pain to be right.

You're right GKH already pointed me to configfs so that's
where it's going to sit if we do this thing.

We'd better write up some code to show how this would
work instead so I'll be back with that sooner or later.

Yours,
Linus Walleij
