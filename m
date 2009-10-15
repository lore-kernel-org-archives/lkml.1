Return-Path: <linux-kernel-owner+w=401wt.eu-S1762431AbZJOJnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431AbZJOJnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758938AbZJOJnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:43:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52350 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZJOJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:43:06 -0400
Date: Thu, 15 Oct 2009 11:42:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091015094229.GD9228@kernel.dk>
References: <20091012120620.GG9228@kernel.dk> <4AD3F1D4.1000006@jp.fujitsu.com> <20091013083152.GR9228@kernel.dk> <4AD45B1B.8000609@jp.fujitsu.com> <20091013112525.GX9228@kernel.dk> <4AD5611F.6010907@jp.fujitsu.com> <20091014084713.GO9228@kernel.dk> <4AD6B612.2030506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD6B612.2030506@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15 2009, Kenji Kaneshige wrote:
> Jens Axboe wrote:
>> On Wed, Oct 14 2009, Kenji Kaneshige wrote:
>>> Jens Axboe wrote:
>>>> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>>>>> Jens Axboe wrote:
>>>>>> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>>>>>>> Jens Axboe wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I'm trying to get pci-express hotplug working in a box here. I don't
>>>>>>>> really care about the hotplug aspect, I just want the darn pci-e slots
>>>>>>>> that are designated hotplug slots to actually WORK. When I load pciehp,
>>>>>>>> I get:
>>>>>>>>
>>>>>>>> Firmware did not grant requested _OSC control
>>>>>>>> Firmware did not grant requested _OSC control
>>>>>>>> Firmware did not grant requested _OSC control
>>>>>>>> Firmware did not grant requested _OSC control
>>>>>>>> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
>>>>>>>> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
>>>>>>>> Firmware did not grant requested _OSC control
>>>>>>>> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>>>>>> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
>>>>>>>> Firmware did not grant requested _OSC control
>>>>>>>> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>>>>>> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
>>>>>>>> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
>>>>>>>> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
>>>>>>>> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>>>>>>>
>>>>>>>> and the devices in the hotplug slots stay off. Is this an ACPI/bios
>>>>>>>> issue? How can I debug this?
>>>>>>>>
>>>>>>> Could you give me the result of "ls -lR /sys/bus/pci/slots/"
>>>>>>> after loading pciehp?
>>>>>> I have attached the result of that ls prior to loading pciehp/acpiphp
>>>>>> (pre-load), after loading pciehp (pciehp-load), and with acpiphp loaded
>>>>>> only as well (acpiphp-load).
>>>>>>
>>>>> Thank you for the info. From the information, I confirmed that hotplug
>>>>> slots are detected by pciehp even though _OSC evaluation failed. There
>>>>> are two ways to take control from the firmware through ACPI control
>>>>> method. One is _OSC control method, and the other is OSHP control method.
>>>>> I guess your ACPI fimware has both _OSC and OSHP on DSDT (ACPI Namespace),
>>>>> and pciehp assumes that it took control through OSHP after the _OSC
>>>>> evaluation failure. I think this pciehp's behavior is wrong because of
>>>>> the following reasons and I think pciehp driver mis-detected the hotplug
>>>>> slots on your environment because of this.
>>>>>
>>>>> - According to the PCI firmware specification, pciehp driver must use the
>>>>>  result of _OSC, if the platform implements both _OSC and OSHP.
>>>>> - OSHP control method seems only for SHPC, not for PCI Express native hot-
>>>>>  plug. So pciehp must not evaluate OSHP to take control from firmware.
>>>>>
>>>>> To confirm this, could you send me the dmesg output after loading pciehp
>>>>> with 'debug_acpi' of pci_hotplug (PCI hotplug core driver) enabled?
>>>>> For example,
>>>>>
>>>>>    $ su
>>>>>    # echo Y > /sys/module/pci_hotplug/parameters/debug_acpi
>>>>>    # modprobe pciehp
>>>>>    # dmesg
>>>> See below.
>>>>
>>>>> And if it is possible, could you send me DSDT of your platform?
>>>> Not sure I can do that, I'll check.
>>>>
>>>>> Anyway, my recommendation is using acpiphp on your environment because
>>>>> your firmware didn't grant control over hotplug control through _OSC.
>>>>> From the information, acpiphp also detects the hotplug slots successfully.
>>>>> Please try "echo 1 > /sys/bus/pci/slots/<slot#>/power". It would turn on
>>>>> the slot and initialize adapter card on the slot.
>>>> It does find the 4 slots correctly. But if I try to turn on the power,
>>>> nothing happens and 'power' stays at 0. If I do the same with pciehp, I
>>>> get the same hang as described when using pciehp with pciehp_force=1.
>>>> But apparently this machine is getting a board replacement very soon, so
>>>> it may solve itself. Unless you think it should work and there's
>>>> something I can try to check, then lets just leave this issue until I
>>>> get it upgraded and return from kernel summit / JLS.
>>>>
>>> Could you try pciehp with "pciehp_debug" option enabled(*), and give me
>>> the following information?
>>
>> I've attached the output of loading pciehp with the debug option
>> enabled.
>>
>>>  - "cat /sys/bus/pci/slots/*/*" output
>>
>> Attached as slots
>>
>>>  - dmesg output after "echo 1 > /sys/bus/pci/slots/<slot#>/power"
>>
>> # echo 1 > /sys/bus/pci/slots/1/power
>> pciehp 0000:00:05.0:pcie04: Power fault on Slot(1)
>> pciehp 0000:00:05.0:pcie04: Power fault bit 0 set
>> pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
>> [...]
>>
>> That last line repeats infinitely.
>
> Thank you very much for information.
>
> The direct cause of the problem that your slot was not turned on
> is power fault. I guess acpiphp is suffering the same problem.
> Unfortunately, it's difficult for me to analyze the root cause
> of this power fault. Please ask the hardware vendor about it. I
> hope board replacement will fix the problem.

OK, I'll try with the new board when back and see what happens. If the
power fault persists, I'll poke the vendor about it.

> By the way, thanks to your report, I noticed the several points
> that might need to be fixed as follows. I'll try to improve that.
>
> - The message "Firmware did not grant requested _OSC control" is
>  confusing and similar message is already displayed by the caller
>  of acpi_pci_osc_control_set(). Therefore, it should be removed.

It's one of those messages that mean very little to you, unless you have
an understanding of how hotplug is supposed to work. So removing it
sounds god.

> - If the platform has _OSC control method, OSHP should not be
>  evaluated.
>
> - (maybe) pciehp must not evaluate OSHP (But your platform seems
>  to provide OSHP for several PCIe hotplug slots because your
>  platform provides OSHP even though it doesn't have any SHPC
>  based PCI/PCI-X hot-plug slots. I need to check PCI firmware
>  spec again).
>
> - pciehp needs something to prevent power fault interrupt storm.

Definitely, it essentially hangs the box and requires a reboot.

Thanks a lot for looking into these issues, I'll be back with a status
message when I've tried the new board.

-- 
Jens Axboe

