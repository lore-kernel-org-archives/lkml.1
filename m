Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbYDUMsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbYDUMsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbYDUMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:48:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38376 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbYDUMsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:48:14 -0400
Subject: Re: v2.6.25: WARNING: at kernel/lockdep.c:2437
	__lock_acquire+0xc69/0xfa0()
From: Peter Zijlstra <peterz@infradead.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com>
References: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 14:48:10 +0200
Message-Id: <1208782090.7115.179.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-20 at 12:29 +0200, Vegard Nossum wrote:
> Hi,
> 
> This appears in clean v2.6.25:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2437 __lock_acquire+0xc69/0xfa0()
> Pid: 1002, comm: scsi_eh_4 Not tainted 2.6.25 #379
>  [<c011bb5c>] warn_on_slowpath+0x3c/0x50
>  [<c013b0f9>] ? __lock_acquire+0x219/0xfa0
>  [<c013b0f9>] ? __lock_acquire+0x219/0xfa0
>  [<c012c2c8>] ? __kernel_text_address+0x8/0x20
>  [<c0104fce>] ? dump_trace+0xce/0x120
>  [<c010a56c>] ? save_stack_trace+0x1c/0x40
>  [<c0138659>] ? save_trace+0x39/0xa0
>  [<c013a3d1>] ? mark_lock+0x61/0x540
>  [<c013bb49>] __lock_acquire+0xc69/0xfa0
>  [<c012b46a>] ? __cancel_work_timer+0x5a/0x140
>  [<c01082ac>] ? native_sched_clock+0x5c/0xb0
>  [<c013beee>] lock_acquire+0x6e/0x90
>  [<c02a8e23>] ? ata_scsi_error+0x33/0x6a0
>  [<c02e4946>] _spin_lock_irqsave+0x26/0x60
>  [<c02a8e23>] ? ata_scsi_error+0x33/0x6a0
>  [<c02a4ee0>] ? ata_bmdma_error_handler+0x0/0x50
>  [<c02a8e23>] ata_scsi_error+0x33/0x6a0
>  [<c02e249a>] ? schedule+0x27a/0x410
>  [<c0256dd1>] ? __scsi_iterate_devices+0x51/0x70
>  [<c025c681>] ? scsi_run_host_queues+0x21/0x30
>  [<c025ae5e>] scsi_error_handler+0x9e/0x4e0
>  [<c02e249a>] ? schedule+0x27a/0x410
>  [<c025adc0>] ? scsi_error_handler+0x0/0x4e0
>  [<c012dd86>] kthread+0x36/0x60
>  [<c012dd50>] ? kthread+0x0/0x60
>  [<c0104c27>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace 5e5d737e76fd4940 ]---

Indeed, quite easy to reproduce:

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 81a4e4a..33901ef 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2434,6 +2434,13 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	 * the hash, not class->key.
 	 */
 	id = class - lock_classes;
+	if (id >= MAX_LOCKDEP_KEYS) {
+		spinlock_t *slock = container_of(lock, spinlock_t, dep_map);
+
+		printk(KERN_EMERG "magic: %x\n", slock->magic);
+		printk(KERN_EMERG "class: %p\n", class);
+		printk(KERN_EMERG "id: %u\n", id);
+	}
 	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 		return 0;
 


gives me:

ata3: PATA max PIO4 cmd 0x1e8 ctl 0x3ee irq 11
magic: c050cf60
class: c7c20e54
id: 2265185251
------------[ cut here ]------------
WARNING: at /mnt/md0/src/linux-2.6-2/kernel/lockdep.c:2444
__lock_acquire+0x57b/0xfd0()


Looks like someone is stomping on the spinlock or just passing us
garbage.



