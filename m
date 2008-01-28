Return-Path: <linux-kernel-owner+w=401wt.eu-S1764520AbYA1Xfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764520AbYA1Xfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYA1Xf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:35:27 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31159 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYA1XfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:35:25 -0500
Date: Mon, 28 Jan 2008 17:35:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Hot (un)plugging of a SATA drive with sata_nv (CK8S)?
In-reply-to: <20080128111953.GA833@zenon.in.qult.net>
To: Ignacy Gawedzki <lkml@qult.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Message-id: <479E66DE.3050705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PdKzY9gi8w+fleyC/mVql2UDhtc@ifi.uio.no>
 <479AA2E6.8070307@shaw.ca> <20080128111953.GA833@zenon.in.qult.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(linux-ide cc'ed)

Ignacy Gawedzki wrote:
> On Fri, Jan 25, 2008 at 09:03:02PM -0600, thus spake Robert Hancock:
>> Ignacy Gawedzki wrote:
>>> Hi everyone,
>>> I'm having trouble to determine the cause of the following behavior.  I'm 
>>> not
>>> even sure that I'm supposed to hot plug and unplug a SATA drive from a 
>>> nForce3
>>> Ultra (apparently CK8S, on a Gigabyte K8NS Ultra 939 mobo) SATA interface, 
>>> to
>>> begin with.  The information is hard to find given that the sata_nv driver
>>> supports a range of different hardware.
>>> I've recently acquired an external drive with (among others) an eSATA
>>> interface, so I also bought a eSATA->SATA bracket and intend to use that 
>>> drive
>>> (Lacie d2 quadra 500G) through eSATA.
>> BTW, eSATA cannot technically be converted properly to SATA with a simple 
>> connector adapter. eSATA is supposed to use higher signalling voltages and 
>> so using such an adapter is not guaranteed to work.
> 
> Yeah, apparently this shortens the max cable length to 1 meter.  In this case
> I've got a 1 meter external cable and approx. 30 cm internal (heavily shielded
> though) cable from the bracket to the SATA port.  Anyway, the drive works
> perfectly if plugged at boot time.
> 
>>> The thing is that if I boot the machine with the drive plugged and turned 
>>> on,
>>> it is properly detected and usable.  If, at some point, I want to remove 
>>> the
>>> drive, I unmount any partitions on it and issue the proper scsiadd -r 
>>> command
>>> (usually scsiadd -r 1 0 0 0, since this is the second SATA drive) and
>>> everything is fine (I turn the drive off and unplug it), so far.  Next, 
>>> when
>>> I want to use the drive again, it's still detected alright (although 
>>> appears
>>> as sdc and not sdb anymore), but the SCSI layer issues "scsi 1:0:0:0:
>>> rejecting I/O to dead device" from time to time.  Then any scsiadd -r 1 0 
>>> 0 0
>>> command fails with "No such device or address", although it appears in the
>>> output of scsiadd -p or even scsiadd -s (always as 1 0 0 0).  If I ignore 
>>> that
>>> detail and switch the drive off, then the kernel eventually notices that 
>>> the
>>> drive is gone and the SCSI layer attempts to stop the device and fails 
>>> ([sdc]
>>> START_STOP FAILED).  From that moment on, any attempt to plug the drive 
>>> again
>>> fails.  The kernel issues "ata2: hard resetting port" and "ata2: port is 
>>> slow
>>> to respond, please be patient (Status 0x80)" periodically, until I switch 
>>> the
>>> drive off.
>>> If the drive is not present at boot, then hot plugging it fails.  The 
>>> kernel
>>> first soft resets the port, then issues the "please be patient (Status 
>>> 0x80)"
>>> message, complains that SRST failed (errno=-16) and goes on hard resetting 
>>> the
>>> port, issuing "please be patient (Status 0x80)" and complaining that 
>>> COMRESET
>>> failed (errno=-16), periodically, until the drive is switched off.
>> Full dmesg output would be useful..
> 
> I repeated the experiments and dumped as much dmesg as I could.
> 
> The dmesg outputs of both experiments are attached and commented.  It seems
> that in the case the drive is pluggin at boot time, it remains hot pluggable
> later (be it with some strange error messages) after all (or is there another
> factor that I did not reproduce?).
> 
> Thank you for any help. =)
> 
> 

So it seems that unplug/plug works fine if the drive was plugged in at 
boot, but if it wasn't plugged in on boot it doesn't work when plugged 
in afterwards. That suggests maybe there is some initialization that the 
BIOS is doing when the drive is plugged in on boot which we're not doing 
when one's plugged in afterwards. Unfortunately the lack of public 
documentation on the NVIDIA SATA hardware makes it difficult to tell 
whether this is the case..

Any ideas guys? When the drive is plugged in, a stream of this shows up. 
It would seem like the controller is throwing hotplug interrupts but we 
never seem to get a "SATA link up". This is on nForce3, btw.

ata2: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH complete
ata2: exception Emask 0x10 SAct 0x0 SErr 0x1d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: SRST failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=4)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=3)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)
ata2: limiting SATA link speed to 1.5 Gbps
ata2: hard resetting port
ata2: COMRESET failed (errno=-16)
ata2: reset failed, giving up
ata2: EH pending after completion, repeating EH (cnt=2)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x19d0000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: COMRESET failed (errno=-16)

etc.
