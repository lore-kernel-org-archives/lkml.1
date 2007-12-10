Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbXLJSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbXLJSB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXLJSA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:00:58 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55197 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbXLJSA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:00:56 -0500
Date: Mon, 10 Dec 2007 13:00:08 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/5] UML - Eliminate setjmp_wrapper
Message-ID: <20071210180008.GA9343@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setjmp_wrapper existed to provide setjmp to kernel code when UML used
libc's setjmp and longjmp.  Now that UML has its own implementation,
this isn't needed and kernel code can invoke setjmp directly.

do_buffer_op is massively cleaned up since it is no longer a callback
from setjmp_wrapper and given a va_list from which it must extract its
arguments.

The actual setjmp is moved from buffer_op to do_op_one_page because
the copy operation is inside an atomic section (kmap_atomic to
kunmap_atomic) and it shouldn't be longjmp-ed out of.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h          |    1 
 arch/um/kernel/skas/uaccess.c |   73 +++++++++++++++---------------------------
 arch/um/os-Linux/util.c       |   15 --------
 3 files changed, 27 insertions(+), 62 deletions(-)

Index: linux-2.6-git/arch/um/include/os.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/os.h	2007-12-10 12:37:04.000000000 -0500
+++ linux-2.6-git/arch/um/include/os.h	2007-12-10 12:37:59.000000000 -0500
@@ -237,7 +237,6 @@ extern void stack_protections(unsigned l
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
-extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
 extern void os_dump_core(void);
 
 /* time.c */
Index: linux-2.6-git/arch/um/kernel/skas/uaccess.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/skas/uaccess.c	2007-12-10 12:36:31.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/skas/uaccess.c	2007-12-10 12:37:59.000000000 -0500
@@ -58,9 +58,10 @@ static pte_t *maybe_map(unsigned long vi
 static int do_op_one_page(unsigned long addr, int len, int is_write,
 		 int (*op)(unsigned long addr, int len, void *arg), void *arg)
 {
+	jmp_buf buf;
 	struct page *page;
 	pte_t *pte;
-	int n;
+	int n, faulted;
 
 	pte = maybe_map(addr, is_write);
 	if (pte == NULL)
@@ -70,82 +71,62 @@ static int do_op_one_page(unsigned long 
 	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) +
 		(addr & ~PAGE_MASK);
 
-	n = (*op)(addr, len, arg);
+	current->thread.fault_catcher = &buf;
+
+	faulted = UML_SETJMP(&buf);
+	if (faulted == 0)
+		n = (*op)(addr, len, arg);
+	else
+		n = -1;
+
+	current->thread.fault_catcher = NULL;
 
 	kunmap_atomic(page, KM_UML_USERCOPY);
 
 	return n;
 }
 
-static void do_buffer_op(void *jmpbuf, void *arg_ptr)
+static int buffer_op(unsigned long addr, int len, int is_write,
+		     int (*op)(unsigned long, int, void *), void *arg)
 {
-	va_list args;
-	unsigned long addr;
-	int len, is_write, size, remain, n;
-	int (*op)(unsigned long, int, void *);
-	void *arg;
-	int *res;
-
-	va_copy(args, *(va_list *)arg_ptr);
-	addr = va_arg(args, unsigned long);
-	len = va_arg(args, int);
-	is_write = va_arg(args, int);
-	op = va_arg(args, void *);
-	arg = va_arg(args, void *);
-	res = va_arg(args, int *);
-	va_end(args);
+	int size, remain, n;
+
 	size = min(PAGE_ALIGN(addr) - addr, (unsigned long) len);
 	remain = len;
 
-	current->thread.fault_catcher = jmpbuf;
 	n = do_op_one_page(addr, size, is_write, op, arg);
 	if (n != 0) {
-		*res = (n < 0 ? remain : 0);
+		remain = (n < 0 ? remain : 0);
 		goto out;
 	}
 
 	addr += size;
 	remain -= size;
-	if (remain == 0) {
-		*res = 0;
+	if (remain == 0)
 		goto out;
-	}
 
-	while(addr < ((addr + remain) & PAGE_MASK)) {
+	while (addr < ((addr + remain) & PAGE_MASK)) {
 		n = do_op_one_page(addr, PAGE_SIZE, is_write, op, arg);
 		if (n != 0) {
-			*res = (n < 0 ? remain : 0);
+			remain = (n < 0 ? remain : 0);
 			goto out;
 		}
 
 		addr += PAGE_SIZE;
 		remain -= PAGE_SIZE;
 	}
-	if (remain == 0) {
-		*res = 0;
+	if (remain == 0)
 		goto out;
-	}
 
 	n = do_op_one_page(addr, remain, is_write, op, arg);
-	if (n != 0)
-		*res = (n < 0 ? remain : 0);
-	else *res = 0;
- out:
-	current->thread.fault_catcher = NULL;
-}
-
-static int buffer_op(unsigned long addr, int len, int is_write,
-		     int (*op)(unsigned long addr, int len, void *arg),
-		     void *arg)
-{
-	int faulted, res;
-
-	faulted = setjmp_wrapper(do_buffer_op, addr, len, is_write, op, arg,
-				 &res);
-	if (!faulted)
-		return res;
+	if (n != 0) {
+		remain = (n < 0 ? remain : 0);
+		goto out;
+	}
 
-	return addr + len - (unsigned long) current->thread.fault_addr;
+	return 0;
+ out:
+	return remain;
 }
 
 static int copy_chunk_from_user(unsigned long from, int len, void *arg)
Index: linux-2.6-git/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/util.c	2007-12-10 12:36:31.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/util.c	2007-12-10 12:37:59.000000000 -0500
@@ -88,21 +88,6 @@ void setup_hostinfo(char *buf, int len)
 		 host.release, host.version, host.machine);
 }
 
-int setjmp_wrapper(void (*proc)(void *, void *), ...)
-{
-	va_list args;
-	jmp_buf buf;
-	int n;
-
-	n = UML_SETJMP(&buf);
-	if(n == 0){
-		va_start(args, proc);
-		(*proc)(&buf, &args);
-	}
-	va_end(args);
-	return n;
-}
-
 void os_dump_core(void)
 {
 	int pid;
