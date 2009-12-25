Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZLYUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZLYUs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZLYUsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:48:25 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56849 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbZLYUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kP1kxFiYa8hXKxSfxoEi8Q9ZCAvq2XTfGUYqPJXaiNTNno2cMSVQ6MgLArj0hW9+1U
         GjuSJgxwrh7EtQZfMigcc4VQLdTGhOFsngbDQFXnWeNAQDpTIbOYqjspivDe3WQzh02+
         swQwitEImQr/cBYcNsR0/JBXzFUwJ35SFj9nc=
Message-ID: <4B352513.90302@lwfinger.net>
Date: Fri, 25 Dec 2009 14:48:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Regression in module wmi since 2.6.32 (bisected to commit 1caab3c)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.32, the module wmi fails to load on my x86_64 system. The problem has
been bisected to the following commit:

commit 1caab3c1a90be3aa4ec3599409d8fe044b077478
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed Nov 4 14:17:53 2009 -0500

    wmi: Add support for module autoloading

    WMI provides interface-specific GUIDs that are exported from modules as
    modalises, but the core currently generates no events to trigger module
    loading. This patch adds support for registering devices for each WMI GUID
    and generating the appropriate uevent.

    Based heavily on a patch by Carlos Corbacho (<carlos@strangeworlds.co.uk>).

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

This bug has an unfortunate side effect. If the module is allowed to autoload,
loading of firmware is affected and symptoms similar to those of Bugzilla No.
14844. I'm still waiting for the OP to report if this is his problem, or if he
has a different issue. If I blacklist wmi, the system will boot.

