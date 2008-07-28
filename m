Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYG1PFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYG1PFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYG1PFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:05:37 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:27825 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755863AbYG1PFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:05:36 -0400
Date: Tue, 29 Jul 2008 00:05:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
Message-ID: <20080728150501.GC16555@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728150430.GB16555@linux-sh.org>
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

---

 fs/binfmt_elf_fdpic.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 0955d03..bc64f5f 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -482,11 +482,18 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	int loop;
 	int nr;	/* reset for each csp adjustment */
 
-	/* we're going to shovel a whole load of stuff onto the stack */
+	/*
+	 * we're going to shovel a whole load of stuff onto the stack
+	 *
+	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
+	 * evictions by the processes running on the same package. One
+	 * thing we can do is to shuffle the initial stack for them, so
+	 * we give the architecture an opportunity to do so here.
+	 */
 #ifdef CONFIG_MMU
-	sp = bprm->p;
+	sp = arch_align_stack(bprm->p);
 #else
-	sp = mm->start_stack;
+	sp = arch_align_stack(mm->start_stack);
 
 	/* stack the program arguments and environment */
 	if (elf_fdpic_transfer_args_to_stack(bprm, &sp) < 0)
@@ -527,20 +534,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
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
