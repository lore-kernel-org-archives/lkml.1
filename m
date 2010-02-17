Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0BQNQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:16:39 -0500
Received: from mail001.aei.ca ([206.123.6.130]:60058 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab0BQNQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:16:37 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [LOCKDEP] 33-rc8 Running aplay with pulse as the default
Date: Wed, 17 Feb 2010 08:16:32 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc8-crc; KDE/4.4.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain> <201002160819.21595.edt@aei.ca> <s5hvddxqp1x.wl%tiwai@suse.de>
In-Reply-To: <s5hvddxqp1x.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002170816.33209.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 08:37:46 Takashi Iwai wrote:
> > Thanks for the patch.  It helps in that it eliminates the opps but lockdep still triggers and aplay still fails.  
> > Here is the new traceback.
> 
> Hmm, fixing this isn't so trivial.  The same problem occurs on other
> subsystems like NFS over years.  And it's still there, AFAIK.
> The mmap mutex appears suddenly in the strange code path at close.
> 
> The patch below might fix, but I'm not 100% sure whether this has no
> side effect.
> 
> Anyway, I doubt very much it being a regression.  There is no change
> in ALSA core side, and also in V4L em28xx code.  Maybe the lockdep
> wasn't triggered by some reason.  And, this lockdep warning is almost
> harmless...

Takashi,

The second patch eliminating the lock causes oppes every time (one follows just in case
its helpful).  Suggest that the first patch might suffice to get rid of the opps.  The only worry I 
have is _once_ after getting the lockdep traceback starting X stalled the box (no opps, no 
sysRQ, no log on the serial console).

Ideas?

---
[   66.200497] BUG: unable to handle kernel NULL pointer dereference at (null)
[   66.201377] IP: [<ffffffff8104dfe6>] do_wait+0x1e6/0x2e0
[   66.201377] PGD 16d25a067 PUD 16d25b067 PMD 0 
[   66.201377] Oops: 0000 [#1] PREEMPT SMP 
[   66.201377] last sysfs file: /sys/devices/pci0000:00/0000:00:14.2/sound/card0/uevent
[   66.252431] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   66.201377] CPU 3 
[   66.201377] Pid: 2816, comm: console-kit-dae Not tainted 2.6.33-rc8-crc #110 M3A78-T/System Product Name
[   66.201377] RIP: 0010:[<ffffffff8104dfe6>]  [<ffffffff8104dfe6>] do_wait+0x1e6/0x2e0
[   66.201377] RSP: 0018:ffff88016d149e88  EFLAGS: 00010293
[   66.201377] RAX: ffff88016b644318 RBX: fffffffffffffcf8 RCX: ffff88016d133e00
[   66.201377] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81a7fa88
[   66.201377] RBP: ffff88016d149ee8 R08: ffffffff821478d0 R09: 0000000000000000
[   66.201377] R10: 0000000000000052 R11: 0000000000000246 R12: ffff88016d149f08
[   66.365887] R13: ffff88016b644020 R14: ffff88016c108000 R15: ffff88016c108000
[   66.365887] FS:  00007fc780a0f700(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
[   66.365887] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   66.365887] CR2: 0000000000000000 CR3: 000000016a044000 CR4: 00000000000006e0
[   66.365887] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.365887] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   66.365887] Process console-kit-dae (pid: 2816, threadinfo ffff88016d148000, task ffff88016c108000)
[   66.365887] Stack:
[   66.365887]  ffff88016c108000 ffff88016c108000 ffff88016d149f30 ffff88016b644318
[   66.365887] <0> ffff88016d149ee8 0000000000000000 ffffffff81069880 00007fff01e7223c
[   66.365887] <0> ffff88016d133e80 0000000000000000 000000000061ea60 00007fff01e7228c
[   66.365887] Call Trace:
[   66.365887]  [<ffffffff81069880>] ? find_get_pid+0x0/0x80
[   66.365887]  [<ffffffff8104e169>] sys_wait4+0x89/0xf0
[   66.365887]  [<ffffffff8104b650>] ? child_wait_callback+0x0/0x80
[   66.365887]  [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   66.365887] Code: eb 29 0f 1f 00 48 89 da be 01 00 00 00 4c 89 e7 e8 f0 f1 ff ff 85 c0 0f 85 d0 00 00 00 48 8b 9b 08 03 00 00 48 81 eb 08 03 00 00 <48> 8b 83 08 03 00 00 0f 18 08 48 8d 83 08 03 00 00 48 39 45 b8 
[   66.365887] RIP  [<ffffffff8104dfe6>] do_wait+0x1e6/0x2e0
[   66.365887]  RSP <ffff88016d149e88>
[   66.365887] CR2: 0000000000000000
[   66.610733] ---[ end trace 7b7cfa53172184c4 ]---
[   66.620906] note: console-kit-dae[2816] exited with preempt_count 1
