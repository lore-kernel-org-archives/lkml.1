Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYGJUUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYGJUUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYGJUUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:20:30 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35392 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYGJUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:20:29 -0400
Date: Thu, 10 Jul 2008 21:19:20 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ollie Wild <aaw@google.com>,
       bugme-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pageexec@freemail.hu,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [Bug 11063][PATCH] exec: fix stack excutability without PT_GNU_STACK
In-Reply-To: <20080709152716.99e9bbe7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807102110130.16171@blonde.site>
References: <bug-11063-27@http.bugzilla.kernel.org/>
 <20080709152716.99e9bbe7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Bugzilla #11063 points out that on some architectures (e.g. x86_32)
exec'ing an ELF without a PT_GNU_STACK program header should default to an
executable stack; but this got broken by the unlimited argv feature because
stack vma is now created before the right personality has been established:
so breaking old binaries using nested function trampolines.

Therefore re-evaluate VM_STACK_FLAGS in setup_arg_pages, where stack
vm_flags used to be set, before the mprotect_fixup.  Checking through
our existing VM_flags, none would have changed since insert_vm_struct:
so this seems safer than finding a way through the personality labyrinth.

Reported-by: pageexec@freemail.hu
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.26-rc9/fs/exec.c	2008-06-21 08:41:19.000000000 +0100
+++ linux/fs/exec.c	2008-07-10 20:02:25.000000000 +0100
@@ -610,7 +610,7 @@ int setup_arg_pages(struct linux_binprm 
 	bprm->exec -= stack_shift;
 
 	down_write(&mm->mmap_sem);
-	vm_flags = vma->vm_flags;
+	vm_flags = VM_STACK_FLAGS;
 
 	/*
 	 * Adjust stack execute permissions; explicitly enable for
