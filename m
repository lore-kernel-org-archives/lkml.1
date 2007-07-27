Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbXG0DUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbXG0DUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 23:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXG0DT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 23:19:59 -0400
Received: from urquell.c3sl.ufpr.br ([200.17.202.3]:48945 "EHLO
	urquell.c3sl.ufpr.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbXG0DT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 23:19:58 -0400
X-Greylist: delayed 1882 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 23:19:58 EDT
Message-ID: <46A95CFC.9050509@c3sl.ufpr.br>
Date: Thu, 26 Jul 2007 23:48:28 -0300
From: Tiago Vignatti <vignatti@c3sl.ufpr.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] exporting address to the page fault notifier
Content-Type: multipart/mixed;
 boundary="------------030004050702050201060603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030004050702050201060603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

I made a module using the notifier scheme which already exists inside 
the kernel. The problem is that the page fault notifier doesn't show the 
address which happened the fault.

This little patch increments this functionality. I chose to break the 
ABI putting a new field in 'die_args' instead build a new struct only 
for it. The patch and the module notifier comes attached.

my regards


-- 
Tiago Vignatti
C3SL - Centro de Computação Científica e Software Livre
www.c3sl.ufpr.br

--------------030004050702050201060603
Content-Type: text/x-patch;
 name="export-address-to-page-fault-notifier.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="export-address-to-page-fault-notifier.diff"

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 01ffdd4..c405802 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -47,14 +47,15 @@ int unregister_page_fault_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_page_fault_notifier);
 
-static inline int notify_page_fault(struct pt_regs *regs, long err)
+static inline int notify_page_fault(struct pt_regs *regs, long err, unsigned long address)
 {
 	struct die_args args = {
 		.regs = regs,
 		.str = "page fault",
 		.err = err,
 		.trapnr = 14,
-		.signr = SIGSEGV
+		.signr = SIGSEGV,
+		.address = address
 	};
 	return atomic_notifier_call_chain(&notify_page_fault_chain,
 	                                  DIE_PAGE_FAULT, &args);
@@ -330,7 +331,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	if (unlikely(address >= TASK_SIZE)) {
 		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
 			return;
-		if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+		if (notify_page_fault(regs, error_code, address) == NOTIFY_STOP)
 			return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
@@ -339,7 +340,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 		goto bad_area_nosemaphore;
 	}
 
-	if (notify_page_fault(regs, error_code) == NOTIFY_STOP)
+	if (notify_page_fault(regs, error_code, address) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
diff --git a/include/linux/kdebug.h b/include/linux/kdebug.h
index 5db38d6..e8005c2 100644
--- a/include/linux/kdebug.h
+++ b/include/linux/kdebug.h
@@ -9,6 +9,7 @@ struct die_args {
 	long err;
 	int trapnr;
 	int signr;
+	unsigned long address;
 };
 
 int register_die_notifier(struct notifier_block *nb);

--------------030004050702050201060603
Content-Type: text/x-csrc;
 name="page_fault_notifier.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="page_fault_notifier.c"

/* 
 * Author: Tiago Vignatti <vignatti (at) c3sl ufpr br>
 * 2007 - code under GPL 
 */
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/notifier.h>
#include <linux/kdebug.h>

/* 
 * error_code:
 *      bit 0 == 0 means no page found, 1 means protection fault
 *      bit 1 == 0 means read, 1 means write
 *      bit 2 == 0 means kernel, 1 means user-mode
 *      bit 3 == 1 means use of reserved bit detected
 *      bit 4 == 1 means fault was an instruction fetch
 */
static int pf_notify (struct notifier_block *self,
                                unsigned long val, void *data)
{
	struct die_args *args = (struct die_args *) data;

	/* You can filter the types of page like this: 
	if (args->err < 4)
		return NOTIFY_DONE;
	*/

	printk("pagefault regs: %p, address: 0x%lx, fault: %lx ",
	       args->regs, args->address, args->err);

	switch (args->err) {
		case 7:
			printk("(write protection fault in user-mode)\n");
			break;
		case 6:
			printk("(write page fault in user-mode)\n");
			break;
		case 5:
			printk("(write protection fault in user-mode)\n");
			break;
		case 4:
			printk("(read page fault in user-mode)\n");
			break;
		case 3:
			printk("(write protection fault in kernel-mode)\n");
			break;
		case 2:
			printk("(write page fault in kernel-mode)\n");
			break;
		case 1:
			printk("(read protection fault in kernel-mode)\n");
			break;
		case 0:
			printk("(read page fault in kernel-mode)\n");
			break;
		default :
			printk("(use of reserved bit detected or fault was an instruction fetch)\n");
			break;
	}

	return NOTIFY_DONE;
}

static struct notifier_block my_nb = {
	.notifier_call = pf_notify,
};

static int __init notifier_init(void)
{
	int ret;

	if ((ret = register_page_fault_notifier(&my_nb)) < 0) {
		printk("register_page_fault_notifier failed, returned %d\n", ret);
		return -1;
	}

	printk("Planted page fault notifier!\n");
	return 0;
}

static void __exit notifier_exit(void)
{
	unregister_page_fault_notifier(&my_nb);
	printk("Page fault notifier unregistered\n");
}

module_init(notifier_init)
module_exit(notifier_exit)
MODULE_LICENSE("GPL");

--------------030004050702050201060603--
