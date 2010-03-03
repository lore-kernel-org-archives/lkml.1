Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0CCLIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:08:30 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:55578 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0CCLI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:08:29 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8E43A2.20203@cam.ac.uk>
Date: Wed, 03 Mar 2010 11:10:26 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Dima Zavin <dmitriyz@google.com>
CC: Jean Delvare <khali@linux-fr.org>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk>	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>	 <20100303103405.127020d8@hyperion.delvare> <404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
In-Reply-To: <404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
> Jean,
> 
> Thanks for the prompt reply.
> 
>>> I definitely see the need for what you guys are trying to accomplish.
>>> For example, currently, we use an input device for reporting events,
>>> and a separate misc device node for control
>>> (enable/disable/configure). It's definitely suboptimal, but there
>>> currently isn't anything there would let us do things cleanly.
>>>
>>> What I would love to see is a more generic sensors framework that
>>> handles different kinds of sensor devices, and different data
>>> acquisition schemes (sampled vs. change notifications).
>>>
>>> I would love to work with you to design something more generic.
>>
>> This can happen later, I see no reason to block the creation of the ALS
>> subsystem. Having a common framework for all ambient light sensor
>> drivers will already be a step forward compared to the current
> 
> Following the logic of putting the ALS subsystem under drivers/als, we
> would then put the proximity subsystem under drivers/proximity, and
> then an accelerometer subsystem under drivers/accelerometer, etc.
> Each
> with their own implementation of very similar set of interfaces. Is
> that what you envision? I just figured that instead of creating
> one-off interfaces for some subset of environmental sensors such as
> als, we can add a sensors subsystem of which als is just an instance.
> 
>> situation. If improvements are needed on top of this, this can happen
>> later.
> 
> I'm just concerned that instead of solving the actual problem, you are
> adding what is essentially a temporary solution. This will only make
> it harder to solve the real issue by introducing new interfaces which
> will need to be obsoleted unless they are designed with care. What you
> are proposing already needs improvements since there are plenty of
> drivers floating out there from many OEMs/vendors that are not ALSs,
> but essentially need a similar interface (e.g. proximity sensor).
Actually, the reason we hived off ambient light sensors into their own
subsystem was mainly that they typically have extremely simple interfaces
and run at rather low rates.  I'm personally extremely interested in
how to support other forms of sensor.  That is what my primary
work at the moment on the IIO subsystem in staging is directed towards.
Initially we did have light sensors within there (and there is one left
at the moment).

However, having said that, we concluded that IIO was massive overkill for
this particular form of sensor.  The typical read rate for these is a
couple of Hz.  IIO is intended to handle the much more sophisticated
devices and right now its still a fair way from being ready for an
attempt at merging with the mainline kernel.  It is getting plenty
of new drivers, but the core still needs some work.  Basically the usual
argument of do things the simple way if you can came to the fore here.
There was little if any overlap with functionality or interface with other
sensor types in IIO so it didn't really make sense to have them there.

Note there are many other complexities in how to handle the other sensors
you mention. If you have a chance to take a look at the current form of
IIO (and perhaps follow the discussions on linux-iio@vger.kernel.org)
we would appreciate any comments on how we are going about it.
> 
> Furthermore, are there more patches coming for this subsystem? Based
> on the above tree, it just seems to be a class device (without any
> standard attributes) and a register/unregister function. It doesn't
> seem to actually be doing anything. Registering with the als subsystem
> at the moment buys the driver nothing. So, in its current state, I'm
> not sure I see what this new common framework actually provides us,
> and thus I'm not sure that it's actually a step forward. The drivers
> are still responsible to provide all their own non-standard,
> incompatible sysfs interfaces for exporting the sensor values.
No the aren't.  The sysfs interface specification is exactly the reason this
subsystem exists.  We could have taken the heavy weight route and done
everything via callbacks etc to try and enforce naming, but instead went
with the one that has been very successful for hwmon, that of a formal
specification and driver review to ensure that all devices are compatible.

In a sense, this subsystem is merely providing an alternative to hwmon for
these devices seeing as they do not fall within the scope of hardware
monitoring.
> If
> there are other patches for the als subsys that are then used by the
> two drivers that got moved into drivers/als, I'd love to take a look
> at them.
The subsystem is deliberately kept simple, but there are patches for
ACPI that add a further driver and a plan to move the tls2563 driver
from IIO to als.  Note that some of these may involve extending the
sysfs specification as appropriate to provide new functionality.

Thanks,

Jonathan

