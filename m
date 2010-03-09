Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0CIIWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:22:40 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:34464 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0CIIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RbMOpzTCklGzUERy7HZIz6scn52jlxWH4etgcIJqlFIs402AKj+3na2B4tpo56UizN
         ROYmnURZXvs6m3x3sVudOjme1pJ/YyiRnFa84ZmmEAprTL2M/fq+Ube5GPvQ7sjLIo9z
         e1hq5mC1agbMDfitJXonYLkCOxE0zDL9BN6nA=
Date: Tue, 9 Mar 2010 00:22:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
Subject: Re: [BUG?] hid-core.c: hid->name = dev->manufacturer + dev->product
   ... why not + dev->serial?
Message-ID: <20100309082216.GG17288@core.coreip.homeip.net>
References: <201003071655.06644@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003071655.06644@rk-nord.at>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Melchior,

I'm adding a few CCs and takinng discussion a bit away from your patch
;)

On Sun, Mar 07, 2010 at 04:55:06PM +0100, Melchior FRANZ wrote:
> Hi,
> 
> just recently I purchased two data acquisition HID devices that pretend to be
> joysticks[1], because that way no special kernel drivers are required, and
> because they are usually used for joystick-like purposes. The devices identify
> themselves as
> 
>   idVendor           0x16c0
>   idProduct          0x05ba 
>   iManufacturer      1 Leo Bodnar
>   iProduct           2 BU0836A Interface
>   iSerial            3 A10123
> 
> The Linux kernel creates the HID/"joystick name" from only iManufacturer and
> iProduct, ignoring iSerial. That way, JSIOCGNAME returns the same string
> for all such devices, making an actual identification impossible.
> joystick-api.txt says about JSIOCGNAME:
> 
>   #define JSIOCGNAME(len) /* get identifier string        char    */
>   ...
>   JSIOCGNAME(len) allows you to get the name string of the joystick
> 
> But this isn't actually true. "Leo Bodnar BU0836A Interface" is only
> the name of the product, but not of the actual (joystick or whatever)
> device. If you have more of these devices on the bus, then software has
> no way to know which is which -- which is the one with the temperature
> sensor on axis 0 etc. (Apart from doing all the USB querying itself,
> of course.)
> 

This is nicely illustrates one of the reasons why input subsystem is
ill-suited for generic data acquisition. I call it "device anonymity" -
input subsystem only interested in the type of event (ABS_X, ABS_Y) but
not necessarily the device it came from. You may have 2 joysticks and
prefer to use one in one game and other in another game. With default
setup you could grab either one and start playing, ABS_X from either
mapping on horizontal movements, ABS_Y on vertical... Same with
keyboards - you plug an external keyboard into laptop and you just start
typing (sans multi-seat setups that we don't support well at the
moment). In other words for input we care very much about capabilities
of a device but care much less about the device itself.

Which data acquisition you care not only about hypothetical
ABS_TEMPERATIRE event but it is also _very_ important the exact device
or probe the data is coming from. Temperature from device A can't be
used in place of temperature form device B.

> The patch below fixed the problem for me. But, certainly, the current
> (mis)behaviour wasn't an accident, but intentional. But what was the
> intention? What happens if I attach two actual identical joysticks?
> What's the purpose of them having the same name on the system under
> /dev/input/{js,event}? 

They will have different event nodes.

> Not even two (human) identical twins have the
> same first name, and for a reason!
> 

But you as an observer have no idea what their names are, and they look the
same to you. And in case of joysticks ther serials are not easily
visible on them when you quickly grab one.

Nevertheless serials are exported in sysfs ('uniq' attribute). Also udev
can give persistent names device nodes based on physocal connection,
serial numbers, etc.

-- 
Dmitry
