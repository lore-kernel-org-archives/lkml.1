Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZBDUzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZBDUzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZBDUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:54:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZBDUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:54:48 -0500
Date: Wed, 4 Feb 2009 15:54:45 -0500
From: Kyle McMartin <kyle@infradead.org>
To: mingo@redhat.com
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: print DMI info in the oops trace
Message-ID: <20090204205445.GA17963@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

This patch echoes what we already do on 32-bit since
90f7d25c6b672137344f447a30a9159945ffea72, and prints the DMI
product name in show_regs, so that system specific problems can be
easily identified.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---

Noticed we weren't doing this on x86_64 while backporting this change
to 2.6.27 for Fedora... Any reason for it?

cheers, Kyle

 arch/x86/kernel/process_64.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 416fb92..85b4cb5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -40,6 +40,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -151,14 +152,18 @@ void __show_regs(struct pt_regs *regs, int all)
 	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
+	const char *board;
 
 	printk("\n");
 	print_modules();
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s\n",
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!board)
+		board = "";
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+		init_utsname()->version, board);
 	printk(KERN_INFO "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_INFO "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
-- 
1.6.0.6

