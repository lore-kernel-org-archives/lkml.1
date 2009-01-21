Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbZAUQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbZAUQKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZAUQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:10:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZAUQKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:10:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: WARNING: at drivers/pci/pci-driver.c:368 pci_legacy_suspend+0x7b/0xb8()
Date: Wed, 21 Jan 2009 17:09:34 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, philipl@overt.org,
       "Pierre Ossman" <drzeus@drzeus.cx>
References: <200901211414.18009.elendil@planet.nl>
In-Reply-To: <200901211414.18009.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211709.35242.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Frans Pop wrote:
> Hi Rafael,
> 
> My last suspend to RAM gave me the WARN below.
> 
> This is with 2.6.28-rc2 with the following patches on top:
> * hp-wmi: fix regressions caused by missing if statement
> * double disk spin off fix:
>   Hibernation: Introduce system_entering_hibernation
>   DMI: Introduce dmi_first_match to make the interface more flexible
>   SATA: Blacklisting of systems that spin off disks during ACPI power off
>   SATA AHCI: Blacklist system that spins off disks during ACPI power off
>   SATA Sil: Blacklist system that spins off disks during ACPI power off
>   SATA PIIX: Blacklist system that spins off disks during ACPI power off
> * selected patches based on regression overview:
>   USB: Fix suspend-resume of PCI USB controllers
>   Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
>   USB: don't enable wakeup by default for PCI host controllers
>   work_on_cpu: dont try to get_online_cpus() in work_on_cpu.
>   PCI PM: Restore standard config registers of all devices early
> 
> I suspect the cause to be the last patch, as an earlier suspend which I 
> did without that patch did not result in the warning.

If line 368 in drivers/pci/pci-driver.c in your tree is:

		if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))

the warning is very much on purpose.  The ricoh_mmc driver appears to do a bad
thing here (powering down the device without saving its state) and that causes
the warning to trigger.

Please check if this patch makes the warning go away:
http://marc.info/?l=linux-kernel&m=123230574110042&w=4

Thanks,
Rafael


> ricoh-mmc: Suspending.
> ricoh-mmc: Controller is now re-enabled.
> ------------[ cut here ]------------
> WARNING: at drivers/pci/pci-driver.c:368 pci_legacy_suspend+0x7b/0xb8()
> Hardware name: HP Compaq 2510p Notebook PC
> Modules linked in: tcp_diag inet_diag i915 drm i2c_algo_bit i2c_core ppdev 
> parport_pc lp parport ipv6 nfs lockd nfs_acl auth_rpcgss sunrpc ext2 
> coretemp hp_wmi acpi_cpufreq loop snd_hda_codec_analog snd_hda_intel 
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss 
> arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq iwlagn 
> iwlcore snd_timer snd_seq_device rfkill snd lib80211 mac80211 serio_raw 
> soundcore pcmcia snd_page_alloc hp_accel cfg80211 psmouse pcspkr iTCO_wdt 
> yenta_socket rsrc_nonstatic pcmcia_core usblp intel_agp wmi video output 
> lis3lv02d container battery ac button joydev evdev ext3 jbd mbcache 
> sha256_generic aes_x86_64 aes_generic cbc usbhid hid dm_crypt dm_mirror 
> dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod piix 
> ide_pci_generic ata_piix ide_core pata_acpi ohci1394 sdhci_pci sdhci 
> ieee1394 mmc_core led_class ricoh_mmc ata_generic ehci_hcd libata 
> uhci_hcd e1000e scsi_mod thermal processor fan thermal_sys
> Pid: 6325, comm: s2ram Not tainted 2.6.29-rc2 #7
> Call Trace:
>  [<ffffffff802398cf>] warn_slowpath+0xd3/0x10f
>  [<ffffffff8035ae2b>] ? acpi_ns_get_node+0x92/0xa1
>  [<ffffffff80444232>] ? printk+0x67/0x6d
>  [<ffffffff8032c1cc>] ? pci_bus_write_config_byte+0x59/0x67
>  [<ffffffffa00bc2d5>] ? ricoh_mmc_enable+0x13c/0x145 [ricoh_mmc]
>  [<ffffffff80331894>] pci_legacy_suspend+0x7b/0xb8
>  [<ffffffff803319c4>] pci_pm_suspend+0x34/0x86
>  [<ffffffff8039929a>] pm_op+0x52/0xe5
>  [<ffffffff80399844>] device_suspend+0x32e/0x453
>  [<ffffffff8025f39e>] suspend_devices_and_enter+0x3e/0x12e
>  [<ffffffff8025f5f6>] enter_state+0x110/0x164
>  [<ffffffff8025f701>] state_store+0xb7/0xd7
>  [<ffffffff8032069f>] kobj_attr_store+0x17/0x19
>  [<ffffffff802e1de9>] sysfs_write_file+0xdf/0x114
>  [<ffffffff8029723b>] vfs_write+0xa7/0xe1
>  [<ffffffff80297339>] sys_write+0x47/0x6f
>  [<ffffffff8020c25b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 7b44d6d0be5818c2 ]---
