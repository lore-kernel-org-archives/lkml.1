Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZBQXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZBQXVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZBQXV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:21:29 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:37881 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZBQXV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V+M7sdzLfBGWbsSETsJxNfP07l/c62Kb24OBunsgHDkRi2K05KFVximlpfsXGWWCju
         YplDCDFl20430wrHyifZqVF7IS1Fo4ginf0KIe5HfAmKvcndE/sr4B8IRzwxQ+yIabpZ
         2Px2CM9pWGksIixST2ZvvuoqIeBbJr8FGaCXM=
Message-ID: <499B465D.9080502@gmail.com>
Date: Wed, 18 Feb 2009 00:21:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090208 SUSE/3.0b1-7.1 Thunderbird/3.0b2pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, x86@kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
In-Reply-To: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.2.2009 21:33, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-17-12-33 has been uploaded to

Hi,

I'm getting the page fault below everytime during bootup. This is how 
__task_rq_lock looks like:
         for (;;) {
                 struct rq *rq;
         printk("CPU=%u %p %p %p %s\n", task_cpu(p), p,
                         task_thread_info(p)->task,
                         task_thread_info(p), p->comm);
                 rq = task_rq(p);
                 spin_lock(&rq->lock);
                 if (likely(rq == task_rq(p)))
                         return rq;
                 spin_unlock(&rq->lock);
         }

CPU=2303197184 ffff880012497d90 b8005f57df1d8948 ffffffff80262d0a 
migration/0
BUG: unable to handle kernel paging request at 00000003cabbb780
IP: [<ffffffff802399eb>] __sched_setscheduler+0x17b/0x4a0
PGD 0
Oops: 0000 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.29-rc5-mm1_64 #578
RIP: 0010:[<ffffffff802399eb>]  [<ffffffff802399eb>] 
__sched_setscheduler+0x17b/0x4a0
RSP: 0018:ffff880012497cc0  EFLAGS: 00000086
RAX: 0000000089480000 RBX: ffffffff80262d0a RCX: 00000000ffffffff
RDX: 000000000000d7d7 RSI: 0000000000000046 RDI: ffffffff80835334
RBP: ffff880012497d30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000010180
R13: 0000000000000000 R14: ffff880012497d90 R15: 0000000000010180
FS:  0000000000000000(0000) GS:ffff880001007000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000003cabbb780 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process swapper (pid: 1, threadinfo ffff880012496000, task ffff880012478000)
Stack:
  0000000000000000 ffff880012497dc0 ffff880012498270 ffffffff12478000
  0000000000000000 ffffffff80262d0a ffff8800124980f0 0000000000000046
  0000000000000246 ffff880012497d50 ffffffff806f1065 0000000000000000
Call Trace:
  [<ffffffff80262d0a>] ? tick_check_broadcast_device+0x3a/0x70
  [<ffffffff80239d1b>] sched_setscheduler_nocheck+0xb/0x10
  [<ffffffff80256ad7>] kthread_create+0xe7/0x120
  [<ffffffff8023b820>] ? migration_thread+0x0/0x230
  [<ffffffff80262d0a>] ? tick_check_broadcast_device+0x3a/0x70
  [<ffffffff80262109>] ? tick_notify+0x369/0x410
  [<ffffffff807d9598>] ? migration_init+0x0/0x5c
  [<ffffffff805de278>] migration_call+0x376/0x4ed
  [<ffffffff807d9598>] ? migration_init+0x0/0x5c
  [<ffffffff807d95be>] migration_init+0x26/0x5c
  [<ffffffff807d9598>] ? migration_init+0x0/0x5c
  [<ffffffff8020904c>] do_one_initcall+0x3c/0x170
  [<ffffffff807d31c4>] ? native_smp_prepare_cpus+0x1c0/0x311
  [<ffffffff807ca559>] kernel_init+0x76/0x1bc
  [<ffffffff8020d8da>] child_rip+0xa/0x20
  [<ffffffff807ca4e3>] ? kernel_init+0x0/0x1bc
  [<ffffffff8020d8d0>] ? child_rip+0x0/0x20
Code: 69 3a 00 49 8b 5e 08 4c 8b 45 08 48 8b 0b ba db 08 00 00 48 c7 c6 
e0 4a 6e 80 48 c7 c7 ce 99 6e 80 31 c0 e8 0b 69 3a 00 8b 43 18 <4c> 03 
24 c5 80 b7 7b 80 4c 89 e7 e8 e5 97 3a 00 49 8b 5e 08 31
RIP  [<ffffffff802399eb>] __sched_setscheduler+0x17b/0x4a0
  RSP <ffff880012497cc0>
CR2: 00000003cabbb780
---[ end trace 4eaa2a86a8e2da22 ]---
