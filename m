Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYGNRIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYGNRIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYGNRI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:08:27 -0400
Received: from mercury.realtime.net ([205.238.132.86]:55814 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542AbYGNRI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:08:26 -0400
In-Reply-To: <20080714095914.0644ac5d@hyperion.delvare>
References: <for-27-patch1-0@bga.com> <48768018.2070704@hhs.nl> <acca8e14e769b2feadee19f1f7448438@bga.com> <20080711085246.1ead773b@hyperion.delvare> <48770B5E.7000308@hhs.nl> <20080711093650.4b98e3b7@hyperion.delvare> <4879A144.8060203@hhs.nl> <4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com> <487A7211.7030309@hhs.nl> <4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com> <20080714095914.0644ac5d@hyperion.delvare>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <88f5162604470179b3c6ebfe729a46f5@bga.com>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, "Hans de Goede" <j.w.r.degoede@hhs.nl>,
       "Samuel Ortiz" <samuel@sortiz.org>, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org, "David Hubbard" <david.c.hubbard@gmail.com>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [RFC] (almost) booting allyesconfig -- please don't poke super-io without request_region
Date: Mon, 14 Jul 2008 12:09:03 -0500
To: Jean Delvare <khali@linux-fr.org>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 14, 2008, at 2:59 AM, Jean Delvare wrote:
> On Sun, 13 Jul 2008 15:26:56 -0600, David Hubbard wrote:
>> Hi Hans,
>>
>>>> I propose writing a subsystem driver. (Is that properly called "The
>>>> SuperIO Bus Driver"?) If no one thinks it's a really bad idea I will
>>>> put together some code and submit it for review, and maintain it.
>>>>
>>>> Some hwmon chips have odd / unique probe sequences. IMHO this is 
>>>> where
>>>> the design needs to be inspected. One of those is the w83627ehf, 
>>>> which
>>>> Jean and Hans are familiar enough with to check my work.
>>>>
>>>> Thoughts?
>>>
>>> I'm afraid that making this a "bus" will be a bit overkill. Jim's 
>>> patches
>>> are quite simple and seem todo the job.
>>>
>>> Also keep in mind that most users will be platform devices which 
>>> just want
>>> to use the superio registers to find out the baseaddress of their 
>>> logical
>>> device, a whole bus seems overkill for this, would the hwmon driver 
>>> then
>>> need to be a superio_driver (as well as an platform_driver) or can 
>>> the bus
>>> be queried / used
>>> without having to be a bustype-driver?
>>
>> I think that's a valid point. I am willing to keep it small, but I
>> would prefer to follow the pattern set in other subsystems. It may be
>> my lack of experience in designing a subsystem showing here! What are
>> some alternative ways to implement it?
>>
>> In other words, Jim's patches are a good start, but maybe I am
>> misunderstanding them. I see it as the superio-locks module, a driver
>> that other drivers would depend on / auto-load. Is that something
>> other subsystems also do?
>
> Well, there are two approaches to the problem. The first approach
> (which I think Jim took in his patches? I don't really remember) is to
> simply solve the problem of concurrent I/O access to the Super-I/O
> configuration ports (typically 0x2e/0x2f or 0x4e/0x4f). That would be a
> simple driver requesting the ports in question and exporting an API for
> other drivers to access them in a safe way.
>
> The second approach is to make it a whole subsystem, as David is
> suggesting. The Super-I/O driver would then not only request the I/O
> ports, it would also identify which Super-I/O is there, and it would
> create devices (in the Linux device driver model sense of the term) for
> every logical device we are interested in (amongst which the hwmon
> ones.) The hwmon drivers would have to be converted from platform
> drivers to superio drivers.
>
> Each approach has its advantages. The first one is rather simple and
> also very generic in nature. It could be reused for other purposes. The
> second one offers automatic loading of hwmon drivers, which would be
> nice to have.
>
> There's probably a middle way which would keep the simplicity of the
> first approach while still allowing for driver auto-loading, without
> changing the bus type of all drivers. It would probably take some
> research though.

I haven't done the research, but it might be keep superio as
a platform driver, and keep the clients as platform drivers.  Only
have the superio driver probe and discover the subcomponent
addresses and then create the platform devices as children
instead of having each driver create its own platform device.
(This all assumes they are all platform devices in sysfs, I have
not looked).

This is all because in the platform bus the bus driver does not
discover the addresses but relies on drivers or platform setup code.

> Me, I don't really care which path we choose, given that I am not the
> one who will take care of it. All I have to say is that this has been
> discussed several times over the past 2 years and nothing came out of
> it (as far as the mainline kernel is concerned, at least) so whatever
> is done now, what really matters is that it makes it into the kernel
> quickly. We have some drivers missing features because of this (for
> example real-time reading of VID pin values.)
>
> This should also not prevent us from fixing the drivers now so that
> they temporarily request the Super-I/O ports they are using, as Milton
> suggested. Not only we don't know when we will have something better to
> offer, but it might also help us find conflicts between drivers, so
> that we know which drivers should make use of the future superio
> driver. This could also reveal conflicts with PNP BIOS reservations,
> etc. Milton, will you write a patch?

Well, that is the second time you asked me, so I guess I should respond.

While I it is possible for me to write this patch, my schedule and
priority list predict it would not be before the merge window closes.  
In
fact, I'm not sure when it would come out.   It might be argued it could
go in early -rc, but I would fear somebody's chip will not be detected
with the additional check.  For example, the port may reserved as mother
board resources or something.  Also, I have no hardware to test any
proposed patch, so it would be compile check only.

milton

