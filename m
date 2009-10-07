Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbZJGImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbZJGImR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933515AbZJGImP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:42:15 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:50063 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110AbZJGImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:42:12 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 6/7] x86 dumpstack: fix printing of stack dump loglevels
Date: Wed,  7 Oct 2009 09:39:46 +0100
Message-Id: <1254904787-11323-7-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5fd29d6 "printk: clean up handling of log-levels and newlines"
breaks the log level in the output of the x86 stack dumper:

    Pid: 2199, comm: klauncher Not tainted (2.6.32-rc2eeepc-test #483) 701
     EFLAGS: 00010296 CPU: 0
     EIP is at fget_light+0x39/0x79
     ...
     Stack:
     00000020 dbe23e7c dbe23f8c c01a62bd 00000001 d759c400 dbc61840 00000000
     <0> 08088728 08088750 00000000 dbe23e74 dbe23ea4 00000000 00000000 00000000
     <0> dbe23c18 00c7afc0 c01a6eb1 ffffffff 00000000 dbc61840 00000000 00000000

      ^ stray loglevel tokens

Those last two lines will also be incorrectly output as KERN_DEFAULT.

In this case the problem is effectively

    printk("\n" KERN_EMERG);

Changing printk() to accept loglevels in the middle of the string again
would be non-trivial.  Let's accept this limitation and simply split the
above code into two separate calls to printk().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 arch/x86/kernel/dumpstack_32.c |    6 ++++--
 arch/x86/kernel/dumpstack_64.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f7dd2a7..8f1fb21 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -88,8 +88,10 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (kstack_end(stack))
 			break;
-		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("\n%s", log_lvl);
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0)) {
+			printk("\n");
+			printk("%s", log_lvl);
+		}
 		printk(" %08lx", *stack++);
 		touch_nmi_watchdog();
 	}
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a071e6b..dbe1734 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -235,8 +235,10 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (((long) stack & (THREAD_SIZE-1)) == 0)
 			break;
 		}
-		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("\n%s", log_lvl);
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0)) {
+			printk("\n");
+			printk("%s", log_lvl);
+		}
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
-- 
1.6.3.2

