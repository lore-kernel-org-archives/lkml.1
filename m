Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0BSROW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:14:22 -0500
Received: from kroah.org ([198.145.64.141]:57462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0BSRA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:29 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:38 2010
Message-Id: <20100219163238.671588178@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Neuling <mikey@neuling.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Anton Blanchard <anton@samba.org>, Oleg Nesterov <oleg@redhat.com>,
       James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
       Serge Hallyn <serue@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [29/93] fs/exec.c: restrict initial stack space expansion to rlimit
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 803bf5ec259941936262d10ecc84511b76a20921 upstream.

When reserving stack space for a new process, make sure we're not
attempting to expand the stack by more than rlimit allows.

This fixes a bug caused by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba ("mm:
variable length argument support") and unmasked by
fc63cf237078c86214abcb2ee9926d8ad289da9b ("exec: setup_arg_pages() fails
to return errors").

This bug means that when limiting the stack to less the 20*PAGE_SIZE (eg.
80K on 4K pages or 'ulimit -s 79') all processes will be killed before
they start.  This is particularly bad with 64K pages, where a ulimit below
1280K will kill every process.

To test, do:

  'ulimit -s 15; ls'

before and after the patch is applied.  Before it's applied, 'ls' should
be killed.  After the patch is applied, 'ls' should no longer be killed.

A stack limit of 15KB since it's small enough to trigger 20*PAGE_SIZE.
Also 15KB not a multiple of PAGE_SIZE, which is a trickier case to handle
correctly with this code.

4K pages should be fine to test with.

[kosaki.motohiro@jp.fujitsu.com: cleanup]
[akpm@linux-foundation.org: cleanup cleanup]
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -572,6 +572,9 @@ int setup_arg_pages(struct linux_binprm
 	struct vm_area_struct *prev = NULL;
 	unsigned long vm_flags;
 	unsigned long stack_base;
+	unsigned long stack_size;
+	unsigned long stack_expand;
+	unsigned long rlim_stack;
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size to 1GB */
@@ -628,10 +631,24 @@ int setup_arg_pages(struct linux_binprm
 			goto out_unlock;
 	}
 
+	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_size = vma->vm_end - vma->vm_start;
+	/*
+	 * Align this down to a page boundary as expand_stack
+	 * will align it up.
+	 */
+	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
+	rlim_stack = min(rlim_stack, stack_size);
 #ifdef CONFIG_STACK_GROWSUP
-	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	if (stack_size + stack_expand > rlim_stack)
+		stack_base = vma->vm_start + rlim_stack;
+	else
+		stack_base = vma->vm_end + stack_expand;
 #else
-	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	if (stack_size + stack_expand > rlim_stack)
+		stack_base = vma->vm_end - rlim_stack;
+	else
+		stack_base = vma->vm_start - stack_expand;
 #endif
 	ret = expand_stack(vma, stack_base);
 	if (ret)


