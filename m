Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbXJOXth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbXJOXth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbXJOXtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:49:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5547 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbXJOXtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aRXqCadpe84FGEPbqYrKVmOxX34igBodjOwApCWOmLqzVZ9E9XXV805qHJURb1p5g5viqCxAJBVlwj+GEo+7lnd9kE8oxIeHkyS2Ia/FBumXoNwOOP+yEx/mKBIjNi1xohU5DWBHvR3qwFAK7jGdb1QGv257DzwuzIEwQxbUB6o=
Message-ID: <646765f40710151649o490c4e61y99864e16bba490bc@mail.gmail.com>
Date: Tue, 16 Oct 2007 09:49:04 +1000
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: What still uses the block layer?
Cc: "Theodore Tso" <tytso@mit.edu>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Matthew Wilcox" <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, "Jens Axboe" <axboe@suse.de>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Nick Piggin" <piggin@cyberone.com.au>
In-Reply-To: <200710151511.29748.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710112011.22000.rob@landley.net>
	 <200710150508.37332.rob@landley.net>
	 <646765f40710150327i78519a0fvaea7a83d5975b180@mail.gmail.com>
	 <200710151511.29748.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[adding back CCs which were dropped because I'm stupid - sorry!]

On 10/16/07, Rob Landley <rob@landley.net> wrote:
> On Monday 15 October 2007 5:27:55 am Julian Calaby wrote:
> > On 10/15/07, Rob Landley <rob@landley.net> wrote:
> > > On Monday 15 October 2007 4:06:20 am Julian Calaby wrote:
> > > > On 10/15/07, Rob Landley <rob@landley.net> wrote:
> > > > > I note that the eth0 and eth1 names are dynamically assigned on a
> > > > > first come first serve basis (like scsi).  This never causes me a
> > > > > problem because the driver loading order is constant, and once you
> > > > > figure out that eth0 is gigabit and eth1 is the 80211g it _stays_
> > > > > that way across reboots, reliably. Yeah, it's a heuristic.  Hands up
> > > > > everybody relying on such a heuristic in the real world.
> > > >
> > > > Umm, not quite, from my experiences with pre-production wireless
> > > > drivers, (another story, another time) fancy stuff is being done in
> > > > udev to make sure that your gigabit card is always assigned to eth0.
> > >
> > > I remember building a 2.4 kernel, statically linking in all the drivers,
> > > and getting the ethernet devices showing up in a reliable order for
> > > years.  Where does the need for fancy stuff come in?
> >
> > I remember that too. In fact, I have had no issues with network card
> > enumeration order, outside my own inexperience and stupidity.
> >
> > However, this sort of thing is needed now because of the various types
> > of hotpluggable networking devices, e.g. USB 802.11 cards, USB
> > ethernet cards, PCMCIA, etc.
>
> I thought the strategy was just to scan the hotpluggable busses after the
> non-hotpluggable busses.

My (practical) experience is that I couldn't guarantee which card was
which. (I remember once where it changed over a kernel re-compile) So
my solution, before Debian's persistent naming scheme appeared, was to
check it after every new kernel and make sure my config matched up
with the names of the physical interfaces.

> > And yes, PCMCIA worked fine for ages, but
> > usually you'd never have more than one PCMCIA network card.
>
> Still don't, but presumably the slots are scanned in a reliable order so if
> the cards are always present on bootup in the same slots, they'd stay in that
> order.

Well, yes and no. My gut feeling is that it's probed like PCI cards
are. They're initialised when the drivers are loaded, and not before,
as such, there are no guarantees which card will be initialised first.
- and anyway, what happens if you plug them in in a different order?

> > Personally, I use 2 different usb network cards, and I'm quite
> > comforted to know that the 802.11a one is always wlan0, and the
> > 802.11b/g one is always wlan1.
>
> So if I have a USB 100baseT adapter, and I boot with it plugged in, it'll
> potentially come before my built-in wireless card due to ordering based on
> device type?

Ok, firstly the 100baseT adapter will be named something like ethX,
the wireless card will most likely be named something like wlanX.

Now let's say your laptop has a built in ethernet card.

So, we'll assume a modular kernel, with the module "usbnet" for the
usb card and "e100" for the onboard card:

If the "usbnet" module is loaded first, then initially, according to
the kernel, the usb card will be eth0 and the built in one eth1.

Now let's assume that, on the PCI bus, the USB controller is in a
lower slot number than the network card. (highly likely, given that
the network card is most likely external to the chipset of the laptop)
It's pretty likely that the USB controller will have it's module
loaded first, before the built in network card. At this point, it'll
send out hotplug events for all it's children (root hubs, etc.) and
eventually an event will be sent out for the usb network card. Now, at
this point, it's impossible to say which one will claim eth0 first.

Now, in my case, with my two wireless cards, what happens if I plug
the 802.11b/g one in first? If this fancy renaming didn't happen, it'd
end up with the name wlan0 and, hence, try to connect to the network
which the 802.11a one is supposed to connect to.

This is not a good thing.

I also have to make the point that this has been happening all over
the kernel, well before I started using it. Video4Linux and DVB
devices can be USB, and the order the /dev/videoX nodes appear in is
determined by the plugging order. IRDA cards, sound cards, usb
devices, framebuffers, mice, keyboards, loopback devices, etc. all
have the same "issue". (and annoyingly, they all have different ways
of getting around it, or not)

And to make one final point, getting right back to the initial parts
of the discussion, at the end of the day, your SATA disk, IDE disk,
USB disk and the CF card in your camera are all mass storage devices -
they all work in a fairly similar way. You want to mount filesystems
from all of them, and when you run low level tools, like parted or
whatever, you want them all to behave in the same way. If the kernel
abstract away the nastinesses of talking SATA, IDE, USB mass storage,
or CF - and hence, make them all behave in the same, standard, way,
why the hell not?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
