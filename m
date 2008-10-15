Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYJOPwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYJOPwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYJOPvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:51:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46710 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYJOPvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:51:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/7] binfmt_elf_fdpic: Convert initial stack alignment to
	arch_align_stack()
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:51:14 +0100
Message-ID: <20081015155114.2158.12058.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
References: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

binfmt_elf_fdpic seems to have grabbed a hard-coded hack from an ancient
version of binfmt_elf in order to try and fix up initial stack alignment
on multi-threaded x86, which while in addition to being unused, was also
pushed down beyond the first set of operations on the stack pointer,
negating the entire purpose.

These days, we have an architecture independent arch_align_stack(), so we
switch to using that instead. Move the initial alignment up before the
initial stores while we're at it.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/binfmt_elf_fdpic.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)


diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 0955d03..f8c1469 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -466,7 +466,8 @@ error_kill:
 #endif
 
 /*
- * present useful information to the program
+ * present useful information to the program by shovelling it onto the new
+ * process's stack
  */
 static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 				   struct mm_struct *mm,
@@ -482,9 +483,13 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	int loop;
 	int nr;	/* reset for each csp adjustment */
 
-	/* we're going to shovel a whole load of stuff onto the stack */
 #ifdef CONFIG_MMU
-	sp = bprm->p;
+	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
+	 * by the processes running on the same package. One thing we can do is
+	 * to shuffle the initial stack for them, so we give the architecture
+	 * an opportunity to do so here.
+	 */
+	sp = arch_align_stack(bprm->p);
 #else
 	sp = mm->start_stack;
 
@@ -527,20 +532,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 			return -EFAULT;
 	}
 
-#if defined(__i386__) && defined(CONFIG_SMP)
-	/* in some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
-	 * by the processes running on the same package. One thing we can do is
-	 * to shuffle the initial stack for them.
-	 *
-	 * the conditionals here are unneeded, but kept in to make the code
-	 * behaviour the same as pre change unless we have hyperthreaded
-	 * processors. This keeps Mr Marcelo Person happier but should be
-	 * removed for 2.5
-	 */
-	if (smp_num_siblings > 1)
-		sp = sp - ((current->pid % 64) << 7);
-#endif
-
 	sp &= ~7UL;
 
 	/* stack the load map(s) */

