Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbZDHULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbZDHULX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbZDHULN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:11:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35965 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbZDHULM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:11:12 -0400
Date: Wed, 8 Apr 2009 13:11:07 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com, mhiramat@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: BUG from text_poke() during CPU offlining
Message-ID: <20090408201107.GA11159@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into the below BUG with 32-bit 2.6.30-rc1 while offlining
all of the offlineable CPUs.  It happened when the last offlineable
CPUs was being offlined.  The problem disappeared after I reverted
the following two patches.
 - x86: implement atomic text_poke() via fixmap
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=78ff7fae04554b49d29226ed12536268c2500d1f
 - x86: expand irq-off region in text_poke()
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7cf49427042400d40bdc80b5c3399b6b5945afa8

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

           ...
Unmapping cpu 15 from all nodes
CPU 15 is now offline
SMP alternatives: switching to UP code
------------[ cut here ]------------
kernel BUG at arch/x86/kernel/alternative.c:543!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu15/online
Modules linked in: radeon drm ipv6 af_packet microcode fuse loop dm_mod i2c_piix4 i2c_core rtc_cmos tg3 rtc_core sworks_agp rtc_lib button joydev agpgart libphy pcspkr sr_mod cdrom sg usbhid hid sd_mod crc_t10dif ohci_hcd ehci_hcd aic94xx libsas scsi_transport_sas usbcore edd ext3 mbcache jbd fan ide_pci_generic serverworks ide_core ata_generic thermal processor thermal_sys hwmon pata_serverworks libata scsi_mod [last unloaded: speedstep_lib]

Pid: 7816, comm: cpus_offline_al Tainted: G        W  (2.6.30-rc1-gh-5-pae #2) IBM x3850-[88641RY]-
EIP: 0060:[<c0330161>] EFLAGS: 00010096 CPU: 0
EIP is at text_poke+0x1a6/0x1bf
EAX: 00000ff0 EBX: 00040800 ECX: f288de8f EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: f288de84 ESP: f288de64
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cpus_offline_al (pid: 7816, ti=f288c000 task=f29450a0 task.ti=f288c000)
Stack:
 00000001 f288de8f f7ca57b4 00000286 f6f5ea20 f7cb9a9c f7ca5000 f7cb9ae8
 f288de9c c0106563 3e88de9c f377c840 00000000 c0332e2d f288dec4 c01066ae
 f7caf9c4 00000000 c04e1744 c0532468 00000000 c0532468 00000000 c03f9259
Call Trace:
 [<f7ca57b4>] ? scsi_dispatch_cmd+0x15/0x1ee [scsi_mod]
 [<f7ca5000>] ? scsi_device_type+0x0/0x2c [scsi_mod]
 [<c0106563>] ? alternatives_smp_unlock+0x40/0x57
 [<c0332e2d>] ? _etext+0x0/0x3
 [<c01066ae>] ? alternatives_smp_switch+0x134/0x164
 [<f7caf9c4>] ? scsi_proc_hostdir_add+0x5f/0xa1 [scsi_mod]
 [<c010e88b>] ? native_cpu_die+0x44/0x6b
 [<c0320576>] ? _cpu_down+0x172/0x24d
 [<c0320692>] ? cpu_down+0x41/0x72
 [<c0321b14>] ? store_online+0x25/0x59
 [<c0321aef>] ? store_online+0x0/0x59
 [<c029397f>] ? sysdev_store+0x1b/0x23
 [<c01db772>] ? sysfs_write_file+0xb0/0xdb
 [<c01db6c2>] ? sysfs_write_file+0x0/0xdb
 [<c019d7c7>] ? vfs_write+0x8c/0x136
 [<c019d90a>] ? sys_write+0x3b/0x60
 [<c0102930>] ? sysenter_do_call+0x12/0x22
Code: b8 c8 06 00 00 e8 45 89 de ff 5b 5e 0f 20 d8 0f 22 d8 b8 01 00 00 00 0f a2 31 d2 eb 13 8b 4d e8 8a 04 11 8b 4d e4 3a 04 11 74 04 <0f> 0b eb fe 42 3b 55 e0 72 e8 ff 75 ec 9d 8b 45 e8 8d 65 f4 5b
EIP: [<c0330161>] text_poke+0x1a6/0x1bf SS:ESP 0068:f288de64
---[ end trace ba8fcc89e8d7a9dc ]---

