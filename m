Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbXLSXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbXLSXNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXLSXNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:13:08 -0500
Received: from mail.queued.net ([207.210.101.209]:1071 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbXLSXNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:13:07 -0500
Date: Wed, 19 Dec 2007 18:13:04 -0500
From: Andres Salomon <dilinger@queued.net>
To: cbou@mail.ru
Cc: cbouatmailru@gmail.com, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071219181304.48609ecb@ephemeral>
In-Reply-To: <20071219185050.GA1570@localhost.localdomain>
References: <20071216212443.4a1fff3d@ephemeral>
	<1197858984.3798.201.camel@shinybook.infradead.org>
	<20071217055123.GA2274@zarina>
	<20071217024139.2f81e36d@ephemeral>
	<20071217112416.GA25948@localhost.localdomain>
	<20071218021001.46783004@ephemeral>
	<20071219123546.GA6277@localhost.localdomain>
	<20071219130241.21f0b416@ephemeral>
	<20071219185050.GA1570@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 21:50:50 +0300
Anton Vorontsov <cbou@mail.ru> wrote:

> On Wed, Dec 19, 2007 at 01:02:41PM -0500, Andres Salomon wrote:
> [...]
> > > > Hm.  It occurs to me that there's nothing keeping us from having a
> > > > single callback for the driver properties.  Keeping the other patches
> > > > the same, do you prefer the following approach versus what was originally
> > > > in patch#3?
> > > 
> > > Why so difficult? Maybe like this:
> > > 
> > 
> > The point is to get rid of 'propval', and having the core driver define
> > formats.  That's one of the places where we ran into problems with the
> > current API; by having the core driver define what type a property should
> > be returning, we limit battery drivers to what they can display, as well
> 
> Limiting is:
> - I want to do A.
> - I won't let you do that.
> 
> But you don't want convert and write integer attributes directly to
> sysfs.
> 
> If you do so, class will end up converting everything back from
> strings to integers (as in _leds case. And another example, though
> bad one, is drivers/power/apm_power.c).

Yeah, I thought the _leds str_to_int stuff was ugly, but I didn't see
a way around it without sacrificing flexibility.

> 
> > as encourage a lot of non-shared code to end up in the core driver.  That's
> > the reason why we strcpy into 'buf', rather than val->strval.
> 
> When properties are pure integers why you so eager to fill sysfs by
> yourself?
> 

The issue is more about forcing power_supply users to return an integer.
By passing them 'buf', they are allowed to fill it with whatever they
want.  OTOH, if we force (for example) CHARGE_FULL to return an integer,
then a driver that wants to format something differently doesn't have
the opportunity to do that.  I can't think of a case w/ CHARGE_FULL
where we'd want to do that, but the point is more that we shouldn't
assume we'll always know better than someone who's writing a driver
for their particular hardware.  Maybe we want to return a really large
number?  Maybe we want to return a hex number?  Perhaps we want to
pad the number with 0s?  etc..


> You don't want to pad "voltage" property with zeroes. Probably you
> want free-form S/N property. Ok, it fits quite well in the purposed
> scheme: fill strval.
> 
> Can you imagine an use case when this approach doesn't work?

Sure, using a strval is fine *as long* as there's a way to say "this
attribute should be passed a buf".  By having this code in
power_supply_{sysfs,core}.c, we're ensuring that users do not have the
flexibility to define such things.

> 
> > For transitioning, we could certainly just use val->strval all of the time,
> > but there's not much point in doing that in the long term; we might as well
> > just pass around 'buf'.
> 
> No, we don't need strval for every property. Most of them are integers,
> and power_supply_sysfs.c doing its small job: representing internal
> structure to sysfs, through strings. Strings aren't there in the
> first place.


Yes, most are integers, but we could certainly end up with others.
I've already pointed out how the API falls down because it attempts
to be too restrictive.


One of the reasons I proposed this API is because it has sysfs call
the power supply attributes directly.  If we attempt to have a wrapper
for struct device_attribute in power_supply_sysfs.c, we either a) force
power_supply core to determine what type/format each property, and
don't allow power_supply drivers to override that/specify their own
types, or b) include a lot of complexity to allow power_supply drivers
to specify what properties are returning.  (a) is what the current
API does, and it ends up not being flexible enough, and I'm having
a tough time wrapping my head around how to implement (b).

My preferred choice of API has power_supply drivers have callbacks
that are directly called by sysfs.

