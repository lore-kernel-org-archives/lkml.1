Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXCEWjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXCEWjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXCEWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:39:15 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:1328 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXCEWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:39:14 -0500
Date: Mon, 5 Mar 2007 23:39:11 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] kprobes breaks BUG_ON
Message-ID: <20070305223910.GA22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] kprobes breaks BUG_ON

The illegal operation handler calls the die notifier with DIE_BPT to
let kprobes pick up its breakpoint. If kprobes does not find its
breakpoint it returns NOTIFY_STOP instead of NOTIFY_DONE.
Since we use stop_machine_run on s390 to arm/disarm the kprobes
breakpoints the race that kprobe_handler tries to solve by checking
for the kprobes breakpoints does not exist. Removing the check makes
BUG_ON working again.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/kprobes.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/kprobes.c linux-2.6-patched/arch/s390/kernel/kprobes.c
--- linux-2.6/arch/s390/kernel/kprobes.c	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/kprobes.c	2007-03-05 22:51:47.000000000 +0100
@@ -337,21 +337,14 @@ static int __kprobes kprobe_handler(stru
 	}
 
 	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 *
-			 */
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
+	if (!p)
+		/*
+		 * No kprobe at this address. The fault has not been
+		 * caused by a kprobe breakpoint. The race of breakpoint
+		 * vs. kprobe remove does not exist because on s390 we
+		 * use stop_machine_run to arm/disarm the breakpoints.
+		 */
 		goto no_kprobe;
-	}
 
 	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 	set_current_kprobe(p, regs, kcb);
