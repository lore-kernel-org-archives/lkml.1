Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614Ab0A2CHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab0A2CHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135Ab0A2CHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:07:42 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:44606 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab0A2CHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kaZd4gP45PJ/jcYx2q9BEz/X8UjZ2f6EQDbkOCPHVHFaN6lWeN5Q+W616AiCHMfoXU
         8cRZZR8W4U8soQTXK8KpfC9ecj9dmH0OxP9d0TxV39YJM9iX4KFaROGNOk3mJnHbwFyO
         dagAUZDS3533slI+e+5uLVal7Ytqw8nCFHX7Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] x86/hw-breakpoints: Optimize return code from notifier chain in hw_breakpoint_handler
Date: Fri, 29 Jan 2010 03:07:09 +0100
Message-Id: <1264730829-14563-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
References: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

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
-- 
1.6.2.3

