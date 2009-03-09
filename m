Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZCIGhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZCIGhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 02:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZCIGg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 02:36:59 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23790 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZCIGg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 02:36:58 -0400
Date: Mon, 9 Mar 2009 00:36:54 -0600
From: Alex Chiang <achiang@hp.com>
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: kobj refcounting weirdness
Message-ID: <20090309063654.GB23137@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, kay.sievers@vrfy.org,
	greg@kroah.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay, Greg,

I've been working on this patch series recently that adds
function and device level hotplug into the PCI core:

	http://thread.gmane.org/gmane.linux.kernel.pci/3495

For the last two weeks, I've been beating my head against a
refcounting/kobject problem, and was hoping you could give me
some advice, since I seem to have run into a wall.

My test case has been removing device 0000:04:00.0, which should
remove all the devices below it.

 +-[0000:03]---00.0-[0000:04-07]----00.0-[0000:05-07]--+-02.0-[0000:06]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
 |                                                     |                 \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
 |                                                     \-04.0-[0000:07]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
 |                                                                       \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter

I can remove the device and rescan the bus once, and it works
fine. The second removal works fine, and then, unpredictably,
later rescan/remove cycles eventually end up producing a warning
and oops every time. Sometimes I die on the 2nd rescan, sometimes
not until the 4th or 5th remove/rescan cycle.

In this data set, I turned on kobject debugging, and managed to
capture a trace where we die on the 2nd rescan.

In this data set, we:

	- create a kobject for 0000:04:00.0 (e00000018cac2920)
	- remove the device
	- observe '0000:04:00.0' (e00000018cac2920): calling ktype release
	- rescan the bus
	- discover that e00000018cac2920 is still hanging around!

At this point, I'm not sure what else to instrument or look at to
see what might be going on, and was hoping you could give me a
pointer.

One final data point, if I build my kernel without PCIe support,
the same experiment on the same topology/devices above can
withstand infinite remove/recan cycles (where infinite is defined
as > 20 before I got bored ;).

I'm going to include the kobject debug info below along with some
annotations. There's a lot of data, but it should be
straightforward to follow. It doesn't get interesting until the
2nd remove/rescan.

Any help/advice you have for me would be greatly appreciated.

Thanks!

/ac

