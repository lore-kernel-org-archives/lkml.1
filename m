Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYAQXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYAQXeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYAQXeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:34:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:2606 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbYAQXeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:34:12 -0500
X-ExtLoop1: 1
Date: Thu, 17 Jan 2008 15:33:55 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Linux ACPI mailing list <linux-acpi@vger.kernel.org>,
       Intel E/100 mailing list <e1000-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080117233355.GA13590@linux-os.sc.intel.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117124622.GA18450@balbir.in.ibm.com> <20080117104021.25a8e562.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com> <20080117114032.1f9f1df5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117114032.1f9f1df5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:40:32AM -0800, Andrew Morton wrote:
> On Thu, 17 Jan 2008 11:22:19 -0800 "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
> 
> >  
> > The problem is
> > >> modprobe:2584 conflicting cache attribute 50000000-50001000
> > >> uncached<->default
> > 
> > Some address range here is being mapped with conflicting types.
> > Somewhere the range was mapped with default (write-back). Later
> > pci_iomap() is mapping that region as uncacheable which is basically
> > aliasing. PAT code detects the aliasing and fails the second uncacheable
> > request which leads in the failure.
> 
> It sounds to me like you need considerably more runtime debugging and
> reporting support in that code.  Ensure that it generates enough output
> both during regular operation and during failures for you to be able to
> diagnose things in a single iteration.
> 
> We can always take it out later.
> 
> 

Patch below makes the interesting printks from PAT non DEBUG.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap.c	2008-01-17 03:18:59.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap.c	2008-01-17 08:11:51.000000000 -0800
@@ -25,10 +25,13 @@
  */
 void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
 {
-	if (pat_wc_enabled)
+	if (pat_wc_enabled) {
+		printk(KERN_INFO "ioremap_wc: addr %lx, size %lx\n",
+		       phys_addr, size);
 		return __ioremap(phys_addr, size, _PAGE_WC);
-	else
+	} else {
 		return ioremap_nocache(phys_addr, size);
+	}
 }
 EXPORT_SYMBOL(ioremap_wc);
 
Index: linux-2.6.git/arch/x86/mm/ioremap_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_32.c	2008-01-17 03:18:59.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_32.c	2008-01-17 08:10:58.000000000 -0800
@@ -164,6 +164,8 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
+	printk(KERN_INFO "ioremap_nocache: addr %lx, size %lx\n",
+	       phys_addr, size);
 	return __ioremap(phys_addr, size, _PAGE_UC);
 }
 EXPORT_SYMBOL(ioremap_nocache);
Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-17 03:18:59.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-17 08:10:13.000000000 -0800
@@ -144,7 +144,7 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	printk(KERN_DEBUG "ioremap_nocache: addr %lx, size %lx\n",
+	printk(KERN_INFO "ioremap_nocache: addr %lx, size %lx\n",
 	       phys_addr, size);
 	return __ioremap(phys_addr, size, _PAGE_UC);
 }
Index: linux-2.6.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pat.c	2008-01-17 03:18:59.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pat.c	2008-01-17 08:06:23.000000000 -0800
@@ -170,7 +170,7 @@
 
 			if (!fattr && attr != ml->attr) {
 				printk(
-	KERN_DEBUG "%s:%d conflicting cache attribute %Lx-%Lx %s<->%s\n",
+	KERN_WARNING "%s:%d conflicting cache attribute %Lx-%Lx %s<->%s\n",
 					current->comm, current->pid,
 					start, end,
 					cattr_name(attr), cattr_name(ml->attr));
@@ -205,7 +205,7 @@
 	list_for_each_entry(ml, &mattr_list, nd) {
 		if (ml->start == start && ml->end == end) {
 			if (ml->attr != attr)
-				printk(KERN_DEBUG
+				printk(KERN_WARNING
 	"%s:%d conflicting cache attributes on free %Lx-%Lx %s<->%s\n",
 			current->comm, current->pid, start, end,
 			cattr_name(attr), cattr_name(ml->attr));
@@ -217,7 +217,7 @@
 	}
 	spin_unlock(&mattr_lock);
 	if (err)
-		printk(KERN_DEBUG "%s:%d freeing invalid mattr %Lx-%Lx %s\n",
+		printk(KERN_WARNING "%s:%d freeing invalid mattr %Lx-%Lx %s\n",
 			current->comm, current->pid,
 			start, end, cattr_name(attr));
 	return err;
Index: linux-2.6.git/include/asm-x86/io_32.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io_32.h	2008-01-17 06:28:06.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io_32.h	2008-01-17 08:09:30.000000000 -0800
@@ -113,6 +113,8 @@
 
 static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
 {
+	printk(KERN_INFO "ioremap: addr %lx, size %lx\n",
+	       offset, size);
 	return __ioremap(offset, size, 0);
 }
 
Index: linux-2.6.git/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io_64.h	2008-01-17 08:08:23.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io_64.h	2008-01-17 08:08:44.000000000 -0800
@@ -154,7 +154,7 @@
 
 static inline void __iomem * ioremap (unsigned long offset, unsigned long size)
 {
-	printk(KERN_DEBUG "ioremap: addr %lx, size %lx\n",
+	printk(KERN_INFO "ioremap: addr %lx, size %lx\n",
 	       offset, size);
 	return __ioremap(offset, size, 0);
 }
