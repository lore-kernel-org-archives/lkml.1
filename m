Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYACSso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYACSso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYACSsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:48:37 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43218 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYACSsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:48:35 -0500
X-Greylist: delayed 1761 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 13:48:34 EST
Message-ID: <477D2710.1020103@mev.co.uk>
Date: Thu, 03 Jan 2008 18:18:56 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071123)
MIME-Version: 1.0
To: john_flowers@agilent.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM:  fakephp hangs terminal in 2.6.22 (and 2.6.21), does
 not Hot Plug
References: <BD63C848ECB98D4582D05FFF2C79CFF2478356@cos-us-mb01.cos.agilent.com>
In-Reply-To: <BD63C848ECB98D4582D05FFF2C79CFF2478356@cos-us-mb01.cos.agilent.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2008 18:18:58.0194 (UTC) FILETIME=[1B842F20:01C84E35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/07 21:16, john_flowers@agilent.com wrote:
> The "Fake" PCI Hot Plug module fakephp does not complete the slot 
> shutdown and will hang a terminal.
> 
> 
> I am attempting to use the fakephp module to shutdown and restart a 
> PCI Express FPGA board when the FPGA is reloaded. Using 2.6.22 
> (Ubuntu 7.10) or 2.6.21 (Fedora Core 7) I cannot get this 
> functionality to work. Sending a '1' to the power file causes no 
> change or debug output in dmesg and sending a '0' causes the terminal 
> to hang. Please CC me as I am not subscribed to the mailing list.

I encountered the same problem today with a 2.6.24-rc6-git9 x86_64 SMP
kernel when testing the hotplug sections of a driver I wrote.  The
terminal locks up when echoing a '0' to a PCI slot's "power" file.  I
added a few dbg calls in the fs_remove_slot function in
pci_hotplug_core.c and it seems that the call to sysfs_remove_file to
remove the "power" file that is being written to does not return.
Perhaps the code is locking the same mutex twice in this situation?

As this messsage thread is a bit ancient now, I'll requote the important
bits of John's error report:

> Keywords: linux kernel module PCI
> 
> Linux nsafm01 2.6.21-1.3194.fc7 #1 SMP Wed May 23 22:35:01 EDT 2007 i686 i686 i386 GNU/Linux
> 
> Gnu C                  4.1.2
> Gnu make               3.81
> binutils               2.17.50.0.12-4
> util-linux             2.13-pre7
> mount                  2.13-pre7
> module-init-tools      3.3-pre11
> e2fsprogs              1.39
> pcmciautils            014
> quota-tools            3.14.
> PPP                    2.4.4
> isdn4k-utils           3.9
> Linux C Library        > libc.2.6
> Dynamic linker (ldd)   2.6
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.2
> Sh-utils               6.9
> udev                   106
> wireless-tools         28
> Modules Loaded         fakephp i915 drm autofs4 hidp rfcomm l2cap bluetooth sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand acpi_cpufreq dm_multipath video sbs i2c_ec button dock battery ac ipv6 lp loop snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sr_mod fw_ohci cdrom serio_raw snd_timer iTCO_wdt parport_pc snd iTCO_vendor_support fw_core ata_generic parport i2c_i801 i2c_core e1000 soundcore pcspkr snd_page_alloc sg dm_snapshot dm_zero dm_mirror dm_mod pata_marvell ahci libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
> 
> How to reproduce:
> 
> modprobe fakephp debug=1
> echo 8 > /proc/sysrq-trigger
> echo -n 0 > /sys/bus/pci/slots ... & (wanted to get the command line back)
> alt-sysrq-t
> dmesg 
> 
[snip]
> [   90.409104]  =======================
> [   90.409145] bash          D 00000046     0  4698   4657 (NOTLB)
> [   90.409246]        f724de58 00000086 c0216f6b 00000046 c17ec000 c17ec000 0000000a 6e7a4da7 
> [   90.409444]        00000013 00000008 6e7c0cb1 00000013 000392f8 f79a0640 c17e3b00 00000001 
> [   90.409674]        0000bcbf 00000000 dfa0ee00 c024f410 0000792d c17e3fc4 c01282b3 00007960 
> [   90.409905] Call Trace:
> [   90.409977]  [<c0216f6b>] vgacon_set_cursor_size+0x9b/0x140
> [   90.410045]  [<c024f410>] vt_console_print+0x0/0x2b0
> [   90.410109]  [<c01282b3>] __call_console_drivers+0x53/0x60
> [   90.410175]  [<c02f3d8c>] __down+0x8c/0xf4
> [   90.410236]  [<c0122bc0>] default_wake_function+0x0/0x10
> [   90.410301]  [<c02f3b37>] __down_failed+0x7/0x10
> [   90.410364]  [<c01c294b>] sysfs_drop_dentry+0x13b/0x190
> [   90.410430]  [<c01c2ac1>] sysfs_hash_and_remove+0xd1/0x130
> [   90.410496]  [<f89749bd>] pci_hp_deregister+0x10d/0x1b0 [pci_hotplug]
> [   90.410567]  [<f89c8017>] remove_slot+0x17/0x60 [fakephp]
> [   90.410633]  [<f89c814b>] disable_slot+0xab/0x140 [fakephp]
> [   90.410699]  [<f8974e03>] power_write_file+0xb3/0x110 [pci_hotplug]
> [   90.410768]  [<f8974d50>] power_write_file+0x0/0x110 [pci_hotplug]
> [   90.410836]  [<f8974059>] hotplug_slot_attr_store+0x29/0x40 [pci_hotplug]
> [   90.410905]  [<c01c30ab>] sysfs_write_file+0xab/0x110
> [   90.410971]  [<c0180c4e>] vfs_write+0xbe/0x170
> [   90.411033]  [<c01c3000>] sysfs_write_file+0x0/0x110
> [   90.411098]  [<c0181361>] sys_write+0x41/0x70
> [   90.411161]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
> [   90.411226]  [<c02f0000>] clip_ioctl+0x500/0x510
> [   90.411290]  =======================

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
