Return-Path: <linux-kernel-owner+w=401wt.eu-S936867AbYEUS7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936867AbYEUS7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936335AbYEUS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:58:44 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51708 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S936274AbYEUS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:58:42 -0400
Date: Wed, 21 May 2008 13:58:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080521175829.GA10648@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <Pine.LNX.4.61.0805201117540.12360@chaos.analogic.com> <20080520173503.GA10811@c2.user-mode-linux.org> <Pine.LNX.4.61.0805201751500.13532@chaos.analogic.com> <20080521021502.GB16212@c2.user-mode-linux.org> <7b9198260805210502i316c9e38lcc9b5561045dd5d@mail.gmail.com> <7b9198260805210504h278f014s5aba720360ac02ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805210504h278f014s5aba720360ac02ab@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:04:21PM +0100, Tom Spink wrote:
> Oh No! I forgot to get rid of those nasty includes.... Take 2....

This is actually supposed to return the address space top, not the
size, so I changed the name and return value accordingly.

Other than that, this is fine.  The final result is below...

      	   	      Jeff

-- 
Work email - jdike at linux dot intel dot com

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
 arch/um/os-Linux/sys-i386/task_size.c   |   35 +++++++++++++++++++++-----------
 arch/um/os-Linux/sys-x86_64/task_size.c |    2 -
 4 files changed, 27 insertions(+), 14 deletions(-)

Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2008-05-21 13:48:23.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2008-05-21 13:48:47.000000000 -0400
@@ -299,6 +299,6 @@ extern int os_arch_prctl(int pid, int co
 extern int get_pty(void);
 
 /* sys-$ARCH/task_size.c */
-extern unsigned long os_get_task_size(void);
+extern unsigned long os_get_top_address(void);
 
 #endif
Index: linux-2.6.22/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/um_arch.c	2008-04-24 13:22:09.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/um_arch.c	2008-05-21 13:46:56.000000000 -0400
@@ -274,7 +274,7 @@ int __init linux_main(int argc, char **a
 	if (have_root == 0)
 		add_arg(DEFAULT_COMMAND_LINE);
 
-	host_task_size = os_get_task_size();
+	host_task_size = os_get_top_address();
 	/*
 	 * TASK_SIZE needs to be PGDIR_SIZE aligned or else exit_mmap craps
 	 * out
Index: linux-2.6.22/arch/um/os-Linux/sys-i386/task_size.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/sys-i386/task_size.c	2008-04-23 13:07:23.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/sys-i386/task_size.c	2008-05-21 13:54:47.000000000 -0400
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
@@ -89,16 +89,30 @@ unsigned long os_get_task_size(void)
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
 	/* This could happen with a 4G/4G split */
 	if (page_ok(top))
 		goto out;
@@ -114,11 +128,10 @@ unsigned long os_get_task_size(void)
 out:
 	/* Restore the old SIGSEGV handling */
 	if (sigaction(SIGSEGV, &old, NULL)) {
-		perror("os_get_task_size");
+		perror("os_get_top_address");
 		exit(1);
 	}
-	top <<= UM_KERN_PAGE_SHIFT;
-	printf("0x%x\n", top);
+	printf("0x%x\n", top << UM_KERN_PAGE_SHIFT);
 
-	return top;
+	return top << UM_KERN_PAGE_SHIFT;
 }
Index: linux-2.6.22/arch/um/os-Linux/sys-x86_64/task_size.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/sys-x86_64/task_size.c	2008-02-18 11:53:51.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/sys-x86_64/task_size.c	2008-05-21 13:49:59.000000000 -0400
@@ -1,4 +1,4 @@
-unsigned long os_get_task_size(unsigned long shift)
+unsigned long os_get_top_address(unsigned long shift)
 {
 	/* The old value of CONFIG_TOP_ADDR */
 	return 0x7fc0000000;
