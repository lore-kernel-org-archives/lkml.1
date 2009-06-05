Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZFEUdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZFEUdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZFEUdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:33:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43545 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbZFEUdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:33:17 -0400
In-Reply-To: <4A2950F0.5050309@in.ibm.com>
References: <4A2950F0.5050309@in.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [IMA] 2.6.30-rc8 : Bug while trying to launch a KVM guest
X-KeepSent: 64D7363D:C87FDEC1-852575CC:006F30A6;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF64D7363D.C87FDEC1-ON852575CC.006F30A6-852575CC.0070CAE8@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 5 Jun 2009 16:31:59 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 06/05/2009 16:31:59,
	Serialize complete at 06/05/2009 16:31:59
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant <sachinp@in.ibm.com> wrote on 06/05/2009 01:08:00 PM:

> I had a x86_64 machine running 2.6.30-rc7-git4 as a KVM Host.
> I configured a KVM guest and was able to boot the guest.
> 
> On the KVM host i compiled a 2.6.30-rc8 kernel with
> CONFIG_IMA=y and rebooted the machine into that kernel.
> 
> When i tried to launch the KVM guest with 2.6.30-rc8 kernel
> ran into following BUG.

This bug has been addressed in linux-next. Please refer to:

f06dd16a03f6f7f72fab4db03be36e28c28c6fd6 : IMA: Handle dentry_open 
failures
1a62e958fa4aaeeb752311b4f5e16b2a86737b23 : IMA: open all files O_LARGEFILE
04288f42033607099cebf5ca15ce8dcec3a9688b : integrity: ima audit 
dentry_open failure

The default policy in 2.6.30 measures all files open for read by root.
(So starting the VM as root will cause it to be read.)  This linux-next
patch changes the default behavior so that nothing is measured. 

5789ba3bd0a3cd20df5980ebf03358f2eb44fd67 :  IMA: Minimal IMA policy and 
boot param for TCB IMA policy

Mimi Zohar
 
> # qemu-system-x86_64 -hda /local/kvmtest/rhel53.img  -m 512
> rhel53.img dentry_open failed
> BUG: unable to handle kernel paging request at ffffffffffffffe5
> IP: [<ffffffff802cde9d>] fput+0x8/0x1a
> PGD 203067 PUD 204067 PMD 0 
> Oops: 0002 [#2] SMP 
> last sysfs file: 
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> CPU 1 
> Modules linked in: kvm_amd kvm ipv6 sr_mod cdrom fuse loop dm_mod 
ums_cypress
> bnx2 sg mptctl i2c_piix4 rtc_cmos pcspkr usb_storage button serio_raw 
rtc_core
> i2c_core rtc_lib shpchp k8temp pci_hotplug usbhid hid ohci_hcd ehci_hcd 
sd_mod
> crc_t10dif usbcore edd ext3 jbd fan thermal processor thermal_sys hwmon 
mptsas
> mptscsih mptbase scsi_transport_sas scsi_mod
> Pid: 3068, comm: qemu-system-x86 Tainted: G      D    2.6.30-rc8 #1 
BladeCenter
> LS21 -[79716AA]-
> RIP: 0010:[<ffffffff802cde9d>]  [<ffffffff802cde9d>] fput+0x8/0x1a
> RSP: 0018:ffff880128d6dd88  EFLAGS: 00010282
> RAX: ffffffffffffffe5 RBX: ffff880128d2a580 RCX: 0000000000000ccb
> RDX: ffff88002803c000 RSI: 0000000000000046 RDI: ffffffffffffffb5
> RBP: ffff880128d6dd88 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff8800000be360 R11: ffff880128d6db78 R12: ffff88012db6ad60
> R13: ffffffffffffffb5 R14: ffff880128d6de48 R15: ffff88012db6ac00
> FS:  00007f60db16b6f0(0000) GS:ffff88002803c000(0000) 
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffffffffffffe5 CR3: 0000000128d11000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process qemu-system-x86 (pid: 3068, threadinfo ffff880128d6c000, task
> ffff88012c9f1880)
> Stack:
>  ffff880128d6ddc8 ffffffff803ac6f1 ffff880128d2a5a8 ffff880126805fc0
>  0000000000009001 0000000000000004 ffff880128d6de48 ffff88012db6acc0
>  ffff880128d6de08 ffffffff802d5f3c ffff880128d6de08 0000000000000000
> Call Trace:
>  [<ffffffff803ac6f1>] ima_path_check+0x1a5/0x1c3
>  [<ffffffff802d5f3c>] may_open+0xc1/0x278
>  [<ffffffff802d8620>] do_filp_open+0x498/0x914
>  [<ffffffff802abd89>] ? handle_mm_fault+0x35b/0x75e
>  [<ffffffff802cb0c9>] ? fd_install+0x30/0x60
>  [<ffffffff802e0abd>] ? alloc_fd+0x6d/0x117
>  [<ffffffff802cb295>] do_sys_open+0x56/0xd6
>  [<ffffffff802cb33e>] sys_open+0x1b/0x1d
>  [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
> Code: ff 74 13 41 c7 87 cc 00 00 00 00 00 00 00 4c 89 ff e8 86 43 01 00 
41 58
> 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 48 8d 47 30 48 89 e5 <f0> 48 ff 08 
0f 94 c2
> 84 d2 74 05 e8 47 fe ff ff c9 c3 55 48 89 
> RIP  [<ffffffff802cde9d>] fput+0x8/0x1a
>  RSP <ffff880128d6dd88>
> CR2: ffffffffffffffe5
> ---[ end trace 65e02cf766f19c9b ]---
> 
> Let me know if some more information is required.
> 
> Thanks
> -Sachin
> 
> -- 
> 
> ---------------------------------
> Sachin Sant
> IBM Linux Technology Center
> India Systems and Technology Labs
> Bangalore, India
> ---------------------------------
> 

