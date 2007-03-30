Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXC3P2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXC3P2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXC3P2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:28:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:20891 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXC3P2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IfzfMGFqQeIURgihNGyzSOZS/p8cND/NBBwouC3ahR3mvMt6fFEQ9NkroCwSSbIBBUU5OQJ/w77KWjrjXp0YHMd+wQZu3bk39KTXrZNS+MmmPHEXysE8QQJb9QheB1lWvQrJcEn4Z1Sjh6RZtzQMBA18QRlH8wCvtonvY5OYjmw=
Message-ID: <d120d5000703300828k5baf3c7x3716148b2e08d17f@mail.gmail.com>
Date: Fri, 30 Mar 2007 11:28:10 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill - Add support for input key to control wireless radio
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "John Linville" <linville@tuxdriver.com>, "Jiri Benc" <jbenc@suse.cz>,
       "Lennart Poettering" <lennart@poettering.net>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200703301659.48047.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200612031936.34343.IvDoorn@gmail.com>
	 <200701311220.51971.IvDoorn@gmail.com>
	 <200703300127.40849.dtor@insightbb.com>
	 <200703301659.48047.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
> > I am very sorry for taking so much time to respond but finally I went
> > through the patch and I still have the same objection as before -
> > it mixes two logically (and often physically) separated objects into
> > a single entity. I think that RF switch and button should be separate
> > entities, created and destroyed independently of each other. This way
> > everything handled uniformly by the kernel.
>
> ok. Sounds good as well. :)
>
> > I attempted to rework the rfkill core supprt and simplify it and
> > came up with the patch below. Network card drivers that are able
> > to control state of their RF transmitters allocate and register
> > rfkill structures. Every rfkill structure belongs to one of
> > RF classes (WLAN, Bluetooth or IRDA) and exports its name, type,
> > state and "user_claim" through sysfs.
> >
> > There is also an input handler that catces KEY_WLAN and KEY_BLUETOOTH
> > events passing through input system and toggles state of all RF
> > switches of appropriate type registered with rfkill system (unless
> > a switch was claimed by userspace in which case it is left alone).
> > I think this provides basic functionality that most of the users need
> > and any advanced control will have to be done from userspace.
>
> Shouldn't a KEY_IRDA be added as well?
> It isn't currently defined in input.h yet, but perhaps it actually should?
> Or is IRDA treated differently for a specific reason?

Do we actually have cards with IRDA switches? We are kind of tight in
input KEY_ namespace so I am hesitant to add defines before there
actual users.

>
> > In a followup patch there is a skeleton code for creating polled
> > input devices. For cards that have button physically connected
> > their drivers will have to register a separate input device and
> > let either input handler or userspace application take care of
> > switching RF state appropriately.
> >
> > My only concern is where rfkill code should live. Since it is no
> > longer dependent on input core (embedded systems might disable
> > rfkill-input and use bare rfkill and control state from userspace)
> > it does not need to live in drivers/input.
>
> How about:
> rfkill -> drivers/misc

Not in net?

> rfkill_input -> input/misc

I can go both ways on this one as it crosses line between input and
rfkill. I think from user/Kconfig point of view it is better to keep
it together with rfkill: user woudl select rfkill option and right
then and there decide if he wants to give the kernel ability to
automatically control RF switche

> input_polldev -> lib/ (perhaps small namechange to rfkill_polldev?)

No, I do not want to change name - I have bunch of drivers that can me
converted to use this skeleton - wistron, aaedkbd, hdaps, ams,
cobalt_btns. It is also pure input-related function so it is the only
module that definitely belongs to drivers/input/misc.

> It would scatter the components a bit, but since each of those modules
> has its own specific task this would make the most sense.
> And by setting the depends and select fields for the menu entries correctly
> it shouldn't be too big of a problem.
>
> > Please let me know what you think.
>
> Just to get it straight on how these 3 modules would cooperate (before I start mixing things up) ;)
>
>  - rfkill
>        - Drivers register to the rfkill module, rfkill
>        - Provides the sysfs interface
>        - Drivers that don't require polling should report the events to this module

Not quite. Drivers that have buttons do not require polling still
should create an input device and register it with input layer. Except
that with interrupt-driven devices there is not much you can stub out
so you just have to do input_allocate_device/input_register_device.

>
>  - rfkill_input
>        - Provides input device visible to userspace
>

No, rfkill-input is not an input device but input handler (or input
interface). It routes input events from buttons into switches (see
below).

>  - input_polldev
>        - Handlers polling, where the driver should check what the previous state was and the driver
>          should send the event to rfkill.

This is the input device visible to userspace and kernel. It polls
state of the button and sends KEY_WLAN/KEY_BLUETOOTH events through
input layer. They get distributed through various input handlers such
as evdev and rfkill-input. Evdev provides route for events to
userspace where application can listen to events and then toggle RF
switches according to the current policy via
/sys/class/rfkill/rfkillXXX/state. Rfkill-input provides in-kernel
route for events into rfkill system. If rfkill-input is loaded
switches that are not claimed by userspace will be toggled
automatically.

Does this make sense?

Note that we don't start polling the state of button until tare are
users of that input device. If rfkill-input is loaded then there is a
user right away. Otherwise we wait for userspace to open evdev node.

>
> personally I would prefer enforcing drivers to call
> allocate()
> register()
> unregister()
> free()
>
> Especially with unregister() doing the same steps as free() (put_device)
> might be somwhat confusing. But might be just me. ;)
>

I know but for refcounted objects you can't really tell when they will
actually be freed. It depends when their last user drops off.

BTW, I can't either as I don't have any laptops with RF swtches ;)

-- 
Dmitry
