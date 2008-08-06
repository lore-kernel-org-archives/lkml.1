Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYHFKhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYHFKhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761849AbYHFKgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:36:51 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:48486 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761836AbYHFKgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:36:49 -0400
Date: Wed, 6 Aug 2008 19:36:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack()
Message-ID: <20080806103600.GB5194@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080806103458.GE2610@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806103458.GE2610@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 7c83605..f9d6eaa 100644
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
