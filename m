Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbZD2Wgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbZD2Wgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbZD2WVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:45 -0400
Received: from kroah.org ([198.145.64.141]:40532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760079AbZD2WVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.014406153@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 40/58] kprobes: Fix locking imbalance in kretprobes
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=kprobes-fix-locking-imbalance-in-kretprobes.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

commit f02b8624fedca39886b0eef770dca70c2f0749b3 upstream.

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
LKML-Reference: <20090318113621.GB4129@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/kprobes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -890,10 +890,8 @@ static int __kprobes pre_handler_kretpro
 		ri->rp = rp;
 		ri->task = current;
 
-		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_unlock_irqrestore(&rp->lock, flags);
+		if (rp->entry_handler && rp->entry_handler(ri, regs))
 			return 0;
-		}
 
 		arch_prepare_kretprobe(ri, regs);
 