If I modprobe wmi after the system is booted, the specific messages are as follows:

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:477 sysfs_add_one+0xd6/0xee()
Hardware name: System Product Name
sysfs: cannot create duplicate filename
'/devices/virtual/wmi/05901221-D566-11D1-B2F0-00A0C9062910'
Modules linked in: wmi(+) binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq
snd_seq_device nfs nfsd lockd nfs_acl auth_rpcgss sunrpc cpufreq_conservative
cpufreq_userspace cpufreq_powersave powernow_k8 fuse xfs exportfs loop dm_mod
ide_cd_mod cdrom ata_generic pata_amd snd_hda_codec_nvhdmi snd_hda_codec_via
ide_pci_generic tuner_simple tuner_types tda9887 tda8290 arc4 snd_hda_intel ecb
snd_hda_codec tuner tvp5150 b43 saa7115 msp3400 mac80211 ivtv i2c_algo_bit
ir_kbd_i2c snd_hwdep snd_pcm cfg80211 cx2341x snd_timer em28xx v4l2_common
videobuf_vmalloc videodev led_class v4l1_compat snd amd74xx usbhid videobuf_core
v4l2_compat_ioctl32 usblp video rtc_cmos soundcore hid tveeprom output ide_core
serio_raw shpchp ssb button k8temp pcspkr rtc_core snd_page_alloc floppy
forcedeth sg i2c_core rtc_lib pci_hotplug ohci_hcd ehci_hcd sd_mod crc_t10dif
usbcore edd ahci libata scsi_mod ext3 mbcache jbd fan thermal processor
thermal_sys hwmon
Pid: 3928, comm: modprobe Not tainted 2.6.33-rc2 #54
Call Trace:
 [<ffffffff81136757>] ? sysfs_add_one+0xd6/0xee
 [<ffffffff810405a1>] warn_slowpath_common+0x77/0xa4
 [<ffffffff8104061b>] warn_slowpath_fmt+0x3c/0x3e
 [<ffffffff81136757>] sysfs_add_one+0xd6/0xee
 [<ffffffff81136d1f>] create_dir+0x58/0x93
 [<ffffffff81136d92>] sysfs_create_dir+0x38/0x4f
 [<ffffffff811855db>] ? kobject_get+0x1a/0x22
 [<ffffffff81185722>] kobject_add_internal+0xd6/0x196
 [<ffffffff811858ba>] kobject_add_varg+0x41/0x4e
 [<ffffffff8118d85d>] ? kvasprintf+0x45/0x6e
 [<ffffffff81185982>] kobject_add+0x64/0x66
 [<ffffffff81213593>] ? get_device_parent+0xac/0x14b
 [<ffffffff81214586>] device_add+0xc9/0x539
 [<ffffffff811853ab>] ? kobject_init+0x43/0x83
 [<ffffffff81214a0f>] device_register+0x19/0x1d
 [<ffffffffa02042ca>] acpi_wmi_init+0x12b/0x19b [wmi]
 [<ffffffff8105d3ff>] ? up_read+0x9/0xb
 [<ffffffffa020419f>] ? acpi_wmi_init+0x0/0x19b [wmi]
 [<ffffffff810001f0>] do_one_initcall+0x5a/0x14a
 [<ffffffff810704c9>] sys_init_module+0xd0/0x229
 [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
---[ end trace 8700152a35cf1eac ]---
kobject_add_internal failed for 05901221-D566-11D1-B2F0-00A0C9062910 with
-EEXIST, don't try to register things with the same name in the same directory.
Pid: 3928, comm: modprobe Tainted: G        W  2.6.33-rc2 #54
Call Trace:
 [<ffffffff811857c9>] kobject_add_internal+0x17d/0x196
 [<ffffffff811858ba>] kobject_add_varg+0x41/0x4e
 [<ffffffff8118d85d>] ? kvasprintf+0x45/0x6e
 [<ffffffff81185982>] kobject_add+0x64/0x66
 [<ffffffff81213593>] ? get_device_parent+0xac/0x14b
 [<ffffffff81214586>] device_add+0xc9/0x539
 [<ffffffff811853ab>] ? kobject_init+0x43/0x83
 [<ffffffff81214a0f>] device_register+0x19/0x1d
 [<ffffffffa02042ca>] acpi_wmi_init+0x12b/0x19b [wmi]
 [<ffffffff8105d3ff>] ? up_read+0x9/0xb
 [<ffffffffa020419f>] ? acpi_wmi_init+0x0/0x19b [wmi]
 [<ffffffff810001f0>] do_one_initcall+0x5a/0x14a
 [<ffffffff810704c9>] sys_init_module+0xd0/0x229
 [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff81219e37>] device_pm_remove+0x34/0x52
PGD 11c47e067 PUD 114eca067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 1
Pid: 3928, comm: modprobe Tainted: G        W  2.6.33-rc2 #54 M3N78-VM/System
Product Name
RIP: 0010:[<ffffffff81219e37>]  [<ffffffff81219e37>] device_pm_remove+0x34/0x52
RSP: 0018:ffff88011c071e28  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff880114e4f800 RCX: ffff880114e4f8a0
RDX: 0000000000000000 RSI: ffffffffa01fbb8c RDI: ffffffff8178f490
RBP: ffff88011c071e38 R08: ffff88011c071e18 R09: ffff88011c071d88
R10: ffff88011c071e68 R11: ffff88011c071e88 R12: ffff88011c342640
R13: 0000000000000000 R14: 00000000ffffffef R15: 0000000000000200
FS:  00007f279c8c16f0(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 00000001166ab000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 3928, threadinfo ffff88011c070000, task ffff88011adf0340)
Stack:
 ffff880114e4fa10 ffff880114e4f800 ffff88011c071e68 ffffffff812142b2
<0> ffff88011c071e68 ffff880114e4f800 ffff88011c342640 ffff88011c342640
<0> ffff88011c071e88 ffffffff8121442e ffff88011c071e88 ffff880114e4f800
Call Trace:
 [<ffffffff812142b2>] device_del+0x3c/0x1a7
 [<ffffffff8121442e>] device_unregister+0x11/0x1e
 [<ffffffffa01fb3ec>] wmi_class_exit+0x2c/0x51 [wmi]
 [<ffffffffa020430c>] acpi_wmi_init+0x16d/0x19b [wmi]
 [<ffffffff8105d3ff>] ? up_read+0x9/0xb
 [<ffffffffa020419f>] ? acpi_wmi_init+0x0/0x19b [wmi]
 [<ffffffff810001f0>] do_one_initcall+0x5a/0x14a
 [<ffffffff810704c9>] sys_init_module+0xd0/0x229
 [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
Code: c7 c7 90 f4 78 81 48 83 ec 08 e8 a2 f1 0a 00 48 8b 83 a8 00 00 00 48 8b 93
a0 00 00 00 48 8d 8b a0 00 00 00 48 c7 c7 90 f4 78 81 <48> 89 42 08 48 89 10 48
89 8b a8 00 00 00 48 89 8b a0 00 00 00
RIP  [<ffffffff81219e37>] device_pm_remove+0x34/0x52
 RSP <ffff88011c071e28>
CR2: 0000000000000008
---[ end trace 8700152a35cf1ead ]---

Larry

