Return-Path: <linux-kernel-owner+w=401wt.eu-S1765210AbXLTPFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765210AbXLTPFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762700AbXLTPFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:05:14 -0500
Received: from mx30.mail.ru ([194.67.23.238]:32167 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbXLTPFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:05:11 -0500
Date: Thu, 20 Dec 2007 18:07:16 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071220150716.GA31896@localhost.localdomain>
Reply-To: cbou@mail.ru
References: <20071216212443.4a1fff3d@ephemeral> <1197858984.3798.201.camel@shinybook.infradead.org> <20071217055123.GA2274@zarina> <20071217024139.2f81e36d@ephemeral> <20071217112416.GA25948@localhost.localdomain> <20071218021001.46783004@ephemeral> <20071219123546.GA6277@localhost.localdomain> <20071219130241.21f0b416@ephemeral> <20071219185050.GA1570@localhost.localdomain> <20071219181304.48609ecb@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071219181304.48609ecb@ephemeral>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Wed, Dec 19, 2007 at 06:13:04PM -0500, Andres Salomon wrote:
> On Wed, 19 Dec 2007 21:50:50 +0300
> Anton Vorontsov <cbou@mail.ru> wrote:
> 
> > On Wed, Dec 19, 2007 at 01:02:41PM -0500, Andres Salomon wrote:
> > [...]
> > > > > Hm.  It occurs to me that there's nothing keeping us from having a
> > > > > single callback for the driver properties.  Keeping the other patches
> > > > > the same, do you prefer the following approach versus what was originally
> > > > > in patch#3?
> > > > 
> > > > Why so difficult? Maybe like this:
> > > > 
> > > 
> > > The point is to get rid of 'propval', and having the core driver define
> > > formats.  That's one of the places where we ran into problems with the
> > > current API; by having the core driver define what type a property should
> > > be returning, we limit battery drivers to what they can display, as well
> > 
> > Limiting is:
> > - I want to do A.
> > - I won't let you do that.
> > 
> > But you don't want convert and write integer attributes directly to
> > sysfs.
> > 
> > If you do so, class will end up converting everything back from
> > strings to integers (as in _leds case. And another example, though
> > bad one, is drivers/power/apm_power.c).
> 
> Yeah, I thought the _leds str_to_int stuff was ugly, but I didn't see
> a way around it without sacrificing flexibility.

Please, stop saying "flexibility". ;-) Better "I needed this, that's
why I've done that".

You needed S/N property, I've gave you the solution without any
drastic or conceptual change to the whole subsystem.

Not that I don't want conceptual changes, I just don't see any need
for them. And no, I don't think that purposed changes are any
better then existing properties.

> > > as encourage a lot of non-shared code to end up in the core driver.  That's
> > > the reason why we strcpy into 'buf', rather than val->strval.
> > 
> > When properties are pure integers why you so eager to fill sysfs by
> > yourself?
> > 
> 
> The issue is more about forcing power_supply users to return an integer.

This isn't the issue. This is what userspace expects. And no, we don't
want to some driver return "too much" from the "current_now" property.
This isn't legitimate value for that property!

> By passing them 'buf', they are allowed to fill it with whatever they
> want.

Why do they want silly things in the first place?

> OTOH, if we force (for example) CHARGE_FULL to return an integer,
> then a driver that wants to format something differently doesn't have
> the opportunity to do that.

This is _good_. And we've done it expressly:

- - - Documentation/power_supply_class.txt
So, userspace gets predictable set of attributes and their units for any
kind of power supply, and can process/present them to a user in
consistent manner. Results for different power supplies and machines are
also directly comparable.
- - - -

> I can't think of a case w/ CHARGE_FULL where we'd want to do that, but
> the point is more that we shouldn't assume we'll always know better
> than someone who's writing a driver for their particular hardware.

See the quote above. If driver implements something special, it must
create its own attribute. Via device_create_file. So far none driver
(including OLPC) needed any special attribute that we wouldn't add
to the "core set".

> Maybe we want to return a really large number?

Did you reach int limit already? I can change the int to long long
in a jiffy. Or add new member to the union, with "bigint" name.
I don't see any problem if one day we will face int limit.

> Maybe we want to return a hex number?

No way. What is that for? Name the property.

> Perhaps we want to pad the number with 0s?  etc..

For what kind of property? Does it exist?

> > You don't want to pad "voltage" property with zeroes. Probably you
> > want free-form S/N property. Ok, it fits quite well in the purposed
> > scheme: fill strval.
> > 
> > Can you imagine an use case when this approach doesn't work?
> 
> Sure, using a strval is fine *as long* as there's a way to say "this
> attribute should be passed a buf".  By having this code in
> power_supply_{sysfs,core}.c, we're ensuring that users do not have the
> flexibility to define such things.
  ^^^^^^^^^^^
s/flexibility/anarchy/

Yes, we're disciplining drivers, so they will look uniform outside of
the kernel. If driver needs not to be uniform, it's free to define its
own internal attributes in _addition_ to uniform ones. And again,
no single driver ever implemented this yet, and no one ever asked to
add new attribute to the "core set". And obviously no one got a refuse
to add one.

If you want to add S/N attribute to the core set -- go ahead, this
is long awaited addition. S/N is okay to be a free-form, thus
strval is a correct choice for that property.

> > > For transitioning, we could certainly just use val->strval all of the time,
> > > but there's not much point in doing that in the long term; we might as well
> > > just pass around 'buf'.
> > 
> > No, we don't need strval for every property. Most of them are integers,
> > and power_supply_sysfs.c doing its small job: representing internal
> > structure to sysfs, through strings. Strings aren't there in the
> > first place.
> 
> 
> Yes, most are integers, but we could certainly end up with others.

When we'll end up with "others", we'll implement another attribute.

If it needs to be free-form, it will use strval. If it will need
to be a hex number, it will be 'int' and _sysfs will represent it
as hex, for _all_ drivers.

> I've already pointed out how the API falls down because it attempts
> to be too restrictive.

You didn't point how that api falls down, really. You're talking
about maybes and what-ifs.

> One of the reasons I proposed this API is because it has sysfs call
> the power supply attributes directly.  If we attempt to have a wrapper
> for struct device_attribute in power_supply_sysfs.c, we either

> a) force power_supply core to determine what type/format each property,
> and don't allow power_supply drivers to override that/specify their own
> types, or

Correct.

> b) include a lot of complexity to allow power_supply drivers
> to specify what properties are returning.

Then, what the power supply subsystem is for? Just place all the
drivers together in driver/power/, and let them create sysfs
attributes by their own. You'll get a medley, not the subsystem.

Good luck,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
