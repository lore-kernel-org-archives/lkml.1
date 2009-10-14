Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZJNIrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZJNIrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZJNIry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:47:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38138 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbZJNIrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:47:51 -0400
Date: Wed, 14 Oct 2009 10:47:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091014084713.GO9228@kernel.dk>
References: <20091012120620.GG9228@kernel.dk> <4AD3F1D4.1000006@jp.fujitsu.com> <20091013083152.GR9228@kernel.dk> <4AD45B1B.8000609@jp.fujitsu.com> <20091013112525.GX9228@kernel.dk> <4AD5611F.6010907@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ep0oHQY+/Gbo/zt0"
Content-Disposition: inline
In-Reply-To: <4AD5611F.6010907@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 14 2009, Kenji Kaneshige wrote:
> Jens Axboe wrote:
>> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>>> Jens Axboe wrote:
>>>> On Tue, Oct 13 2009, Kenji Kaneshige wrote:
>>>>> Jens Axboe wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I'm trying to get pci-express hotplug working in a box here. I don't
>>>>>> really care about the hotplug aspect, I just want the darn pci-e slots
>>>>>> that are designated hotplug slots to actually WORK. When I load pciehp,
>>>>>> I get:
>>>>>>
>>>>>> Firmware did not grant requested _OSC control
>>>>>> Firmware did not grant requested _OSC control
>>>>>> Firmware did not grant requested _OSC control
>>>>>> Firmware did not grant requested _OSC control
>>>>>> pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
>>>>>> pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
>>>>>> Firmware did not grant requested _OSC control
>>>>>> pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>>>> pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
>>>>>> Firmware did not grant requested _OSC control
>>>>>> pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
>>>>>> pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
>>>>>> pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
>>>>>> pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
>>>>>> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>>>>>
>>>>>> and the devices in the hotplug slots stay off. Is this an ACPI/bios
>>>>>> issue? How can I debug this?
>>>>>>
>>>>> Could you give me the result of "ls -lR /sys/bus/pci/slots/"
>>>>> after loading pciehp?
>>>> I have attached the result of that ls prior to loading pciehp/acpiphp
>>>> (pre-load), after loading pciehp (pciehp-load), and with acpiphp loaded
>>>> only as well (acpiphp-load).
>>>>
>>> Thank you for the info. From the information, I confirmed that hotplug
>>> slots are detected by pciehp even though _OSC evaluation failed. There
>>> are two ways to take control from the firmware through ACPI control
>>> method. One is _OSC control method, and the other is OSHP control method.
>>> I guess your ACPI fimware has both _OSC and OSHP on DSDT (ACPI Namespace),
>>> and pciehp assumes that it took control through OSHP after the _OSC
>>> evaluation failure. I think this pciehp's behavior is wrong because of
>>> the following reasons and I think pciehp driver mis-detected the hotplug
>>> slots on your environment because of this.
>>>
>>> - According to the PCI firmware specification, pciehp driver must use the
>>>  result of _OSC, if the platform implements both _OSC and OSHP.
>>> - OSHP control method seems only for SHPC, not for PCI Express native hot-
>>>  plug. So pciehp must not evaluate OSHP to take control from firmware.
>>>
>>> To confirm this, could you send me the dmesg output after loading pciehp
>>> with 'debug_acpi' of pci_hotplug (PCI hotplug core driver) enabled?
>>> For example,
>>>
>>>    $ su
>>>    # echo Y > /sys/module/pci_hotplug/parameters/debug_acpi
>>>    # modprobe pciehp
>>>    # dmesg
>>
>> See below.
>>
>>> And if it is possible, could you send me DSDT of your platform?
>>
>> Not sure I can do that, I'll check.
>>
>>> Anyway, my recommendation is using acpiphp on your environment because
>>> your firmware didn't grant control over hotplug control through _OSC.
>>> From the information, acpiphp also detects the hotplug slots successfully.
>>> Please try "echo 1 > /sys/bus/pci/slots/<slot#>/power". It would turn on
>>> the slot and initialize adapter card on the slot.
>>
>> It does find the 4 slots correctly. But if I try to turn on the power,
>> nothing happens and 'power' stays at 0. If I do the same with pciehp, I
>> get the same hang as described when using pciehp with pciehp_force=1.
>> But apparently this machine is getting a board replacement very soon, so
>> it may solve itself. Unless you think it should work and there's
>> something I can try to check, then lets just leave this issue until I
>> get it upgraded and return from kernel summit / JLS.
>>
>
> Could you try pciehp with "pciehp_debug" option enabled(*), and give me
> the following information?

