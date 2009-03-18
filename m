Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZCRLga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZCRLga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZCRLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:36:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55798 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZCRLgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:36:19 -0400
Date: Wed, 18 Mar 2009 17:06:21 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, bharata@linux.vnet.ibm.com
Subject: [PATCH] Kprobes: Fix locking imbalance in kretprobes
Message-ID: <20090318113621.GB4129@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix locking imbalance in kretprobes:

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
kthreadd/2 is trying to release lock (&rp->lock) at:
[<c06b3080>] pre_handler_kretprobe+0xea/0xf4
but there are no more locks to release!

other info that might help us debug this:
1 lock held by kthreadd/2:
 #0:  (rcu_read_lock){..--}, at: [<c06b2b24>] __atomic_notifier_call_chain+0x0/0x5a

stack backtrace:
Pid: 2, comm: kthreadd Not tainted 2.6.29-rc8 #1
Call Trace:
 [<c06ae498>] ? printk+0xf/0x17
 [<c06b3080>] ? pre_handler_kretprobe+0xea/0xf4
 [<c044ce6c>] print_unlock_inbalance_bug+0xc3/0xce
 [<c0444d4b>] ? clocksource_read+0x7/0xa
 [<c04450a4>] ? getnstimeofday+0x5f/0xf6
 [<c044a9ca>] ? register_lock_class+0x17/0x293
 [<c044b72c>] ? mark_lock+0x1e/0x30b
 [<c0448956>] ? tick_dev_program_event+0x4a/0xbc
 [<c0498100>] ? __slab_alloc+0xa5/0x415
 [<c06b2fbe>] ? pre_handler_kretprobe+0x28/0xf4
 [<c06b3080>] ? pre_handler_kretprobe+0xea/0xf4
 [<c044cf1b>] lock_release_non_nested+0xa4/0x1a5
 [<c06b3080>] ? pre_handler_kretprobe+0xea/0xf4
 [<c044d15d>] lock_release+0x141/0x166
 [<c06b07dd>] _spin_unlock_irqrestore+0x19/0x50
 [<c06b3080>] pre_handler_kretprobe+0xea/0xf4
 [<c06b20b5>] kprobe_exceptions_notify+0x1c9/0x43e
 [<c06b2b02>] notifier_call_chain+0x26/0x48
 [<c06b2b5b>] __atomic_notifier_call_chain+0x37/0x5a
 [<c06b2b24>] ? __atomic_notifier_call_chain+0x0/0x5a
 [<c06b2b8a>] atomic_notifier_call_chain+0xc/0xe
 [<c0442d0d>] notify_die+0x2d/0x2f
 [<c06b0f9c>] do_int3+0x1f/0x71
 [<c06b0e84>] int3+0x2c/0x34
 [<c042d476>] ? do_fork+0x1/0x288
 [<c040221b>] ? kernel_thread+0x71/0x79
 [<c043ed1b>] ? kthread+0x0/0x60
 [<c043ed1b>] ? kthread+0x0/0x60
 [<c04040b8>] ? kernel_thread_helper+0x0/0x10
 [<c043ec7f>] kthreadd+0xac/0x148
 [<c043ebd3>] ? kthreadd+0x0/0x148
 [<c04040bf>] kernel_thread_helper+0x7/0x10

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Tested-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/kprobes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: utrace-16mar/kernel/kprobes.c
===================================================================
--- utrace-16mar.orig/kernel/kprobes.c
+++ utrace-16mar/kernel/kprobes.c
@@ -912,10 +912,8 @@ static int __kprobes pre_handler_kretpro
 		ri->rp = rp;
 		ri->task = current;
 
-		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_unlock_irqrestore(&rp->lock, flags);
+		if (rp->entry_handler && rp->entry_handler(ri, regs))
 			return 0;
-		}
 
 		arch_prepare_kretprobe(ri, regs);
 
