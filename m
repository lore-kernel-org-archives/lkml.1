Return-Path: <linux-kernel-owner+w=401wt.eu-S1764553AbXEVJ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764553AbXEVJ5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXEVJ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:57:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59871 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbXEVJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:57:12 -0400
Date: Tue, 22 May 2007 11:57:11 +0200
From: Jan Kara <jack@suse.cz>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in dentry_iput with 2.6.22-rc2 on AMD64
Message-ID: <20070522095711.GB27428@atrey.karlin.mff.cuni.cz>
References: <20070522041036.GD6074@iucha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522041036.GD6074@iucha.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> I was running a multithreaded perl application that leaks some memory
> so it gets to eat up a significant chunk of my 2 GB and even push a
> bit into swap.  I left it running before going out for a walk.
  Hmm, what seems suspitious is, that in R12 (which probably contains
the address dereferenced later) is address ffff9100... while all other
addresses start with ffff8100. So it seems to me it could be a 1-bit
flip. Care to check your memory with memtest?
  Also this is a code all other people use all the time so I guess we
would see more reports if this was some general bug...

> When I got back, I found this in the log:
> 
> [28818.103829] Unable to handle kernel paging request at ffff910025c9a8b4 RIP: 
> [28818.103836]  [<ffffffff80288998>] dentry_iput+0x58/0xbb
> [28818.103845] PGD 0 
> [28818.103848] Oops: 0000 [1] SMP 
> [28818.103851] CPU 0 
> [28818.103853] Modules linked in: radeon ntfs sbp2 lp lgdt330x cx88_dvb cx88_vp3054_i2c dvb_pll video_buf_dvb tuner cx8802 cx88_alsa cx8800 cx88xx ir_common rtc tveeprom video_buf btcx_risc i2c_nforce2 evdev forcedeth
> [28818.103868] Pid: 253, comm: kswapd0 Not tainted 2.6.22-rc2 #1
> [28818.103871] RIP: 0010:[<ffffffff80288998>]  [<ffffffff80288998>] dentry_iput+0x58/0xbb
> [28818.103877] RSP: 0000:ffff81007de75d40  EFLAGS: 00010246
> [28818.103880] RAX: 0000000000000000 RBX: ffff810075662e00 RCX: ffff810025c9a898
> [28818.103883] RDX: ffff810025c9a898 RSI: 0000000000000001 RDI: 0000000000000282
> [28818.103886] RBP: ffff81007de75d50 R08: 000000000000534d R09: 0000000000000064
> [28818.103890] R10: ffff81007de75d80 R11: 000000000000000a R12: ffff910025c9a868
> [28818.103893] R13: ffff810075662e08 R14: 0000000000000000 R15: 000000000000005e
> [28818.103897] FS:  0000000042804940(0000) GS:ffffffff806c8000(0000) knlGS:0000000000000000
> [28818.103900] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [28818.103903] CR2: ffff910025c9a8b4 CR3: 00000000254bf000 CR4: 00000000000006e0
> [28818.103907] Process kswapd0 (pid: 253, threadinfo ffff81007de74000, task ffff81007de706d0)
> [28818.103909] Stack:  ffff810075662e00 0000000000000001 ffff81007de75d70 ffffffff80288aaf
> [28818.103916]  ffff81007e606070 0000000000000001 ffff81007de75d90 ffffffff80289a35
> [28818.103921]  ffff81007e606070 ffff810075662e00 ffff81007de75dd0 ffffffff80289d3d
> [28818.103926] Call Trace:
> [28818.103931]  [<ffffffff80288aaf>] d_kill+0x38/0x58
> [28818.103935]  [<ffffffff80289a35>] prune_one_dentry+0x3c/0x10f
> [28818.103939]  [<ffffffff80289d3d>] prune_dcache+0x137/0x1a0
> [28818.103944]  [<ffffffff80289dc2>] shrink_dcache_memory+0x1c/0x35
> [28818.103948]  [<ffffffff80261178>] shrink_slab+0xe6/0x162
> [28818.103953]  [<ffffffff802615ef>] kswapd+0x329/0x4ca
> [28818.103958]  [<ffffffff8024458b>] autoremove_wake_function+0x0/0x38
> [28818.103963]  [<ffffffff802612c6>] kswapd+0x0/0x4ca
> [28818.103967]  [<ffffffff8024447f>] kthread+0x49/0x76
> [28818.103971]  [<ffffffff8020a578>] child_rip+0xa/0x12
> [28818.103977]  [<ffffffff80244436>] kthread+0x0/0x76
> [28818.103980]  [<ffffffff8020a56e>] child_rip+0x0/0x12
> [28818.103982] 
> [28818.103984] 
> [28818.103985] Code: 41 83 7c 24 4c 00 75 1c 4c 89 e7 45 31 c0 31 c9 31 d2 be 00 
> [28818.103994] RIP  [<ffffffff80288998>] dentry_iput+0x58/0xbb
> [28818.103999]  RSP <ffff81007de75d40>
> [28818.104001] CR2: ffff910025c9a8b4

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
