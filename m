Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYCNOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYCNOqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYCNOqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:46:14 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14917 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772AbYCNOqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:46:11 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JXQ6CD-02-BPD-01
Date: Fri, 14 Mar 2008 15:45:59 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: panic caused by 653a00c9662304ef72a3eb4e681c91720960e0b4
	(ACPI:thermal fixup)
Message-ID: <20080314144559.GD22740@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Mar 2008 14:45:54.0564 (UTC) FILETIME=[1B354C40:01C885E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have seen a panic with current kernels in the acpi_thermal code.
Bisecting shows that it is due to commit 
653a00c9662304ef72a3eb4e681c91720960e0b4 (ACPI: thermal fixup)

The kernel before this commit works and I have this messages:

 ACPI: ACPI0007:00 is registered as cooling_device0
 ACPI: Processor [C000] (supports 8 throttling states)
 ACPI: ACPI0007:01 is registered as cooling_device1
 ACPI: ACPI0007:02 is registered as cooling_device2
 ACPI: ACPI0007:03 is registered as cooling_device3
 ACPI: LNXTHERM:01 is registered as thermal_zone0
 ACPI: Thermal Zone [THRM] (26 C)

I.e. one thermal_zone device registered.
With above commit I get this panic:

 ACPI: ACPI0007:00 is registered as cooling_device0
 ACPI: Processor [C000] (supports 8 throttling states)
 ACPI: ACPI0007:01 is registered as cooling_device1
 ACPI: ACPI0007:02 is registered as cooling_device2
 ACPI: ACPI0007:03 is registered as cooling_device3
 general protection fault: 0000 [1] SMP
 CPU 0
 Modules linked in:
 Pid: 1, comm: swapper Not tainted 2.6.24-06491-g653a00c-dirty #21
 RIP: 0010:[<ffffffff81161813>]  [<ffffffff81161813>] acpi_ns_map_handle_to_node+\
 0x14/0x1d
 RSP: 0000:ffff81007eb7fc58  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000001001 RCX: 0000000000000000
 RDX: 0000000000004a21 RSI: ffffc200002a32f8 RDI: 4d52454854584e4c
 RBP: 4d52454854584e4c R08: ffff81007d876460 R09: 0000000000000000
 R10: 0000000000000246 R11: ffff81007eb637d0 R12: ffff81007eb7fcd0
 R13: ffffffff8116ae54 R14: 0000000000000002 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffffffff814b3000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process swapper (pid: 1, threadinfo ffff81007eb7e000, task ffff81007eb637d0)
 Stack:  ffffffff81160cae 00000000fffffff4 ffff81007eb7fcd0 ffff81007d87a800
  0000000000000000 ffff81007eb7fcd0 ffffffff8116a6ac 0000000000000001
  ffffffff81175f9f ffff81007d876460 ffffffff812337f7 ffff81007d879c00
 Call Trace:
  [<ffffffff81160cae>] ? acpi_get_data+0x3e/0x6e
  [<ffffffff8116a6ac>] ? acpi_bus_get_device+0x1d/0x2e
  [<ffffffff81175f9f>] ? acpi_thermal_cooling_device_cb+0x67/0x16b
  [<ffffffff812337f7>] ? thermal_zone_bind_cooling_device+0x0/0x1f3
  [<ffffffff81233532>] ? thermal_zone_device_register+0x243/0x2b7
  [<ffffffff8117620c>] ? acpi_thermal_add+0x151/0x40e
  [<ffffffff8116c1de>] ? acpi_device_probe+0x43/0x91
  [<ffffffff8119d768>] ? driver_probe_device+0xb5/0x132
  [<ffffffff8119d92d>] ? __driver_attach+0x90/0xcd
  [<ffffffff8119d89d>] ? __driver_attach+0x0/0xcd
  [<ffffffff8119d89d>] ? __driver_attach+0x0/0xcd
  [<ffffffff8119caf4>] ? bus_for_each_dev+0x44/0x6f
  [<ffffffff8119d393>] ? bus_add_driver+0xae/0x1f7
  [<ffffffff8119db86>] ? driver_register+0x59/0xce
  [<ffffffff814e6447>] ? acpi_thermal_init+0x61/0x84
  [<ffffffff814d26f2>] ? kernel_init+0x175/0x2df
  [<ffffffff8100cc48>] ? child_rip+0xa/0x12
  [<ffffffff814d257d>] ? kernel_init+0x0/0x2df
  [<ffffffff8100cc3e>] ? child_rip+0x0/0x12
 
 
 Code: 00 c3 49 ff c1 48 83 c6 04 41 ff c8 45 85 c0 75 a8 31 c0 c6 06 00 c3 48 8d\
  47 ff 48 83 f8 fd 76 08 48 8b 05 e0 bf 42 00 c3 31 c0 <80> 7f 08 0f 48 0f 44 c7\
  c3 48 89 f8 c3 31 c0 48 85 ff 74 0d f6
 RIP  [<ffffffff81161813>] acpi_ns_map_handle_to_node+0x14/0x1d
  RSP <ffff81007eb7fc58>
 ---[ end trace 778e504de7e3b1e3 ]---
 Kernel panic - not syncing: Attempted to kill init!

Of course when booting the kernel with thermal.off=1 there is no
panic.  I am not sure wether the thermal zone info is correctly set up
as I am not that familar with it but of course the kernel should not
panic.

I've done a test run with all the acpi.debug stuff enabled (even the
function traces, which produced much too much output).
Maybe the most important lines of that debug output are:

 nsutils-0869 [00] ns_get_node           : _HOT, AE_NOT_FOUND
 nsutils-0869 [00] ns_get_node           : _AC0, AE_NOT_FOUND
 nsutils-0869 [00] ns_get_node           : _TZD, AE_NOT_FOUND
 nsutils-0869 [00] ns_get_node           : _SCP, AE_NOT_FOUND
 nsutils-0869 [00] ns_get_node           : _TZP, AE_NOT_FOUND

Any ideas what's happening here?


Thanks,

Andreas


