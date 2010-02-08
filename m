Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab0BHFhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:37:53 -0500
Received: from ozlabs.org ([203.10.76.45]:54898 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0BHFhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:37:51 -0500
From: Michael Neuling <mikey@neuling.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org, miltonm@bga.com, aeb@cwi.nl
Subject: [PATCH] Restrict stack space reservation to rlimit
In-reply-to: <20100208141716.FB55.A69D9226@jp.fujitsu.com>
References: <20100208140323.FB52.A69D9226@jp.fujitsu.com> <20100208051104.GL32246@kryten> <20100208141716.FB55.A69D9226@jp.fujitsu.com>
Comments: In-reply-to KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
   message dated "Mon, 08 Feb 2010 14:22:22 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Mon, 08 Feb 2010 16:37:49 +1100
Message-ID: <9729.1265607469@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > Hi,
> > 
> > > Why do we need page size independent stack size? It seems to have
> > > compatibility breaking risk.
> > 
> > I don't think so. The current behaviour is clearly wrong, we dont need a
> > 16x larger stack just because you went from a 4kB to a 64kB base page
> > size. The user application stack usage is the same in both cases.
> 
> I didn't discuss which behavior is better. Michael said he want to apply
> his patch to 2.6.32 & 2.6.33. stable tree never accept the breaking
> compatibility patch.
> 
> Your answer doesn't explain why can't we wait it until next merge window.
> 
> btw, personally, I like page size indepent stack size. but I'm not sure
> why making stack size independency is related to bug fix.

I tend to agree.  

Below is just the bug fix to limit the reservation size based rlimit.
We still reserve different stack sizes based on the page size as
before (unless we hit rlimit of course).

Mikey

Restrict stack space reservation to rlimit

When reserving stack space for a new process, make sure we're not
attempting to allocate more than rlimit allows.

This fixes a bug cause by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba 
"mm: variable length argument support" and unmasked by
fc63cf237078c86214abcb2ee9926d8ad289da9b 
"exec: setup_arg_pages() fails to return errors".

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: stable@kernel.org
---
 fs/exec.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6-ozlabs/fs/exec.c
===================================================================
--- linux-2.6-ozlabs.orig/fs/exec.c
+++ linux-2.6-ozlabs/fs/exec.c
@@ -627,10 +627,13 @@ int setup_arg_pages(struct linux_binprm 
 			goto out_unlock;
 	}
 
+	stack_base = min(EXTRA_STACK_VM_PAGES * PAGE_SIZE,
+			 current->signal->rlim[RLIMIT_STACK].rlim_cur -
+			   PAGE_SIZE);
 #ifdef CONFIG_STACK_GROWSUP
-	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_base = vma->vm_end + stack_base;
 #else
-	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_base = vma->vm_start - stack_base;
 #endif
 	ret = expand_stack(vma, stack_base);
 	if (ret)

