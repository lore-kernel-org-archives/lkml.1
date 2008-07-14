Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYGNRXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYGNRXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYGNRW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:22:57 -0400
Received: from smtp2.versatel.nl ([62.58.50.89]:44062 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYGNRW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:22:56 -0400
Message-ID: <487B8D2C.1090208@hhs.nl>
Date: Mon, 14 Jul 2008 19:30:20 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Jean Delvare <khali@linux-fr.org>, Samuel Ortiz <samuel@sortiz.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [lm-sensors] [RFC] (almost) booting allyesconfig -- please	don't
 poke super-io without request_region
References: <for-27-patch1-0@bga.com> <48768018.2070704@hhs.nl>	<acca8e14e769b2feadee19f1f7448438@bga.com>	<20080711085246.1ead773b@hyperion.delvare>	<48770B5E.7000308@hhs.nl>	<20080711093650.4b98e3b7@hyperion.delvare>	<4879A144.8060203@hhs.nl>	<4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>	<487A7211.7030309@hhs.nl>	<4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>	<20080714095914.0644ac5d@hyperion.delvare> <88f5162604470179b3c6ebfe729a46f5@bga.com>
In-Reply-To: <88f5162604470179b3c6ebfe729a46f5@bga.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller wrote:
> On Jul 14, 2008, at 2:59 AM, Jean Delvare wrote:
>> On Sun, 13 Jul 2008 15:26:56 -0600, David Hubbard wrote:
>>> Hi Hans,
>>>
>>>>> I propose writing a subsystem driver. (Is that properly called "The
>>>>> SuperIO Bus Driver"?) If no one thinks it's a really bad idea I will
>>>>> put together some code and submit it for review, and maintain it.
>>>>>
>>>>> Some hwmon chips have odd / unique probe sequences. IMHO this is 
>>>>> where
>>>>> the design needs to be inspected. One of those is the w83627ehf, 
>>>>> which
>>>>> Jean and Hans are familiar enough with to check my work.
>>>>>
>>>>> Thoughts?
>>>> I'm afraid that making this a "bus" will be a bit overkill. Jim's 
>>>> patches
>>>> are quite simple and seem todo the job.
>>>>
>>>> Also keep in mind that most users will be platform devices which 
>>>> just want
>>>> to use the superio registers to find out the baseaddress of their 
>>>> logical
>>>> device, a whole bus seems overkill for this, would the hwmon driver 
>>>> then
>>>> need to be a superio_driver (as well as an platform_driver) or can 
>>>> the bus
>>>> be queried / used
>>>> without having to be a bustype-driver?
>>> I think that's a valid point. I am willing to keep it small, but I
>>> would prefer to follow the pattern set in other subsystems. It may be
>>> my lack of experience in designing a subsystem showing here! What are
>>> some alternative ways to implement it?
>>>
>>> In other words, Jim's patches are a good start, but maybe I am
>>> misunderstanding them. I see it as the superio-locks module, a driver
>>> that other drivers would depend on / auto-load. Is that something
>>> other subsystems also do?
>> Well, there are two approaches to the problem. The first approach
>> (which I think Jim took in his patches? I don't really remember) is to
>> simply solve the problem of concurrent I/O access to the Super-I/O
>> configuration ports (typically 0x2e/0x2f or 0x4e/0x4f). That would be a
>> simple driver requesting the ports in question and exporting an API for
>> other drivers to access them in a safe way.
>>
>> The second approach is to make it a whole subsystem, as David is
>> suggesting. The Super-I/O driver would then not only request the I/O
>> ports, it would also identify which Super-I/O is there, and it would
>> create devices (in the Linux device driver model sense of the term) for
>> every logical device we are interested in (amongst which the hwmon
>> ones.) The hwmon drivers would have to be converted from platform
>> drivers to superio drivers.
>>
>> Each approach has its advantages. The first one is rather simple and
>> also very generic in nature. It could be reused for other purposes. The
>> second one offers automatic loading of hwmon drivers, which would be
>> nice to have.
>>
>> There's probably a middle way which would keep the simplicity of the
>> first approach while still allowing for driver auto-loading, without
>> changing the bus type of all drivers. It would probably take some
>> research though.
> 
> I haven't done the research, but it might be keep superio as
> a platform driver, and keep the clients as platform drivers.  Only
> have the superio driver probe and discover the subcomponent
> addresses and then create the platform devices as children
> instead of having each driver create its own platform device.
> (This all assumes they are all platform devices in sysfs, I have
> not looked).
> 
> This is all because in the platform bus the bus driver does not
> discover the addresses but relies on drivers or platform setup code.
> 

This sounds like a good plan, rather then add a new bus type add a superio 
platform driver which does superio probing and registering of platform devices 
for discovered logical devices.

This superio platform driver then needs to also export some functions of those 
few logical devices which need access to the superio registers for more then 
just finding out their own base address.

I guess that it then would be best to load this superio driver by default on 
most systems.

How does this all mix and match with isapnp, it feels to me we're doing 
somewhat the same as isapnp here.

Regards,

Hans
