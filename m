Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXDEAke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXDEAke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXDEAke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:40:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55307 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932442AbXDEAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:40:33 -0400
Date: Wed, 4 Apr 2007 17:40:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [i386] Use page allocator to allocate threadinfo structure
Message-ID: <Pine.LNX.4.64.0704041734270.22851@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 uses kmalloc to allocate the threadinfo structure assuming that the 
allocations result in a page sized aligned allocation. That has worked so 
far because SLAB exempts page sized slabs from debugging and aligns them 
in special ways that goes beyond the restrictions imposed by 
KMALLOC_ARCH_MINALIGN valid for other slabs in the kmalloc array.

SLUB also works fine without debugging since page sized allocations neatly 
align at page boundaries. However, if debugging is switched on then SLUB 
will extend the slab with debug information. The resulting slab is not 
longer of page size. It will only be aligned following the requirements 
imposed by KMALLOC_ARCH_MINALIGN. As a result the threadinfo 
structure may not be page aligned which makes i386 fail to boot with
SLUB debug on.

Replace the calls to kmalloc with calls into the page allocator.

An alternate solution may be to create a custom slab cache where the 
alignment is set to PAGE_SIZE. That would allow slub debugging to be 
applied to the threadinfo structure.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6.21-rc5-mm4.orig/include/asm-i386/thread_info.h	2007-04-03 23:48:34.000000000 -0700
+++ linux-2.6.21-rc5-mm4/include/asm-i386/thread_info.h	2007-04-04 17:33:41.000000000 -0700
@@ -95,12 +95,14 @@ static inline struct thread_info *curren
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info(tsk) ((struct thread_info *) \
+	__get_free_pages(GFP_KERNEL| __GFP_ZERO, get_order(THREAD_SIZE)))
 #else
-#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info(tsk) ((struct thread_info *) \
+	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
 #endif
 
-#define free_thread_info(info)	kfree(info)
+#define free_thread_info(info)	free_pages((unsigned long)(info), get_order(THREAD_SIZE))
 
 #else /* !__ASSEMBLY__ */
 
