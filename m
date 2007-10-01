Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXJAHnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXJAHnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXJAHnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:43:07 -0400
Received: from mx1.caravan.ru ([217.23.130.2]:64550 "EHLO mx1.caravan.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXJAHnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:43:04 -0400
X-Greylist: delayed 2441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 03:43:04 EDT
Message-ID: <47009BF6.5000208@lxnt.info>
Date: Mon, 01 Oct 2007 11:04:22 +0400
From: Alexander Sabourenkov <screwdriver@lxnt.info>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-ide@vger.kernel.org
Subject: Promise SATA300 TX4: errors, oops in ext3 code
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware:  Athlon64, Asus A8V, Promise SATA300 TX4, 2xSeagate 7200.10 
320G, jumper-limited to SATA150.
Kernel : 2.6.22.9 amd64

Problem:
Heavy load causes errors and triggers oops.

History:
Problems were first encountered on kernel 2.6.19, both i686 ("old" 
system) and amd64 (gentoo installation CD).
Can't say anything about older kernels. Most probably they have same 
issues (or worse).

Problems were blamed:
   - SATA300 being too 'hot'  (jumpered the drives)
   - cables (work perfectly on onboard controller)
   - interrupt sharing (found the only slot which does not share 
interrupt line)
   - cooling (3 fans installed, smartctl-reported temperature at max 
load dropped to 35C)
   - weak PSU (installed 600W FSP)
   - kernel bugs (upgraded to 2.6.22.9)

All those measures significantly dropped error rate (from about 20 to 
2-4 per mirror rebuild) but did not eliminate the problem.

Errors are easily reproduced by performing resync on a md RAID-1. 
Raising overall system load (compilation, copy operations on other HDDs) 
makes errors happen sooner.

Errors lead to data loss: if errors occur on master disk while raid 
rebuild is in progress, and there is some write activity (like package 
installation), some files disappear: package management check reports 
missing files.

Oops was encountered while rsyncing data from disks on separate (VIA 
onboard) controller and simultaneously rebuilding GCC.



Typical error:

Sep 30 17:26:51 host ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 
action 0x2
Sep 30 17:26:51 host ata3.00: (port_status 0x20080000)
Sep 30 17:26:51 host ata3.00: cmd c8/00:08:31:47:36/00:00:00:00:00/e6 
tag 0 cdb 0x0 data 4096 in
Sep 30 17:26:51 host res 50/00:00:38:47:36/00:00:00:00:00/e6 Emask 0x2 
(HSM violation)
Sep 30 17:26:52 host ata3: soft resetting port
Sep 30 17:26:52 host ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep 30 17:26:52 host ata3.00: configured for UDMA/133
Sep 30 17:26:52 host ata3: EH complete
Sep 30 17:26:52 host sd 2:0:0:0: [sda] 625142448 512-byte hardware 
sectors (320073 MB)
Sep 30 17:26:52 host sd 2:0:0:0: [sda] Write Protect is off
Sep 30 17:26:52 host sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Sep 30 17:26:52 host sd 2:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA

Oops:

Sep 30 17:27:46 host Unable to handle kernel NULL pointer dereference at 
000000000000000e RIP:
Sep 30 17:27:46 host [<ffffffff8024b03a>] __pagevec_lru_add+0x12/0x97
Sep 30 17:27:46 host PGD fdff067 PUD 84c1067 PMD 0
Sep 30 17:27:46 host Oops: 0000 [1]
Sep 30 17:27:46 host CPU 0
Sep 30 17:27:46 host Modules linked in: snd_via82xx snd_mpu401_uart 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer 
snd_page_alloc snd_util_mem snd_hwdep snd soundcore
Sep 30 17:27:46 host Pid: 21657, comm: rsync Not tainted 2.6.22-gentoo-r8 #1
Sep 30 17:27:46 host RIP: 0010:[<ffffffff8024b03a>] 
[<ffffffff8024b03a>] __pagevec_lru_add+0x12/0x97
Sep 30 17:27:46 host RSP: 0000:ffff81000b081998  EFLAGS: 00010217
Sep 30 17:27:46 host RAX: 0000000000000000 RBX: ffff81000b0819a8 RCX: 
0000000000000000
Sep 30 17:27:46 host RDX: 0000000000000000 RSI: 6db6db6db6db6db7 RDI: 
000000000000000e
Sep 30 17:27:46 host RBP: 0000000000000013 R08: 0000000000000000 R09: 
00000000000000ff
Sep 30 17:27:46 host R10: ffff810021c72bc0 R11: ffff810033a3e068 R12: 
ffff81000b081b88
Sep 30 17:27:46 host R13: ffff810021c72bc0 R14: ffffffff802a122c R15: 
ffff810011f3fe00
Sep 30 17:27:46 host FS:  00002ae93d4d66d0(0000) 
GS:ffffffff80595000(0000) knlGS:00000000f7dc2a00
Sep 30 17:27:46 host CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 30 17:27:46 host CR2: 000000000000000e CR3: 0000000008fcd000 CR4: 
00000000000006e0
Sep 30 17:27:46 host Process rsync (pid: 21657, threadinfo 
ffff81000b080000, task ffff81003f783100)
Sep 30 17:27:46 host Stack:  ffff810001152bf8 ffffffff802830f1 
ffffffff802a122c ffffffff802218bf
Sep 30 17:27:46 host 000000000000000e 0000000000000000 ffff81000195cdf0 
ffff8100014e6998
Sep 30 17:27:46 host ffff810001ac6540 ffff810001af2488 ffff81000154d900 
ffff8100018aced8
Sep 30 17:27:46 host Call Trace:
Sep 30 17:27:46 host [<ffffffff802830f1>] mpage_readpages+0xe5/0x138
Sep 30 17:27:46 host [<ffffffff802a122c>] ext3_get_block+0x0/0xe4
Sep 30 17:27:46 host [<ffffffff802218bf>] __activate_task+0x23/0x34
Sep 30 17:27:46 host [<ffffffff80248f2a>] __alloc_pages+0x61/0x2a8
Sep 30 17:27:46 host [<ffffffff8024a79e>] 
__do_page_cache_readahead+0x124/0x217
Sep 30 17:27:46 host [<ffffffff80465a08>] thread_return+0x0/0x94
Sep 30 17:27:46 host [<ffffffff80245233>] sync_page+0x0/0x40
Sep 30 17:27:46 host [<ffffffff8024a8e4>] 
blockable_page_cache_readahead+0x53/0xb2
Sep 30 17:27:46 host [<ffffffff8024a9ca>] make_ahead_window+0x87/0xa3
Sep 30 17:27:46 host [<ffffffff8024ab6e>] page_cache_readahead+0x188/0x1bf
Sep 30 17:27:46 host [<ffffffff80245a1a>] 
do_generic_mapping_read+0x136/0x43a
Sep 30 17:27:46 host [<ffffffff8024500a>] file_read_actor+0x0/0x11d
Sep 30 17:27:46 host [<ffffffff8024754f>] generic_file_aio_read+0x11d/0x15a
Sep 30 17:27:46 host [<ffffffff802617b0>] do_sync_read+0xc9/0x10c
Sep 30 17:27:46 host [<ffffffff80233fb1>] autoremove_wake_function+0x0/0x2e
Sep 30 17:27:46 host [<ffffffff80261f21>] vfs_read+0xaa/0x132
Sep 30 17:27:46 host [<ffffffff80262236>] sys_read+0x45/0x6e
Sep 30 17:27:46 host [<ffffffff8020936e>] system_call+0x7e/0x83
Sep 30 17:27:46 host
Sep 30 17:27:46 host
Sep 30 17:27:46 host Code: 48 8b 07 48 c1 e8 3e 48 69 c0 70 02 00 00 48 
8d b0 20 2e 56
Sep 30 17:27:46 host RIP  [<ffffffff8024b03a>] __pagevec_lru_add+0x12/0x97
Sep 30 17:27:46 host RSP <ffff81000b081998>
Sep 30 17:27:46 host CR2: 000000000000000e


Dmesg output: http://lxnt.info/linux/dmesg.text
Errors and oops: http://lxnt.info/linux/oops.text


-- 

./lxnt
