Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZDMDRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZDMDRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZDMDRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:17:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:11642 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZDMDR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:17:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,178,1239001200"; 
   d="scan'208";a="402549269"
Subject: Re: [PATCH 0/13] Per-bdi writeback flusher threads #3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <20090410072109.GK5178@kernel.dk>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
	 <1239335199.2567.784.camel@ymzhang>  <20090410072109.GK5178@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Apr 2009 11:18:03 +0800
Message-Id: <1239592683.2567.796.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 09:21 +0200, Jens Axboe wrote:
> On Fri, Apr 10 2009, Zhang, Yanmin wrote:
> > On Wed, 2009-04-08 at 14:00 +0200, Jens Axboe wrote:
> > > Hi,
> > > 
> > > This is the third version of the patchset. Changes since v2:
> > Jens,
> > 
> > The patchset forgets kernel/sysctl.c part, so the compilation link fails.
> 
> Yep, noticed that as well. Not really great timing with adding more
> pdflush tunables...
When I run a fio testing with a partition on one of my machines, I hit below bug
checking. It's a ﻿ fio_mmap_randwrite_4k_preread testing. I'm not sure if it happens
after the testing and before the next testing, or just happens when the testing is
ongoing. When I see it, next testing stops at the beginning when mounting the partition.

----------------------sys log--------------------

kernel BUG at fs/jbd/journal.c:1166!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/block/sdb/stat
CPU 0 
Modules linked in: igb
Pid: 18329, comm: umount Not tainted 2.6.30-rc1-bdiflusherv3 #1 X8DTN
RIP: 0010:[<ffffffff80344747>]  [<ffffffff80344747>] journal_destroy+0x108/0x1b4
RSP: 0018:ffff8800bd95fe08  EFLAGS: 00010286
RAX: 000000000000c7c7 RBX: ffff8800bc93dc00 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff8800bc93dd64
RBP: ffff8800bc93dd64 R08: ffff8800bc93dc88 R09: 00000000bd95fcc0
R10: 0000000000000246 R11: 00000000fffffffb R12: ffff8800bd95fe08
R13: ffff8800bd95fe20 R14: ffff8800bc93dc98 R15: ffff8800bc93dcc8
FS:  00007f3f26c717d0(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3f263fe000 CR3: 00000000bc18e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 18329, threadinfo ffff8800bd95e000, task ffff8800bcdcdca0)
Stack:
 0000000000000000 ffff8800bcdcdca0 ffffffff8024ddaa ffff8800bd95fe20
 ffff8800bd95fe20 ffffffff802e53ac ffff8800bd95fe38 ffff8800bd0e3a00
 ffff8800a1ff2400 ffff8800bc93b000 ffff8800bb8cb400 0000000000000000
Call Trace:
 [<ffffffff8024ddaa>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff802e53ac>] ? mb_cache_shrink+0x22/0x9e
 [<ffffffff8032fbcc>] ? ext3_put_super+0x29/0x204
 [<ffffffff802ac7ab>] ? generic_shutdown_super+0x70/0xde
 [<ffffffff802ac83b>] ? kill_block_super+0x22/0x3a
 [<ffffffff802ac8fe>] ? deactivate_super+0x5f/0x77
 [<ffffffff802bf20a>] ? sys_umount+0x2da/0x309
 [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b
Code: ff 48 8d ab 64 01 00 00 eb 0b fe 45 00 48 89 df e8 cc e8 ff ff 48 89 ef e8 2f e8 3d 00 48 83 7b 60 00 75 e6 48 83 7b 50 00 74 04 <0f> 0b eb fe 48 83 7b 58 00 74 04 0f 0b eb fe fe 83 64 01 00 00 
RIP  [<ffffffff80344747>] journal_destroy+0x108/0x1b4
 RSP <ffff8800bd95fe08>
---[ end trace 14f5ccbafee46eb4 ]---


> 
> There's also an issue with the SRCU init, so it will not even work
> irregardless of the compilation problem. I'll have to update and repost
> next week.
> 

