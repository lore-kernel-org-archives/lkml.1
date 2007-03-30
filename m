Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXC3PAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXC3PAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXC3PAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:00:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:42110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbXC3PAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Q54FclG4qIJPqfvcxPg4PZZ8gPjxgQ7WG4U2k4DWGE1jJqereuhC48mt/KOLaayS4hwELaU6Ke9rCzPJZIPS4XUXn+TFw7h1wDBqZ0p4uZZ4GHYSTmeJFBY1C1pDofQd7RTFmsYDRbLkMaXoGPqUx4UMWccH1MPdL4g4q/Rl0wM=
To: Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: [RFC] rfkill - Add support for input key to control wireless radio
Date: Fri, 30 Mar 2007 16:59:47 +0200
User-Agent: KMail/1.9.5
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
       Lennart Poettering <lennart@poettering.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Larry Finger <Larry.Finger@lwfinger.net>
References: <200612031936.34343.IvDoorn@gmail.com> <200701311220.51971.IvDoorn@gmail.com> <200703300127.40849.dtor@insightbb.com>
In-Reply-To: <200703300127.40849.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703301659.48047.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I am very sorry for taking so much time to respond but finally I went
> through the patch and I still have the same objection as before -
> it mixes two logically (and often physically) separated objects into
> a single entity. I think that RF switch and button should be separate
> entities, created and destroyed independently of each other. This way
> everything handled uniformly by the kernel.

ok. Sounds good as well. :)

> I attempted to rework the rfkill core supprt and simplify it and
> came up with the patch below. Network card drivers that are able
> to control state of their RF transmitters allocate and register
> rfkill structures. Every rfkill structure belongs to one of
> RF classes (WLAN, Bluetooth or IRDA) and exports its name, type,
> state and "user_claim" through sysfs.
> 
> There is also an input handler that catces KEY_WLAN and KEY_BLUETOOTH
> events passing through input system and toggles state of all RF
> switches of appropriate type registered with rfkill system (unless
> a switch was claimed by userspace in which case it is left alone).
> I think this provides basic functionality that most of the users need
> and any advanced control will have to be done from userspace.

Shouldn't a KEY_IRDA be added as well?
It isn't currently defined in input.h yet, but perhaps it actually should?
Or is IRDA treated differently for a specific reason?

> In a followup patch there is a skeleton code for creating polled
> input devices. For cards that have button physically connected
> their drivers will have to register a separate input device and
> let either input handler or userspace application take care of
> switching RF state appropriately.
>
> My only concern is where rfkill code should live. Since it is no
> longer dependent on input core (embedded systems might disable
> rfkill-input and use bare rfkill and control state from userspace)
> it does not need to live in drivers/input.

How about:
rfkill -> drivers/misc
rfkill_input -> input/misc
input_polldev -> lib/ (perhaps small namechange to rfkill_polldev?)
It would scatter the components a bit, but since each of those modules
has its own specific task this would make the most sense.
And by setting the depends and select fields for the menu entries correctly
it shouldn't be too big of a problem.

> Please let me know what you think.

Just to get it straight on how these 3 modules would cooperate (before I start mixing things up) ;)

 - rfkill
	- Drivers register to the rfkill module, rfkill 
	- Provides the sysfs interface
	- Drivers that don't require polling should report the events to this module

 - rfkill_input
	- Provides input device visible to userspace

 - input_polldev
	- Handlers polling, where the driver should check what the previous state was and the driver
	  should send the event to rfkill.

Could input_polldev perhaps not be setup to poll, and keep track of the current button status
and send the signal directly to rfkill?

What I am also not sure of is that input_polldev and rfkill_input both register a input device.
Instead of starting and stopping the polling through the input device it would perhaps make more
sense to either use the input device from rfkill_input and/or make use of a sysfs attribute.

> +/**
> + * rfkill_unregister - Uegister a rfkill structure.
> + * @rfkill: rfkill structure to be unregistered
> + *
> + * This function should be called by the network driver during device
> + * teardown to destroy rfkill structure. Note that rfkill_free() should
> + * _not_ be called after rfkill_unregister().
> + */
> +void rfkill_unregister(struct rfkill *rfkill)
> +{
> +       device_del(&rfkill->dev);
> +       rfkill_remove_switch(rfkill);
> +       put_device(&rfkill->dev);
> +}
> +EXPORT_SYMBOL(rfkill_unregister);

personally I would prefer enforcing drivers to call
allocate()
register()
unregister()
free()

Especially with unregister() doing the same steps as free() (put_device)
might be somwhat confusing. But might be just me. ;)

The remainder looks good, unfortunately I can't test it since the laptop with an rfkill button I have
requires isn't in a state for testing at this moment, and I would need to figure out how button status
reading happens in bcm43xx.

Ivo
