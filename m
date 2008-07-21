Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYGUVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYGUVNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYGUVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:12:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:63334 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYGUVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:12:56 -0400
Date: Mon, 21 Jul 2008 14:12:20 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: PIXIS gpio controller and gpio flags
In-Reply-To: <20080721175357.GA1773@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0807211340460.26456@t2.domain.actdsltmp>
References: <20080717140519.GA32617@polina.dev.rtsoft.ru>
 <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca>
 <20080717152006.GA26120@polina.dev.rtsoft.ru>
 <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com>
 <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
 <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
 <20080718100549.GA28741@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp>
 <20080721175357.GA1773@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Anton Vorontsov wrote:
> On Sat, Jul 19, 2008 at 02:08:01PM -0700, Trent Piepho wrote:
>> It doesn't look like you have any way to unset the active low flag.  What if
>> I unload the leds-gpio driver (or another gpio user) and then try to use the
>> gpio with something else?  The active low flag is stuck on!
>
> Why would you want to unset the flags? It is specified in the device
> tree, and can't be changed. Specifying different flags for the same GPIO
> would be an error (plus, Linux forbids shared gpios, so you simply can't
> specify one gpio for several devices).

You can't use the same gpio for two different things at the same time, but you
can load a driver, unload it, and then load another.

>> Most gpio users, including leds-gpio, can handle gpios being busy.  If
>> leds-gpio can't get one of the gpios, it rolls back all the leds it did
>> create, doesn't drive the device and returns EBUSY.  Except with
>> of_get_gpio() setting the flags, it will change the flags out from under
>> whatever had the gpio already allocated!
>
> You're still assuming that something was allocated. It wasn't. The flag
> was set, and it should not change. It is irrelevant if request() failed
> or not.

Another driver has requested the gpio with active low NOT set.  Then the led
driver looks up the property with active low set, which changes the flags. 
When it tries to request the gpio it fails since the gpio is already in use. 
The led driver handles this failure.  Except the active low flag is now set
and the driver that was using the gpio before will now mysteriously stop
working.  Perhaps by erasing flash instead of reading it or something nasty
like that.

Is this the proper way to handle a dts mistake that has two drivers trying to
use the same gpio?  Without the gpio flags getting set when looking up the
gpio, this situation is handled without any difficulty.

And is having a gpio used twice in the device tree really a mistake?  What if
there are two different devices that can be attached to the gpios?  For
example, an LED bank that can be unplugged and a serial console attached in
its place, sharing the same connector and gpios.  Other than gpio flags
getting set when looking up a gpio, it works fine to list both devices in the
device tree as long as userspace has the correct driver loaded first.
