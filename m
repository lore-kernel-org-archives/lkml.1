Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYA2FG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYA2FG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYA2FGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:33 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34400 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYA2FGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:32 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: ebiederm@xmission.com, vgoyal@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/9] Handle kernel near memory hole in clear_kernel_mapping
Message-Id: <20080129050629.9D3DA1B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:29 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:13.0268 (UTC) FILETIME=[D4C65140:01C86233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This was a long standing obscure problem in the relocatable kernel. The
AMD GART driver needs to unmap part of the GART in the kernel direct mapping to 
prevent cache corruption. With the relocatable kernel it is in theory possible 
that the separate kernel text mapping straddles that area too. 

Normally it should not happen because GART tends to be >= 2GB, and the kernel 
is normally not loaded that high, but it is possible in theory. 

Teach clear_kernel_mapping() about this case.

This will become more important once the kernel mapping uses 1GB pages.

Cc: ebiederm@xmission.com
Cc: vgoyal@redhat.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -438,7 +438,8 @@ void __init paging_init(void)
  * address and size must be aligned to 2MB boundaries.
  * Does nothing when the mapping doesn't exist.
  */
-void __init clear_kernel_mapping(unsigned long address, unsigned long size)
+static void __init
+__clear_kernel_mapping(unsigned long address, unsigned long size)
 {
 	unsigned long end = address + size;
 
@@ -475,6 +476,28 @@ void __init clear_kernel_mapping(unsigne
 	__flush_tlb_all();
 }
 
+#define overlaps(as, ae, bs, be) ((ae) >= (bs) && (as) <= (be))
+
+void __init clear_kernel_mapping(unsigned long address, unsigned long size)
+{
+	int sh = PMD_SHIFT;
+	unsigned long kernel = __pa(__START_KERNEL_map);
+
+	/*
+	 * Note that we cannot unmap the kernel itself because the unmapped
+	 * holes here are always at least 2MB aligned.
+	 * This just applies to the trailing areas of the 40MB kernel mapping.
+	 */
+	if (overlaps(kernel >> sh, (kernel + KERNEL_TEXT_SIZE) >> sh,
+			__pa(address) >> sh, __pa(address + size) >> sh)) {
+		printk(KERN_WARNING
+			"Kernel mapping at %lx within 2MB of memory hole\n",
+				kernel);
+		__clear_kernel_mapping(__START_KERNEL_map+__pa(address), size);
+	}
+	__clear_kernel_mapping(address, size);
+}
+
 /*
  * Memory hotplug specific functions
  */
