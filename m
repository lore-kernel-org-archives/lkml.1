Return-Path: <linux-kernel-owner+w=401wt.eu-S1031923AbXFHXDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031923AbXFHXDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 19:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXFHXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 19:02:56 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44031 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032436AbXFHXCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 19:02:53 -0400
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Purdie <rpurdie@openedhand.com>
To: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Hughes <hughsient@gmail.com>, "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <20070608185710.GB14372@kroah.com>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
	 <1180715004.6390.169.camel@localhost.localdomain>
	 <20070608185710.GB14372@kroah.com>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 00:02:28 +0100
Message-Id: <1181343748.9506.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 11:57 -0700, Greg KH wrote:
> On Fri, Jun 01, 2007 at 05:23:24PM +0100, Richard Purdie wrote:
> > I still question whether either colour or function properties are
> > actually particularly useful to userspace other than for naming purposes
> > which is why they were part of the device name.
> > 
> > Anyhow, I'm trying not to say too much more as it will just go in
> > circles. I'll await a reply from Greg.
> 
> Hm, I thought I made my opinion pretty clear in the beginning.
> 
> Why not just do a simple:
> 	led01
> 	led02
> 	led03
> 	...
> 
> and so on?

If we do this, my point is we're exporting something to userspace which
is totally devoid of information. 

sysfs is for userspace and "led01" means absolutely nothing to it. The
most you can summarise from it is it happens to have registered first
and its an LED. Since its in class/leds/ we can summarise the latter
without help from the prefix. I'd hate to think userspace cares about
the former.

> And use the 'name' field to put the name of your device (disk,
> bluetooth, etc.)  This is the way all other busses and devices work, and
> I don't think that LEDs are anything more "special" than anything else
> in the kernel, right?

Since the "busid" field means absolutely nothing, why not give it a
sensible id and save the overhead of a separate name?

If kernel policy is that we should have useless data in sysfs, so be it,
I just make sure that is on record and then break the defined LED class
API.


<serious mode>
Ok, so I make the point above with a sledge hammer. There are more
subtle issues here too. People are asking for a ton of extra attributes
for the LED class. We can have a name, a colour, an LED "function", a
location on the device and probably 101 other things.

As I understand it, sysfs was put there to pass information *the kernel
knows* to userspace. The kernel doesn't actually care about the location
of an LED or its colour. All the kernel cares is we have an LED and it
has a certain brightness.

Yes, we can teach the kernel all this extra info but it is simply to
pass to userspace. Why should my kernel be bloated with all that extra
information which it doesn't need itself?

My conclusion is that there should be something in userspace
supplementing this information from the kernel. Going back the the
problem at hand, HAL is already equipped to do this, all it needs is
some kind of unique ID so it can identify the LED. This would be the
busid.

So I do stand by what the LED class does as being sane. Yes, the class
defined a way of writing its busids which isn't like any other but there
is a good reason for it. We could make it machine readable to provide
hints to userspace and I never saw any reason why we shouldn't have
done. It was discussed on LKML and no objections were raised (it was in
fact requested). The choice of field separator is unfortunate since its
developed other meanings after it was used in the LED class, such is
life.

So there are various options:

1. We keep 'useful' busids and the LED class continues as is. We accept
classes can provide a busid naming policy if it makes sense.

2. We adopt free form busids and export a ton of attributes just useful
to userspace (bloating the kernel IMO).

3. As 2. but use 'useless' busids that mean nothing.

4. We adopt free form busids but let userspace fill in its own
information based on the busid (no policy on naming).

5. Other combinations thereof.


I'm very aware I'm isolated here and ultimately this is probably Greg's
decision which I will end up abiding by. If anyone else does have a
view, speak now ;-). I think there are some important issues here and
they do need clarification, one way or another.


Cheers,

Richard


