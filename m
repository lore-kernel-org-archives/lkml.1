Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZLENI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZLENI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZLENIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:08:24 -0500
Received: from mailgw5.ericsson.se ([193.180.251.36]:51017 "EHLO
	mailgw5.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZLENIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:08:23 -0500
X-AuditID: c1b4fb24-b7beeae000003a71-e2-4b1a5b4c4c4b
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [POWER] battery calibration parameters from sysfs
Date: Sat, 5 Dec 2009 14:08:11 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
In-Reply-To: <20091204104930.GA28625@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [POWER] battery calibration parameters from sysfs
Thread-Index: Acp0z3lkDu1oT7VaR7uFcmRKvNMNsgA2bFqA
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se> <20091204104930.GA28625@sirena.org.uk>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: <cbou@mai.ru>, <dwmw2@infradead.org>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>
X-OriginalArrivalTime: 05 Dec 2009 13:08:12.0845 (UTC) FILETIME=[000235D0:01CA75AC]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark, prompt answers as always.

[Mark Brown]
> [Linus Walleij]
> > In our code we have a number of (x,y) pair tables like this:
> 
> > /* Vbat mV to Battery capacity % */
> > struct voltage_vs_capacity {
> > 	int voltage;
> > 	int capacity;
> > };
> 
> Isn't the standard thing here to handle this voltage to 
> capacity mapping in userspace if we're just extrapolating
> from experimental results?

That's an easy solution of course, but then the sysfs files
specified by the power subsystem, i.e. all "charge_*",
"energy_*", "capacity" and "time_to_*" loose their meaning
and must be ignored by userspace.

Also this was just an example, we have similar calibration
for the temperature sensor, and thus the "temp" sysfs file
also loose its meaning.

Since there is a plethora of userspace apps that just
interface these files directly (gnome-power-manager and
the Android stack come to mind) all these will have to
be patches to accept a calibrated value from somewhere
else if we shall use them with our hardware.

But as you say:

> Even with the "smart" batteries in PCs there are some 
> accuracy concerns and obviously the performance of the
> battery will change over time.
> ...
> Actually, one further thing here - if this functionality
> is implemented in kernel then shouldn't it be a generic
> feature rather than part of the driver?  The idea of
> mapping battery voltages to capacity percentages isn't
> specific to a given charger and will apply to all
> batteries using the same technology.

Surely, we'd be happy to do it that way if desired.
What about drivers/power/battery_lib.c?

(And getting algorithms in place for gradually
adjusting the capacity levels as compared to factory
settings for PC batteries would perhaps end up in the
same place then.)

We have other odd code. Actually we have full software-
controlled CC/CV charging in our driver, and that
would *definately* go in such a library if it was
to end up in kernelspace. We have actually
pushed that to userspace, while I still tend to think
that the kernel (with right parameters) should be able
to charge a battery. But, well.

As for the calibration format, after reading up on the
latest sysfs doc I saw:

Documentation/filesystems/sysfs.txt:
"Attributes should be ASCII text files, preferably with
only one value per file. It is noted that it may not be
efficient to contain only one value per file, so it is
socially acceptable to express an array of values of the
same type."

This is close to that, an array of two types (x,y)(x,y)
voltage,capacity,voltage,capacity etc. Pushing them in
two files

/sys/.../v_vs_cap_v
/sys/.../v_vs_cap_cap

and then make sure we write as many values to each array
is uglier IMHO.


Yours,
Linus Walleij
