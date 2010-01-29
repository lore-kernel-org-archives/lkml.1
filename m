Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539Ab0A2J1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0A2J1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698Ab0A2J1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:27:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab0A2J1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:27:08 -0500
Date: Fri, 29 Jan 2010 09:26:15 GMT
From: "tip-bot for K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, jan.kiszka@siemens.com, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, jan.kiszka@siemens.com, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20100128111415.GC13935@in.ibm.com>
References: <20100128111415.GC13935@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/hw-breakpoints: Optimize return code from notifier chain in hw_breakpoint_handler
Message-ID: <tip-e0e53db6133c32964fd17f20b17073a402f07ed3@git.kernel.org>
Git-Commit-ID: e0e53db6133c32964fd17f20b17073a402f07ed3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:26:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e53db6133c32964fd17f20b17073a402f07ed3
Gitweb:     http://git.kernel.org/tip/e0e53db6133c32964fd17f20b17073a402f07ed3
Author:     K.Prasad <prasad@linux.vnet.ibm.com>
AuthorDate: Thu, 28 Jan 2010 16:44:15 +0530
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 29 Jan 2010 02:44:30 +0100

x86/hw-breakpoints: Optimize return code from notifier chain in hw_breakpoint_handler

Processing of debug exceptions in do_debug() can stop if it
originated from a hw-breakpoint exception by returning NOTIFY_STOP
in most cases.

But for certain cases such as:

a) user-space breakpoints with pending SIGTRAP signal delivery (as
in the case of ptrace induced breakpoints).

b) exceptions due to other causes than breakpoints

We will continue to process the exception by returning NOTIFY_DONE.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
LKML-Reference: <20100128111415.GC13935@in.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 05d5fec..ae90b47 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 		rcu_read_lock();
 
 		bp = per_cpu(bp_per_reg[i], cpu);
-		if (bp)
-			rc = NOTIFY_DONE;
 		/*
 		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
 		 * exception handling
@@ -522,7 +520,13 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 
 		rcu_read_unlock();
 	}
-	if (dr6 & (~DR_TRAP_BITS))
+	/*
+	 * Further processing in do_debug() is needed for a) user-space
+	 * breakpoints (to generate signals) and b) when the system has
+	 * taken exception due to multiple causes
+	 */
+	if ((current->thread.debugreg6 & DR_TRAP_BITS) ||
+	    (dr6 & (~DR_TRAP_BITS)))
 		rc = NOTIFY_DONE;
 
 	set_debugreg(dr7, 7);