I've attached the output of loading pciehp with the debug option
enabled.

>  - "cat /sys/bus/pci/slots/*/*" output

Attached as slots

>  - dmesg output after "echo 1 > /sys/bus/pci/slots/<slot#>/power"

# echo 1 > /sys/bus/pci/slots/1/power
pciehp 0000:00:05.0:pcie04: Power fault on Slot(1)
pciehp 0000:00:05.0:pcie04: Power fault bit 0 set
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 2
[...]

That last line repeats infinitely.

> (*) you can enable "pciehp_debug" option as follows
>
>  # modprobe pciehp pciehp_debug
>
> I'm not sure, but I think one of the possibility is that your hot-plug
> controller doesn't support power controller. On such slot, the slot is
> usually turned on automatically at adapter card insertion. So card
> re-insertion might make some difference.

The dmesg seems to suggest it has a power controller. I also tried
removing and replugging the card, which is detected:

pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 8
pciehp 0000:00:05.0:pcie04: Presence/Notify input change
pciehp 0000:00:05.0:pcie04: Card not present on Slot(1)
pciehp 0000:00:05.0:pcie04: pcie_isr: intr_loc 8
pciehp 0000:00:05.0:pcie04: Presence/Notify input change
pciehp 0000:00:05.0:pcie04: Card present on Slot(1)

but the slot isn't powered on still.

> By the way, I would like to know if your system has SHPC based hotplug
> slots. Could you load shpchp driver and send me the
> "ls -lR /sys/bus/pci/slots/" output? And I would like to see the dmesg
> output with "debug_acpi" of pci_hotplug enabled. For example,
>
>    $ su
>    # echo Y > /sys/module/pci_hotplug/parameters/debug_acpi
>    # modprobe shpchp

This doesn't dump anything but:

shpchp: Standard Hot Plug PCI Controller Driver version: 0.4

>    # ls -lR /sys/bus/pci/slots
>    # dmesg

Attached.

-- 
Jens Axboe


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ls-lr-slots
Content-Transfer-Encoding: quoted-printable

