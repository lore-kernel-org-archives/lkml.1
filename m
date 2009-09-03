Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZICNvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZICNvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZICNvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:51:11 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:49379 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZICNvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:51:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A9FC9D7.20000@cam.ac.uk>
Date: Thu, 03 Sep 2009 14:51:19 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       Zhang Rui <rui.zhang@intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Subject: RFC: Light sensors, unifying current options?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

This thread is a follow up to (amongst others)

[lm-sensors] Ambient Light sensor for Intersil-ISL29020 device

Currently there are a number of light sensor drivers either in the
mainline kernel, posted to various mailing lists or sitting in various
testing trees.

For example.

Intersil ISL29020
http://www.intersil.com/products/deviceinfo.asp?pn=ISL29020 driver
posted by Kalan Trisal to lm-sensors (as hwmon device rejected for
being out of subsystem scope)
http://lists.lm-sensors.org/pipermail/lm-sensors/2009-September/026575.html

ALS_sysfs class and als_acpi driver (V6 posted to lkml earlier this week).
http://lkml.org/lkml/2009/9/1/38

TSL2561 under the industrial I/O Framework. (in Greg KH's tree, will
being in staging after merge window - there due to lack of review
more than any known problems.)
http://www.farnell.com/datasheets/49661.pdf
http://lkml.org/lkml/2009/7/2/189

TSL2550 under i2c/chips/ which as a location is going away.
http://www.farnell.com/datasheets/48715.pdf

(any others people know of?)

Two big questions:

* Are there sufficient shared characteristics between these devices to
all for a unified framework? (would certainly be nice!)

* What applications are they used for? This will drive the question
of what functionality is desirable. (particularly do we need an event
infrastructure or not).

To sumarize the functionality currently provided by the above drivers
(or that should probably be added)

ISL29020:
* sensing_range
* lux_level
* power state (should probably move over to the new power management
  framework)

ALS:
* illuminance (equivalent of lux_level)
* adjustment (I don't follow the purpose of this, but then I don't know
anything about how this is being used!)

TSL2561
* infrared (raw value)
* broad spectrum (raw value)
(I'm of the view any derived values should probably be done in userspace)
This one is under IIO at the moment for two reasons.
1) I hit the same issue of no suitable subsystem, but for a much larger
class of sensor devices. Light sensors are just one example (that's not
to say I mind hiving this lot off to a system of their own).
2) To provide an event interface (which I haven't yet done)
Driver should also include:
* integration time
* gain control 

TSL2550
* power state
* operating mode
* lux (actually calculated from two separate readings as
per the tsl2561 but the are not available to userspace)

Applications:

1) Backlight intensity type apps (guessing that covers most people)
2) Environmental monitoring apps (the crossbow imb400 imote2 daughter
board I'm using doesn't have any screen or other direct interface, its
simply a lightweight sensor platform).
3) High speed apps (all current sensors are pretty slow so this isn't
yet relevant).

My personal feelings is that the IIO is overkill for these types
of sensors (slow update rate, tsl2550 takes 400ms, tsl2561 12-400ms)
unless we want the event handling infrastructure. I'm inclined to
say it is unecessary given the same result could be obtained by
polling only a few times a second.

My comments on ALS may be wrong or misleading as they are based on a
brief read of the code (please correct me!)  A lot of the
infrastructure is only necessary if we have in kernel users (and at
the moment the functionality doesn't appear to be there for any such
users to acquire access to these sensors in the first place.  For
example, the approach used by hwmon of letting drivers define their
own attributes seems to me to be more easily extendable than ALS' use
of an ops structure. For example, I'm not convinced it makes sense for
drivers to have to have a get_adjustment attribute or indeed even
necessarily have a direct illuminance attribute (deriving the relevant
value may be a case of userspace combining several associated
readings). As an aside: Why specify it is 'ambient' light?  Kind of
implies an unnecessary restriction on the users of the subsystem.

Anyhow, the point of this email was to draw together those interested
in a unified light sensor system and perhaps promote discussion of
what such a unified system should do before we end up with even more
in kernel alternatives!  As such this email isn't meant to be a
complete description of the problem / possible issues, merely a
starting point.

Personally I really don't mind where the tsl2561 driver ends up as
long as the functionality is all available.

Any comments?

Thanks

---
Jonathan Cameron






