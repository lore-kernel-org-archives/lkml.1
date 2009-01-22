Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZAVGIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZAVGIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZAVGIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:08:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZAVGIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:08:24 -0500
Message-ID: <49780D3D.5030406@suse.com>
Date: Thu, 22 Jan 2009 01:07:57 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [BUG] Page table corruption from commit 9542ada803198e6eba29d3289abb39ea82047b92.
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Suresh -

I'm running into the following dump on one of my development nodes. I've
bisected it down to commit 9542ada803198e6eba29d3289abb39ea82047b92. The
SUSE hwinfo tool can reproduce this readily, at least on my system. I'd
be happy to try any test fixes.

Here's from the bisection run, 2.6.27-rc6.

hwinfo: Corrupted page table at address 7f388590d000
PGD 1f88cf067 PUD 1f88ce067 PMD 1fb4e6067 PTE ffffffffffffffff
Bad pagetable: 000d [1] SMP 
CPU 3 
Modules linked in: ipv6 af_packet fuse loop dm_mod tg3 sg rtc_cmos shpchp i2c_amd756 i2c_amd8111 rtc_core sr_mod pcspkr ppdev parport_pc serio_raw i2c_core button rtc_lib k8temp amd_rng cdrom parport pci_hotplug floppy sd_mod ohci_hcd crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic pata_amd sata_sil libata scsi_mod thermal processor thermal_sys hwmon
Pid: 5869, comm: hwinfo Not tainted 2.6.27-rc6-vanilla #13
RIP: 0033:[<00007f38850dbd3e>]  [<00007f38850dbd3e>] 0x7f38850dbd3e
RSP: 002b:00007fff8d9a7fa8  EFLAGS: 00010202
RAX: 0000000000651820 RBX: 0000000000001000 RCX: fefefefefefefeff
RDX: 0000000000000001 RSI: 00007f388590d000 RDI: 0000000000651820
RBP: 000000000009d000 R08: ffffffffff000000 R09: 00007f38853b0a00
R10: ffffffffffffffff R11: 0000000000000000 R12: 00007f3885427fb6
R13: 0000000000609010 R14: 00007f388590d000 R15: 0000000000000005
FS:  00007f388598f740(0000) GS:ffff8801ffb54a40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f388590d000 CR3: 00000000f5014000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hwinfo (pid: 5869, threadinfo ffff8801fb5d4000, task ffff8801f895c4c0)

RIP  [<00007f38850dbd3e>] 0x7f38850dbd3e
 RSP <00007fff8d9a7fa8>
- ---[ end trace 7aaf64f58d755288 ]---

.. and with 2.6.29-rc2, but I'm seeing another warning first:

- ------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:620 reserve_pfn_range+0x5b/0x26d()
Hardware name: To Be Filled By O.E.M.
Modules linked in: ipv6 af_packet fuse loop dm_mod tg3 sg ppdev i2c_amd8111 i2c_amd756 shpchp rtc_cmos sr_mod parport_pc rtc_core rtc_lib button cdrom pci_hotplug serio_raw pcspkr floppy parport i2c_core amd_rng k8temp sd_mod ohci_hcd crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic pata_amd sata_sil libata scsi_mod thermal processor thermal_sys hwmon
Pid: 5532, comm: hwinfo Not tainted 2.6.29-rc2-vanilla #16
Call Trace:
 [<ffffffff80242053>] warn_slowpath+0xb1/0xed
 [<ffffffff802b5ea2>] ? vm_unmap_aliases+0x17c/0x18e
 [<ffffffff8022ba43>] ? lookup_address+0x1dd/0x209
 [<ffffffff80264ad1>] ? smp_call_function_many+0x1f0/0x210
 [<ffffffff8022b84c>] ? __cpa_flush_range+0x0/0x1a
 [<ffffffff8022dd92>] reserve_pfn_range+0x5b/0x26d
 [<ffffffff8022dfef>] track_pfn_vma_new+0x4b/0xb7
 [<ffffffff802aad2e>] remap_pfn_range+0xb5/0x50e
 [<ffffffff8022b2ae>] ? ioremap_change_attr+0x18/0x28
 [<ffffffff8022e3b3>] ? phys_mem_access_prot_allowed+0x100/0x1a9
 [<ffffffff802c88a1>] ? __dentry_open+0x174/0x265
 [<ffffffff803cac46>] mmap_mem+0x75/0x9d
 [<ffffffff802afff8>] mmap_region+0x2a3/0x52a
 [<ffffffff802b058c>] do_mmap_pgoff+0x30d/0x370
 [<ffffffff804a284b>] ? __down_write_nested+0x45/0xe1
 [<ffffffff8021052c>] sys_mmap+0x92/0xce
 [<ffffffff8020c42a>] system_call_fastpath+0x16/0x1b
- ---[ end trace 504e1a061d49152d ]---
hwinfo: Corrupted page table at address 7f8f68c5f000
PGD 1fe474067 PUD 1fe970067 PMD 1f900d067 PTE fffffffffffffbff
Bad pagetable: 000d [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:09.1/class
CPU 3 
Modules linked in: ipv6 af_packet fuse loop dm_mod tg3 sg ppdev i2c_amd8111 i2c_amd756 shpchp rtc_cmos sr_mod parport_pc rtc_core rtc_lib button cdrom pci_hotplug serio_raw pcspkr floppy parport i2c_core amd_rng k8temp sd_mod ohci_hcd crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic pata_amd sata_sil libata scsi_mod thermal processor thermal_sys hwmon
Pid: 5532, comm: hwinfo Tainted: G        W  2.6.29-rc2-vanilla #16
RIP: 0033:[<00007f8f6842dd3e>]  [<00007f8f6842dd3e>] 0x7f8f6842dd3e
RSP: 002b:00007fff70cf82d8  EFLAGS: 00010202
RAX: 0000000000652280 RBX: 0000000000001000 RCX: fefefefefefefeff
RDX: 0000000000000001 RSI: 00007f8f68c5f000 RDI: 0000000000652280
RBP: 000000000009d000 R08: ffffffffff000000 R09: 00007f8f68702a00
R10: ffffffffffffffff R11: 0000000000000000 R12: 00007f8f68779fb6
R13: 0000000000609010 R14: 00007f8f68c5f000 R15: 0000000000000005
FS:  00007f8f68ce1740(0000) GS:ffff8801ff209b40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f8f68c5f000 CR3: 00000001fdd19000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hwinfo (pid: 5532, threadinfo ffff8801fe938000, task ffff8801f907a040)

RIP  [<00007f8f6842dd3e>] 0x7f8f6842dd3e
 RSP <00007fff70cf82d8>
- ---[ end trace 504e1a061d49152e ]---

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl4DT0ACgkQLPWxlyuTD7LbpQCeK6aVOiHY4niprseJatUm27w5
OHsAnjbO9btEuudeeeqVWxsVfa3yiUzU
=MJvA
-----END PGP SIGNATURE-----
