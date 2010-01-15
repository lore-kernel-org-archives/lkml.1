Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0AONbq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972Ab0AONbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:31:46 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59688 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab0AONbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:31:45 -0500
Date: Fri, 15 Jan 2010 14:31:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h 
 CPUs
Message-ID: <20100115143140.25b86c1c@hyperion.delvare>
In-Reply-To: <4B503C26.7040902@ladisch.de>
References: <4AF91F70.10106@ladisch.de>
	<4B06501B.8080509@ladisch.de>
	<87ws1l5wcl.fsf@depni.sinp.msu.ru>
	<4B0673D7.5010006@ladisch.de>
	<20091120123016.19d98ab4@hyperion.delvare>
	<4B068402.7020606@ladisch.de>
	<20091120131855.7f8f8722@hyperion.delvare>
	<4B0A3DB6.9090703@ladisch.de>
	<20091123145154.5b2b5735@hyperion.delvare>
	<4B0AAA55.3040702@ladisch.de>
	<20091123200527.1114cbc2@hyperion.delvare>
	<4B0B9CB1.3090808@ladisch.de>
	<20091124142654.76f4d166@hyperion.delvare>
	<4B0BE935.1050708@ladisch.de>
	<20091124211134.12971937@hyperion.delvare>
	<4B0CFE2A.6010008@ladisch.de>
	<20091126214429.6ac22d3f@hyperion.delvare>
	<4B0FCE21.9070007@ladisch.de>
	<20100110154549.1e5d0098@hyperion.delvare>
	<4B503C26.7040902@ladisch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On Fri, 15 Jan 2010 10:57:58 +0100, Clemens Ladisch wrote:
> Jean Delvare wrote:
> > On Fri, 27 Nov 2009 14:03:29 +0100, Clemens Ladisch wrote:
> > > +temp[1-*]_scale	Temperature scale type.
> > > +		0: millidegrees Celsius (default if no _scale entry)
> > > +		1: relative millidegrees Celsius; see below
> > > +		2: millivolts; see below
> > > +		other values: unknown
> > 
> > Maybe, yes. I am a little worried that older versions of libsensors
> > will ignore this attribute. The good thing about this is that users
> > will still get some value until they upgrade. The bad thing is that
> > they will not know that the value isn't absolute. They are likely to
> > get frightened by unexpected values and/or to complain to us about them.
> > 
> > I am wondering if a totally separate channel type wouldn't be
> > preferable. The pros and cons would be inverted of course: older
> > versions of libsensors would have zero support for that, and all
> > applications would have to be updated to support it, but at least the
> > meaning of the value would be totally clear. This would come at the
> > price of some code duplication both in libsensors and applications
> > though.
> > 
> > I guess it basically depends whether we want to consider a thermal
> > margin as a "temperature measurement except that it's relative" or as
> > something completely separate.
> 
> It's different from the millidegree/millivolt issue; millivolts can be
> transparently converted by libsensors, while relative values must be
> handled/displayed differently by the application.  So I think at least
> in the libsensors API, relative values should be different.
>
> (In any case, we should add temp#_scale at least for millivolts.)

I agree it would make sense. So far, libsensors worked without it,
thanks to a large default configuration file that included a default
voltage->temperature conversion for each affected chip. Now that we
have opted for a much smaller configuration file, completely weird
temperature values will be displayed by default. Ideally, libsensors
would refuse to display temperature values that are reported in mV in
the absence of a corresponding conversion formula in the configuration
file. I'm not sure how easy that would be to implement in libsensors
though.

> > Honestly, I've been thinking about this
> > for some time now and I simply don't know what we'd rather do :(
> 
> The sysfs interface is a somewhat internal interface;

NO, it is not. I would love to consider it internal, and we certainly
discourage people from accessing the sysfs interface directly. However
some applications _do_ access sysfs directly (fancontrol and pwmconfig
come to mind but there are others.) On top of that, older and newer
versions of libsensors are being used. So we have to preserve
compatibility in every change we make to the sysfs interface. Thus you
can't claim it is internal.

> I think the main
> question is whether old userspace (old libsensors or old apps using a
> new libsensors) should be able to see relative values without knowing
> that they are relative.

Yes, this is the main question. There are pros and cons both ways, as I
explained before.

> Coretemp and k10temp already exist and show relative values.

Not really. There is a significant difference between showing absolute
values which may be incorrect because we are unsure of the base point
(coretemp), showing relative values which are arbitrarily offset to
look like absolute values (k10temp) and showing totally relative
values (thermal margins actually.) In the former two cases, there can
be some confusion for the user (for example when comparing two sensor
values in the same machine) but I don't expect the user to be
frightened. While showing "negative temperatures" would probably
frighten the users. Showing values which decrease when temperature
increases (which is still an option) would also be a lot more confusing
than what we have today.

As a matter of fact, we will have to handle the 3 cases I just
described differently, at least to some extent, for compatibility
reasons (see below.)

> If we
> introduced a new channel for relative values now, we would still have
> problems with those drivers, so it might already be too late to avoid
> problems for old userspace.

We can't change old user-space by definition. All we can do is think of
how it will react to sysfs interface changes.

One thing you must keep in mind is that trading one form of imperfection
for another is not considered OK. Users get used to the initial form of
imperfection and will still see the change as a regression (I do
software maintenance for a living if you couldn't tell.) This is
especially true when things have been the way they are for long (which
is the case of coretemp.) For k10temp we have a grace period because
the driver is still new and its users are few. But this won't last.

Concretely, this means that, just because coretemp doesn't always
report correct temperature values, we can't change it to exclusively
report raw thermal margins today. Whatever change we come up with, it
shouldn't alter what older versions of libsensors would report.

I am fine with your temp[1-*]_scale proposal, but this is only one
piece of the puzzle. We must also define what newer versions of
libsensors will do with the value in that file, both for older drivers
such as coretemp (for which we can't change the interface too much for
compatibility reasons) and for hypothetical new drivers reporting truly
relative temperatures (with k10temp being an intermediate case.)

I suspect we will have change the output of "sensors" too. So far we
did not print any category names, under the assumption that the unit
used for each value was sufficient. Now if °C can mean absolute
temperature or (relative) thermal margin, this becomes ambiguous.

I've created a new ticket on lm-sensors.org to track this issue:
http://www.lm-sensors.org/ticket/2376

(Sorry, the site is awfully slow these days, when responsive at all...)

I can create a wiki account for you if you want to keep participating
in the lm-sensors project.

-- 
Jean Delvare
