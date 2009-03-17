Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZCQRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZCQRZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZCQRZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:25:10 -0400
Received: from carmd-sa01.sierrawireless.com ([208.81.121.45]:34901 "EHLO
	carmd-sa01.sierrawireless.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbZCQRZI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:25:08 -0400
X-ASG-Debug-ID: 1237310704-338f01c50000-xx1T2L
X-Barracuda-URL: http://carmd-sa01.sierrawireless.com:80/cgi-bin/mark.cgi
From: Rory Filer <rfiler@SierraWireless.com>
To: Ralf Nyren <ralf@nyren.net>
CC: Greg KH <greg@kroah.com>, Stephen Clark <sclark46@earthlink.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Date: Tue, 17 Mar 2009 10:24:42 -0700
X-ASG-Orig-Subj: RE: Sierra Wireless (MC8780) HSDPA speed issue
Subject: RE: Sierra Wireless (MC8780) HSDPA speed issue
Thread-Topic: Sierra Wireless (MC8780) HSDPA speed issue
Thread-Index: AcmnH1skupNoKQq1SmekoRH6XLSVMgAACHqQ
Message-ID: <8F90F944E50427428C60E12A34A309D21C40221E0A@carmd-exchmb01.sierrawireless.local>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se>
 <20090314040322.GB3417@kroah.com>
 <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se>
 <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net>
 <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se>
 <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local>
 <20090316043359.GA24632@kroah.com>
 <alpine.DEB.1.10.0903161324440.32709@fujje.iml.umu.se>
 <8F90F944E50427428C60E12A34A309D21C401BAB03@carmd-exchmb01.sierrawireless.local>
 <alpine.DEB.1.10.0903171642030.10762@fujje.iml.umu.se>
 <8F90F944E50427428C60E12A34A309D21C40221D59@carmd-exchmb01.sierrawireless.local>
 <alpine.DEB.1.10.0903171725560.10762@fujje.iml.umu.se>
In-Reply-To: <alpine.DEB.1.10.0903171725560.10762@fujje.iml.umu.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[10.0.6.5]
X-Barracuda-Start-Time: 1237310705
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-Virus-Scanned: by CARMD-SA01 at sierrawireless.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf

Yes, that's exactly what I was looking for. Thanks. I should have asked this question in the first place, but we have two flavours of modem now, one which requires a non-composite USB driver and one which requires a composite one. Until this morning I have been thinking your modem is the composite version and there's a big difference in the underlying USB hardware which I will try to explain below.  

The modem uses a MUXing protocol when Windows is in charge and all the traffic between it and the modem is carried over the USB interface which shows up in Linux on /dev/ttyUSB0; (Note: if you have any other USB serial-type devices, then the port numbers in this email could be wrong, I'm assuming the Sierra modem is the only such device connected to your computer in this email). The other two interfaces are not used when the modem is running on a Windows machine. On Linux the muxing protocol is not being used and so all data exchange (of various types) happens over all the available USB interfaces. By far the most efficient interface is the one that shows up on /dev/ttyUSB0 and you will get the best throughput if you use that interface. 

Since PPP needs to issue an AT command as part of its procedure for establishing a data connection, the interface used for data exchange has a simple-minded AT command parser on it. This interface recognizes a few AT commands and the ones I know of are ATI and ATD*99#. The data port's ATI command provides less information than the one on the real AT command port, which matches your findings below. Your data port is /dev/ttyUSB0. These days data requires much higher throughput than AT commands, and your real AT command port lives on /dev/ttyUSB2. Note that the real AT command port will also establish a dialup connection with the network, but its USB interface is a bottleneck, as you have discovered.

You should definitely be able to open a minicom session on /dev/ttyUSB2 while you have an active data connection on /dev/ttyUSB0. Your note that the modem immediately hangs up when you try it sounds like a bug to me. You should be able to issue any AT command at any time, regardless of what your data port is doing. I'm on vacation this week, but I'll look into whether this is a known problem on your modem and f/w version when I return.

As a final note, our newer products provide 7 USB interfaces and all interfaces are just as efficient, so there is no need to worry about which one to map the data ports to. Just so our readers know, the data ports are on /dev/ttyUSB4, 5 and 6 on these products. The AT port is on /dev/ttyUSB3. The data ports have the same dumb AT parser as the 3-port devices, but on some carriers' networks and plans you can establish multiple dialup sessions, one on each of the ports, but YMMV. 

Regards, 

Rory


-----Original Message-----
From: Ralf Nyren [mailto:ralf@nyren.net] 
Sent: Tuesday, March 17, 2009 9:38 AM
To: Rory Filer
Cc: Greg KH; Stephen Clark; linux-kernel@vger.kernel.org; Kevin Lloyd
Subject: RE: Sierra Wireless (MC8780) HSDPA speed issue

Hi,

Three devices appear, ttyUSB0, ttyUSB1, ttyUSB2.

Response from ATI command is as follows:

ttyUSB0:  (this is the device providing high speed connection)
Sierra Wireless, Inc. 
MC8780 
APP1

ttyUSB1: no response here, I understand this device is for the proprietary
protocol...

ttyUSB2:  (this is the device with the speed "problem")
Manufacturer: Sierra Wireless, Inc.
Model: MC8780
Revision: F1_0_0_10AP C:/WS/FW/F1_0_0_10AP/MSM7200R3/SRC/AMSS 2007/11/08 10:51:15
IMEI: 354219010190864
IMEI SV: 7
FSN: D332567166610
3GPP Release 6
+GCAP: +CGSM,+DS,+ES

>From my experience there are very few commands which gives any output at all on
ttyUSB0.  AT+CSQ and AT+COPS? gives output on ttyUSB0 but commands like
AT*CNTI=0 only give output on ttyUSB2.

Hope that's the information you're looking for.

Best regards, Ralf

On Tue, 17 Mar 2009, Rory Filer wrote:

> Hi Ralf,
>
> I wonder whether you could do a little experiment for me. Issue the following AT command to both ports you've identified:
>
> ATI
>
> And note which of the AT ports provides the most information. They will both respond, but one will be more verbose than the others.
>
> Another thing of interest is to record how many files appear in response to the following command:
>
> ls /dev/ttyU*
>
> when the modem is running, of course.
>
> Question - at what point should we stop including linux-kernel in this thread, if at all?
>
> Regards
>
> Rory
>
> -----Original Message-----
> From: Ralf Nyren [mailto:ralf@nyren.net]
> Sent: Tuesday, March 17, 2009 8:54 AM
> To: Rory Filer
> Cc: Greg KH; Stephen Clark; linux-kernel@vger.kernel.org; Kevin Lloyd
> Subject: RE: Sierra Wireless (MC8780) HSDPA speed issue
>
> Hi again,
>
> Problem solved this time, well sort of anyway.
>
> This is a bit embarrassing, was quite sure I had tested this before but oh well...
>
> According to the FAQ at sierrawireless.com you should make the data connection
> on /dev/ttyUSB2 when using a MC8780 modem, /dev/ttyUSB0 is used for AT commands
> queries. This works nicely except for the speed problem. Now _changing_ so the
> data connection is established on /dev/ttyUSB0 instead solves the speed
> problem. I have successfully reached average download speeds above 400KB/s.
>
> Just to make sure I tried this fix using both 1.3.2 and 1.6.0 driver. I also
> tried the modified ppp_async.c with OBUFSIZE=4096. The cell appeared to be
> rather busy during the tests but as far as I can see both drivers and OBUFSIZE
> gave about the same speed, i.e. 300-400KB/s at my current location. No issue
> with the kernel that is.
>
> My only remaining problem is that I can't issue commands like AT+CSQ, AT+COPS?
> to determine signal strength and ISP while the connection is up and running.
> Any AT command sent to /dev/ttyUSB2 while pppd runs on /dev/ttyUSB0 causes an
> immediate modem hangup. Not a big issue but it would be nice if it worked.
>
> The card is a builtin card in the laptop and all tests reported so far have
> been performed with the same machine. Have a dual boot setup with Debian Lenny
> and Windows XP. Firmware on the MC8780 card is reported as follows:
>
> AT+GMR
> F1_0_0_10AP C:/WS/FW/F1_0_0_10AP/MSM7200R3/SRC/AMSS 2007/11/08 10:51:15
> OK
>
> If you think this problem could affect others as well an update to the table on
> the FAQ page would be nice:
>  http://www.sierrawireless.com/faq/ShowFAQ.aspx?ID=607
>
> Thanks for all valuable help and support. Just let me know if you need someone
> to test future firmware/driver updates.
>
> Best regards, Ralf
>
>
> On Mon, 16 Mar 2009, Rory Filer wrote:
>
>> Hi Ralf,
>>
>> Actually the Windows and Linux models are the same from the modem's point of view, but the PPP client is inside the NDIS driver.
>>
>> I've pasted in the response from our UMTS engineer below, but I'm not sure how much help it will be; here it is:
>>
>> -----Begin Included...
>> There is no specific AT command that would limit the data rate on the device - except for AT!HSDCAT but I do not think that he would be using this. Other commands such as AT+CGEQREQ probably would not help, so they should clear them.
>>
>> From the email below it seems that he used the same device on Windows so the device configuration should be OK. The location could be an issue but I would assume that he tried using the device with Windows at the same location.
>>
>> One problem that I have seen with USB is that the USB modem throughput will be low if there are other devices on the same USB hub of the laptop
>> ----End Included
>>
>> There it is. If you could get your hands on another machine and put Linux on it - or maybe temporarily make your windows machine into Dual Boot with Ubuntu (using wubi) and see how that compares that might help, but I am out of useful ideas at this point.
>>
>> Regards
>>
>> Rory
>>
>>
>>
>> -----Original Message-----
>> From: Ralf Nyren [mailto:ralf@nyren.net]
>> Sent: Monday, March 16, 2009 5:48 AM
>> To: Greg KH
>> Cc: Rory Filer; Stephen Clark; linux-kernel@vger.kernel.org; Kevin Lloyd
>> Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
>>
>> Thanks Rory,
>>
>> I have tried changing OBUFSIZE in ppp_async.c (still kernel 2.6.28.7), first
>> 512 and then 4096. However the speed "limit" of about 100KB/s remains the same.
>> So perhaps there's some setup/firmware issue with the hardware. If I understand
>> things correctly the Windows driver uses a proprietary protocol to init the card
>> while in Linux you use the AT command interface. Could be something there which
>> makes a difference I guess.
>>
>> Best regards, Ralf
>>
>> On Sun, 15 Mar 2009, Greg KH wrote:
>>
>>> On Sun, Mar 15, 2009 at 03:30:54PM -0700, Rory Filer wrote:
>>>> Hi Ralf
>>>>
>>>> Using the driver we sent you on a call-box (i.e. with a "perfect"
>>>> simulated network connection) on Ubuntu 8.04 we were seeing ~4 Mbps on
>>>> the downlink. So I would rule out any problem with the driver and
>>>> conclude it must be something in either PPP/Linux or in the modem. In
>>>> order to rule out the modem, I've got a question into one of our UMTS
>>>> engineers and will send you a reply when we get the answer.
>>>>
>>>> We did play around a little with 2.4 kernels of Linux and discovered
>>>> there is a buffer in PPP_ASYNC.C which, when its size is increased,
>>>> doubled the throughput. If you are savvy enough with Linux, you might
>>>> want to try playing with that. We stopped short of any thorough
>>>> testing of changing this array size, but were pleased with the result.
>>>> If I recall properly, the size of this array is (was, in 2.4) 256
>>>> bytes. Doubling it gave an immediate improvement. We were guessing
>>>> that the small size of this buffer was fine in the "old days" when
>>>> modems peaked at ~56 kbps. Even 8 years ago that was the fastest you
>>>> could go with a GPRS product, now our new HSPA+ products yields 21
>>>> Mbps on Telstra's network! Quite a difference.
>>>
>>> Ah, the OBUFSIZE #define in drivers/net/ppp_async.c?
>>>
>>> Anyone care to bump this size up and see if that helps out?
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>>
>
>

