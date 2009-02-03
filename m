Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZBCIt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZBCIt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZBCItq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:49:46 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:12460 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbZBCItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:49:45 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] Suspend tries to suspend devices already in D3
Date: Tue, 3 Feb 2009 09:49:41 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030949.42342.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2009 08:49:42.0995 (UTC) FILETIME=[5B6D2A30:01C985DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second time I've hit this warning on an STR. Most times
I do *not* get the warning. The first line is an extra debug printk I added
after the first occurrence to give me the driver causing the problem.

What is different is that before this suspend I had switched to my wired
e1000e NIC and had done an ifdown on the wireless. I suspect that because
of that the wireless already was at D3 _before_ the suspend was started.

Could this be the same issue as reported by Ming Lei?

Kernel is v2.6.29-rc3-100-gf2257b7 with the following relevant extra patches:
- PCI PM: Fix suspend error paths and testing facility breakage
- ricoh_mmc: Use suspend_late/resume_early

Cheers,
FJP

kernel: iwlagn 0000:10:00.0: has incorrect power state
kernel: ------------[ cut here ]------------
kernel: WARNING: at drivers/pci/pci-driver.c:375 pci_legacy_suspend+0xd4/0x119()
kernel: Hardware name: HP Compaq 2510p Notebook PC
kernel: Modules linked in: tcp_diag inet_diag i915 drm i2c_algo_bit i2c_core ppdev parport_pc lp parport 
ipv6 nfs lockd nfs_acl auth_rpcgss sunrpc ext2 coretemp hp_wmi acpi_cpufreq loop snd_hda_codec_analog arc4 
snd_hda_intel ecb snd_hda_codec snd_pcm_oss snd_mixer_oss iwlagn iwlcore snd_pcm rfkill snd_seq_dummy 
lib80211 mac80211 pcmcia snd_seq_oss snd_seq_midi snd_rawmidi cfg80211 snd_seq_midi_event snd_seq snd_timer 
snd_seq_device yenta_socket rsrc_nonstatic pcmcia_core serio_raw iTCO_wdt psmouse pcspkr usblp snd soundcore 
snd_page_alloc wmi hp_accel intel_agp video output battery lis3lv02d container ac button joydev evdev ext3 
jbd mbcache sha256_generic aes_x86_64 aes_generic cbc usbhid hid dm_crypt dm_mirror dm_region_hash dm_log 
dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix ata_piix ide_pci_generic ide_core pata_acpi ohci1394 
sdhci_pci sdhci ricoh_mmc ieee1394 mmc_core led_class ata_generic uhci_hcd ehci_hcd libata e1000e scsi_mod 
thermal processor fan thermal_sys
kernel: Pid: 14203, comm: s2ram Not tainted 2.6.29-rc3 #13
kernel: Call Trace:
acpid: client 13573[0:0] has disconnected
acpid: client 4290[0:0] has disconnected
kernel:  [<ffffffff8023995b>] warn_slowpath+0xd3/0x10f
kernel:  [<ffffffff8024fc19>] ? down_trylock+0x2d/0x34
kernel:  [<ffffffff80446562>] ? _spin_unlock+0x9/0xb
kernel:  [<ffffffff80443ff6>] ? printk+0x67/0x69
kernel:  [<ffffffff803649c0>] ? acpi_bus_power_manageable+0x11/0x29
kernel:  [<ffffffff8033771f>] ? acpi_pci_power_manageable+0x17/0x19
kernel:  [<ffffffff8032ef75>] ? pci_set_power_state+0xcc/0x101
kernel:  [<ffffffff803313dd>] pci_legacy_suspend+0xd4/0x119
kernel:  [<ffffffff80331515>] pci_pm_suspend+0x34/0x86
kernel:  [<ffffffff80398e0e>] pm_op+0x52/0xe5
kernel:  [<ffffffff803993b8>] device_suspend+0x32e/0x453
kernel:  [<ffffffff8025f4a6>] suspend_devices_and_enter+0x3e/0x12e
kernel:  [<ffffffff8025f6fe>] enter_state+0x110/0x164
kernel:  [<ffffffff8025f809>] state_store+0xb7/0xd7
kernel:  [<ffffffff8032014f>] kobj_attr_store+0x17/0x19
kernel:  [<ffffffff802e1991>] sysfs_write_file+0xdf/0x114
kernel:  [<ffffffff8029729f>] vfs_write+0xa7/0xe1
kernel:  [<ffffffff8029739d>] sys_write+0x47/0x6f
kernel:  [<ffffffff8020c25b>] system_call_fastpath+0x16/0x1b
kernel: ---[ end trace 7c1037001dd4a99a ]---