=1B[0m/sys/bus/pci/slots/:
total 0
drwxr-xr-x 2 root root 0 2009-10-14 10:44 =1B[01;34m1=1B[0m/
drwxr-xr-x 2 root root 0 2009-10-14 10:44 =1B[01;34m2=1B[0m/
drwxr-xr-x 2 root root 0 2009-10-14 10:44 =1B[01;34m6=1B[0m/
drwxr-xr-x 2 root root 0 2009-10-14 10:44 =1B[01;34m7=1B[0m/

/sys/bus/pci/slots/1:
total 0
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0madapter=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0maddress=1B[0m
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mattention=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mcur_bus_speed=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mlatch=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mmax_bus_speed=1B[0m
lrwxrwxrwx 1 root root    0 2009-10-14 10:44 =1B[01;36mmodule=1B[0m -> =1B[=
01;34m../../../../module/pciehp=1B[0m/
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mpower=1B[0m

/sys/bus/pci/slots/2:
total 0
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0madapter=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0maddress=1B[0m
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mattention=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mcur_bus_speed=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mlatch=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mmax_bus_speed=1B[0m
lrwxrwxrwx 1 root root    0 2009-10-14 10:44 =1B[01;36mmodule=1B[0m -> =1B[=
01;34m../../../../module/pciehp=1B[0m/
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mpower=1B[0m

/sys/bus/pci/slots/6:
total 0
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0madapter=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0maddress=1B[0m
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mattention=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mcur_bus_speed=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mlatch=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mmax_bus_speed=1B[0m
lrwxrwxrwx 1 root root    0 2009-10-14 10:44 =1B[01;36mmodule=1B[0m -> =1B[=
01;34m../../../../module/pciehp=1B[0m/
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mpower=1B[0m

/sys/bus/pci/slots/7:
total 0
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0madapter=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0maddress=1B[0m
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mattention=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mcur_bus_speed=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mlatch=1B[0m
-r--r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mmax_bus_speed=1B[0m
lrwxrwxrwx 1 root root    0 2009-10-14 10:44 =1B[01;36mmodule=1B[0m -> =1B[=
01;34m../../../../module/pciehp=1B[0m/
-rw-r--r-- 1 root root 4096 2009-10-14 10:44 =1B[0mpower=1B[0m
=1B[m
--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slots

Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp 0000:
--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=pciehp-load-debug

Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp 0000:00:05.0:pcie04: Hotplug Controller:
pciehp 0000:00:05.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:05.0 IRQ 75
pciehp 0000:00:05.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:05.0:pcie04:   Device ID            : 0x340c
pciehp 0000:00:05.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:00:05.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:00:05.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:00:05.0:pcie04:   PCI resource [7]     : 0x1000@0x2000
pciehp 0000:00:05.0:pcie04:   PCI resource [8]     : 0x1000000@0x92900000
pciehp 0000:00:05.0:pcie04:   PCI resource [9]     : 0x4000000@0xc7f00000
pciehp 0000:00:05.0:pcie04: Slot Capabilities      : 0x0008005b
pciehp 0000:00:05.0:pcie04:   Physical Slot Number : 1
pciehp 0000:00:05.0:pcie04:   Attention Button     : yes
pciehp 0000:00:05.0:pcie04:   Power Controller     : yes
pciehp 0000:00:05.0:pcie04:   MRL Sensor           :  no
pciehp 0000:00:05.0:pcie04:   Attention Indicator  : yes
pciehp 0000:00:05.0:pcie04:   Power Indicator      : yes
pciehp 0000:00:05.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:00:05.0:pcie04:   EMI Present          :  no
pciehp 0000:00:05.0:pcie04:   Command Completed    : yes
pciehp 0000:00:05.0:pcie04: Slot Status            : 0x0040
pciehp 0000:00:05.0:pcie04: Slot Control           : 0x07cf
pciehp 0000:00:05.0:pcie04: Link Active Reporting supported
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid 0 ss_did 0
pciehp 0000:00:05.0:pcie04: Registering domain:bus:dev=0000:08:00 sun=1
pciehp 0000:00:05.0:pcie04: get_power_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:00:05.0:pcie04: get_attention_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:00:05.0:pcie04: get_latch_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: get_adapter_status: physical_slot = 1
pciehp 0000:00:05.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
Firmware did not grant requested _OSC control
pciehp 0000:00:07.0:pcie04: Hotplug Controller:
pciehp 0000:00:07.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:00:07.0 IRQ 76
pciehp 0000:00:07.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:00:07.0:pcie04:   Device ID            : 0x340e
pciehp 0000:00:07.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:00:07.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:00:07.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:00:07.0:pcie04:   PCI resource [7]     : 0x1000@0x1000
pciehp 0000:00:07.0:pcie04:   PCI resource [8]     : 0x1000000@0x91900000
pciehp 0000:00:07.0:pcie04:   PCI resource [9]     : 0x4000000@0xcbf00000
pciehp 0000:00:07.0:pcie04: Slot Capabilities      : 0x0010005b
pciehp 0000:00:07.0:pcie04:   Physical Slot Number : 2
pciehp 0000:00:07.0:pcie04:   Attention Button     : yes
pciehp 0000:00:07.0:pcie04:   Power Controller     : yes
pciehp 0000:00:07.0:pcie04:   MRL Sensor           :  no
pciehp 0000:00:07.0:pcie04:   Attention Indicator  : yes
pciehp 0000:00:07.0:pcie04:   Power Indicator      : yes
pciehp 0000:00:07.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:00:07.0:pcie04:   EMI Present          :  no
pciehp 0000:00:07.0:pcie04:   Command Completed    : yes
pciehp 0000:00:07.0:pcie04: Slot Status            : 0x0000
pciehp 0000:00:07.0:pcie04: Slot Control           : 0x07cf
pciehp 0000:00:07.0:pcie04: Link Active Reporting supported
pciehp 0000:00:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:00:07.0:pcie04: Registering domain:bus:dev=0000:0b:00 sun=2
pciehp 0000:00:07.0:pcie04: get_power_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:00:07.0:pcie04: get_attention_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:00:07.0:pcie04: get_latch_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: get_adapter_status: physical_slot = 2
pciehp 0000:00:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:00:07.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
Firmware did not grant requested _OSC control
pciehp 0000:80:07.0:pcie04: Hotplug Controller:
pciehp 0000:80:07.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:80:07.0 IRQ 84
pciehp 0000:80:07.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:80:07.0:pcie04:   Device ID            : 0x340e
pciehp 0000:80:07.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:80:07.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:80:07.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:80:07.0:pcie04:   PCI resource [7]     : 0x1000@0x9000
pciehp 0000:80:07.0:pcie04:   PCI resource [8]     : 0x1000000@0xd1000000
pciehp 0000:80:07.0:pcie04:   PCI resource [9]     : 0x4000000@0xf3f00000
pciehp 0000:80:07.0:pcie04: Slot Capabilities      : 0x0030005b
pciehp 0000:80:07.0:pcie04:   Physical Slot Number : 6
pciehp 0000:80:07.0:pcie04:   Attention Button     : yes
pciehp 0000:80:07.0:pcie04:   Power Controller     : yes
pciehp 0000:80:07.0:pcie04:   MRL Sensor           :  no
pciehp 0000:80:07.0:pcie04:   Attention Indicator  : yes
pciehp 0000:80:07.0:pcie04:   Power Indicator      : yes
pciehp 0000:80:07.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:80:07.0:pcie04:   EMI Present          :  no
pciehp 0000:80:07.0:pcie04:   Command Completed    : yes
pciehp 0000:80:07.0:pcie04: Slot Status            : 0x0000
pciehp 0000:80:07.0:pcie04: Slot Control           : 0x07cf
pciehp 0000:80:07.0:pcie04: Link Active Reporting supported
pciehp 0000:80:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:07.0:pcie04: HPC vendor_id 8086 device_id 340e ss_vid 0 ss_did 0
pciehp 0000:80:07.0:pcie04: Registering domain:bus:dev=0000:84:00 sun=6
pciehp 0000:80:07.0:pcie04: get_power_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:80:07.0:pcie04: get_attention_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:80:07.0:pcie04: get_latch_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: get_adapter_status: physical_slot = 6
pciehp 0000:80:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:07.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:07.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
pciehp 0000:80:09.0:pcie04: Hotplug Controller:
pciehp 0000:80:09.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 0000:80:09.0 IRQ 85
pciehp 0000:80:09.0:pcie04:   Vendor ID            : 0x8086
pciehp 0000:80:09.0:pcie04:   Device ID            : 0x3410
pciehp 0000:80:09.0:pcie04:   Subsystem ID         : 0x0000
pciehp 0000:80:09.0:pcie04:   Subsystem Vendor ID  : 0x0000
pciehp 0000:80:09.0:pcie04:   PCIe Cap offset      : 0x90
pciehp 0000:80:09.0:pcie04:   PCI resource [7]     : 0x1000@0x8000
pciehp 0000:80:09.0:pcie04:   PCI resource [8]     : 0x1000000@0xd0000000
pciehp 0000:80:09.0:pcie04:   PCI resource [9]     : 0x4000000@0xf7f00000
pciehp 0000:80:09.0:pcie04: Slot Capabilities      : 0x0038005b
pciehp 0000:80:09.0:pcie04:   Physical Slot Number : 7
pciehp 0000:80:09.0:pcie04:   Attention Button     : yes
pciehp 0000:80:09.0:pcie04:   Power Controller     : yes
pciehp 0000:80:09.0:pcie04:   MRL Sensor           :  no
pciehp 0000:80:09.0:pcie04:   Attention Indicator  : yes
pciehp 0000:80:09.0:pcie04:   Power Indicator      : yes
pciehp 0000:80:09.0:pcie04:   Hot-Plug Surprise    :  no
pciehp 0000:80:09.0:pcie04:   EMI Present          :  no
pciehp 0000:80:09.0:pcie04:   Command Completed    : yes
pciehp 0000:80:09.0:pcie04: Slot Status            : 0x0000
pciehp 0000:80:09.0:pcie04: Slot Control           : 0x07cf
pciehp 0000:80:09.0:pcie04: Link Active Reporting supported
pciehp 0000:80:09.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:09.0:pcie04: HPC vendor_id 8086 device_id 3410 ss_vid 0 ss_did 0
pciehp 0000:80:09.0:pcie04: Registering domain:bus:dev=0000:87:00 sun=7
pciehp 0000:80:09.0:pcie04: get_power_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 7c0
pciehp 0000:80:09.0:pcie04: get_attention_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: pciehp_get_attention_status: SLOTCTRL a8, value read 7c0
pciehp 0000:80:09.0:pcie04: get_latch_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: get_adapter_status: physical_slot = 7
pciehp 0000:80:09.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:09.0:pcie04: Command not completed in 1000 msec
pciehp 0000:80:09.0:pcie04: pciehp_power_off_slot: SLOTCTRL a8 write cmd 400
pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
pciehp: pcie_port_service_register = 0
pciehp: PCI Express Hot Plug Controller Driver version: 0.4


--ep0oHQY+/Gbo/zt0--
