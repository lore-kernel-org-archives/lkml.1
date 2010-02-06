Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0BFKWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 05:22:18 -0500
Received: from ozlabs.org ([203.10.76.45]:58839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab0BFKWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 05:22:17 -0500
From: Michael Neuling <mikey@neuling.org>
To: Anton Blanchard <anton@samba.org>
cc: stable@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Serge Hallyn <serue@us.ibm.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
Subject: Re: Stack size protection broken on ppc64
In-reply-to: <20100206042038.GB32246@kryten>
References: <3984.1265416993@neuling.org> <20100206042038.GB32246@kryten>
Comments: In-reply-to Anton Blanchard <anton@samba.org>
   message dated "Sat, 06 Feb 2010 15:20:38 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sat, 06 Feb 2010 21:22:12 +1100
Message-ID: <10125.1265451732@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On recent ppc64 kernels, limiting the stack (using 'ulimit -s blah') is
> > now more restrictive than it was before.  On 2.6.31 with 4k pages I
> > could run 'ulimit -s 16; /usr/bin/test' without a problem.  Now with
> > mainline, even 'ulimit -s 64; /usr/bin/test' gets killed.
> > 
> > Using 64k pages is even worse.  I can't even run '/bin/ls' with a 1MB
> > stack (ulimit -s 1024; /bin/ls).  Hence, it seems new kernels are too
> > restrictive, rather than the old kernels being too liberal.
> 
> It looks like this is causing it:
> 
> #define EXTRA_STACK_VM_PAGES    20      /* random */
> 
> ...
> 
> #ifdef CONFIG_STACK_GROWSUP
>         stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> #else
>         stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> #endif
> 
> Which got added back in 2005 in a memory overcommit patch. It only took 5
> years for us to go back and review that random setting :)
> 
> The comment from Andries explains the purpose:
> 
>     (1) It reserves a reasonable amount of virtual stack space (amount
>         randomly chosen, no guarantees given) when the process is started, so
>         that the common utilities will not be killed by segfault on stack
>         extension.
> 
> This explains why 64kB is much worse. The extra stack reserve should be in kB
> and we also need to be careful not to ask for more than our rlimit.

Cool, thanks.  The following is based on this and fixes the problem for
me on PPC64 ie. the !CONFIG_STACK_GROWSUP case. 

Mikey

[PATCH] Restrict stack space reservation to rlimit

When reserving stack space for a new process, make sure we're not
attempting to allocate more than rlimit allows.

Also, reserve the same stack size independent of page size.

This fixes a bug unmasked by fc63cf237078c86214abcb2ee9926d8ad289da9b

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: stable@kernel.org
---
 fs/exec.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: clone1/fs/exec.c
===================================================================
--- clone1.orig/fs/exec.c
+++ clone1/fs/exec.c
@@ -554,7 +554,7 @@ static int shift_arg_pages(struct vm_are
 	return 0;
 }
 
-#define EXTRA_STACK_VM_PAGES	20	/* random */
+#define EXTRA_STACK_VM_SIZE	81920UL	/* randomly 20 4K pages */
 
 /*
  * Finalizes the stack vm_area_struct. The flags and permissions are updated,
@@ -627,10 +627,13 @@ int setup_arg_pages(struct linux_binprm 
 			goto out_unlock;
 	}
 
+	stack_base = min(EXTRA_STACK_VM_SIZE,
+			 current->signal->rlim[RLIMIT_STACK].rlim_cur) -
+		PAGE_SIZE;
 #ifdef CONFIG_STACK_GROWSUP
-	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_base = vma->vm_end + stack_base;
 #else
-	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_base = vma->vm_start - stack_base;
 #endif
 	ret = expand_stack(vma, stack_base);
 	if (ret)
