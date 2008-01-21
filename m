Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYAUW6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYAUW6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbYAUW57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:57:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:20687 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867AbYAUW55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mlbwifwoMAML+6vekFwxnd606WUfwhzmcQCLadeLsV0Be9RaTqWPloqVH85neSzLzwneXXtUK76biyNlFaZPU97/veenbYPbEmEWQh9OSrlwACBMI+gA4k2Z7bDSdy4Ni4Y1EMahVGe+AJmymhpGmuoYsSKzNQw6CHxKIw+xS1Q=
Subject: [PATCH 3/3] x86: Unify page fault oops printing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 14:58:03 -0800
Message-Id: <1200956283.16972.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the oops dumping format for page faults to
be similar between X86_32 and 64.

This is the first user of printk_address on X86_32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this patch has behavior changes that will need discussion

 arch/x86/mm/fault_32.c |   12 ++++++------
 arch/x86/mm/fault_64.c |    9 ++++++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index fda3997..28ea3d3 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -340,15 +340,15 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 				"(uid: %d)\n", current->uid);
 	}
 #endif
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
 	if (address < PAGE_SIZE)
-		printk(KERN_ALERT "BUG: unable to handle kernel NULL "
-				"pointer dereference");
+		printk(KERN_CONT "NULL pointer dereference");
 	else
-		printk(KERN_ALERT "BUG: unable to handle kernel paging"
-				" request");
-	printk(" at virtual address %08lx\n", address);
-	printk(KERN_ALERT "printing ip: %08lx ", regs->ip);
+		printk(KERN_CONT "paging request");
+	printk(KERN_CONT " at %08lx\n", address);
 
+	printk(KERN_ALERT "IP:");
+	printk_address(regs->ip, 1);
 	dump_pagetable(address);
 }
 
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 1897704..e12c34b 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -296,11 +296,14 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 			    unsigned long address)
 {
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
 	if (address < PAGE_SIZE)
-		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
+		printk(KERN_CONT "NULL pointer dereference");
 	else
-		printk(KERN_ALERT "Unable to handle kernel paging request");
-	printk(" at %016lx RIP: \n" KERN_ALERT, address);
+		printk(KERN_CONT "paging request");
+	printk(KERN_CONT " at %016lx\n", address);
+
+	printk(KERN_ALERT "IP:");
 	printk_address(regs->ip, 1);
 	dump_pagetable(address);
 }
-- 
1.5.4.rc3.1118.gf6754c

