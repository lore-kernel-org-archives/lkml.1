Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbXAYFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbXAYFku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXAYFku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:40:50 -0500
Received: from chaos.ao.net ([205.244.242.21]:35059 "EHLO chaos.ao.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbXAYFkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:40:49 -0500
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 00:40:49 EST
Date: Thu, 25 Jan 2007 00:07:31 -0500
From: Dan Merillat <dmerillat@sequiam.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cluster@redhat.com
Subject: 2.6.20-rc4 gfs2 bug
Message-ID: <20070125050731.GA23270@chaos.ao.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running 2.6.20-rc4 _WITH_ the following patch: (Shouldn't be the issue,
but just in case, I'm listing it here)

Date:	Fri, 29 Dec 2006 21:03:57 +0100
From:	Ingo Molnar <mingo@elte.hu>
Subject: [patch] remove MAX_ARG_PAGES
Message-ID: <20061229200357.GA5940@elte.hu>

Linux fileserver 2.6.20-rc4MAX_ARGS #4 PREEMPT Fri Jan 12 03:58:25 EST 2007 x86_64 GNU/Linux

This happened when I started testing gfs2 for the first time.  I
installed userspace from CVS, loaded the gfs2/dlm modules, mkfs.gfs2,
then "mount -t gfs2 -v /dev/vg1/gfs2 /mnt/gfs"

This was the initial mount of the new filesystem.  I can create
directories, but attempting a stress-test with bonnie seems to have
deadlocked something.  (at "Start 'em", immediately.)

To clarify: the two oopses happened at first mount.  After that, I
created files/directories, then attempted to stress it a bit with
bonnie++.  No further oops/dmesg output.

For the GFS2 folks, latest CVS gfs_tool doesn't have lockdump, is there
any way to examine what I'm stuck on?

This machine is specifically for testing new things before I put them
into production, so I can leave it hung like this indefinitely for
debugging.


[845566.571468] GFS2 (built Jan 12 2007 04:02:27) installed
[849416.113382] DLM (built Jan 12 2007 04:01:21) installed
[849416.352219] Lock_DLM (built Jan 12 2007 04:02:46) installed
[850966.368016] GFS2: fsid=: Trying to join cluster "lock_dlm", "internal:gfs-test"
[850971.783223] dlm: gfs-test: recover 1
[850971.783242] dlm: gfs-test: add member 1
[850971.783246] dlm: gfs-test: total members 1 error 0
[850971.783248] dlm: gfs-test: dlm_recover_directory
[850971.783260] dlm: gfs-test: dlm_recover_directory 0 entries
[850971.783270] dlm: gfs-test: recover 1 done: 0 ms
[850971.783454] GFS2: fsid=internal:gfs-test.0: Joined cluster. Now mounting FS...
[850973.409048] GFS2: fsid=internal:gfs-test.0: jid=0, already locked for use
[850973.409135] GFS2: fsid=internal:gfs-test.0: jid=0: Looking at journal...
[850973.504558] GFS2: fsid=internal:gfs-test.0: jid=0: Done
[850973.504653] GFS2: fsid=internal:gfs-test.0: jid=1: Trying to acquire journal lock...
[850973.517086] GFS2: fsid=internal:gfs-test.0: jid=1: Looking at journal...
[850973.691546] GFS2: fsid=internal:gfs-test.0: jid=1: Done
[850973.691635] GFS2: fsid=internal:gfs-test.0: jid=2: Trying to acquire journal lock...
[850973.702646] GFS2: fsid=internal:gfs-test.0: jid=2: Looking at journal...
[850973.846397] GFS2: fsid=internal:gfs-test.0: jid=2: Done


[850973.869288] ------------[ cut here ]------------
[850973.869294] kernel BUG at fs/gfs2/glock.c:738!
[850973.869297] invalid opcode: 0000 [1] PREEMPT 
[850973.869300] CPU 0 
[850973.869302] Modules linked in: lock_dlm dlm gfs2 scsi_tgt bttv video_buf firmware_class ir_common compat_ioctl32 btcx_risc tveeprom videodev v4l2_common v4l1_compat radeon nbd eth1394 ohci1394 dm_crypt eeprom w83627hf hwmon_vid i2c_isa i2c_viapro snd_via82xx snd_mpu401_uart snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd soundcore
[850973.869324] Pid: 31076, comm: gfs2_glockd Not tainted 2.6.20-rc4MAX_ARGS #4
[850973.869327] RIP: 0010:[<ffffffff8816cabb>]  [<ffffffff8816cabb>] :gfs2:gfs2_glmutex_unlock+0x2b/0x40
[850973.869355] RSP: 0018:ffff81001849be70  EFLAGS: 00010282
[850973.869359] RAX: ffff810023ff4ee0 RBX: ffff810023ff4e68 RCX: ffffffff88185800
[850973.869363] RDX: 0000000000000000 RSI: ffff810023ff4ec0 RDI: ffff810023ff4e68
[850973.869366] RBP: ffff810023ff4f38 R08: 0000000000000000 R09: 0000000000006052
[850973.869370] R10: 0000000000000000 R11: ffffffff8816de60 R12: ffff810023ff4e68
[850973.869374] R13: ffff810023ff4eb0 R14: ffff81003ffd6850 R15: ffff81003ffd6870
[850973.869378] FS:  00002aebf51826d0(0000) GS:ffffffff807fb000(0000) knlGS:00000000f72026c0
[850973.869381] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[850973.869384] CR2: 00002b9e93097fe0 CR3: 0000000003a79000 CR4: 00000000000006e0
[850973.869388] Process gfs2_glockd (pid: 31076, threadinfo ffff81001849a000, task ffff810000b82890)
[850973.869390] Stack:  ffff810023ff4eb0 ffffffff8816cc08 ffff81001849beb0 ffff810024322000
[850973.869397]  ffff8100243223b8 ffff8100074cf968 ffffffff88163510 ffffffff88163528
[850973.869402]  0000000000000000 ffff810000b82890 ffffffff8029fe70 ffff81001849bec8
[850973.869407] Call Trace:
[850973.869421]  [<ffffffff8816cc08>] :gfs2:gfs2_reclaim_glock+0x138/0x180
[850973.869434]  [<ffffffff88163510>] :gfs2:gfs2_glockd+0x0/0xf0
[850973.869445]  [<ffffffff88163528>] :gfs2:gfs2_glockd+0x18/0xf0
[850973.869453]  [<ffffffff8029fe70>] autoremove_wake_function+0x0/0x30
[850973.869465]  [<ffffffff88163510>] :gfs2:gfs2_glockd+0x0/0xf0
[850973.869471]  [<ffffffff80234d43>] kthread+0xd3/0x110
[850973.869476]  [<ffffffff80229407>] schedule_tail+0x37/0xc0
[850973.869481]  [<ffffffff8029fca0>] keventd_create_kthread+0x0/0xa0
[850973.869485]  [<ffffffff80264618>] child_rip+0xa/0x12
[850973.869490]  [<ffffffff8029fca0>] keventd_create_kthread+0x0/0xa0
[850973.869497]  [<ffffffff80234c70>] kthread+0x0/0x110
[850973.869501]  [<ffffffff8026460e>] child_rip+0x0/0x12
[850973.869504] 
[850973.869505] 
[850973.869506] Code: 0f 0b 66 66 90 eb fe 66 66 66 90 66 66 66 90 66 66 90 66 66 
[850973.869514] RIP  [<ffffffff8816cabb>] :gfs2:gfs2_glmutex_unlock+0x2b/0x40
[850973.869528]  RSP <ffff81001849be70>
[850973.869530]  <6>note: gfs2_glockd[31076] exited with preempt_count 1


[850986.762341] ------------[ cut here ]------------
[850986.762346] kernel BUG at fs/gfs2/glock.c:738!
[850986.762349] invalid opcode: 0000 [2] PREEMPT 
[850986.762351] CPU 0 
[850986.762353] Modules linked in: lock_dlm dlm gfs2 scsi_tgt bttv video_buf firmware_class ir_common compat_ioctl32 btcx_risc tveeprom videodev v4l2_common v4l1_compat radeon nbd eth1394 ohci1394 dm_crypt eeprom w83627hf hwmon_vid i2c_isa i2c_viapro snd_via82xx snd_mpu401_uart snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd soundcore
[850986.762376] Pid: 31075, comm: gfs2_scand Not tainted 2.6.20-rc4MAX_ARGS #4
[850986.762379] RIP: 0010:[<ffffffff8816cabb>]  [<ffffffff8816cabb>] :gfs2:gfs2_glmutex_unlock+0x2b/0x40
[850986.762405] RSP: 0000:ffff81001f221e80  EFLAGS: 00010286
[850986.762408] RAX: ffff810023ff4940 RBX: ffff810023ff48c8 RCX: 0000000000000000
[850986.762412] RDX: 0000000000000146 RSI: ffff810023ff4920 RDI: ffff810023ff48c8
[850986.762416] RBP: ffff810024322000 R08: ffff81001f220000 R09: 00000000f6e88388
[850986.762418] R10: 0000000000000000 R11: 00000000ffffffff R12: 0000000000000000
[850986.762422] R13: 0000000000000000 R14: ffffffff8816d2f0 R15: ffff81003ffd6870
[850986.762426] FS:  00002b5212e53ae0(0000) GS:ffffffff807fb000(0000) knlGS:00000000f6e88bb0
[850986.762429] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[850986.762432] CR2: 00000000f706f000 CR3: 000000002b96b000 CR4: 00000000000006e0
[850986.762436] Process gfs2_scand (pid: 31075, threadinfo ffff81001f220000, task ffff810025448850)
[850986.762438] Stack:  ffff810023ff48c8 ffffffff8816a86c 0000000000000147 ffff810024322000
[850986.762445]  ffff8100074cf968 ffffffff88163600 ffff81003ffd6850 ffffffff8816ae54
[850986.762450]  ffff81003ffd6850 000000000000000f ffff810024322000 ffffffff88163618
[850986.762454] Call Trace:
[850986.762469]  [<ffffffff8816a86c>] :gfs2:examine_bucket+0x8c/0x100
[850986.762481]  [<ffffffff88163600>] :gfs2:gfs2_scand+0x0/0x70
[850986.762494]  [<ffffffff8816ae54>] :gfs2:gfs2_scand_internal+0x24/0x40
[850986.762506]  [<ffffffff88163618>] :gfs2:gfs2_scand+0x18/0x70
[850986.762514]  [<ffffffff80234d43>] kthread+0xd3/0x110
[850986.762519]  [<ffffffff80229407>] schedule_tail+0x37/0xc0
[850986.762525]  [<ffffffff8029fca0>] keventd_create_kthread+0x0/0xa0
[850986.762530]  [<ffffffff80264618>] child_rip+0xa/0x12
[850986.762535]  [<ffffffff8029fca0>] keventd_create_kthread+0x0/0xa0
[850986.762542]  [<ffffffff80234c70>] kthread+0x0/0x110
[850986.762545]  [<ffffffff8026460e>] child_rip+0x0/0x12
[850986.762548] 
[850986.762549] 
[850986.762550] Code: 0f 0b 66 66 90 eb fe 66 66 66 90 66 66 66 90 66 66 90 66 66 
[850986.762559] RIP  [<ffffffff8816cabb>] :gfs2:gfs2_glmutex_unlock+0x2b/0x40
[850986.762572]  RSP <ffff81001f221e80>
[850986.762575]  <6>note: gfs2_scand[31075] exited with preempt_count 1
