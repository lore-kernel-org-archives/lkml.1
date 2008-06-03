Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYFCTEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYFCTEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYFCTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:04:09 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58522 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbYFCTEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:04:06 -0400
Date: Tue, 3 Jun 2008 15:02:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Tom Spink <tspink@gmail.com>
Subject: [PATCH 3/6] UML - Deal with inaccessible address space start
Message-ID: <20080603190236.GA9519@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Spink <tspink@gmail.com>

This patch makes os_get_task_size locate the bottom of the address space,
as well as the top.  This is for systems which put a lower limit on mmap
addresses.  It works by manually scanning pages from zero onwards until a
valid page is found.

Because the bottom of the address space may not be zero, it's not sufficient
to assume the top of the address space is the size of the address space.  The
size is the difference between the top address and bottom address.

[ jdike@addtoit.com - Changed the name to reflect that this function
is supposed to return the top of the process address space, not its
size and changed the return value to reflect that.  Also some minor
formatting changes ]

Signed-off-by: Tom Spink <tspink@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h                    |    2 -
 arch/um/kernel/um_arch.c                |    2 -
 arch/um/os-Linux/sys-i386/task_size.c   |   36 ++++++++++++++++++++++++--------
 arch/um/os-Linux/sys-x86_64/task_size.c |    2 -
 4 files changed, 31 insertions(+), 11 deletions(-)

Index: linux-2.6-git/arch/um/include/os.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/os.h	2008-05-14 10:44:02.000000000 -0400
+++ linux-2.6-git/arch/um/include/os.h	2008-06-02 15:44:47.000000000 -0400
@@ -299,6 +299,6 @@ extern int os_arch_prctl(int pid, int co
 extern int get_pty(void);
 
 /* sys-$ARCH/task_size.c */
-extern unsigned long os_get_task_size(void);
+extern unsigned long os_get_top_address(void);
 
 #endif
Index: linux-2.6-git/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/um_arch.c	2008-05-14 10:44:02.000000000 -0400
+++ linux-2.6-git/arch/um/kernel/um_arch.c	2008-06-02 15:44:47.000000000 -0400
@@ -274,7 +274,7 @@ int __init linux_main(int argc, char **a
 	if (have_root == 0)
 		add_arg(DEFAULT_COMMAND_LINE);
 
-	host_task_size = os_get_task_size();
+	host_task_size = os_get_top_address();
 	/*
 	 * TASK_SIZE needs to be PGDIR_SIZE aligned or else exit_mmap craps
 	 * out
Index: linux-2.6-git/arch/um/os-Linux/sys-i386/task_size.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/sys-i386/task_size.c	2008-05-14 10:44:02.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/sys-i386/task_size.c	2008-06-02 15:48:10.000000000 -0400
@@ -63,7 +63,7 @@ static int page_ok(unsigned long page)
 	return ok;
 }
 
-unsigned long os_get_task_size(void)
+unsigned long os_get_top_address(void)
 {
 	struct sigaction sa, old;
 	unsigned long bottom = 0;
@@ -76,9 +76,9 @@ unsigned long os_get_task_size(void)
 	 * hosts, but shouldn't hurt otherwise.
 	 */
 	unsigned long top = 0xffffd000 >> UM_KERN_PAGE_SHIFT;
-	unsigned long test;
+	unsigned long test, original;
 
-	printf("Locating the top of the address space ... ");
+	printf("Locating the bottom of the address space ... ");
 	fflush(stdout);
 
 	/*
@@ -89,16 +89,31 @@ unsigned long os_get_task_size(void)
 	sigemptyset(&sa.sa_mask);
 	sa.sa_flags = SA_NODEFER;
 	if (sigaction(SIGSEGV, &sa, &old)) {
-		perror("os_get_task_size");
+		perror("os_get_top_address");
 		exit(1);
 	}
 
-	if (!page_ok(bottom)) {
-		fprintf(stderr, "Address 0x%x no good?\n",
-			bottom << UM_KERN_PAGE_SHIFT);
+	/* Manually scan the address space, bottom-up, until we find
+	 * the first valid page (or run out of them).
+	 */
+	for (bottom = 0; bottom < top; bottom++) {
+		if (page_ok(bottom))
+			break;
+	}
+
+	/* If we've got this far, we ran out of pages. */
+	if (bottom == top) {
+		fprintf(stderr, "Unable to determine bottom of address "
+			"space.\n");
 		exit(1);
 	}
 
+	printf("0x%x\n", bottom << UM_KERN_PAGE_SHIFT);
+	printf("Locating the top of the address space ... ");
+	fflush(stdout);
+
+	original = bottom;
+
 	/* This could happen with a 4G/4G split */
 	if (page_ok(top))
 		goto out;
@@ -114,7 +129,7 @@ unsigned long os_get_task_size(void)
 out:
 	/* Restore the old SIGSEGV handling */
 	if (sigaction(SIGSEGV, &old, NULL)) {
-		perror("os_get_task_size");
+		perror("os_get_top_address");
 		exit(1);
 	}
 	top <<= UM_KERN_PAGE_SHIFT;
Index: linux-2.6-git/arch/um/os-Linux/sys-x86_64/task_size.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/sys-x86_64/task_size.c	2008-04-28 13:05:21.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/sys-x86_64/task_size.c	2008-06-02 15:44:47.000000000 -0400
@@ -1,4 +1,4 @@
-unsigned long os_get_task_size(unsigned long shift)
+unsigned long os_get_top_address(unsigned long shift)
 {
 	/* The old value of CONFIG_TOP_ADDR */
 	return 0x7fc0000000;