[During initial boot]
ACPI: PCI Root Bridge [L003] (0000:03)
kobject: 'pci0000:03' (e0000001809b3090): kobject_add_internal: parent: 'devices', set: 'devices'
kobject: 'pci0000:03' (e0000001809b3090): kobject_uevent_env
kobject: 'pci0000:03' (e0000001809b3090): kobject_uevent_env: filter function caused the event to drop!
kobject: '0000:03' (e0000001801961b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:03' (e0000001801961b8): kobject_uevent_env
kobject: '0000:03' (e0000001801961b8): fill_kobj_path: path = '/class/pci_bus/0000:03'
PCI: Scanning bus 0000:03
[scan buses 0000:03 -- 0000:07]
kobject: '0000:03:00.0' (e000000181661120): kobject_add_internal: parent: 'pci0000:03', set: 'devices'
kobject: '0000:03:00.0' (e000000181661120): kobject_uevent_env
kobject: '0000:03:00.0' (e000000181661120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0'
kobject: '0000:04:00.0' (e000000181661920): kobject_add_internal: parent: '0000:03:00.0', set: 'devices'
kobject: '0000:04:00.0' (e000000181661920): kobject_uevent_env
kobject: '0000:04:00.0' (e000000181661920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:05:02.0' (e000000181662120): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:05:02.0' (e000000181662120): kobject_uevent_env
kobject: '0000:05:02.0' (e000000181662120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:05:04.0' (e000000181662920): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:05:04.0' (e000000181662920): kobject_uevent_env
kobject: '0000:05:04.0' (e000000181662920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:06:00.0' (e000000181663120): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:06:00.0' (e000000181663120): kobject_uevent_env
kobject: '0000:06:00.0' (e000000181663120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.0'
kobject: '0000:06:00.1' (e000000181663920): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:06:00.1' (e000000181663920): kobject_uevent_env
kobject: '0000:06:00.1' (e000000181663920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.1'
kobject: '0000:06' (e000000180196db8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:06' (e000000180196db8): kobject_uevent_env
kobject: '0000:06' (e000000180196db8): fill_kobj_path: path = '/class/pci_bus/0000:06'
kobject: '0000:05:02.0' (e000000181662120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:07:00.0' (e000000181664120): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:07:00.0' (e000000181664120): kobject_uevent_env
kobject: '0000:07:00.0' (e000000181664120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.0'
kobject: '0000:07:00.1' (e000000181664920): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:07:00.1' (e000000181664920): kobject_uevent_env
kobject: '0000:07:00.1' (e000000181664920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.1'
kobject: '0000:07' (e0000001801971b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:07' (e0000001801971b8): kobject_uevent_env
kobject: '0000:07' (e0000001801971b8): fill_kobj_path: path = '/class/pci_bus/0000:07'
kobject: '0000:05:04.0' (e000000181662920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:05' (e0000001801969b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:05' (e0000001801969b8): kobject_uevent_env
kobject: '0000:05' (e0000001801969b8): fill_kobj_path: path = '/class/pci_bus/0000:05'
kobject: '0000:04:00.0' (e000000181661920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:04' (e0000001801965b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:04' (e0000001801965b8): kobject_uevent_env
kobject: '0000:04' (e0000001801965b8): fill_kobj_path: path = '/class/pci_bus/0000:04'
kobject: '0000:03:00.0' (e000000181661120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0'
[PCIe port driver gets loaded and claims ports]
kobject: '0000:03:00.0:pcie01' (e0000001830b00b0): kobject_add_internal: parent: '0000:03:00.0', set: 'devices'
kobject: '0000:03:00.0:pcie01' (e0000001830b00b0): kobject_uevent_env
kobject: '0000:03:00.0:pcie01' (e0000001830b00b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:03:00.0:pcie01'
kobject: '0000:03:00.0:pcie02' (e0000001830b02b0): kobject_add_internal: parent: '0000:03:00.0', set: 'devices'
kobject: '0000:03:00.0:pcie02' (e0000001830b02b0): kobject_uevent_env
kobject: '0000:03:00.0:pcie02' (e0000001830b02b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:03:00.0:pcie02'
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): kobject_uevent_env
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:04:00.0:pcie18'
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie22'
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie28'
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): kobject_uevent_env
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie22'
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): kobject_uevent_env
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie28'

[system completes boot, now ready for 1st remove iteration]
[root@tahitifp1 /sys/bus/pci]# echo 1 > devices/0000\:04\:00.0/remove
kobject: '0000:06:00.0' (e000000181663120): kobject_uevent_env
kobject: '0000:06:00.0' (e000000181663120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.0'
kobject: '0000:06:00.0' (e000000181663120): kobject_cleanup
kobject: '0000:06:00.0' (e000000181663120): calling ktype release
kobject: '0000:06:00.0': free name
kobject: '0000:06:00.1' (e000000181663920): kobject_uevent_env
kobject: '0000:06:00.1' (e000000181663920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.1'
kobject: '0000:06:00.1' (e000000181663920): kobject_cleanup
kobject: '0000:06:00.1' (e000000181663920): calling ktype release
kobject: '0000:06:00.1': free name
kobject: '0000:06' (e000000180196db8): kobject_uevent_env
kobject: '0000:06' (e000000180196db8): fill_kobj_path: path = '/class/pci_bus/0000:06'
kobject: '0000:05:02.0' (e000000181662120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:06' (e000000180196db8): kobject_cleanup
kobject: '0000:06' (e000000180196db8): calling ktype release
kobject: '0000:06': free name
aer 0000:05:02.0:pcie22: unloading service driver aer
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie22'
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): kobject_cleanup
kobject: '0000:05:02.0:pcie22' (e0000001830b06b0): calling ktype release
kobject: '0000:05:02.0:pcie22': free name
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie28'
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): kobject_cleanup
kobject: '0000:05:02.0:pcie28' (e0000001830b08b0): calling ktype release
kobject: '0000:05:02.0:pcie28': free name
kobject: '0000:05:02.0' (e000000181662120): kobject_uevent_env
kobject: '0000:05:02.0' (e000000181662120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:05:02.0' (e000000181662120): kobject_cleanup
kobject: '0000:05:02.0' (e000000181662120): calling ktype release
kobject: '0000:05:02.0': free name
kobject: '0000:07:00.0' (e000000181664120): kobject_uevent_env
kobject: '0000:07:00.0' (e000000181664120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.0'
kobject: '0000:07:00.0' (e000000181664120): kobject_cleanup
kobject: '0000:07:00.0' (e000000181664120): calling ktype release
kobject: '0000:07:00.0': free name
kobject: '0000:07:00.1' (e000000181664920): kobject_uevent_env
kobject: '0000:07:00.1' (e000000181664920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.1'
kobject: '0000:07:00.1' (e000000181664920): kobject_cleanup
kobject: '0000:07:00.1' (e000000181664920): calling ktype release
kobject: '0000:07:00.1': free name
kobject: '0000:07' (e0000001801971b8): kobject_uevent_env
kobject: '0000:07' (e0000001801971b8): fill_kobj_path: path = '/class/pci_bus/0000:07'
kobject: '0000:05:04.0' (e000000181662920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:07' (e0000001801971b8): kobject_cleanup
kobject: '0000:07' (e0000001801971b8): calling ktype release
kobject: '0000:07': free name
aer 0000:05:04.0:pcie22: unloading service driver aer
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): kobject_uevent_env
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie22'
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): kobject_cleanup
kobject: '0000:05:04.0:pcie22' (e0000001830b0ab0): calling ktype release
kobject: '0000:05:04.0:pcie22': free name
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): kobject_uevent_env
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie28'
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): kobject_cleanup
kobject: '0000:05:04.0:pcie28' (e0000001830b0cb0): calling ktype release
kobject: '0000:05:04.0:pcie28': free name
kobject: '0000:05:04.0' (e000000181662920): kobject_uevent_env
kobject: '0000:05:04.0' (e000000181662920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:05:04.0' (e000000181662920): kobject_cleanup
kobject: '0000:05:04.0' (e000000181662920): calling ktype release
kobject: '0000:05:04.0': free name
kobject: '0000:05' (e0000001801969b8): kobject_uevent_env
kobject: '0000:05' (e0000001801969b8): fill_kobj_path: path = '/class/pci_bus/0000:05'
kobject: '0000:04:00.0' (e000000181661920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:05' (e0000001801969b8): kobject_cleanup
kobject: '0000:05' (e0000001801969b8): calling ktype release
kobject: '0000:05': free name
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): kobject_uevent_env
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:04:00.0:pcie18'
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): kobject_cleanup
kobject: '0000:04:00.0:pcie18' (e0000001830b04b0): calling ktype release
kobject: '0000:04:00.0:pcie18': free name
kobject: '0000:04:00.0' (e000000181661920): kobject_uevent_env
kobject: '0000:04:00.0' (e000000181661920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:04' (e0000001801965b8): kobject_uevent_env
kobject: '0000:04' (e0000001801965b8): fill_kobj_path: path = '/class/pci_bus/0000:04'
kobject: '0000:03:00.0' (e000000181661120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0'
kobject: '0000:04' (e0000001801965b8): kobject_cleanup
kobject: '0000:04' (e0000001801965b8): calling ktype release
kobject: '0000:04': free name
pci 0000:04:00.0: remove_callback ref: 1
kobject: '0000:04:00.0' (e000000181661920): kobject_cleanup
kobject: '0000:04:00.0' (e000000181661920): calling ktype release
kobject: '0000:04:00.0': free name
pci 0000:04:00.0: remove_callback e000000181661800 ref: 0

[remove succeeded, now rescan the PCI bus. we expect to find 0000:04:00.0
and all devices below it. this rescan is successful. Note kobject
e00000018cac2920 -- this is the device we're interested in.]
[root@tahitifp1 /sys/bus/pci]# echo 1 > rescan
kobject: '0000:04:00.0' (e00000018cac2920): kobject_add_internal: parent: '0000:03:00.0', set: 'devices'
kobject: '0000:04:00.0' (e00000018cac2920): kobject_uevent_env
kobject: '0000:04:00.0' (e00000018cac2920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): kobject_uevent_env
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:04:00.0:pcie18'
kobject: '0000:05:02.0' (e00000018cac6120): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:05:02.0' (e00000018cac6120): kobject_uevent_env
kobject: '0000:05:02.0' (e00000018cac6120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie22'
aer 0000:05:02.0:pcie22: service driver aer loaded
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie28'
kobject: '0000:05:04.0' (e00000018cac9920): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:05:04.0' (e00000018cac9920): kobject_uevent_env
kobject: '0000:05:04.0' (e00000018cac9920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): kobject_uevent_env
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie22'
aer 0000:05:04.0:pcie22: service driver aer loaded
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): kobject_uevent_env
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie28'
kobject: '0000:06:00.0' (e00000018cacc920): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:06:00.0' (e00000018cacc920): kobject_uevent_env
kobject: '0000:06:00.0' (e00000018cacc920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.0'
kobject: '0000:06:00.1' (e00000018cacf120): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'
kobject: '0000:06:00.1' (e00000018cacf120): kobject_uevent_env
kobject: '0000:06:00.1' (e00000018cacf120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.1'
kobject: '0000:06' (e000000181ded1b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:06' (e000000181ded1b8): kobject_uevent_env
kobject: '0000:06' (e000000181ded1b8): fill_kobj_path: path = '/class/pci_bus/0000:06'
kobject: '0000:05:02.0' (e00000018cac6120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:07:00.0' (e00000018cacb120): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:07:00.0' (e00000018cacb120): kobject_uevent_env
kobject: '0000:07:00.0' (e00000018cacb120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.0'
kobject: '0000:07:00.1' (e00000018cacd120): kobject_add_internal: parent: '0000:05:04.0', set: 'devices'
kobject: '0000:07:00.1' (e00000018cacd120): kobject_uevent_env
kobject: '0000:07:00.1' (e00000018cacd120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.1'
kobject: '0000:07' (e0000001801965b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:07' (e0000001801965b8): kobject_uevent_env
kobject: '0000:07' (e0000001801965b8): fill_kobj_path: path = '/class/pci_bus/0000:07'
kobject: '0000:05:04.0' (e00000018cac9920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:05' (e000000181dec1b8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:05' (e000000181dec1b8): kobject_uevent_env
kobject: '0000:05' (e000000181dec1b8): fill_kobj_path: path = '/class/pci_bus/0000:05'
kobject: '0000:04:00.0' (e00000018cac2920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:04' (e000000181defdb8): kobject_add_internal: parent: 'pci_bus', set: 'devices'
kobject: '0000:04' (e000000181defdb8): kobject_uevent_env
kobject: '0000:04' (e000000181defdb8): fill_kobj_path: path = '/class/pci_bus/0000:04'
kobject: '0000:03:00.0' (e000000181661120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0'

[rescan succeeded, time to remove again. again, note kobject e00000018cac2920]
[root@tahitifp1 /sys/bus/pci]# echo 1 > devices/0000\:04\:00.0/remove
kobject: '0000:06:00.0' (e00000018cacc920): kobject_uevent_env
kobject: '0000:06:00.0' (e00000018cacc920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.0'
kobject: '0000:06:00.0' (e00000018cacc920): kobject_cleanup
kobject: '0000:06:00.0' (e00000018cacc920): calling ktype release
kobject: '0000:06:00.0': free name
kobject: '0000:06:00.1' (e00000018cacf120): kobject_uevent_env
kobject: '0000:06:00.1' (e00000018cacf120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:06:00.1'
kobject: '0000:06:00.1' (e00000018cacf120): kobject_cleanup
kobject: '0000:06:00.1' (e00000018cacf120): calling ktype release
kobject: '0000:06:00.1': free name
kobject: '0000:06' (e000000181ded1b8): kobject_uevent_env
kobject: '0000:06' (e000000181ded1b8): fill_kobj_path: path = '/class/pci_bus/0000:06'
kobject: '0000:05:02.0' (e00000018cac6120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:06' (e000000181ded1b8): kobject_cleanup
kobject: '0000:06' (e000000181ded1b8): calling ktype release
kobject: '0000:06': free name
aer 0000:05:02.0:pcie22: unloading service driver aer
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie22'
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): kobject_cleanup
kobject: '0000:05:02.0:pcie22' (e000000184cf26b0): calling ktype release
kobject: '0000:05:02.0:pcie22': free name
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): kobject_uevent_env
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0/0000:05:02.0:pcie28'
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): kobject_cleanup
kobject: '0000:05:02.0:pcie28' (e000000184cf22b0): calling ktype release
kobject: '0000:05:02.0:pcie28': free name
kobject: '0000:05:02.0' (e00000018cac6120): kobject_uevent_env
kobject: '0000:05:02.0' (e00000018cac6120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:05:02.0' (e00000018cac6120): kobject_cleanup
kobject: '0000:05:02.0' (e00000018cac6120): calling ktype release
kobject: '0000:05:02.0': free name
kobject: '0000:07:00.0' (e00000018cacb120): kobject_uevent_env
kobject: '0000:07:00.0' (e00000018cacb120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.0'
kobject: '0000:07:00.0' (e00000018cacb120): kobject_cleanup
kobject: '0000:07:00.0' (e00000018cacb120): calling ktype release
kobject: '0000:07:00.0': free name
kobject: '0000:07:00.1' (e00000018cacd120): kobject_uevent_env
kobject: '0000:07:00.1' (e00000018cacd120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:07:00.1'
kobject: '0000:07:00.1' (e00000018cacd120): kobject_cleanup
kobject: '0000:07:00.1' (e00000018cacd120): calling ktype release
kobject: '0000:07:00.1': free name
kobject: '0000:07' (e0000001801965b8): kobject_uevent_env
kobject: '0000:07' (e0000001801965b8): fill_kobj_path: path = '/class/pci_bus/0000:07'
kobject: '0000:05:04.0' (e00000018cac9920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:07' (e0000001801965b8): kobject_cleanup
kobject: '0000:07' (e0000001801965b8): calling ktype release
kobject: '0000:07': free name
aer 0000:05:04.0:pcie22: unloading service driver aer
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): kobject_uevent_env
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie22'
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): kobject_cleanup
kobject: '0000:05:04.0:pcie22' (e000000184cf1cb0): calling ktype release
kobject: '0000:05:04.0:pcie22': free name
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): kobject_uevent_env
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0/0000:05:04.0:pcie28'
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): kobject_cleanup
kobject: '0000:05:04.0:pcie28' (e000000184cf18b0): calling ktype release
kobject: '0000:05:04.0:pcie28': free name
kobject: '0000:05:04.0' (e00000018cac9920): kobject_uevent_env
kobject: '0000:05:04.0' (e00000018cac9920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:04.0'
kobject: '0000:05:04.0' (e00000018cac9920): kobject_cleanup
kobject: '0000:05:04.0' (e00000018cac9920): calling ktype release
kobject: '0000:05:04.0': free name
kobject: '0000:05' (e000000181dec1b8): kobject_uevent_env
kobject: '0000:05' (e000000181dec1b8): fill_kobj_path: path = '/class/pci_bus/0000:05'
kobject: '0000:04:00.0' (e00000018cac2920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:05' (e000000181dec1b8): kobject_cleanup
kobject: '0000:05' (e000000181dec1b8): calling ktype release
kobject: '0000:05': free name
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): kobject_uevent_env
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:04:00.0:pcie18'
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): kobject_cleanup
kobject: '0000:04:00.0:pcie18' (e000000184cf2cb0): calling ktype release
kobject: '0000:04:00.0:pcie18': free name
kobject: '0000:04:00.0' (e00000018cac2920): kobject_uevent_env
kobject: '0000:04:00.0' (e00000018cac2920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:04' (e000000181defdb8): kobject_uevent_env
kobject: '0000:04' (e000000181defdb8): fill_kobj_path: path = '/class/pci_bus/0000:04'
kobject: '0000:03:00.0' (e000000181661120): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0'
kobject: '0000:04' (e000000181defdb8): kobject_cleanup
kobject: '0000:04' (e000000181defdb8): calling ktype release
kobject: '0000:04': free name
kobject: '0000:04:00.0' (e00000018cac2920): kobject_cleanup
kobject: '0000:04:00.0' (e00000018cac2920): calling ktype release
kobject: '0000:04:00.0': free name

[2nd remove complete -- note above that we called ktype release for
e00000018cac2920. 2nd rescan, and here's were we blow up. why is
that kobject e00000018cac2920 still hanging around?!?]
[root@tahitifp1 /sys/bus/pci]# echo 1 > rescan
kobject: '0000:04:00.0' (e00000018cac2920): kobject_add_internal: parent: '0000:03:00.0', set: 'devices'
kobject: '0000:04:00.0' (e00000018cac2920): kobject_uevent_env
kobject: '0000:04:00.0' (e00000018cac2920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0'
kobject: '0000:04:00.0:pcie18' (e000000184cf12b0): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x110/0x140()
Hardware name: server BL860c                   
sysfs: cannot create duplicate filename '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:04:00.0:pcie18/power'
Modules linked in: binfmt_misc dm_multipath pci_slot sg shpchp pci_hotplug dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd ohci_hcd ehci_hcd usbcore

Call Trace:
 [<a0000001000146d0>] show_stack+0x50/0xa0
                                sp=e00000018756f860 bsp=e000000187561818
 [<a000000100014750>] dump_stack+0x30/0x60
                                sp=e00000018756fa30 bsp=e000000187561800
 [<a00000010009a0f0>] warn_slowpath+0x130/0x180
                                sp=e00000018756fa30 bsp=e000000187561798
 [<a000000100230790>] sysfs_add_one+0x110/0x140
                                sp=e00000018756fb50 bsp=e000000187561760
 [<a000000100230900>] create_dir+0x80/0x120
                                sp=e00000018756fb50 bsp=e000000187561728
 [<a0000001002309d0>] sysfs_create_subdir+0x30/0x60
                                sp=e00000018756fb70 bsp=e0000001875616f8
 [<a0000001002333f0>] internal_create_group+0x130/0x400
                                sp=e00000018756fb70 bsp=e0000001875616a0
 [<a0000001002336f0>] sysfs_create_group+0x30/0x60
                                sp=e00000018756fb80 bsp=e000000187561678
 [<a000000100513b50>] dpm_sysfs_add+0x30/0x60
                                sp=e00000018756fb80 bsp=e000000187561658
 [<a0000001005043e0>] device_add+0xa00/0xd80
                                sp=e00000018756fb80 bsp=e0000001875615e0
 [<a000000100504790>] device_register+0x30/0x60
                                sp=e00000018756fb90 bsp=e0000001875615c0
 [<a00000010041e610>] pcie_port_device_register+0xa30/0xbc0
                                sp=e00000018756fb90 bsp=e000000187561510
 [<a000000100912060>] pcie_portdrv_probe+0xe0/0x140
                                sp=e00000018756fbd0 bsp=e0000001875614f0
 [<a000000100413a30>] local_pci_probe+0x70/0xa0
                                sp=e00000018756fbd0 bsp=e0000001875614d0
 [<a0000001004142b0>] pci_device_probe+0x210/0x280
                                sp=e00000018756fbd0 bsp=e000000187561490
 [<a00000010050be00>] driver_probe_device+0x3a0/0x5a0
                                sp=e00000018756fdf0 bsp=e000000187561450
 [<a00000010050c030>] __device_attach+0x30/0x60
                                sp=e00000018756fdf0 bsp=e000000187561428
 [<a0000001005094a0>] bus_for_each_drv+0xa0/0x140
                                sp=e00000018756fdf0 bsp=e0000001875613e0
 [<a00000010050c110>] device_attach+0xb0/0x100
                                sp=e00000018756fe00 bsp=e0000001875613b0
 [<a000000100509bd0>] bus_attach_device+0x70/0x100
                                sp=e00000018756fe00 bsp=e000000187561380
 [<a000000100504460>] device_add+0xa80/0xd80
                                sp=e00000018756fe00 bsp=e000000187561310
 [<a000000100408000>] pci_bus_add_device+0x20/0xa0
                                sp=e00000018756fe10 bsp=e0000001875612f0
 [<a000000100408260>] pci_bus_add_devices+0xe0/0x3a0
                                sp=e00000018756fe10 bsp=e0000001875612a8
 [<a000000100408450>] pci_bus_add_devices+0x2d0/0x3a0
                                sp=e00000018756fe10 bsp=e000000187561260
 [<a0000001009124c0>] pci_do_scan_bus+0x160/0x180
                                sp=e00000018756fe10 bsp=e000000187561220
 [<a000000100417f30>] bus_rescan_store+0xb0/0x120
                                sp=e00000018756fe10 bsp=e0000001875611e8
 [<a000000100508b50>] bus_attr_store+0x70/0xa0
                                sp=e00000018756fe20 bsp=e0000001875611b0
 [<a00000010022da00>] sysfs_write_file+0x240/0x2e0
                                sp=e00000018756fe20 bsp=e000000187561160
 [<a000000100187290>] vfs_write+0x1b0/0x2e0
                                sp=e00000018756fe20 bsp=e000000187561110
 [<a000000100187510>] sys_write+0x70/0xe0
                                sp=e00000018756fe20 bsp=e000000187561098
 [<a00000010000c560>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000018756fe30 bsp=e000000187561098
 [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000000187570000 bsp=e000000187561098
---[ end trace 60823c890ff5d765 ]---
kobject: '0000:04:00.0:pcie18' (e000000184cf12b0): kobject_uevent_env
kobject: '0000:04:00.0:pcie18' (e000000184cf12b0): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:04:00.0:pcie18'
kobject: '0000:05:02.0' (e00000018cac9920): kobject_add_internal: parent: '0000:04:00.0', set: 'devices'
kobject: '0000:05:02.0' (e00000018cac9920): kobject_uevent_env
kobject: '0000:05:02.0' (e00000018cac9920): fill_kobj_path: path = '/devices/pci0000:03/0000:03:00.0/0000:04:00.0/0000:05:02.0'
kobject: '0000:05:02.0:pcie22' (e000000184cf16b0): kobject_add_internal: parent: '0000:05:02.0', set: 'devices'


