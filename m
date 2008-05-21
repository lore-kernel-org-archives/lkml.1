Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbYEUKEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbYEUKEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758993AbYEUKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:04:44 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:55463 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYEUKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:04:43 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4833F3B6.6020806@gmail.com>
Date: Wed, 21 May 2008 11:04:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare> <20080520214005.GH3220@local>
In-Reply-To: <20080520214005.GH3220@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans and Jean, 

Thanks for your responses.
> On Tue, May 20, 2008 at 01:28:17PM +0200, Jean Delvare wrote:
>   
>> Hi Jonathan,
>>
>> On Tue, 20 May 2008 11:04:01 +0100, Jonathan Cameron wrote:
>>     
>>> This email is basically a request for opinions on how and where such sensors
>>> should be integrated into the kernel.
>>>
>>> To set the scene...
>>>
>>> Increasing numbers of embedded devices are being supplied attached MEMS
>>> devices (www.xbow.com imote2 etc). Along with more traditional sensors such
>>> as ADC's not being used for hardware monitoring, these do not really 
>>> seem to
>>> fit with in an particular subsystem of the kernel.  A previous 
>>> discussion on
>>> lkml in 2006 considered the accelerometers to be found within some laptop
>>> hard drives, but I haven't been able to track down any more general 
>>> discussions
>>> of such non hardware monitoring sensors.
>>>
>>> The obvious possibilities are:
>>>
>>> * To place the various drivers within the spi / i2c etc subsystems as 
>>> relevant.
>>>       
>> Bad idea. Grouping drivers by connectivity is almost always the wrong
>> thing to do, as it means that different persons will maintain them and
>> they have all chances to diverge. You really want to group drivers by
>> functionality. On top of that, I am busy enough maintaining the i2c
>> core and bus drivers without having more i2c device drivers added to my
>> plate. These days I am trying to _empty_ drivers/i2c/chips, if anything.
>>     
I can certainly see your point there. 
>
> 100% ACK. And the functionality here is something like "industrial
> control" or "automation I/O".
Hmm.. Going to be interesting coming up with a name!   Guess that can 
come at a
later stage anyway.
>  If this sort of hardware appears as device
> with mappable memory, we can handle it with UIO, but for SPI, I2C, USB,
> serial, we should have a new subsystem. It should handle not only input,
> but also similar output devices. It doesn't make sense to have ADCs in
> one subsystem, and DACs in a different one.
>   
Definitely agreed that it makes sense to put DACs and ADCs in the same 
general place
and obviously there are plenty of devices out there that do both.
>>> * To place within the hwmon subsystem as this is probably closest.
>>> (there is already at least one straight ADC driver in hwmon)
>>>       
>> Probably not the wisest choice, if nothing else, because the hwmon
>> maintainer is already overloaded. And I don't think that these devices
>> have much in common with the traditional hardware monitoring components
>> anyway.
>>     
>
> Agreed, hwmon devices are not really tuned for maximum performance, for
> example. Performance is often critical in automation control
> applications.
>   
It would indeed by stretching the point to make drivers in that 
subsystem have more performance
critical drivers!  We seem to have a consensus that neither hwmon or 
i2c/chips is good idea.
>> I'm not sure what "straight ADC driver" you are referring to, but
>> anything which measures a voltage and exports the reading to user-space
>> is, well, a voltage sensor, and thus fix within hwmon. If the same chip
>> is used for a higher-level, dedicated function then we would probably
>> have a separate driver for it, outside of hwmon.
>>
>>     
>>> * To create a new subsystem, or perhaps merely sysfs class to contain these
>>>   elements.
>>>       
>> Would be OK.
>>     
> Definitely.
>
>   
>> Or:
>>
>> * Place these within the input subsystem. You might want to discuss
>> this with the input subsystem maintainer Dmitry Torokhov (Cc'd). The
>> Wii remote is essentially a joystick, and joysticks belong to the input
>> subsystem.
>>     
>
> This might apply to some devices, but not all. And the requirements are
> quite different, I think.
>   
Although I don't know much about the input subsystem it doesn't seem 
likely that all the devices
we are considering would share all that much functionality with the 
devices in there, particularly if
as you have suggested, we include DACs.  
>> This all sounds quite different from our hwmon drivers. Our hwmon
>> drivers read all the sensor values at once and cache the readings for a
>> couple seconds, so you can't get an instant reading at any time, and
>> they also don't support interrupts in general.
>>     
>
> Exactly.
>   
Ok, so the consensus so far is we are looking at a new subsystem.  Will 
give this a few more days
on the lists, then if the consensus is still heading that way, I'll have 
a think about exact functionality
this would need.  I guess it would be something that would probably 
evolve for some time, centered
around an initial half dozen or so drivers.

Thanks for all your comments,

--
Jonathan Cameron

