Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbXJ3WWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbXJ3WWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXJ3WWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:22:12 -0400
Received: from msgbas2x.cos.agilent.com ([192.25.240.37]:51030 "EHLO
	msgbas2x.cos.agilent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXJ3WWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:22:11 -0400
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 18:22:10 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: fakephp problem in 2.6.22 (and 2.6.21)
Date: Tue, 30 Oct 2007 16:00:26 -0600
Message-ID: <BD63C848ECB98D4582D05FFF2C79CFF2433817@cos-us-mb01.cos.agilent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fakephp problem in 2.6.22 (and 2.6.21)
Thread-Index: AcgbQEcc0PBzsLZNRdujN/XY+keZmw==
From: <john_flowers@agilent.com>
To: <linux-pci@atrey.karlin.mff.cuni.cz>
Cc: <linux-kernel@vger.kernel.org>, <greg@kroah.com>, <jdittmer@ppp0.net>
X-OriginalArrivalTime: 30 Oct 2007 22:00:27.0289 (UTC) FILETIME=[47956890:01C81B40]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux PCI,

Kernel Version(s): 2.6.22 (Ubuntu 7.10) and 2.6.21 (Fedora Core 7)

I am trying to use fakephp to rescan the PCI bus when I reload my PCI Interface FPGA.

When I reload the FPGA, lspci shows "[disabled]" for the original Base Address Regions. My hope is that a rescan will re-enumerate the bus and fill in the PCI Settings on the FPGA interface. In fact, I can use setpci to re-enable the board after loading FPGA, but only if I have not changed any of the core parameters. I would hope that a rescan would read the possibly changed core parameters and reallocate memory as needed.

fakephp is loaded in to the kernel using "modprobe fakephp debug=1" as advised in order to get debug information in dmesg.

dmesg indicates fakephp is installed

fakephp: Fake PCI Hot Plug Controller Driver
fakephp: slot->name = 0000:00:00.0
...
fakephp: slot->name = 0000:03:00.0
fakephp: slot->name = 0000:06:03.0

my FPGA board is connected via PCI Express to bus 3 so I issue the following command

echo 1 > /sys/bus/pci/slots/0000\:03\:00.0/power
-bash: echo: write error: No such device

lspci still shows that the BAR on 03:0.0 are still disabled, and dmesg gives no other indications.

writing a 1 to any other device/slot seems to have no effect.

writing a 0 to this power file causes the terminal to hang, but something does happen in dmesg.

echo 0 > /sys/bus/pci/slots/0000\:03\:00.0/power ***TERMINAL HANG***

(open another terminal)
last few lines of dmesg 
fakephp: disable_slot - physical_slot = 0000:03:00.0
fakephp: No device in slot found
fakephp: No device in slot found
fakephp: No device in slot found
fakephp: No device in slot found
fakephp: No device in slot found
fakephp: No device in slot found
fakephp: No device in slot found
fakephp: removing slot 0000:03:00.0

Now echo 1 > /sys/bus/pci/slots/0000\:03\:00.0/power ***TERMINAL HANG***

(open another terminal)
no change in dmesg
echo 1 > /sys/bus/pci/slots/0000\:06\:03.0/power
-bash: echo: write error: No such device

now dmesg has a lot of detail:

fakephp: New device on PCI Bus #03 function 0:0
fakephp: slot->name = 0000:03:00.0
kobject_add failed for 0000:03:00.0 with -EEXIST, don't try to register things with the same name in the same directory.
 [<c04e376b>] kobject_shadow_add+0x153/0x185
 [<c04e3873>] kobject_register+0x19/0x30
 [<c04f48b5>] pci_hp_register+0x88/0x294
 [<f8d9921d>] add_slot+0xb3/0x10c [fakephp]
 [<f8d99377>] pci_rescan_buses+0x101/0x222 [fakephp]
 [<f8d9947c>] pci_rescan_buses+0x206/0x222 [fakephp]
 [<f8d994a2>] enable_slot+0xa/0x10 [fakephp]
 [<c04f4b55>] power_write_file+0x94/0xcd
 [<c04f4ac1>] power_write_file+0x0/0xcd
 [<c04f4042>] hotplug_slot_attr_store+0x1e/0x22
 [<c04abb8e>] sysfs_write_file+0xbd/0xe7
 [<c04abad1>] sysfs_write_file+0x0/0xe7
 [<c0475d33>] vfs_write+0xa8/0x154
 [<c0476342>] sys_write+0x41/0x67
 [<c0404f70>] syscall_call+0x7/0xb
 =======================
pci_hotplug: Unable to register kobject<3>fakephp: pci_hp_register failed with error -22

lspci still shows that my FPGA board BAR is "[disabled]"

Any advice would be appreciated.

John
