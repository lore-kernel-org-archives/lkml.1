Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZJNF1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZJNF1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 01:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZJNF1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 01:27:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49778 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZJNF1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 01:27:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AD5611F.6010907@jp.fujitsu.com>
Date: Wed, 14 Oct 2009 14:26:55 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
References: <20091012120620.GG9228@kernel.dk> <4AD3F1D4.1000006@jp.fujitsu.com> <20091013083152.GR9228@kernel.dk> <4AD45B1B.8000609@jp.fujitsu.com> <20091013112525.GX9228@kernel.dk>
In-Reply-To: <20091013112525.GX9228@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>> Jens Axboe wrote:
>>> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>>>> Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> I'm trying to get pci-express hotplug working in a box here. I don't
>>>>> really care about the hotplug aspect, I just want the darn pci-e slots
>>>>> that are designated hotplug slots to actually WORK. When I load pciehp,
>>>>> I get:
>>>>>
>>>>> Firmware did not grant requested _OSC control
>>>>> Firmware did not grant requested _OSC control
>>>>> Firmware did not grant requested _OSC control
>>>>> Firmware did not grant requested _OSC control
>>>>> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
>>>>> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
>>>>> Firmware did not grant requested _OSC control
>>>>> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>>> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
>>>>> Firmware did not grant requested _OSC control
>>>>> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>>> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
>>>>> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
>>>>> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
>>>>> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>>>>
>>>>> and the devices in the hotplug slots stay off. Is this an ACPI/bios
>>>>> issue? How can I debug this?
>>>>>
>>>> Could you give me the result of "ls -lR /sys/bus/pci/slots/"
>>>> after loading pciehp?
>>> I have attached the result of that ls prior to loading pciehp/acpiphp
>>> (pre-load), after loading pciehp (pciehp-load), and with acpiphp loaded
>>> only as well (acpiphp-load).
>>>
>> Thank you for the info. From the information, I confirmed that hotplug
>> slots are detected by pciehp even though _OSC evaluation failed. There
>> are two ways to take control from the firmware through ACPI control
>> method. One is _OSC control method, and the other is OSHP control method.
>> I guess your ACPI fimware has both _OSC and OSHP on DSDT (ACPI Namespace),
>> and pciehp assumes that it took control through OSHP after the _OSC
>> evaluation failure. I think this pciehp's behavior is wrong because of
>> the following reasons and I think pciehp driver mis-detected the hotplug
>> slots on your environment because of this.
>>
>> - According to the PCI firmware specification, pciehp driver must use the
>>  result of _OSC, if the platform implements both _OSC and OSHP.
>> - OSHP control method seems only for SHPC, not for PCI Express native hot-
>>  plug. So pciehp must not evaluate OSHP to take control from firmware.
>>
>> To confirm this, could you send me the dmesg output after loading pciehp
>> with 'debug_acpi' of pci_hotplug (PCI hotplug core driver) enabled?
>> For example,
>>
>>    $ su
>>    # echo Y > /sys/module/pci_hotplug/parameters/debug_acpi
>>    # modprobe pciehp
>>    # dmesg
> 
> See below.
> 
>> And if it is possible, could you send me DSDT of your platform?
> 
> Not sure I can do that, I'll check.
> 
>> Anyway, my recommendation is using acpiphp on your environment because
>> your firmware didn't grant control over hotplug control through _OSC.
>> From the information, acpiphp also detects the hotplug slots successfully.
>> Please try "echo 1 > /sys/bus/pci/slots/<slot#>/power". It would turn on
>> the slot and initialize adapter card on the slot.
> 
> It does find the 4 slots correctly. But if I try to turn on the power,
> nothing happens and 'power' stays at 0. If I do the same with pciehp, I
> get the same hang as described when using pciehp with pciehp_force=1.
> But apparently this machine is getting a board replacement very soon, so
> it may solve itself. Unless you think it should work and there's
> something I can try to check, then lets just leave this issue until I
> get it upgraded and return from kernel summit / JLS.
> 

Could you try pciehp with "pciehp_debug" option enabled(*), and give me
the following information?

  - "cat /sys/bus/pci/slots/*/*" output
  - dmesg output after "echo 1 > /sys/bus/pci/slots/<slot#>/power"

(*) you can enable "pciehp_debug" option as follows

  # modprobe pciehp pciehp_debug

I'm not sure, but I think one of the possibility is that your hot-plug
controller doesn't support power controller. On such slot, the slot is
usually turned on automatically at adapter card insertion. So card
re-insertion might make some difference.

By the way, I would like to know if your system has SHPC based hotplug
slots. Could you load shpchp driver and send me the
"ls -lR /sys/bus/pci/slots/" output? And I would like to see the dmesg
output with "debug_acpi" of pci_hotplug enabled. For example,

    $ su
    # echo Y > /sys/module/pci_hotplug/parameters/debug_acpi
    # modprobe shpchp
    # ls -lR /sys/bus/pci/slots
    # dmesg

> 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
> Firmware did not grant requested _OSC control
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP5 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:05.0 (\_SB_.IOH0.MRP5)
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
> Firmware did not grant requested _OSC control
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP7 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:07.0 (\_SB_.IOH0.MRP7)
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
> Firmware did not grant requested _OSC control
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.PEX0 
> acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0.PEX0 OSHP not found
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0 
> acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0 OSHP not found
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Cannot get control of hotplug hardware for pci 0000:00:1c.0
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPI 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:07.0 (\_SB_.IOH1.MRPI)
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPK 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:09.0 (\_SB_.IOH1.MRPK)
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
> Firmware did not grant requested _OSC control
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP5 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:05.0 (\_SB_.IOH0.MRP5)
> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
> Firmware did not grant requested _OSC control
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP7 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:07.0 (\_SB_.IOH0.MRP7)
> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
> Firmware did not grant requested _OSC control
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.PEX0 
> acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0.PEX0 OSHP not found
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0 
> acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0 OSHP not found
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Cannot get control of hotplug hardware for pci 0000:00:1c.0
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPI 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:07.0 (\_SB_.IOH1.MRPI)
> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 _id 340e ss_vid 0 ss_did 0
> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPK 
> acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:09.0 (\_SB_.IOH1.MRPK)
> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> 

It seems your environment has two PCI root bridges and one of them
(IOH0) provides both _OSC and OSHP, and the other (IOH1) provides
only OSHP. The _OSC under IOH0 doesn't grant hot-plug control, so
I think your system expects that at least the slots under IOH0 is
handled by acpiphp. But I don't have any idea about the slots
under IOH1 for now.

Thanks,
Kenji Kaneshige


