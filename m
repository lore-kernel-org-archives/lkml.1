Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYENQFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYENQFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYENQFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:05:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55154 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYENQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:05:19 -0400
Date: Wed, 14 May 2008 18:05:17 +0200
From: Jan Kara <jack@suse.cz>
To: Stawi <stawi@plusnet.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24 kernel BUG at fs/buffer.c:450
Message-ID: <20080514160517.GA22140@atrey.karlin.mff.cuni.cz>
References: <4823830E.4090301@plusnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4823830E.4090301@plusnet.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> I have software RAID1 on two SATA disks. Sometimes (rather usually..) 
> under heavy I/O load system hangs.
> Easier way to reproduce bug is to run few times:
> 
> (dd if=/dev/zero of=f bs=128k count=5000 &); sleep 1; dd of=/dev/null 
> if=f iflag=direct bs=128k count=5000
> 
> Problem was also present in 2.6.22. I'm using Debian lenny amd64 default 
> kernel images.
> Hardware: Asus P5K-WS, Intel Core2 Quad Q6600, 2x2GB DDR2 Patriot, 2x 
> WD5000AAKS SATA disk.
> 
> I hope someone can help, because it makes my crazy to resync 500GB RAID 
> almost everyday..
  Interesting. Can you try to reproduce the problem without the
proprietary Nvidia module? Also if you could run:
  gdb /boot/vmlinux (or where you have your vmlinux file stored)
  disass end_buffer_write_async

and send me the first page. The kernel complains that the buffer does
not have async flag set on the buffer which it really should when
end_buffer_async_write() is called. On my machine, buffer flags are in
RAX which is 1 on your machine. That would be really strange - it ought
to be something like 261...

								Honza

> I managed to capture last words by serial console:
> 
> ------------[ cut here ]------------
> kernel BUG at fs/buffer.c:450!
> invalid opcode: 0000 [1] SMP
> CPU 2
> Modules linked in: nvidia(P) rfcomm l2cap bluetooth ppdev parport_pc lp 
> parport ac battery ipv6 coretemp w83627ehf hwmon_vid loop firewire_sbp2 
> snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
> snd_emu10k1 firmware_class snd_ac97_codec ac97_bus snd_util_mem 
> snd_hwdep snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
> snd_seq snd_timer snd_seq_device joydev emu10k1_gp snd gameport i2c_i801 
> shpchp soundcore intel_agp button i2c_core pci_hotplug iTCO_wdt pcspkr 
> evdev usblp ext3 jbd mbcache usbhid hid raid1 raid0 md_mod dm_mirror 
> dm_mod sg sr_mod cdrom sd_mod generic ide_core ata_piix firewire_ohci 
> pata_marvell ata_generic firewire_core floppy crc_itu_t libata scsi_mod 
> sky2 ehci_hcd uhci_hcd thermal processor fan
> Pid: 0, comm: swapper Tainted: P        2.6.24-1-amd64 #1
> RIP: 0010:[<ffffffff802b8964>]  [<ffffffff802b8964>] 
> end_buffer_async_write+0x14/0xf0
> RSP: 0018:ffff81012b6f7d60  EFLAGS: 00010246
> RAX: 0000000000000001 RBX: ffff8100325038e8 RCX: 0000000000000001
> RDX: 0000000000000008 RSI: 0000000000000001 RDI: ffff8100325038e8
> RBP: ffff8101285e5bc0 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff81012f9f5b60 R11: ffffffff802b82d5 R12: ffff8101288588c0
> R13: ffff810011214440 R14: ffff810011214440 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff81012b6821c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000006cb3a4 CR3: 0000000123113000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff81012b6f0000, task ffff81012b6ab800)
> Stack:  0000000000000282 0000000000000003 ffff81012b6f7db0 ffffffff8022e6b8
> ffff8101288588c0 ffff8100112144c0 ffff8101285e5bc0 ffff8101288588c0
> ffff810011214440 ffffffff802b82f9 ffff8100112137c0 ffffffff8815cbb3
> Call Trace:
> <IRQ>  [<ffffffff8022e6b8>] __wake_up+0x38/0x4f
> [<ffffffff802b82f9>] end_bio_bh_fo_sync+0x241/0x2d
> [<ffffffff8815cbb3>] :raid1:raid_end_bio_io+0x30/0x85
> [<ffffffff8815f00f>] :raid1:raid1_end_write_request+0x1e6/0x20c
> [<ffffffff80302c6f>] __end_that_request_first+0x1ba/0x3a9
> [<ffffffff880453af>] :scsi_mod:scsi_end_request+0x27/0xc9
> [<ffffffff880457b2>] :scsi_mod:scsi_io_completion+0x154/0x32c
> [<ffffffff80305829>] blk_done_softirq+0x5c/0x6a
> [<ffffffff8023a809>] __do_softirq+0x55/0xc3
> [<ffffffff8021f0be>] ack_apic_level+0x10/0xd9
> [<ffffffff8020cfbc>] call_softirq+0x1c/0x28
> [<ffffffff8020ebf8>] do_softirq+0x2c/0x7d
> [<ffffffff8023a76f>] irq_exit+0x3f/0x84
> [<ffffffff8020ee2e>] do_IRQ+0xb6/0xd4
> [<ffffffff8020b1da>] mwait_idle+0x0/0x46
> [<ffffffff8020c341>] ret_from_intr+0x0/0xa
> <EOI>  [<ffffffff8021d632>] lapic_next_event+0x0/0xa
> [<ffffffff8020b21c>] mwait_idle+0x42/0x46
> [<ffffffff8020b16a>] cpu_idle+0x90/0xbb
> 
> 
> Code: 0f 0b eb fe 85 f6 4c 8b 6f 10 74 07 f0 0f ba 2f 00 eb 49 e8
> RIP  [<ffffffff802b8964>] end_buffer_async_write+0x14/0xf0
> RSP <ffff81012b6f7d60>
> ---[ end trace cb1e64c05ce6ac8c ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
