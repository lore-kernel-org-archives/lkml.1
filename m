Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0BQKtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:49:04 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:57198 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0BQKtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:49:00 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B7BCA08.60609@cam.ac.uk>
Date: Wed, 17 Feb 2010 10:50:48 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Greg KH <gregkh@suse.de>, Mike Frysinger <vapier.adi@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>, Jean Delvare <khali@linux-fr.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>,
       Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC] Staging: IIO: New ABI V2
References: <4B6C619C.3000302@cam.ac.uk> <20100216024924.GA29008@suse.de> <4B7A7B8F.9080501@cam.ac.uk> <201002161418.28097.rgetz@blackfin.uclinux.org>
In-Reply-To: <201002161418.28097.rgetz@blackfin.uclinux.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/10 19:18, Robin Getz wrote:
> On Tue 16 Feb 2010 06:03, Jonathan Cameron pondered:
>> On 02/16/10 02:49, Greg KH wrote:
>>> On Mon, Feb 15, 2010 at 07:58:12PM -0500, Mike Frysinger wrote:
>>>> On Mon, Feb 15, 2010 at 15:26, Robin Getz wrote:
>>>>> [snip]
>>>>> What exists today still requires a copy_[to|from]_user when using
>>>>> the ring buffer (and then another cache_flush if you are dma'ing
>>>>> things). These seems pretty expensive and will consume extra cycles
>>>>> that will limit throughput. 
>>>>>
>>>>> Any thoughts to a mmaped interface directly to the IIO ring buffer, 
>>>>> so the system could avoid some of the above overhead? (This is what
>>>>> we had to do for some other drivers - which were able to handle a 40
>>>>> MSample/second data processed by userspace for a soft radio).
>>>>
>>>> does sysfs currently support mmap-ing of files in there ?
>>>
>>> For binary files, yes.  If you are going to use mmap, use a character
>>> device node instead please, that's not what sysfs is for.
>> All the buffer access is done via character device nodes anyway.
>>
>> For anyone entering the discussion at this point:
>> Only really simple IIO drivers (for typically very slow devices)
>> are principally accessed through sysfs.  For these fast devices we
>> probably wouldn't provide that route at all, merely using sysfs to
>> describe the parameters of the device and buffer being used.
> 
> Can we be a little more specific - what in your mind is "very slow"? 
> and "fast"?
> 
> Is it designated by samples per second? (and bits per sample doesn't matter?) 
> or is it the result (bits per sample * samples per second/8 == bytes/second?)
>
> Many people I know would call a 1Mega sample per second converter very slow, 
> but the kernel handling a memcpy of a continuous 2Mbyte/second (16-bits per 
> sample), stream seems a little wasteful.

I think we want to keep this fairly fuzzy.  Basically I'd envision people only
writing drivers for devices to the level they need.  A sysfs only interface
is always going to be the starting point for the majority of drivers.  If nothing
else it provides a simple means of sanity checking that the device is working
as expected. At that level the subsystem is more or less an equivalent of
hwmon and similar systems.  As such a driver is only marginally more complex
to write.

If, like I have for my apps, (and indeed you probably want to support) people
have a need for handling mid rates (fuzzily perhaps starting at a few
hundred bytes per sec) then they will probably want to use some buffering
and it the extra copy of not using mmaping won't really mater them, but if
it is there it would certainly be nice.

At the higher rates then, as you say, that memcpy is going to start to become
an issue.  Exactly where is going to be very dependent on the platform.  So
in the ideal world there will be no costs to having a mmapped buffer and we 
would simply use such a 'perfect' buffer for both the 'mid' and 'high' rate devices.
Until we have an implementation I'm not sure what issues it will result in.

Obviously there will always be IIO buffers where mmapping isn't possible,
(hardware buffers via a serial bus for example), but I'd love to see support
where we can.  I think the trick to this might be to push forward breaking the
current hard connections between particular drivers and a given buffer
implementation to give us the flexibility to play with different options.

Frankly if we can get the functionality of my highly dubious ring implementation
with mmaping and a cleaner implementation it would be a great advancement.
That is to say if we can have a buffering structure with minimal (ideally no)
locking, that is scalable to radically different sizes (as appropriate for the
range of data rates we are dealing with) and supports notification (without polling)
of buffer thresholds being passed then I will be a very happy bunny indeed.
The events stuff may not be relevant to all applications and this might make life
easier for a high performance buffer, but then we would definitely need to maintain
a version with this capability for cases like extremely variable rate triggering.

On a similar note, we also ideally need to have a buffer implementation that allows
for direct dma transfers into the buffer so as to cut down on the copies currently
present there.  I was interested to see the recent proposals to add this functionality
to kfifo.  This will be complex to implement for some devices where there are annoying
things like status bytes kicking around, but that can be a problem for the individual
drivers (and appropriate interactions with the underlying buses).

(kfifo reference: http://lkml.org/lkml/2010/1/27/139 )

So in conclusion. Lets deliberately keep things vague! 

Jonathan
