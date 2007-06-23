Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXFWMO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXFWMO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXFWMOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:14:49 -0400
Received: from esuna.co.uk ([83.223.102.198]:35018 "EHLO mail.esuna.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbXFWMOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:14:47 -0400
Message-ID: <467D0EB0.9030100@esuna.co.uk>
Date: Sat, 23 Jun 2007 13:14:40 +0100
From: "Jay L. T. Cornwall" <jay@esuna.co.uk>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com> <467BE4F1.7040308@esuna.co.uk>
In-Reply-To: <467BE4F1.7040308@esuna.co.uk>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay L. T. Cornwall wrote:

> Already done. The filesystem came back as clean after the first oops,
> but I forced a recheck with fsck to be safe - it found no problems.
> 
> This is reproducible on a clean filesystem.

Following up on this, I've now extracted another oops (at the bottom of
this mail).

The common factor here seems to be the buffer_head circular list leading
to invalid pointers in bh->b_this_page.

I'm beginning to suspect the Attansic L1 Gigabit Etherner driver (marked
as EXPERIMENTAL in 2.6.22-rc5). I can't reproduce these panics on
disk-to-disk copies or SCP across the localhost interface. However, SCP
from a server onto either of two different HDDs hits these oopses fairly
quickly.

Is it even possible for the Ethernet driver to corrupt ext3 data
structures, short of trashing memory?

[  628.135241] general protection fault: 0000 [1] SMP
[  628.135422] CPU 1
[  628.135522] Modules linked in: usb_storage libusual netconsole
binfmt_misc rfcomm l2cap bluetooth ppdev capability commoncap
acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_ondemand
cpufreq_conservative cpufreq_powersave freq_table video container
battery dock asus_acpi ac sbs button af_packet ipv6 nls_utf8 ntfs
w83627ehf i2c_isa parport_pc lp parport fuse snd_hda_intel snd_pcm_oss
snd_mixer_oss mt2060 snd_pcm snd_seq_dummy cx22702 snd_seq_oss cx88_dvb
cx88_vp3054_i2c video_buf_dvb snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq cx8800 nls_cp437 dvb_usb_dib0700 dib7000m
dib7000p dvb_usb cx8802 cx88xx dvb_core cifs ir_common dvb_pll
i2c_algo_bit dib3000mc nvidia(P) dibx000_common snd_timer tveeprom atl1
compat_ioctl32 i2c_core videodev mii psmouse snd_seq_device v4l1_compat
video_buf v4l2_common btcx_risc pcspkr shpchp snd soundcore
snd_page_alloc intel_agp pci_hotplug serio_raw tsdev evdev sr_mod cdrom
ext3 jbd mbcache sg sd_mod pata_jmicron usbhid hid ata_generic ata_piix
ahci libata scsi_mod generic ehci_hcd uhci_hcd usbcore thermal processor fan
[  628.139866] Pid: 201, comm: kswapd0 Tainted: P       2.6.22-rc5-edge #1
[  628.139952] RIP: 0010:[<ffffffff802929ee>]  [<ffffffff802929ee>]
free_block+0x10e/0x160
[  628.140108] RSP: 0018:ffff8101322ebaf0  EFLAGS: 00010046
[  628.140190] RAX: 3eac08c8be1ff284 RBX: ffff810039616f68 RCX:
ffff810127524c00
[  628.140278] RDX: bc10c1d4beae1915 RSI: ffff810039616000 RDI:
00000000dc050844
[  628.140366] RBP: ffff8101322ebb40 R08: ffff81013b07cc07 R09:
00000000ffffffe9
[  628.140455] R10: ffff81013c68e1c0 R11: ffffffff88108740 R12:
ffff81013b81b800
[  628.140542] R13: 0000000000000001 R14: 0000000000000001 R15:
0000000000000640
[  628.140630] FS:  0000000000000000(0000) GS:ffff81013b07cac0(0000)
knlGS:0000000000000000
[  628.140750] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  628.140832] CR2: 00002ae5699e0000 CR3: 00000001001c5000 CR4:
00000000000006e0
[  628.140921] Process kswapd0 (pid: 201, threadinfo ffff8101322ea000,
task ffff81013b15a3c0)
[  628.141039] Stack:  ffff81000000e380 ffff81013b078400
0000000000000640 0000000000000640
[  628.141320]  ffff81013b81b800 0000000000000246 ffff8101322ebd90
ffffffff80292846
[  628.141563]  ffff810039616f68 ffff810039616f68 ffff810039616f68
ffff81012ad8d598
[  628.141746] Call Trace:
[  628.141886]  [<ffffffff80292846>] kmem_cache_free+0x1b6/0x1d0
[  628.141979]  [<ffffffff802bbf00>] free_buffer_head+0x20/0x50
[  628.142063]  [<ffffffff802bc334>] try_to_free_buffers+0x64/0xa0
[  628.142153]  [<ffffffff8027824a>] shrink_inactive_list+0x82a/0x960
[  628.142274]  [<ffffffff802776f1>] shrink_active_list+0x421/0x4e0
[  628.142395]  [<ffffffff8027844b>] shrink_zone+0xcb/0x140
[  628.142484]  [<ffffffff8027909a>] kswapd+0x3ea/0x560
[  628.142578]  [<ffffffff8024b040>] autoremove_wake_function+0x0/0x30
[  628.142679]  [<ffffffff80278cb0>] kswapd+0x0/0x560
[  628.142762]  [<ffffffff8024ac7b>] kthread+0x4b/0x80
[  628.142846]  [<ffffffff8020aca8>] child_rip+0xa/0x12
[  628.142942]  [<ffffffff8024ac30>] kthread+0x0/0x80
[  628.143023]  [<ffffffff8020ac9e>] child_rip+0x0/0x12
[  628.143106]
[  628.143171]
[  628.143172] Code: 48 89 30 0f 85 44 ff ff ff 48 83 c4 08 5b 5d 41 5c
41 5d 41
[  628.144015] RIP  [<ffffffff802929ee>] free_block+0x10e/0x160
[  628.144130]  RSP <ffff8101322ebaf0>

-- 
Jay L. T. Cornwall, http://www.esuna.co.uk/~jay/
PhD Student
Imperial College London
