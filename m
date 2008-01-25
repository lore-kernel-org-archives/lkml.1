Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYAYB4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYAYB4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYAYB4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:56:07 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:44220 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbYAYB4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:56:05 -0500
Date: Thu, 24 Jan 2008 19:49:38 -0600
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ville Syrj??l?? <syrjala@sci.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] W1: w1_therm.c standardize units to millidegrees C
Message-ID: <20080125014938.GC1865@spacedout.fries.net>
References: <20080124020330.GA19155@spacedout.fries.net> <20080124123909.GY30987@sci.fi> <20080124145332.GA24193@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20080124145332.GA24193@2ka.mipt.ru>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Thu, 24 Jan 2008 19:49:43 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2008 at 05:53:32PM +0300, Evgeniy Polyakov wrote:
> On Thu, Jan 24, 2008 at 02:39:09PM +0200, Ville Syrj??l?? (syrjala@sci.fi=
) wrote:
> > Why isn't w1_therm presented as a hwmon device?
>=20
> First, because it was created way earlier, second, because it is not a
> hardware monitor :)
> Feel free to create a driver to bind thermal sensors to hwmon framework,
> but I'm not sure it worth time.

They aren't typically found on motherboards.  With their long cable
length they are more commonly used for personal weather stations.  The
guidelines list 750 meters as the longest distance signal wise, and
one example listed example 100 meters and 100 iButton devices as
possible.

The same one wire sensors are part of the OpenBSD equivalent sysctl
command to get hardware information and sensor data.  I added support
for the ds18b20 sensor to OpenBSD.  Interestingly they also had a bug
when reading negative C values, but it was a different implementation
of the bug.  In their implementation the temperature sensor has a
hardcoded 5 second sleep between temperature conversions.  When the
temperature is read the syctl data store is updated.

I did not care for the method which OpenBSD merged the sensor data in
with the other temperature conversions.  Their argument is that the
a user program doesn't block when it goes to read the sensor data.
But the program can't find out how old the data is.  It can't find out
if the temperature didn't change or if there just hasn't been an
updated temperature reading.  The temperature readings are also always
taking place no matter if anyone is reading the results or not.  It
might not be a big deal except the conversion for one sensor is 750ms
and blocks the 1-wire bus for the duration when using parasite power.
Both the Linux and OpenBSD assume parasite power.  In practice it
takes about one second per sensor.  On an otherwise idle system the
one wire scanning and temperature conversion was obvious in top and
vmstat in OpenBSD even if nothing is using the data.  Just think, if
they did have those 100 sensors, the data would be over 105 seconds
old and there would be no way to know just how old.

I'm seeing the applications using these devices as custom written
programs that can easily be written to the current sysfs interface.
That allows the application to initiate a conversion on the sensor it
wants when it wants it.  If anyone does want to pull it into the hwmon
framework please make it optional and allow the application the same
control of which sensor, when to poll, and don't do so when no one is
reading the data.

I'm interested in putting a few sensors around the house to log
temperatures and control the furnace based on that data.  I'm
expecting to poll the sensor connected to the furnace duct much more
frequently than the others.  By default the w1 driver scans the bus to
detect missing and or new devices.  I let it scan once and then
disable it as my network hardly ever changes, especially as right now
it only has the one sensor on it.  I would like to be able to give the
driver a sensor id when it isn't scanning the bus and let it do a
targeted scan for present or not present and then report back to the
program.  That way a program that has a list of what devices should be
there can find out if they are detected without the driver constantly
scanning the bus for the same old devices.  By the way the default bus
scan takes 7.7 seconds to complete and then sleeps 10 seconds before
the next scan leaving the bus idle for only 56% of the time.

--=20
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHmUAyAI852cse6PARAvm7AKCjkZDYsxFlPt91ythoIdIHE+foeQCeLezM
fzsYOhIn5xOxTFaD2+smL8o=
=imCa
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
