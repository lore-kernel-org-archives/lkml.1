Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbXH3Mmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbXH3Mmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 08:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXH3Mm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 08:42:27 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60422 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbXH3Mm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 08:42:26 -0400
X-Sasl-enc: 1/jiZ+gYhvrjxwxjA2fTGMH/0XG7HT970jYrbOlngXRn 1188477745
Date: Thu, 30 Aug 2007 09:42:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shem Multinymous <multinymous@gmail.com>
Cc: Yan Burman <burman.yan@gmail.com>, hdaps-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data
	Protection System 3D ACPI driver (resend)
Message-ID: <20070830124221.GA23831@khazad-dum.debian.net>
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com> <20070827171107.GA15647@khazad-dum.debian.net> <46D5A742.8090201@gmail.com> <20070829233024.GA7433@khazad-dum.debian.net> <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Shem Multinymous wrote:
> > > I agree that the sys interface is probably not the best choice, but the
> > > accelerometer data should provide not only position, but also generate
> > > an event when it detects
> > > that it's falling. From what I understood hdaps does not have that info,
> >
> > You can generate events on input devices, but I am not sure that's the best
> > way to go about it for this.  Things that block on read until an interrupt
> > happens might work better.
> 
> You can do the latter via another (4th) input device.

We have the events that can be sent over all devices, actually (we can use
button events for this).  But blocking on read might indeed require a
separate input device... or a file, or something like that.  And we
*definately* should implement something like proper select() and poll()
support for the position sysfs attribute.

HDAPS has also some other crap that needs to go over the input device (mouse
activity, keyboard activity flags).  ams and hpmdp have the "possible shock
imminent" events, etc.  The goal is to kill all need for userspace to keep
pestering the accelerometer driver with open/read/close on sysfs attributes
constantly.

> > I'd suggest an accelerometer sysfs interface, that we implement in hdaps
> > (in and out-of-tree), ams and hpmdp.  One input device for joystick
> > emulation (optional), one input device with accelerometer data in mg or ug,
> 
> Is any of the accelerometer drivers currently capable of computing the
> physical acceleration? Also, is there an issue of linear vs. angular
> acceleration?

HDAPS is, if we add the code to calculate it.  I suppose the others can,
too, if they get the datasheets for the acceleration sensors.  However, if
it proves too difficult to calculate these values, we will have to do away
with it, and instead find a way to export what data we know about the
accelerometers (orientation, type of mesaurement, scales of measurement,
etc).

As for linear vs angular, we will have to find a way to report either: it
will depend on the accelerometer sensor.  HDAPS uses only linear, on two
axes (bad! ams and hpmdp can do it for three axes).  I know of sensors for
three axis (also linear), but it is not difficult to imagine people using
angular acceleration sensors.  Maybe we could export the type of
acceleration per-axis or somesuch using sysfs?

> Before or after axis inversion/swapping? The tp_smapi hdaps driver

After inversion.  The goal is to have something applications can use
transparently, so all input devices have to use the same orientation in all
platforms. We will have to set those in some arbitrary way, and the drivers
will have to do axis inversion when needed.

While one doesn't need (or care) about axis orientation for sudden movement
detection (where the really interesting use is :-) ) (it is enough to know
the axis are orthogonal to each other), it does matter for toys.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
