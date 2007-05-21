Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXEUKJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXEUKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbXEUKJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:23653 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbXEUKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:09 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505437:sNHT22703177"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 11/32] Blackfin arch: fix trace output for FLAT binaries
Date: Mon, 21 May 2007 18:09:19 +0800
Message-Id: <11797421841303-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/traps.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 9556b73..9932ede 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -59,9 +59,10 @@ static int printk_address(unsigned long address)
 	struct vm_list_struct *vml;
 	struct task_struct *p;
 	struct mm_struct *mm;
+	unsigned long offset;
 
 #ifdef CONFIG_KALLSYMS
-	unsigned long offset = 0, symsize;
+	unsigned long symsize;
 	const char *symname;
 	char *modname;
 	char *delim = ":";
@@ -106,12 +107,19 @@ static int printk_address(unsigned long address)
 					              sizeof(_tmpbuf));
 				}
 
+				/* FLAT does not have its text aligned to the start of
+				 * the map while FDPIC ELF does ...
+				 */
+				if (current->mm &&
+				    (address > current->mm->start_code) &&
+				    (address < current->mm->end_code))
+					offset = address - current->mm->start_code;
+				else
+					offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+
 				write_unlock_irq(&tasklist_lock);
 				return printk("<0x%p> [ %s + 0x%lx ]",
-				              (void*)address, name,
-				              (unsigned long)
-				                ((address - vma->vm_start) +
-				                 (vma->vm_pgoff << PAGE_SHIFT)));
+				              (void*)address, name, offset);
 			}
 
 			vml = vml->next;
-- 
1.5.1.2
