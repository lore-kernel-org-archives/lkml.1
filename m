Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZLAWyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZLAWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZLAWye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:54:34 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50920 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZLAWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:54:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CibXVQDa8pzjJ7mpzEFQhHUzTvE9Q280+x5GzDzo8cTQE/XvKymfuOdeTgKyk6T+QA
         MIDz7sNEcvDFwsIUdWxeuzjV+MYdLWe0KgZS0srWNHrFb2cP0cSbHyemrlciJoqcToPw
         7/JwjiDHaStTKZ+1TDX3K3awAtYb/ITuyQzb4=
Message-ID: <4B159EAC.1010006@lwfinger.net>
Date: Tue, 01 Dec 2009 16:54:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Kernel BUG during suspend to disk with 2.6.32-rc8-git3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the mainline kernel git describe == v2.6.32-rc8-259-g2127816),
I get the following BUG and WARNING:

================================
BUG: sleeping function called from invalid context at
drivers/acpi/acpica/psloop.c:826
in_atomic(): 0, irqs_disabled(): 1, pid: 3616, name: s2disk

1 lock held by s2disk/3616:

 #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8106ee46>]
snapshot_ioctl+0x52/0x4ba
irq event stamp: 742026

hardirqs last  enabled at (742025): [<ffffffff8125af88>]
__mutex_unlock_slowpath+0x100/0x10b
hardirqs last disabled at (742026): [<ffffffff8106c22e>]
hibernation_snapshot+0xa0/0x1be
softirqs last  enabled at (741898): [<ffffffff81041936>]
__do_softirq+0x127/0x13d
softirqs last disabled at (741877): [<ffffffff8100cb7c>]
call_softirq+0x1c/0x28
Pid: 3616, comm: s2disk Not tainted
2.6.32-rc8-Linus-00259-g2127816-dirty #127
Call Trace:

 [<ffffffff8105c810>] ? print_irqtrace_events+0xd0/0xd4
 [<ffffffff81033ff9>] __might_sleep+0xef/0xf4
 [<ffffffff81181a9c>] acpi_ps_complete_op+0x2bc/0x2d6
 [<ffffffff8116baa5>] ? acpi_ds_exec_end_op+0x54d/0x570
 [<ffffffff81182378>] acpi_ps_parse_loop+0x8c2/0xa4e
 [<ffffffff8105da14>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff810ae5ed>] ? kmem_cache_alloc+0x10e/0x147
 [<ffffffff81181291>] acpi_ps_parse_aml+0x10a/0x3e1
 [<ffffffff81189073>] ? acpi_ut_create_internal_object_dbg+0x22/0x87
 [<ffffffff81182ca0>] acpi_ps_execute_method+0x22a/0x336
 [<ffffffff8117d490>] acpi_ns_evaluate+0x18c/0x2c9
 [<ffffffff81184230>] acpi_rs_set_srs_method_data+0xdd/0x105
 [<ffffffff81183cfd>] acpi_set_current_resources+0x37/0x45
 [<ffffffff81166229>] acpi_pci_link_set+0x128/0x222
 [<ffffffff810533ab>] ? hres_timers_resume+0x3f/0x41
 [<ffffffff81166356>] irqrouter_resume+0x33/0x4b
 [<ffffffff811b5dc9>] __sysdev_resume+0x20/0xc0
 [<ffffffff811b5ecc>] sysdev_resume+0x63/0xa4
 [<ffffffff8106c29f>] hibernation_snapshot+0x111/0x1be
 [<ffffffff8106f01d>] snapshot_ioctl+0x229/0x4ba
 [<ffffffff8105e9bc>] ? trace_hardirqs_on_caller+0x10c/0x130
 [<ffffffff810c0451>] vfs_ioctl+0x1d/0x82
 [<ffffffff810c09b0>] do_vfs_ioctl+0x483/0x4c9
 [<ffffffff810b4d9e>] ? fget_light+0xdd/0xeb
 [<ffffffff810b4d13>] ? fget_light+0x52/0xeb
 [<ffffffff810c0a38>] sys_ioctl+0x42/0x65
 [<ffffffff8100b9eb>] system_call_fastpath+0x16/0x1b
------------[ cut here ]------------

WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x4f/0xc0()
Hardware name: HP Pavilion dv2700 Notebook PC
Interrupts enabled after irqrouter_resume+0x0/0x4b
Modules linked in: aes_x86_64 aes_generic af_packet xt_tcpudp xt_pkttype
ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd
nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_conservative
cpufreq_userspace cpufreq_powersave powernow_k8 xt_NOTRACK ipt_REJECT
xt_state iptable_raw iptable_filter nf_conntrack_netbios_ns
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables fuse
ext3 jbd loop dm_mod snd_hda_codec_conexant arc4 ecb b43 snd_hda_intel
mac80211 cfg80211 snd_hda_codec rfkill snd_pcm uvcvideo led_class
videodev snd_timer v4l1_compat snd i2c_nforce2 v4l2_compat_ioctl32
ide_cd_mod k8temp soundcore ssb serio_raw ac battery hwmon joydev sg
forcedeth snd_page_alloc button i2c_core cdrom ext4 mbcache jbd2 crc16
sd_mod ahci ohci_hcd libata scsi_mod ehci_hcd usbcore fan processor
ide_pci_generic amd74xx ide_core thermal
Pid: 3616, comm: s2disk Not tainted
2.6.32-rc8-Linus-00259-g2127816-dirty #127
Call Trace:

 [<ffffffff8103c789>] warn_slowpath_common+0x77/0x8f
 [<ffffffff8103c7ee>] warn_slowpath_fmt+0x3c/0x3e
 [<ffffffff81166323>] ? irqrouter_resume+0x0/0x4b
 [<ffffffff811b5df8>] __sysdev_resume+0x4f/0xc0
 [<ffffffff811b5ecc>] sysdev_resume+0x63/0xa4
 [<ffffffff8106c29f>] hibernation_snapshot+0x111/0x1be
 [<ffffffff8106f01d>] snapshot_ioctl+0x229/0x4ba
 [<ffffffff8105e9bc>] ? trace_hardirqs_on_caller+0x10c/0x130
 [<ffffffff810c0451>] vfs_ioctl+0x1d/0x82
 [<ffffffff810c09b0>] do_vfs_ioctl+0x483/0x4c9
 [<ffffffff810b4d9e>] ? fget_light+0xdd/0xeb
 [<ffffffff810b4d13>] ? fget_light+0x52/0xeb
 [<ffffffff810c0a38>] sys_ioctl+0x42/0x65
 [<ffffffff8100b9eb>] system_call_fastpath+0x16/0x1b
---[ end trace 2db18c3096add170 ]---
==============================

I do not know if this is a regression, as I just recently tried hibernation.

The system has x86_64 architecture. The source is "dirty" due to a local
modification of the rtl8187 driver, which is not even loaded.

If additional info is needed, please ask.

Larry

