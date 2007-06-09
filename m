Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbXFIJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbXFIJZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 05:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXFIJZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 05:25:40 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:52404 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbXFIJZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 05:25:39 -0400
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Purdie <rpurdie@openedhand.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <20070608234629.GA11723@kroah.com>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
	 <1180715004.6390.169.camel@localhost.localdomain>
	 <20070608185710.GB14372@kroah.com>
	 <1181343748.9506.116.camel@localhost.localdomain>
	 <20070608234629.GA11723@kroah.com>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 10:25:16 +0100
Message-Id: <1181381117.24811.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 16:46 -0700, Greg KH wrote: 
> On Sat, Jun 09, 2007 at 12:02:28AM +0100, Richard Purdie wrote:
> > On Fri, 2007-06-08 at 11:57 -0700, Greg KH wrote:
> > > On Fri, Jun 01, 2007 at 05:23:24PM +0100, Richard Purdie wrote:
> > > Why not just do a simple:
> > > 	led01
> > > 	led02
> > > 	led03
> > > 	...
> > > 
> > > and so on?
> > 
> > If we do this, my point is we're exporting something to userspace which
> > is totally devoid of information. 
> 
> Just like all other subsystems?
>
> No, the only information the device name is that it shows a UNIQUE name
> at that point in time in the kernel.  Heck, we could just use random
> numbers that are unique like some other people have suggested, it would
> mean the exact same thing.
>
> > Since its in class/leds/ we can summarise the latter without help from
> > the prefix. I'd hate to think userspace cares about the former.
> 
> Ok, then use a random number please.  Start with 00000000000001 and just
> increment from there, or use the idr subsystem.
> 
> I was trying to be nice and at least give you a prefix that looked kind
> of sane to people, but if you want to be difficult... :)

This whole mess is because the LED class tried to be nice with sane
looking ids :/.

> > > And use the 'name' field to put the name of your device (disk,
> > > bluetooth, etc.)  This is the way all other busses and devices work, and
> > > I don't think that LEDs are anything more "special" than anything else
> > > in the kernel, right?
> > 
> > Since the "busid" field means absolutely nothing, why not give it a
> > sensible id and save the overhead of a separate name?
> 
> Because that is not how things work, sorry.

Most of your argument seems to read that this shouldn't be done because
nobody else does it which isn't a particularly good one. Everyone else
is jumping off a bridge, I should as well? You then point out that PCI
and USB busids do have some meaning and a quick glance at sysfs shows
others too.

> > If kernel policy is that we should have useless data in sysfs, so be it,
> > I just make sure that is on record and then break the defined LED class
> > API.
> 
> Again, the bus id needs to be unique, for that specific class/bus that's
> it.

and as I've said several times, the LED scheme *is* unique meeting your
criteria ;-).

>   The attributes in the directory let you figure out what specifics
> are for the device.
> 
> Look at the PCI and USB devices.  There is some information you can
> glean from those names, but they are primary a unique identifier, you
> need to look at the attributes to get the real information about your
> device.

So the PCI and USB subsystems need adjusting to use random numbers since
they're also breaking the rules and might have meaningful information in
their busids? Please fix them too ;-).

> > <serious mode>
> > Ok, so I make the point above with a sledge hammer. There are more
> > subtle issues here too. People are asking for a ton of extra attributes
> > for the LED class. We can have a name, a colour, an LED "function", a
> > location on the device and probably 101 other things.
> 
> Great, the more the merrier.  Seriously, I have no problem with that.

Where do you draw the line though?

> > As I understand it, sysfs was put there to pass information *the kernel
> > knows* to userspace. The kernel doesn't actually care about the location
> > of an LED or its colour. All the kernel cares is we have an LED and it
> > has a certain brightness.
> 
> If you know the color and location already, why not export that
> information?  Unless you can determine it from userspace some other way
> already?

The kernel doesn't know this and it doesn't care about this.

We could teach the kernel. Alternatively we could teach userspace.

> > Yes, we can teach the kernel all this extra info but it is simply to
> > pass to userspace. Why should my kernel be bloated with all that extra
> > information which it doesn't need itself?
> 
> If there's no other way for userspace to determine it, then put it in
> the kernel.  Otherwise leave it for userspace to handle.

Ok. The LED class can provide a name attribute which uniquely identifies
each LED. Userspace can then store and look up all the information it
wants against that "name".

So by this argument, colour, function and all these other attributes
should be left for userspace/HAL to deal with.

> > I'm very aware I'm isolated here and ultimately this is probably Greg's
> > decision which I will end up abiding by. If anyone else does have a
> > view, speak now ;-). I think there are some important issues here and
> > they do need clarification, one way or another.
> 
> I know that LEDs are special and unique, just like everyone else, so
> please work like everyone else does :)

I've never claimed that it was special and unique. Just because it does
something differently, that doesn't mean its wrong either. 

One last try to demonstrate this is grossly inefficient (and this kind
of inefficiency is one reason I'm beginning to dislike sysfs). On my
handheld, you can currently script something to light a specific LED
with something like:

echo "1" > /sys/class/leds/spitz\:green/brightness

With the busid changes, this becomes:

for busid in `ls /sys/class/leds`
do
  name=`cat /sys/class/leds/$busid/name`
  if [ "$name" = "spitz_green" ]; then
    break
  fi
done
echo "1" > /sys/class/leds/$busid/brightness

Even after accounting for my lack of l33t shell skills, the latter will
be much more complex. For what gain? It doesn't matter whether you do
this through shell or any other language. Even if you know the name of
the device you want to talk to you have to convert to some meaningless
busid first which is inefficient. Things like HAL are going to be forced
to read things after every boot. This has wider implications than the
LEDs which are just a tiny consideration in the grand sysfs scheme. If
we can make sysfs more efficient, wouldn't that be a good idea?


Anyhow, time to stop pretending I have any choice in this ;-). I will
have the LED class use random numbers for busids and add a name
attribute unless anyone else voices an opinion.

My current view is that notions of colour, function, location etc.
shouldn't be in the class since userspace can handle it in userspace and
these don't mean anything to the kernel.

Cheers,

Richard


