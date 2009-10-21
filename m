Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZJUKBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZJUKBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 06:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZJUKBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 06:01:38 -0400
Received: from mx08.lb01.inode.at ([62.99.145.8]:37787 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751896AbZJUKBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 06:01:37 -0400
Message-ID: <4ADEDBFD.6030305@sbg.ac.at>
Date: Wed, 21 Oct 2009 12:01:33 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20090826)
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Tejun Heo <tj@kernel.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <4AD422F2.4080308@sbg.ac.at> <4AD473F9.7090606@kernel.org> <200910211038.47653.jdelvare@suse.de>
In-Reply-To: <200910211038.47653.jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Tejun, Alexander,
>
> Le mardi 13 octobre 2009, Tejun Heo a écrit :
>   
>> Alexander Huemer wrote:
>>     
>>> i compiled gcc in a loop over night, 14 times. no error.
>>> it really seams i2c_i801 was the cause...
>>> unfortunately i still don't know how i can extract the part of the gcc
>>> compilation process that causes the error on an affected kernel.
>>> that would enable me to create a simple test program.
>>>       
>> Given that i2c is used for temperature monitoring, I think it is not
>> triggered by any single step of the compiling but rather by the
>> accumulated heat load during compilation.  Let's wait for Jean to
>> chime in.  :-)
>>     
>
> OK, here I am, sorry for the delay. I've read the discussion thread.
> Here are the few data points I can offer, in the hope it will help:
>
> * While the i2c-i801 driver received some changes in kernel 2.6.30,
>   none of these are related to PCI nor interrupts. So as the problem
>   is new in kernel 2.6.30, the i2c-i801 driver alone is unlikely to
>   cause it. This may, however, be a combination of something i2c-i801
>   does and something the pci subsystem does since kernel 2.6.30. For
>   this reason, I would still recommend a bisection if the problem can
>   be reliably reproduced. I know it takes time, but it is always
>   easier to fix a bug when we know which commit introduced it.
>
> * The i2c-i801 driver does _not_ make use of interrupts. It is
>   poll-based (I am not exactly proud of that, but that's the way it
>   is.)
>
>   #define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
>
>   So I am very surprised to read that this driver would cause an IRQ
>   storm.
>
> * One thing the i2c-i801 driver does on the PCI device is:
>
>   err = pci_enable_device(dev);
>
>   I presume this is what causes the following message in dmesg:
>
>   i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23
>
>   Basically, even though the driver doesn't make use of interrupts,
>   the IRQ is still registered because this is how the hardware is
>   setup.
>
> As a conclusion, I suspect that 2 things may be happening: either
> the SMBus is triggering interrupts when told not to. The ICH6 is a
> bit different from all the other supported chips, I'll double check
> if we may have missed something. Or, something else is triggering
> SMBus transactions. SMI and ACPI come to mind. If this is the case
> then you do not want to use i2c-i801 on this motherboard.
>
> Questions to Alexander :
>
> * Can I please see the output of "sensors" on your system?
> * What are the brand and model of your motherboard?
> * Can we get an acpidump for your system?
>
>   
many thanks for your response. i appreciate that.
first, the data you requested:

    sensors:        http://xx.vu/~ahuemer/sensors-ahuemer-20091021.txt
    acpidump:       http://xx.vu/~ahuemer/acpidump-ahuemer-20091021.txt
    motherboard:    tyan tempest i5400pw/s5397 with one intel xeon e5420.

the output of sensors was made _without_ i801_smbus in the kernel.
i noticed that the data of w83627hf-isa-0290 is quite weird. i do not
have an explanation for that.
if a bisection is what will bring light into this, i am willing to take
the time.
so that would be a bisection between 2.6.29 and 2.6.30 ?
a quicker test case would be good for that, but i don't have one yet,
just the compilation of gcc, which takes time, even on this machine with
tmpfs and ccache.


