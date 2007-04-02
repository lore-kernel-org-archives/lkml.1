Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXDBJXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXDBJXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXDBJXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:23:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37016 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267AbXDBJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:23:04 -0400
Date: Mon, 2 Apr 2007 14:56:36 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Maneesh Soni <maneesh@in.ibm.com>
Subject: [PATCH] Kprobes: Print details of kretprobe on assertion failure
Message-ID: <20070402092636.GA27905@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

In certain cases like when the real return address can't be found or
when the number of tracked calls to a kretprobed function is less than
the number of returns, we may not be able to find the correct return
address after processing a kretprobe. Currently we just do a BUG_ON, but
no information is provided about the actual failing kretprobe.

Print out details of the kretprobe before calling BUG().

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

---
 arch/i386/kernel/kprobes.c    |    6 +++++-
 arch/ia64/kernel/kprobes.c    |    7 ++++++-
 arch/powerpc/kernel/kprobes.c |    7 ++++++-
 arch/x86_64/kernel/kprobes.c  |    7 ++++++-
 4 files changed, 23 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc5/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/i386/kernel/kprobes.c
@@ -440,7 +440,11 @@ fastcall void *__kprobes trampoline_hand
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
+				ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
 
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
 
Index: linux-2.6.21-rc5/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/ia64/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/ia64/kernel/kprobes.c
@@ -444,7 +444,12 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
+				ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
+
 	regs->cr_iip = orig_ret_address;
 
 	reset_current_kprobe();
Index: linux-2.6.21-rc5/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/powerpc/kernel/kprobes.c
@@ -293,7 +293,12 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
+				ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
+
 	regs->nip = orig_ret_address;
 
 	reset_current_kprobe();
Index: linux-2.6.21-rc5/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/x86_64/kernel/kprobes.c
@@ -438,7 +438,12 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
+				ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
+
 	regs->rip = orig_ret_address;
 
 	reset_current_kprobe();
