Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZJML0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZJML0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbZJML0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:26:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39262 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbZJML0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:26:02 -0400
Date: Tue, 13 Oct 2009 13:25:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091013112525.GX9228@kernel.dk>
References: <20091012120620.GG9228@kernel.dk> <4AD3F1D4.1000006@jp.fujitsu.com> <20091013083152.GR9228@kernel.dk> <4AD45B1B.8000609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD45B1B.8000609@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13 2009, Kenji Kaneshige wrote:
> Jens Axboe wrote:
>> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>>> Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> I'm trying to get pci-express hotplug working in a box here. I don't
>>>> really care about the hotplug aspect, I just want the darn pci-e slots
>>>> that are designated hotplug slots to actually WORK. When I load pciehp,
>>>> I get:
>>>>
>>>> Firmware did not grant requested _OSC control
>>>> Firmware did not grant requested _OSC control
>>>> Firmware did not grant requested _OSC control
>>>> Firmware did not grant requested _OSC control
>>>> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
>>>> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
>>>> Firmware did not grant requested _OSC control
>>>> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
>>>> Firmware did not grant requested _OSC control
>>>> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
>>>> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
>>>> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
>>>> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>>>
>>>> and the devices in the hotplug slots stay off. Is this an ACPI/bios
>>>> issue? How can I debug this?
>>>>
>>> Could you give me the result of "ls -lR /sys/bus/pci/slots/"
>>> after loading pciehp?
>>
>> I have attached the result of that ls prior to loading pciehp/acpiphp
>> (pre-load), after loading pciehp (pciehp-load), and with acpiphp loaded
>> only as well (acpiphp-load).
>>
>
> Thank you for the info. From the information, I confirmed that hotplug
> slots are detected by pciehp even though _OSC evaluation failed. There
> are two ways to take control from the firmware through ACPI control
> method. One is _OSC control method, and the other is OSHP control method.
> I guess your ACPI fimware has both _OSC and OSHP on DSDT (ACPI Namespace),
> and pciehp assumes that it took control through OSHP after the _OSC
> evaluation failure. I think this pciehp's behavior is wrong because of
> the following reasons and I think pciehp driver mis-detected the hotplug
> slots on your environment because of this.
>
> - According to the PCI firmware specification, pciehp driver must use the
>  result of _OSC, if the platform implements both _OSC and OSHP.
> - OSHP control method seems only for SHPC, not for PCI Express native hot-
>  plug. So pciehp must not evaluate OSHP to take control from firmware.
>
> To confirm this, could you send me the dmesg output after loading pciehp
> with 'debug_acpi' of pci_hotplug (PCI hotplug core driver) enabled?
> For example,
>
>    $ su
>    # echo Y > /sys/module/pci_hotplug/parameters/debug_acpi
>    # modprobe pciehp
>    # dmesg

See below.

> And if it is possible, could you send me DSDT of your platform?

Not sure I can do that, I'll check.

> Anyway, my recommendation is using acpiphp on your environment because
> your firmware didn't grant control over hotplug control through _OSC.
> From the information, acpiphp also detects the hotplug slots successfully.
> Please try "echo 1 > /sys/bus/pci/slots/<slot#>/power". It would turn on
> the slot and initialize adapter card on the slot.

It does find the 4 slots correctly. But if I try to turn on the power,
nothing happens and 'power' stays at 0. If I do the same with pciehp, I
get the same hang as described when using pciehp with pciehp_force=1.
But apparently this machine is getting a board replacement very soon, so
it may solve itself. Unless you think it should work and there's
something I can try to check, then lets just leave this issue until I
get it upgraded and return from kernel summit / JLS.


acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP5 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:05.0 (\_SB_.IOH0.MRP5)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP7 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:07.0 (\_SB_.IOH0.MRP7)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.PEX0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0.PEX0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Cannot get control of hotplug hardware for pci 0000:00:1c.0
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPI 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:07.0 (\_SB_.IOH1.MRPI)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPK 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:09.0 (\_SB_.IOH1.MRPK)
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP5 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:05.0 (\_SB_.IOH0.MRP5)
pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.MRP7 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:00:07.0 (\_SB_.IOH0.MRP7)
pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0
Firmware did not grant requested _OSC control
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0.PEX0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0.PEX0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH0 
acpi_pcihp: acpi_run_oshp: acpi_run_oshp:\_SB_.IOH0 OSHP not found
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Cannot get control of hotplug hardware for pci 0000:00:1c.0
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPI 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:07.0 (\_SB_.IOH1.MRPI)
pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Trying to get hotplug control for \_SB_.IOH1.MRPK 
acpi_pcihp: acpi_get_hp_hw_control_from_firmware: Gained control for hotplug HW for pci 0000:80:09.0 (\_SB_.IOH1.MRPK)
pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4

-- 
Jens Axboe

