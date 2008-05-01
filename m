Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYEADqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYEADqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYEADqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:46:22 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:43817 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYEADqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:46:22 -0400
Date: Wed, 30 Apr 2008 20:41:54 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
In-Reply-To: <200804301908.32346.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804301931030.1537@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net> <200804301434.25211.david-b@pacbell.net>
 <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp>
 <200804301908.32346.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, David Brownell wrote:
> On Wednesday 30 April 2008, Trent Piepho wrote:
>> On Wed, 30 Apr 2008, David Brownell wrote:
>>> Simple sysfs interface for GPIOs.
>>>
>>>    /sys/class/gpio
>>>    	...
>>
>> "simple"?  What I had was a lot simpler.
>
> But it had some "must fix" problems, which I told you when you
> posted your first patch.  You didn't fix them.  And since then,
> your pushback seems to rely very heavily on ignoring issues I
> pointed out are "must fix" or "can't/doesn't work that way".

So what are these must fix problems?  You don't want all the gpios to appear
in sysfs by default in case there are many.  So have them only appear when
they are requested by something.  Problem solved.

Someone might label the chip with a label using a '/'.  First of all, that's
nothing but speculation on a problem that will probably never happen.  Do any
existing chip labels use a '/'?  Is it really that hard to just not label the
chip that way?  But suppose someone just can't avoid it, one line of code,
that I posted, is all it takes to fix this.

Multiple chips with the same label.  That's more annoying, but still
easy to fix in a number of ways:
1) If the label isn't unique, don't register that chip with sysfs.
2) If the label isn't unique, appended a suffix to make it so.
3) Always add a sequence number the end of the chip label.  This is quite
common in fact.

The sysfs control interface won't be able to handle gpios named this way.  Or
doing so will be "too hard".  Not true, I wrote and posted code that did it. 
It was simpler than the initial code you wrote for the control interface, and
much simpler than the latest with all the gpiochip stuff.  BTW, my code also
worked for unexporting gpio 0....

You say nothing in sysfs works this way, but I don't agree.  Take a look at
/sys/class/net, you have names like "tap0", "eth0", "eth1", "lo", etc.  This
is exactly what I'm saying to do.  The first "eth" gpio chip you register is
appears as eth0 in sysfs, the second as eth1, and so on.

The directories are not just named "netdev0", "netdev1", "netdev2", with some
sort of mapping file telling you ethernet devices are using numbers 2-3.

Look at PCI, you have files like "/sys/bus/pci/devices/0000:01:05.0" and
"/bus/pci/devices/0000:00:0d.2".  It's not "pci1", "pci2", "pci3", with a
"bus0" directory telling you that the bus starts at device 3 and has 6
devices.

Look at ACPI, it's /sys/bus/acpi/devices/{LNXSLPBN:00,LNXPWRBN:00,LNXSYSTM:00}
and "device:00", "device:01".  It uses useful names before the number when
they exist, and just "device" when it doesn't.  This is what I'm saying to do
for gpios.

In fact, what you want - just naming gpios from each device sequentially as
the are dynamically assigned, and then having another set of directories that
allow one to calculate what which one belongs to a given chip - seems to be a
lot harder to find an existing example of.

>> So, I want to set gpio 5 on a pcf9557 extender.
>
> Which isn't exactly where most folk start.  If it's something

It's where I started.  You say your system works for everything that matters
and just dismiss the problems I'm solving as irrelevant with a wave of your
hand.  That's very convenient for you, but where does it leave me?

> done routinely, they'll likely have a script to run; either
> the native language type, or something for bash or Python.

Your worried about the memory usage of some extra sysfs files, but include
python on your device?  IMHO, if you can't do this simple task in 5 minutes
with just busybox, the system is making things too hard.

>> cat 1 > /sys/class/gpio/pcf9557-0:0
>>
>> But now I can't do this anymore,
>
> "Any more"?  You never *could* do that before.  The original
> patch you sent didn't do that, and the last code snippet I
> saw from you didn't either.

I seem to be doing it just fine.  I never posted the latest version of my
code since you didn't respond to my April 7th email.

>> 	 What's the point of allowing
>> one to label gpio lines if it's not going to be easy to see?
>
> You can "cat /sys/kernel/debug/gpio" to see them...

What is the reason to not have the label with gpio in sysfs?

>>>  echo "23" > /sys/class/gpio/control
>>> 	... will gpio_request(23, "sysfs") and gpio_export(23); use
>>
>> So if a driver is already using gpio 23, then there is no way to see it in
>> sysfs, since the gpio_request() will fail?
>
> Right.  If that driver wanted to cope with userspace mucking
> around with its internal state (GPIOs) it would have explicitly
> enabled it by calling gpio_export().  If it's not prepared to
> cope with the various flavors of breakage that would facilitate,
> it doesn't call gpio_export() ... and is safe.

How does seeing the value, direction, and label of a gpio "muck around with
its internal state?"

Of course, one can still change a gpio via /dev/mem or i2c-dev, depending on
the source.  How is being able to do this via sysfs any different?  Yes, the
user could mess the driver up, if they don't know what they are doing.  Just
like there are a hundred other ways to do this via raw device access,
/dev/mem, i2c-dev, and so on.  I guess instead of looking down on everyone and
assuming no one else knows what they are doing and must be protected, I prefer
to assume users aren't idiots, and if they can be trusted with /dev/hda they
can be trusted with gpios in sysfs.
