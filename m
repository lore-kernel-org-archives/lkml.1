Return-Path: <linux-kernel-owner+w=401wt.eu-S1030953AbXEAS0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030953AbXEAS0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030972AbXEAS0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:26:12 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38464 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030953AbXEAS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:26:09 -0400
Date: Tue, 1 May 2007 14:21:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/6] UML - free() wrapper should call libc free
Message-ID: <20070501182158.GA8358@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The libc free wrapper wasn't correctly detecting buffers obtained with
malloc().  This is now done by seeing if the page was reserved.  This is
the case for memory which is left aside for libc and isn't given to
the page allocator.  If we free a pointer in a reserved page, it is
given to free() rather than kfree().

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/user.h   |    1 +
 arch/um/kernel/um_arch.c |    7 +++++++
 arch/um/os-Linux/main.c  |    6 +++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/include/user.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user.h	2007-04-26 17:33:01.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user.h	2007-04-27 14:21:35.000000000 -0400
@@ -27,5 +27,6 @@ extern int in_aton(char *str);
 extern int open_gdb_chan(void);
 extern size_t strlcpy(char *, const char *, size_t);
 extern size_t strlcat(char *, const char *, size_t);
+extern int reserved_address(void *addr);
 
 #endif
Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-04-26 17:41:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-04-27 14:30:36.000000000 -0400
@@ -500,6 +500,13 @@ void __init check_bugs(void)
 	os_check_bugs();
 }
 
+int reserved_address(void *addr)
+{
+	struct page *page = virt_to_page(addr);
+
+	return(PageReserved(page));
+}
+
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 }
Index: linux-2.6.21-mm/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/main.c	2007-04-26 17:41:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/main.c	2007-04-27 14:30:31.000000000 -0400
@@ -266,6 +266,8 @@ void __wrap_free(void *ptr)
 	/* We need to know how the allocation happened, so it can be correctly
 	 * freed.  This is done by seeing what region of memory the pointer is
 	 * in -
+	 *	in a reserved page - free, assume the pointer was
+	 *	    acquired with malloc, since it couldn't have been kmalloced.
 	 * 	physical memory - kmalloc/kfree
 	 *	kernel virtual memory - vmalloc/vfree
 	 * 	anywhere else - malloc/free
@@ -281,7 +283,9 @@ void __wrap_free(void *ptr)
 	 * there is a possibility for memory leaks.
 	 */
 
-	if((addr >= uml_physmem) && (addr < high_physmem)){
+	if(kmalloc_ok && reserved_address(ptr))
+		__real_free(ptr);
+	else if((addr >= uml_physmem) && (addr < high_physmem)){
 		if(CAN_KMALLOC())
 			kfree(ptr);
 	}
