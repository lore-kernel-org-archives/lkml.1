Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYAQRPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYAQRPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYAQRPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:15:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48466 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYAQRPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:15:09 -0500
Subject: Re: 2.6.24-rc8-mm1 (BUG: sched_rt)
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20080117084833.dc946466.randy.dunlap@oracle.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <20080117084833.dc946466.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 18:15:02 +0100
Message-Id: <1200590102.5920.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 08:48 -0800, Randy Dunlap wrote:
> On Thu, 17 Jan 2008 02:35:14 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> Booting on x86_64 SMP gives me:
> 
> ------------[ cut here ]------------
> kernel BUG at kernel/sched_rt.c:228!
> invalid opcode: 0000 [1] SMP
> last sysfs file: /sys/devices/pci0000:40/0000:40:0c.0/0000:41:00.0/0000:42:08.0/class
> CPU 2
> Modules linked in: parport_pc lp parport tg3 cciss ehci_hcd ohci_hcd uhci_hcd
> Pid: 12738, comm: 5-1.test Not tainted 2.6.24-rc8-mm1 #1
> RIP: 0010:[<ffffffff8023077b>]  [<ffffffff8023077b>] update_curr_rt+0x27/0x87
> RSP: 0018:ffff8101e6805e38  EFLAGS: 00010093
> RAX: 0000000000000000 RBX: ffff81027f8591e0 RCX: ffff81000100fb80
> RDX: 0000000000000000 RSI: ffff81026eb8b1e0 RDI: ffff810001014980
> RBP: ffff8101e6805e48 R08: ffffffff8067d960 R09: 00000000000031c1
> R10: 0000000000000000 R11: 0000000000000246 R12: ffff81026eb8b1e0
> R13: ffff810001014980 R14: 0000000000000001 R15: 00000000ffffffff
> FS:  0000000041a07940(0063) GS:ffff81027f80d700(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000338b00c2d0 CR3: 0000000254169000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process 5-1.test (pid: 12738, threadinfo ffff8101e6804000, task ffff81026c8de8f0)
> Stack:  0000000000000000 ffff81026eb8b348 ffff8101e6805e78 ffffffff80231c9b
>  0000000000000000 ffff81026eb8b1e0 ffff810001014980 ffff81026eb8b1e0
>  ffff8101e6805e98 ffffffff8022f1bb ffff8101e6805ea8 ffff810001014980
> Call Trace:
>  [<ffffffff80231c9b>] dequeue_task_rt+0x1f/0x5e
>  [<ffffffff8022f1bb>] dequeue_task+0x13/0x1e
>  [<ffffffff8022f1e8>] deactivate_task+0x22/0x2a
>  [<ffffffff802343f9>] sched_setscheduler+0x22e/0x32f
>  [<ffffffff8023486a>] do_sched_setscheduler+0x5f/0x6e
>  [<ffffffff802348a0>] sys_sched_setscheduler+0x14/0x18
>  [<ffffffff8020c0f9>] tracesys+0xdc/0xe1
> 
> 
> Code: 48 89 c8 c3 55 48 89 e5 53 48 83 ec 08 48 8b 9f a8 07 00 00 8b 83 b0 01 00 00 48 8b 8b 98 01 00 00 83 f8 01 74 09 83 f8 02 74 04 <0f> 0b eb fe 48 8b 97 c8 07 00 00 48 2b 53 68 b8 00 00 00 00 48
> RIP  [<ffffffff8023077b>] update_curr_rt+0x27/0x87
>  RSP <ffff8101e6805e38>
> ---[ end trace 792ff0e66da42f45 ]---

Hmm that would be me messing up in: 4c121cce

-       if (!task_has_rt_policy(curr))
-               return;
+       BUG_ON(!task_has_rt_policy(curr));

Does reverting that help?

Strange thing is, at the time I was pretty sure that ought not
happen... /me reaches for a brown paper bag.

