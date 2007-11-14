Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXKNTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXKNTVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762446AbXKNTVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:21:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44247 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762394AbXKNTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:21:05 -0500
Date: Wed, 14 Nov 2007 14:20:50 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - Host TLS diagnostics
Message-ID: <20071114192050.GA9093@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add some diagnostics when TLS operations on the host fail.  Also spit
out more information about the TLS environment on the host at boot
time.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-i386/tls.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/tls.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/tls.c	2007-11-14 14:08:50.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/tls.c	2007-11-14 14:19:02.000000000 -0500
@@ -26,6 +26,11 @@ int do_set_thread_area(struct user_desc 
 	cpu = get_cpu();
 	ret = os_set_thread_area(info, userspace_pid[cpu]);
 	put_cpu();
+
+	if (ret)
+		printk(KERN_ERR "PTRACE_SET_THREAD_AREA failed, err = %d, "
+		       "index = %d\n", ret, info->entry_number);
+
 	return ret;
 }
 
@@ -37,6 +42,11 @@ int do_get_thread_area(struct user_desc 
 	cpu = get_cpu();
 	ret = os_get_thread_area(info, userspace_pid[cpu]);
 	put_cpu();
+
+	if (ret)
+		printk(KERN_ERR "PTRACE_GET_THREAD_AREA failed, err = %d, "
+		       "index = %d\n", ret, info->entry_number);
+
 	return ret;
 }
 
@@ -356,10 +366,9 @@ out:
 	return ret;
 }
 
-
 /*
- * XXX: This part is probably common to i386 and x86-64. Don't create a common
- * file for now, do that when implementing x86-64 support.
+ * This code is really i386-only, but it detects and logs x86_64 GDT indexes
+ * if a 32-bit UML is running on a 64-bit host.
  */
 static int __init __setup_host_supports_tls(void)
 {
@@ -368,13 +377,16 @@ static int __init __setup_host_supports_
 		printk(KERN_INFO "Host TLS support detected\n");
 		printk(KERN_INFO "Detected host type: ");
 		switch (host_gdt_entry_tls_min) {
-			case GDT_ENTRY_TLS_MIN_I386:
-				printk("i386\n");
-				break;
-			case GDT_ENTRY_TLS_MIN_X86_64:
-				printk("x86_64\n");
-				break;
+		case GDT_ENTRY_TLS_MIN_I386:
+			printk(KERN_CONT "i386");
+			break;
+		case GDT_ENTRY_TLS_MIN_X86_64:
+			printk(KERN_CONT "x86_64");
+			break;
 		}
+		printk(KERN_CONT " (GDT indexes %d to %d)\n",
+		       host_gdt_entry_tls_min,
+		       host_gdt_entry_tls_min + GDT_ENTRY_TLS_ENTRIES);
 	} else
 		printk(KERN_ERR "  Host TLS support NOT detected! "
 				"TLS support inside UML will not work\n");
