Return-Path: <linux-kernel-owner+w=401wt.eu-S966561AbYD1XLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966561AbYD1XLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965894AbYD1XBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:01:23 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:30089
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966905AbYD1XBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:01:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsABAIP0FUh8qMj2/2dsb2JhbAAIrBg
X-IronPort-AV: E=Sophos;i="4.25,718,1199631600"; 
   d="scan'208";a="307876512"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200804281239.51729.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 29 Apr 2008 09:01:18 +1000
Message-Id: <1209423678.14631.27.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 12:39 -0700, David Brownell wrote:
> Simple sysfs interface for GPIOs.
> 
>     /sys/class/gpio
>         /gpio-N ... for each exported GPIO #N
> 	    /value ... always readable, writes fail except for output GPIOs
> 	    /direction ... writable as: in, out (default low), high, low
>     	/control ... to request a GPIO be exported or unexported
> 
> GPIOs may be exported by kernel code using gpio_export(), which should
> be most useful for driver debugging.  Userspace may also ask that they
> be exported by writing to the sysfs control file, helping to cope with
> incomplete board support:
> 
>   echo "export 23" > /sys/class/gpio/control
> 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> 	/sys/class/gpio/gpio-23/direction to configure it.
>   echo "unexport 23" > /sys/class/gpio/control
> 	... will gpio_free(23)

Righteo, so if the kernel explicitly gpio_export()s something, it won't
be gpio_request()ed allowing multiple "owners" making driver debugging
easier.  Most of the time though we don't want to be able to clobber the
kernel's gpios so the control file wizardry isn't so much to cope with
incomplete board support, rather it's the way all regular (ie
non-driver-debugging) gpio access is started..?  Or do you class any
situation where userspace needs primary gpio control as a BSP omission
as there Should Be a formal in-kernel driver for it all?

Also, gpio number discovery can be done through the debugfs interface
already in gpiolib but once you've got a userspace gpio interface which
relies on gpio numbering like this that information ceases to be simple
debugging and becomes pretty mission-critical.  IMO it would make more
sense to shuffle it in to /sys/class/gpio with all this stuff or at
least offer a cut-down chip-to-range mapping in a file here.

> 
> The D-space footprint is negligible, except for the sysfs resources
> associated with each exported GPIO.  The additional I-space footprint
> is about half of the current size of gpiolib.  No /dev node creation
> involved, and no "udev" support is needed.

Which is good for simplicity but makes async notification kinda tricky.
I would suggest that a lack of pin-change signalling is going to be a
problem for people who've become accustomed to having it in their
out-of-tree interfaces.  Probably not a showstopper here but certainly
something which will slow the uptake of this interface.

> 
> This adds a device pointer to "struct gpio_chip".  When GPIO providers
> initialize that, sysfs gpio class devices become children of that device
> instead of being "virtual" devices.  The (few) gpio_chip providers which
> have such a device node have been updated.  (Some also needed to update
> their module "owner" field ... for which missing kerneldoc was added.)
> 
> Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
> from various folk including Hartley Sweeten.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

[had some comments regarding the code but it seems akpm covered them all
already :-)]
