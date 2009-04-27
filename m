Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZD0QBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZD0QBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbZD0QAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:00:50 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29810 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbZD0QAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:00:49 -0400
Date: Mon, 27 Apr 2009 18:00:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael E Brown <Michael_E_Brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090427180036.269a40b3@hyperion.delvare>
In-Reply-To: <ac3eb2510904260642s66a15a8eg5811fdc6b339d493@mail.gmail.com>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	<20090330104952.26f03c13@hyperion.delvare>
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	<20090426085401.3788fc9c@hyperion.delvare>
	<ac3eb2510904260642s66a15a8eg5811fdc6b339d493@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Sun, 26 Apr 2009 15:42:25 +0200, Kay Sievers wrote:
> On Sun, Apr 26, 2009 at 08:54, Jean Delvare <khali@linux-fr.org> wrote:
> > But anyway, this isn't going to happen quickly, and I still believe we
> > should solve the namespace problem I reported.
> 
> I think the real namespace problem lives well inside the i2c devices,
> not in the core. :) Sure, the firmware class is pretty dumb with its
> naming, but the root case is the way i2c devices are created.
> 
> First, i2c stacks class devices, which it should not do, it should use
> a bus not a class, if it has device <-> children relations between
> different types.

Could as well be. I didn't invent it, it was that way when I took over
maintenance of the code. If i2c-adapters shouldn't be class devices,
let's change that... with all due carefulness for user-space tools that
may be relying on sysfs paths.

> Second, it names all the devices from different classes with the
> _same_ name, then puts them in a hierarchy,

Yes... but that shouldn't be (and isn't, really) a problem. We control
the hierarchy, and the fact that different class devices have the same
name doesn't matter at this point.

> and the tries to mix-in a
> third class, the firmware class, which also uses the _same_ name. That
> just asks for trouble. :)

Yes it is. But you will note that the naming of firmware class devices
is the root of the problem. It doesn't even allow for two different
firmware class devices off the same parent. Even the author of the code
put in a warning in the code saying that this would inevitably lead to
collisions. This really should have never be accepted in the kernel to
start with.

> > For firmware, it doesn't seem as legitimate, I can't really think of a
> > good reason to use the i2c-adapter as the parent for the firmware
> > device.
> 
> Oh, I may miss something, I thought that is what you already do and
> causes the problem? I though you use the "adapter" to request the
> firmware? Otherwise I don't see how this can conflict.

Err, yes, this is exactly what we do, and also what I said just above.
Was I not clear maybe?

> You have the "adapter" and the "device" stacked, right?
>   /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/i2c-0/
> 
> Then you use the adapter:
>    /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0
> to request the firmware, which will try to create:
>   /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/i2c-0/
> 
> I thought you could use the "device" and not the "adapter" to request
> the firmware? Then you would get a "nice" chain of devices with all
> the same names, like :)
>    /sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/i2c-0/i2c-0/

Ah, that's what you mean by "use the device". I read it the other way
around, using the _parent_ (bus) device:

    /sys/devices/pci0000:00/0000:00:1f.3/firmware/0000:00:1f.3

Actually I have already sent a patch doing this change to dvb drivers:
  http://www.spinics.net/lists/linux-media/msg04926.html
This still needs testing though.

What you propose wouldn't work, loading i2c-dev is optional so the
device may or may not be there. We definitely don't want to make all
the v4l/dvb stack depend on i2c-dev.

> I see the following options:
>   - the i2c "device", not the "adapter" would request the firmware

See above.

>   - the i2c-adapter converts to a bus, and is no longer a class

You apparently think this should be done either way?

>   - i2c "adapters" and "devices" don't get the same duplicated name

I consider this a feature. Really, they are the same devices, the
device nodes are there for user-space access to the adapters.

>   - if "adapters" can only ever have a single "device", the
>     both could just be merged to a single instance, and maybe compat
>     symlinks created

As said before, I have been considering this already. This would
certainly make things a little easier, but also less flexible (i2c-dev
could only be disabled at build time; if enabled it would always be
loaded, together with i2c-core). I'll think about it some more, in the
light of other i2c-core cleanups.

> 
>   - the firmware class adds a firmware-% prefix in the case the
>     requesting device is a class device, and not the common case
>     which is a bus device

That works but adds inconsistency which may in turn cause trouble in
the future (e.g. converting a bus device to class device or back would
break user-space compatibility.)

> 
>   - change the "glue dir" rules, which I would try to avoid, because
>     we don't know who else might stack class devices of different
>     classes, and might get surprised by this

I understand your reluctance, but still believe this is something we
need to fix. Sure there are alternative fixes or workarounds for the
problem at hand, but there may be other cases in the future.

Paradox of the day, either there are no other stacks of class devices,
and the change is safe and needless. Or there are other stacks of class
devices, and the change is needed but potentially risky. Oh well.

> What do you think?

I'd like to give a try to converting i2c-adapter devices to bus devices
rather than class devices, if you think that's how things should be.
Can you please explain to me how this would be done?

Thanks,
-- 
Jean Delvare
