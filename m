Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYHDKJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYHDKJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYHDKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:09:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYHDKJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:09:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080804040025.GA11127@linux-sh.org>
References: <20080804040025.GA11127@linux-sh.org> <20080728150501.GC16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org> <27552.1217599279@redhat.com> <20080801214448.GA13448@linux-sh.org> <8bd0f97a0808032024x18a31d29tb44ebc6216a2aed@mail.gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Mike Frysinger <vapier.adi@gmail.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 04 Aug 2008 11:08:59 +0100
Message-ID: <32309.1217844539@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> There's no need, as David pointed out, that was the wrong thing to do for
> the nommu case anyways. Here's an updated patch to replace the previous
> one:

That's better, however:

> -	/* we're going to shovel a whole load of stuff onto the stack */
>  #ifdef CONFIG_MMU
> -	sp = bprm->p;
> +	/*
> +	 * we're going to shovel a whole load of stuff onto the stack

I think that comment shouldn't be moved inside the conditional section since
it applies to NOMMU as well.  Picky, I know, but...  It might actually be
better to attach it to the banner comment for the whole function.

David
---
[PATCH] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack()

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
