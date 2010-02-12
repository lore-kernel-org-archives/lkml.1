Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0BLFoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:44:20 -0500
Received: from ozlabs.org ([203.10.76.45]:52136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0BLFoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:44:19 -0500
From: Michael Neuling <mikey@neuling.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Helge Deller <deller@gmx.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Create initial stack independent of PAGE_SIZE
In-reply-to: <20100209132529.bfc455b7.akpm@linux-foundation.org>
References: <20100208161014.7C6D.A69D9226@jp.fujitsu.com> <1273.1265695885@neuling.org> <20100209154141.03F0.A69D9226@jp.fujitsu.com> <11046.1265705967@neuling.org> <20100209132529.bfc455b7.akpm@linux-foundation.org>
Comments: In-reply-to Andrew Morton <akpm@linux-foundation.org>
   message dated "Tue, 09 Feb 2010 13:25:29 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 12 Feb 2010 16:44:15 +1100
Message-ID: <31586.1265953455@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we create the initial stack based on the PAGE_SIZE.  This is
unnecessary.  

This creates this initial stack independent of the PAGE_SIZE.

It also bumps up the number of 4k pages allocated from 20 to 32, to
align with 64K page systems.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
This is the second half of my original patch. This can be targeted for
2.6.34 as it's just a cleanup.

Tested on PPC64 with 4k and 64k pages.

 fs/exec.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-ozlabs/fs/exec.c
===================================================================
--- linux-2.6-ozlabs.orig/fs/exec.c
+++ linux-2.6-ozlabs/fs/exec.c
@@ -554,8 +554,6 @@ static int shift_arg_pages(struct vm_are
 	return 0;
 }
 
-#define EXTRA_STACK_VM_PAGES	20	/* random */
-
 /*
  * Finalizes the stack vm_area_struct. The flags and permissions are updated,
  * the stack is optionally relocated, and some extra space is added.
@@ -630,7 +628,7 @@ int setup_arg_pages(struct linux_binprm 
 			goto out_unlock;
 	}
 
-	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_expand = 131072UL; /* randomly 32*4k (or 2*64k) pages */
 	stack_size = vma->vm_end - vma->vm_start;
 	/*
 	 * Align this down to a page boundary as expand_stack
