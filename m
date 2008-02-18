Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYBRQgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYBRQgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYBRQfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:35:37 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:44067 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYBRQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:35:35 -0500
Message-Id: <20080218163731.764035851@ldl.fc.hp.com>
References: <20080218163403.364442547@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Feb 2008 09:34:04 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/3] Simplify initcall debug output
Content-Disposition: inline; filename=initcall-debug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_fn_descriptor_symbol() prints the address if we don't have a symbol,
so no need to print both.

Also, combine printing return value with elapsed time.  Changes this:

  Calling initcall 0xc05b7a70: pci_mmcfg_late_insert_resources+0x0/0x50()
  initcall 0xc05b7a70: pci_mmcfg_late_insert_resources+0x0/0x50() returned 1.
  initcall 0xc05b7a70 ran for 0 msecs: pci_mmcfg_late_insert_resources+0x0/0x50()
  initcall at 0xc05b7a70: pci_mmcfg_late_insert_resources+0x0/0x50(): returned with error code 1

to this:

  calling  pci_mmcfg_late_insert_resources+0x0/0x50()
  initcall pci_mmcfg_late_insert_resources+0x0/0x50() returned 1 after 0 msecs
  initcall pci_mmcfg_late_insert_resources+0x0/0x50() returned with error code 1

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work6/init/main.c
===================================================================
--- work6.orig/init/main.c	2008-02-18 08:13:35.000000000 -0700
+++ work6/init/main.c	2008-02-18 08:42:37.000000000 -0700
@@ -680,10 +680,8 @@
 		int result;
 
 		if (initcall_debug) {
-			printk("Calling initcall 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol("calling  %s()\n",
 					(unsigned long) *call);
-			printk("\n");
 			t0 = ktime_get();
 		}
 
@@ -693,15 +691,10 @@
 			t1 = ktime_get();
 			delta = ktime_sub(t1, t0);
 
-			printk("initcall 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol("initcall %s()",
 					(unsigned long) *call);
-			printk(" returned %d.\n", result);
-
-			printk("initcall 0x%p ran for %Ld msecs: ",
-				*call, (unsigned long long)delta.tv64 >> 20);
-			print_fn_descriptor_symbol("%s()\n",
-				(unsigned long) *call);
+			printk(" returned %d after %Ld msecs\n", result,
+				(unsigned long long) delta.tv64 >> 20);
 		}
 
 		if (result && result != -ENODEV && initcall_debug) {
@@ -717,10 +710,9 @@
 			local_irq_enable();
 		}
 		if (msg) {
-			printk(KERN_WARNING "initcall at 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
 					(unsigned long) *call);
-			printk(": returned with %s\n", msg);
+			printk(" returned with %s\n", msg);
 		}
 	}
 

-- 
