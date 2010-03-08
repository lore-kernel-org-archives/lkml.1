Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0CHKWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:22:11 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:38978 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab0CHKWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:22:09 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B94D04A.7060308@cam.ac.uk>
Date: Mon, 08 Mar 2010 10:24:10 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Dima Zavin <dmitriyz@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk>	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>	 <20100303184132.GA11471@core.coreip.homeip.net>	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>	 <20100303190753.GB11471@core.coreip.homeip.net>	 <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>	 <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>	 <4B8F9727.6080907@cam.ac.uk> <404ea8001003080158w6a747cbfv9475e32976ccf9e2@mail.gmail.com>
In-Reply-To: <404ea8001003080158w6a747cbfv9475e32976ccf9e2@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dima,
>> Anyhow, the way this conversation is going there appear to be several options
>> and we need to make a decision before anyone wastes much more time.
>>
>> 1) ALS as is. It's extremely light weight and can always be merged with a better
>>  option at a later date. If people prefer we can always stick it in a subdirectory
>>  called sensors or similar.  Perhaps move hwmon in there as well.
> 
> If your plan is to integrate with iio when it's ready, then there will
> be a drivers/iio, so creating top-level als or even drivers/sensors at
> this point wouldn't really make sense. Perhaps putting them into
> drivers/misc/als is more appropriate?
That would work for me though it kind of breaks what I think misc is for.
It's Andrew Morton's domain though... (cc'd)
> 
>> 2) Input.  I agree with Dmitry here.  These devices are not within the scope as it
>>  currently exists.  It can be done and there have been numerous discussions about
>>  doing so in the past (with various sensor types) and each time it has been decided
>>  that it isn't the right option.  Perhaps opinion on this has changed?
> 
> As Dmitry correctly distilled from my ramblings, what we really need
> is support for poll() on sensor devices. If you guys add a poll
> interface to als, then we can probably get by until iio gets merged.
> Otherwise, we will still need to hack up an input device exporting
> ABS_MISC. If we had ABS_AMBIENT_LIGHT_LEVEL, then it'd be slightly
> less hacky.
Adding polling (here anyway) isn't actually a part of the subsystem.
Just write a driver which has some internal caching fed by relevant interrupt.
Then call sysfs_notify with parameters relevant to the attribute in question.
So for an illuminance0 reading say:

sysfs_notify(&device->dev.kobj, NULL, "illuminance0");

This covers any cases of the device notifying of new values.  You can always
add 'alarm' type attributes and poll on them. The only kicker here, is that
userspace that polls on a device not supporting polling will never get a
response. If you need 'alarm' type parameters feel free to add them as long
as they are suitable documented.

> 
>> Please can anyone who feels like suggesting another general sensors subsystem
>> at least taking a look at IIO (and keeping in mind we are in the middle of a big
>> API cleanup).  If you disagree with how we have done things, then contribute
>> to the discussions and they may change.
> 
> I looked into IIO (sorry for the delay), and it does look promising.
> I'll try to participate in future discussions, and will provide some
> more feedback in a more appropriate forum as it is likely out of scope
> here. When I get a chance, I'll try moving one of our drivers to iio
> and see how it goes.
Excellent, I'd suggest waiting till the current round of API changes are in
there.  Right now you'd just end up getting it working and I'd go break the
interface.  Hopefully, once that's in place those elements of the userspace
side of things will be more or less stable.

Jonathan
