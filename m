Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZCRL51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZCRL51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZCRL5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:57:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbZCRL5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:57:05 -0400
Date: Wed, 18 Mar 2009 11:54:28 GMT
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, torvalds@linux-foundation.org, ananth@in.ibm.com,
       bharata@linux.vnet.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, torvalds@linux-foundation.org, ananth@in.ibm.com,
       bharata@linux.vnet.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090318113621.GB4129@in.ibm.com>
References: <20090318113621.GB4129@in.ibm.com>
Subject: [tip:tracing/kprobes] kprobes: Fix locking imbalance in kretprobes
Message-ID: <tip-f02b8624fedca39886b0eef770dca70c2f0749b3@git.kernel.org>
Git-Commit-ID: f02b8624fedca39886b0eef770dca70c2f0749b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 11:54:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f02b8624fedca39886b0eef770dca70c2f0749b3
Gitweb:     http://git.kernel.org/tip/f02b8624fedca39886b0eef770dca70c2f0749b3
Author:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
AuthorDate: Wed, 18 Mar 2009 17:06:21 +0530
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 12:51:16 +0100

kprobes: Fix locking imbalance in kretprobes

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
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org> [2.6.29.x, 2.6.28.x, 2.6.27.x]
LKML-Reference: <20090318113621.GB4129@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/kprobes.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 479d4d5..5016bfb 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -919,10 +919,8 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 		ri->rp = rp;
 		ri->task = current;
 
-		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_unlock_irqrestore(&rp->lock, flags);
+		if (rp->entry_handler && rp->entry_handler(ri, regs))
 			return 0;
-		}
 
 		arch_prepare_kretprobe(ri, regs);
 
