Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569Ab0A2CHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab0A2CHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280Ab0A2CHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:07:20 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:53075 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab0A2CHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:07:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=twRBNOAz27ZlSYotmqFk2GXIPPUEp16jNdxZwXPtQoEAn5SjToJCdHE1BMWVVzAA/w
         TDXArJMsI0jkO4ldwu1bCbmOImttMZidxz77w+lrfVTJlotcTPuWoAnUUW0sXNBuPTDy
         SBwOQwwqc8C2Ik0GekNTDOpmiRD8owKz/hLLw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] x86/debug: Clear reserved bits of DR6 in do_debug()
Date: Fri, 29 Jan 2010 03:07:08 +0100
Message-Id: <1264730829-14563-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
References: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

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
-- 
1.6.2.3

