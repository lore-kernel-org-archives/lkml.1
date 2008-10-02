Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYJBLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYJBLSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYJBLS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:18:28 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46399 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYJBLS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:18:27 -0400
Message-ID: <48E4ADF8.8040200@bull.net>
Date: Thu, 02 Oct 2008 13:18:16 +0200
From: Gilles Carry <Gilles.Carry@bull.net>
User-Agent: Mozilla Thunderbird 1.0 (X11/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [BUG][PPC64] BUG in 2.6.26.5-rt9 causing Hang
References: <20080925123235.GA27916@linux.vnet.ibm.com> <48E1460A.5000504@novell.com>
In-Reply-To: <48E1460A.5000504@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I could reproduce the bug on intel x86_64 with LTP's sbrk_mutex:

kernel BUG at kernel/sched_rt.c:1044!
invalid opcode: 0000 [1] PREEMPT SMP
CPU 5
Modules linked in: mptsas scsi_transport_sas
Pid: 27577, comm: sbrk_mutex Not tainted 2.6.26.5-rt9-00002-g3b27927 #23
RIP: 0010:[<ffffffff80227f95>]  [<ffffffff80227f95>] pick_next_pushable_task+0x6
1/0x77
RSP: 0018:ffff81007713fd28  EFLAGS: 00010046
RAX: 0000000000000005 RBX: ffff810083a4e280 RCX: ffff81013dcee458
RDX: ffff8100771f8000 RSI: ffff81013dcee2c0 RDI: ffff810083a4e280
RBP: ffff81007713fd28 R08: ffff81007713e000 R09: 0000000000000000
R10: 000000004bbbc9e0 R11: ffff81007dc3bde8 R12: ffff81023ff7c910
R13: ffff8101bf4ad0c0 R14: 0000000000000001 R15: ffff810083a4e280
FS:  000000004d3bf940(0063) GS:ffff81013f4458c0(0000) knlGS:00000000f7f216c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000389d495770 CR3: 000000007c11a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sbrk_mutex (pid: 27577, threadinfo ffff81007713e000, task ffff8100771d61
c0)
Stack:  ffff81007713fd68 ffffffff8022b1ce ffff81007713fdc8 ffff810083a4e280
  ffff81023ff7c910 ffff8101bf4ad0c0 0000000000000001 0000000000000000
  ffff81007713fd88 ffffffff8022b3c3 ffff81007713fda8 ffff810083a4e280
Call Trace:
  [<ffffffff8022b1ce>] push_rt_task+0x26/0x207
  [<ffffffff8022b3c3>] push_rt_tasks+0x14/0x1c
  [<ffffffff8022b3e4>] post_schedule_rt+0x19/0x25
  [<ffffffff8022d7e9>] finish_task_switch+0x73/0x121
  [<ffffffff805bbe3d>] thread_return+0x4f/0xdc
  [<ffffffff805bc066>] schedule+0xd4/0xf0
  [<ffffffff805bc686>] do_nanosleep+0x5c/0x9c
  [<ffffffff80248350>] ? hrtimer_nanosleep+0x54/0xbd
  [<ffffffff80247c9d>] ? hrtimer_wakeup+0x0/0x21
  [<ffffffff805bc66b>] ? do_nanosleep+0x41/0x9c
  [<ffffffff8022e9f4>] ? schedule_tail+0x43/0x97
  [<ffffffff80248405>] ? sys_nanosleep+0x4c/0x62
  [<ffffffff8020b32a>] ? system_call_after_swapgs+0x8a/0x8f


Code: 42 18 74 04 0f 0b eb fe 48 39 b7 48 0e 00 00 75 04 0f 0b eb fe 83 b9 50 ff
  ff ff 01 7f 04 0f 0b eb fe 83 b9 e0 fe ff ff 00 75 04 <0f> 0b eb fe 83 b9 8c fe
  ff ff 63 7e 04 0f 0b eb fe c9 48 89 f0
RIP  [<ffffffff80227f95>] pick_next_pushable_task+0x61/0x77
  RSP <ffff81007713fd28>




The difference with powerpc64 is that you need to be patient:
it takes tens of minutes to BUG/hang on intel whereas on power it's
almost immediate.


I just posted the patch on this list (Fix pushable_task list corruption)

Greg, please can you review this patch and comment?
Thanks.

Gilles.

