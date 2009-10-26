Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZJZPCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZJZPCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZJZPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:02:07 -0400
Received: from mx04.lb01.inode.at ([62.99.145.4]:35598 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462AbZJZPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:02:05 -0400
Message-ID: <4AE5B9E7.3070500@sbg.ac.at>
Date: Mon, 26 Oct 2009 16:01:59 +0100
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20091020)
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Tejun Heo <tj@kernel.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200910211038.47653.jdelvare@suse.de> <4ADEDBFD.6030305@sbg.ac.at> <200910211328.38315.jdelvare@suse.de>
In-Reply-To: <200910211328.38315.jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Le mercredi 21 octobre 2009, Alexander Huemer a écrit :
>   
>> Jean Delvare wrote:
>>     
>>> OK, here I am, sorry for the delay. I've read the discussion thread.
>>> Here are the few data points I can offer, in the hope it will help:
>>>
>>> * While the i2c-i801 driver received some changes in kernel 2.6.30,
>>>   none of these are related to PCI nor interrupts. So as the problem
>>>   is new in kernel 2.6.30, the i2c-i801 driver alone is unlikely to
>>>   cause it. This may, however, be a combination of something i2c-i801
>>>   does and something the pci subsystem does since kernel 2.6.30. For
>>>   this reason, I would still recommend a bisection if the problem can
>>>   be reliably reproduced. I know it takes time, but it is always
>>>   easier to fix a bug when we know which commit introduced it.
>>>
>>> * The i2c-i801 driver does _not_ make use of interrupts. It is
>>>   poll-based (I am not exactly proud of that, but that's the way it
>>>   is.)
>>>
>>>   #define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
>>>
>>>   So I am very surprised to read that this driver would cause an IRQ
>>>   storm.
>>>
>>> * One thing the i2c-i801 driver does on the PCI device is:
>>>
>>>   err = pci_enable_device(dev);
>>>
>>>   I presume this is what causes the following message in dmesg:
>>>
>>>   i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23
>>>
>>>   Basically, even though the driver doesn't make use of interrupts,
>>>   the IRQ is still registered because this is how the hardware is
>>>   setup.
>>>
>>> As a conclusion, I suspect that 2 things may be happening: either
>>> the SMBus is triggering interrupts when told not to. The ICH6 is a
>>> bit different from all the other supported chips, I'll double check
>>>       
>
> My bad, it's an 63xxESB-based board, not ICH6. I must have been
> mixing data from a different bug.
>
>   
>>> if we may have missed something. Or, something else is triggering
>>> SMBus transactions. SMI and ACPI come to mind. If this is the case
>>> then you do not want to use i2c-i801 on this motherboard.
>>>
>>> Questions to Alexander :
>>>
>>> * Can I please see the output of "sensors" on your system?
>>> * What are the brand and model of your motherboard?
>>> * Can we get an acpidump for your system?
>>>
>>>   
>>>       
>> many thanks for your response. i appreciate that.
>> first, the data you requested:
>>
>>     sensors:        http://xx.vu/~ahuemer/sensors-ahuemer-20091021.txt
>>     acpidump:       http://xx.vu/~ahuemer/acpidump-ahuemer-20091021.txt
>>     
>
> The good news is that I can't see any access to the SMBus in the
> ACPI tables. Nothing can be said about the SMIs though, without an
> intimate knowledge of the BIOS.
>
>   
>>     motherboard:    tyan tempest i5400pw/s5397 with one intel xeon e5420.
>>
>> the output of sensors was made _without_ i801_smbus in the kernel.
>>     
>
> Then please once again with it. My whole point was to know whether
> there was any hardware monitoring chip connected to the SMBus. Your
> initial kernel configuration suggests that you have a W83793G chip
> there.
>
>   
>> i noticed that the data of w83627hf-isa-0290 is quite weird. i do not
>> have an explanation for that.
>>     
>
> I do. This happens when the manufacturer decides that the hardware
> monitoring features of the Super-I/O are insufficient for their
> needs. They add a dedicated chip for the hardware monitoring. This
> is particularly frequent on server boards from Tyan and SuperMicro.
> Ideally they would _also_ disable the feature on the Super-I/O side,
> but often then do not, so the driver still loads, but outputs
> garbage.
>
> You can see the following messages in your log:
> [    3.878703] w83627hf w83627hf.656: Enabling temp2, readings might not make sense
> [    3.881708] w83627hf w83627hf.656: Enabling temp3, readings might not make sense
> This is a good hint that this is the case (if the nonsensical data
> displayed by "sensors" wasn't enough to convince you.)
>
> So you should stop loading/including kernel module w83627hf.
>
>   
>> if a bisection is what will bring light into this, i am willing to take
>> the time.
>> so that would be a bisection between 2.6.29 and 2.6.30 ?
>> a quicker test case would be good for that, but i don't have one yet,
>> just the compilation of gcc, which takes time, even on this machine with
>> tmpfs and ccache.
>>     
>
>   
here is the output you requested:
http://xx.vu/~ahuemer/sensors_ahuemer_with_i801_20091026.txt
i am currently in the middle of a bisection between 2.6.29 and 2.6.30, 8
steps left.
many thanks for the info on hardware monitoring.
i'll report back when bisection is finished.

regards
-alex
