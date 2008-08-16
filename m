Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYHPWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYHPWgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYHPWgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:36:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:43607 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYHPWf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:35:58 -0400
Subject: patch uml-deal-with-inaccessible-address-space-start.patch added to 2.6.25-stable tree
To: tspink@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:38 -0700
In-Reply-To: <20080805201406.GA11788@c2.user-mode-linux.org>
Message-Id: <20080816223556.A0D2E1454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: deal with inaccessible address space start

to the 2.6.25-stable tree.  Its filename is

    uml-deal-with-inaccessible-address-space-start.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:14:42 2008
From: Tom Spink <tspink@gmail.com>
Date: Tue, 5 Aug 2008 16:14:06 -0400
Subject: uml: deal with inaccessible address space start
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201406.GA11788@c2.user-mode-linux.org>
Content-Disposition: inline

From: Tom Spink <tspink@gmail.com>

commit 40fb16a360d9c6459afee91dc793c1e3374feb94 upstream

This patch makes os_get_task_size locate the bottom of the address space,
as well as the top.  This is for systems which put a lower limit on mmap
addresses.  It works by manually scanning pages from zero onwards until a
valid page is found.

Because the bottom of the address space may not be zero, it's not
sufficient to assume the top of the address space is the size of the
address space.  The size is the difference between the top address and
bottom address.

[jdike@addtoit.com: changed the name to reflect that this function is
supposed to return the top of the process address space, not its size and
changed the return value to reflect that.  Also some minor formatting
changes]

Signed-off-by: Tom Spink <tspink@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/include/os.h                    |    2 -
 arch/um/kernel/um_arch.c                |    2 -
 arch/um/os-Linux/sys-i386/task_size.c   |   38 ++++++++++++++++++++++++--------
 arch/um/os-Linux/sys-x86_64/task_size.c |    2 -
 4 files changed, 32 insertions(+), 12 deletions(-)

--- a/arch/um/include/os.h
+++ b/arch/um/include/os.h
@@ -298,6 +298,6 @@ extern int os_arch_prctl(int pid, int co
 extern int get_pty(void);
 
 /* sys-$ARCH/task_size.c */
-extern unsigned long os_get_task_size(void);
+extern unsigned long os_get_top_address(void);
 
 #endif
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -273,7 +273,7 @@ int __init linux_main(int argc, char **a
 	if (have_root == 0)
 		add_arg(DEFAULT_COMMAND_LINE);
 
-	host_task_size = os_get_task_size();
+	host_task_size = os_get_top_address();
 	/*
 	 * TASK_SIZE needs to be PGDIR_SIZE aligned or else exit_mmap craps
 	 * out
--- a/arch/um/os-Linux/sys-i386/task_size.c
+++ b/arch/um/os-Linux/sys-i386/task_size.c
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
@@ -88,14 +88,32 @@ unsigned long os_get_task_size(void)
 	sa.sa_handler = segfault;
 	sigemptyset(&sa.sa_mask);
 	sa.sa_flags = SA_NODEFER;
-	sigaction(SIGSEGV, &sa, &old);
+	if (sigaction(SIGSEGV, &sa, &old)) {
+		perror("os_get_top_address");
+		exit(1);
+	}
 
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
@@ -110,8 +128,10 @@ unsigned long os_get_task_size(void)
 
 out:
 	/* Restore the old SIGSEGV handling */
-	sigaction(SIGSEGV, &old, NULL);
-
+	if (sigaction(SIGSEGV, &old, NULL)) {
+		perror("os_get_top_address");
+		exit(1);
+	}
 	top <<= UM_KERN_PAGE_SHIFT;
 	printf("0x%x\n", top);
 	fflush(stdout);
--- a/arch/um/os-Linux/sys-x86_64/task_size.c
+++ b/arch/um/os-Linux/sys-x86_64/task_size.c
@@ -1,4 +1,4 @@
-unsigned long os_get_task_size(unsigned long shift)
+unsigned long os_get_top_address(unsigned long shift)
 {
 	/* The old value of CONFIG_TOP_ADDR */
 	return 0x7fc0000000;


Patches currently in stable-queue which might be from tspink@gmail.com are

queue-2.6.25/uml-deal-with-inaccessible-address-space-start.patch
