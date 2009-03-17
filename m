Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZCQPym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZCQPym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZCQPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:54:33 -0400
Received: from kotten8a.marieberg.ac ([213.238.238.22]:41813 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752465AbZCQPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:54:32 -0400
Date: Tue, 17 Mar 2009 16:54:25 +0100 (CET)
From: Ralf Nyren <ralf@nyren.net>
X-X-Sender: plumbum@fujje.iml.umu.se
To: Rory Filer <rfiler@SierraWireless.com>
cc: Greg KH <greg@kroah.com>, Stephen Clark <sclark46@earthlink.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Subject: RE: Sierra Wireless (MC8780) HSDPA speed issue
In-Reply-To: <8F90F944E50427428C60E12A34A309D21C401BAB03@carmd-exchmb01.sierrawireless.local>
Message-ID: <alpine.DEB.1.10.0903171642030.10762@fujje.iml.umu.se>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com> <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se> <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net> <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se>
 <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local> <20090316043359.GA24632@kroah.com> <alpine.DEB.1.10.0903161324440.32709@fujje.iml.umu.se> <8F90F944E50427428C60E12A34A309D21C401BAB03@carmd-exchmb01.sierrawireless.local>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Problem solved this time, well sort of anyway.

This is a bit embarrassing, was quite sure I had tested this before but oh well...

According to the FAQ at sierrawireless.com you should make the data connection
on /dev/ttyUSB2 when using a MC8780 modem, /dev/ttyUSB0 is used for AT commands
queries. This works nicely except for the speed problem. Now _changing_ so the
data connection is established on /dev/ttyUSB0 instead solves the speed
problem. I have successfully reached average download speeds above 400KB/s.

Just to make sure I tried this fix using both 1.3.2 and 1.6.0 driver. I also
tried the modified ppp_async.c with OBUFSIZE=4096. The cell appeared to be
rather busy during the tests but as far as I can see both drivers and OBUFSIZE
gave about the same speed, i.e. 300-400KB/s at my current location. No issue
with the kernel that is.

My only remaining problem is that I can't issue commands like AT+CSQ, AT+COPS?
to determine signal strength and ISP while the connection is up and running.
Any AT command sent to /dev/ttyUSB2 while pppd runs on /dev/ttyUSB0 causes an
immediate modem hangup. Not a big issue but it would be nice if it worked.

The card is a builtin card in the laptop and all tests reported so far have
been performed with the same machine. Have a dual boot setup with Debian Lenny
and Windows XP. Firmware on the MC8780 card is reported as follows:

AT+GMR
F1_0_0_10AP C:/WS/FW/F1_0_0_10AP/MSM7200R3/SRC/AMSS 2007/11/08 10:51:15
OK

If you think this problem could affect others as well an update to the table on
the FAQ page would be nice:
  http://www.sierrawireless.com/faq/ShowFAQ.aspx?ID=607

Thanks for all valuable help and support. Just let me know if you need someone
to test future firmware/driver updates.

Best regards, Ralf


On Mon, 16 Mar 2009, Rory Filer wrote:

> Hi Ralf,
>
> Actually the Windows and Linux models are the same from the modem's point of view, but the PPP client is inside the NDIS driver.
>
> I've pasted in the response from our UMTS engineer below, but I'm not sure how much help it will be; here it is:
>
> -----Begin Included...
> There is no specific AT command that would limit the data rate on the device - except for AT!HSDCAT but I do not think that he would be using this. Other commands such as AT+CGEQREQ probably would not help, so they should clear them.
>
> From the email below it seems that he used the same device on Windows so the device configuration should be OK. The location could be an issue but I would assume that he tried using the device with Windows at the same location.
>
> One problem that I have seen with USB is that the USB modem throughput will be low if there are other devices on the same USB hub of the laptop
> ----End Included
>
> There it is. If you could get your hands on another machine and put Linux on it - or maybe temporarily make your windows machine into Dual Boot with Ubuntu (using wubi) and see how that compares that might help, but I am out of useful ideas at this point.
>
> Regards
>
> Rory
>
>
>
> -----Original Message-----
> From: Ralf Nyren [mailto:ralf@nyren.net]
> Sent: Monday, March 16, 2009 5:48 AM
> To: Greg KH
> Cc: Rory Filer; Stephen Clark; linux-kernel@vger.kernel.org; Kevin Lloyd
> Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
>
> Thanks Rory,
>
> I have tried changing OBUFSIZE in ppp_async.c (still kernel 2.6.28.7), first
> 512 and then 4096. However the speed "limit" of about 100KB/s remains the same.
> So perhaps there's some setup/firmware issue with the hardware. If I understand
> things correctly the Windows driver uses a proprietary protocol to init the card
> while in Linux you use the AT command interface. Could be something there which
> makes a difference I guess.
>
> Best regards, Ralf
>
> On Sun, 15 Mar 2009, Greg KH wrote:
>
>> On Sun, Mar 15, 2009 at 03:30:54PM -0700, Rory Filer wrote:
>>> Hi Ralf
>>>
>>> Using the driver we sent you on a call-box (i.e. with a "perfect"
>>> simulated network connection) on Ubuntu 8.04 we were seeing ~4 Mbps on
>>> the downlink. So I would rule out any problem with the driver and
>>> conclude it must be something in either PPP/Linux or in the modem. In
>>> order to rule out the modem, I've got a question into one of our UMTS
>>> engineers and will send you a reply when we get the answer.
>>>
>>> We did play around a little with 2.4 kernels of Linux and discovered
>>> there is a buffer in PPP_ASYNC.C which, when its size is increased,
>>> doubled the throughput. If you are savvy enough with Linux, you might
>>> want to try playing with that. We stopped short of any thorough
>>> testing of changing this array size, but were pleased with the result.
>>> If I recall properly, the size of this array is (was, in 2.4) 256
>>> bytes. Doubling it gave an immediate improvement. We were guessing
>>> that the small size of this buffer was fine in the "old days" when
>>> modems peaked at ~56 kbps. Even 8 years ago that was the fastest you
>>> could go with a GPRS product, now our new HSPA+ products yields 21
>>> Mbps on Telstra's network! Quite a difference.
>>
>> Ah, the OBUFSIZE #define in drivers/net/ppp_async.c?
>>
>> Anyone care to bump this size up and see if that helps out?
>>
>> thanks,
>>
>> greg k-h
>>
>
>
