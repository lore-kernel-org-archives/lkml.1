Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbXHPHbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbXHPHbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761908AbXHPHbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:31:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:8820 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412AbXHPHbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:31:17 -0400
X-IronPort-AV: i="4.19,270,1183348800"; 
   d="scan'208"; a="48464691:sNHT24890264"
Subject: [PATCH 2/2] Blackfin: Deal with flat binfmt differently to FDPIC
	ELF binfmt when dumping
From: Jie Zhang <jie.zhang@analog.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 16 Aug 2007 15:24:54 +0800
Message-Id: <1187249094.11475.29.camel@mercury.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 16 Aug 2007 07:31:12.0242 (UTC) FILETIME=[6BC58D20:01C7DFD7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This Blackfin arch patch uses the new `name' field in struct
linux_binfmt added by my first patch.


Jie


Signed-off-by: Jie Zhang <jie.zhang@analog.com>
---
 arch/blackfin/kernel/traps.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 792a841..9961c21 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -111,9 +111,7 @@ static int printk_address(unsigned long address)
 				/* FLAT does not have its text aligned to the start of
 				 * the map while FDPIC ELF does ...
 				 */
-				if (current->mm &&
-				    (address > current->mm->start_code) &&
-				    (address < current->mm->end_code))
+				if (strcmp(current->binfmt->name, "flat") == 0)
 					offset = address - current->mm->start_code;
 				else
 					offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
@@ -533,7 +531,7 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 		     " or you are in the kernel\n");
 	}
 
-	if (current->mm) {
+	if (current->mm && strcmp(current->binfmt->name, "flat") == 0) {
 		printk(KERN_EMERG "TEXT = 0x%p-0x%p  DATA = 0x%p-0x%p\n"
 		       KERN_EMERG "BSS = 0x%p-0x%p   USER-STACK = 0x%p\n"
 		       KERN_EMERG "\n",
@@ -544,6 +542,16 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 		       (void *)current->mm->end_data,
 		       (void *)current->mm->brk,
 		       (void *)current->mm->start_stack);
+	} else if (current->mm
+		   && strcmp(current->binfmt->name, "ELF FDPIC") == 0) {
+		printk(KERN_EMERG "TEXT = 0x%p-0x%p  DATA = 0x%p-0x%p\n"
+		       KERN_EMERG "USER-STACK = 0x%p\n"
+		       KERN_EMERG "\n",
+		       (void *)current->mm->start_code,
+		       (void *)current->mm->end_code,
+		       (void *)current->mm->start_data,
+		       (void *)current->mm->end_data,
+		       (void *)current->mm->start_stack);
 	}
 
 	printk(KERN_EMERG "return address: [0x%p]; contents of:", retaddr);
-- 
1.5.2.4
