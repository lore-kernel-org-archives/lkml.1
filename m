Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262Ab0A2J1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0A2J1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929Ab0A2J1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:27:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:57346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab0A2J1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:27:08 -0500
Date: Fri, 29 Jan 2010 09:25:59 GMT
From: "tip-bot for K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, jan.kiszka@siemens.com, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, jan.kiszka@siemens.com, fweisbec@gmail.com,
       roland@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <20100128111401.GB13935@in.ibm.com>
References: <20100128111401.GB13935@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/debug: Clear reserved bits of DR6 in do_debug()
Message-ID: <tip-40f9249a73f6c251adea492b1c3d19d39e2a9bda@git.kernel.org>
Git-Commit-ID: 40f9249a73f6c251adea492b1c3d19d39e2a9bda
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:26:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40f9249a73f6c251adea492b1c3d19d39e2a9bda
Gitweb:     http://git.kernel.org/tip/40f9249a73f6c251adea492b1c3d19d39e2a9bda
Author:     K.Prasad <prasad@linux.vnet.ibm.com>
AuthorDate: Thu, 28 Jan 2010 16:44:01 +0530
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 29 Jan 2010 02:26:10 +0100

x86/debug: Clear reserved bits of DR6 in do_debug()

Clear the reserved bits from the stored copy of debug status
register (DR6).
This will help easy bitwise operations such as quick testing
of a debug event origin.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100128111401.GB13935@in.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/debugreg.h |    3 +++
 arch/x86/kernel/traps.c         |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 8240f76..b81002f 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -14,6 +14,9 @@
    which debugging register was responsible for the trap.  The other bits
    are either reserved or not of interest to us. */
 
+/* Define reserved bits in DR6 which are always set to 1 */
+#define DR6_RESERVED	(0xFFFF0FF0)
+
 #define DR_TRAP0	(0x1)		/* db0 */
 #define DR_TRAP1	(0x2)		/* db1 */
 #define DR_TRAP2	(0x4)		/* db2 */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3339917..1168e44 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -534,6 +534,9 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	get_debugreg(dr6, 6);
 
+	/* Filter out all the reserved bits which are preset to 1 */
+	dr6 &= ~DR6_RESERVED;
+
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
 		return;
