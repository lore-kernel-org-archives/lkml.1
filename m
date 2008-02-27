Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbYB0VD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbYB0VD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbYB0VAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11803 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbYB0VAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=jf1rt4C1Sqb05Ao8ZjSafytOE2XtyhNGCE8ptMerPgH3qtNCMeAuAVSC+Hl/u4M4f+M2ZbkeOQP+3KnuD3T2wp8nn19yCzWPxJDwRBefza2/pS9+CWF6wqJlD7svLNimENA6vZhQXnBAw0n1nDZXPQJ/kfBBHtnMGJCCi8J7hTw=
Message-Id: <20080227210004.407632127@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:40 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 09/10] alpha: vmlinux.lds cleanup - use THREAD_SIZE macro
Content-Disposition: inline; filename=alpha-vmlinux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies thread_info.h header to be able to include it
into linker script and then we're able to use THREAD_SIZE in
vmlinux.lds

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

 arch/alpha/kernel/vmlinux.lds.S |    3 ++-
 include/asm-alpha/thread_info.h |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/alpha/kernel/vmlinux.lds.S	2008-02-27 21:48:19.000000000 +0300
+++ linux-2.6.git/arch/alpha/kernel/vmlinux.lds.S	2008-02-27 22:05:37.000000000 +0300
@@ -1,5 +1,6 @@
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf64-alpha")
 OUTPUT_ARCH(alpha)
@@ -88,7 +89,7 @@ SECTIONS
 
 	PERCPU(PAGE_SIZE)
 
-	. = ALIGN(2 * PAGE_SIZE);
+	. = ALIGN(THREAD_SIZE);
 	__init_end = .;
 	/* Freed after init ends here */
 
Index: linux-2.6.git/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6.git.orig/include/asm-alpha/thread_info.h	2008-02-27 21:48:28.000000000 +0300
+++ linux-2.6.git/include/asm-alpha/thread_info.h	2008-02-27 22:05:37.000000000 +0300
@@ -7,9 +7,7 @@
 #include <asm/processor.h>
 #include <asm/types.h>
 #include <asm/hwrpb.h>
-#endif
 
-#ifndef __ASSEMBLY__
 struct thread_info {
 	struct pcb_struct	pcb;		/* palcode state */
 
@@ -50,13 +48,14 @@ register struct thread_info *__current_t
 #define current_thread_info()  __current_thread_info
 
 /* Thread information allocation.  */
-#define THREAD_SIZE (2*PAGE_SIZE)
 #define alloc_thread_info(tsk) \
   ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
 #define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* __ASSEMBLY__ */
 
+#define THREAD_SIZE (2 * PAGE_SIZE)
+
 #define PREEMPT_ACTIVE		0x40000000
 
 /*
@@ -94,6 +93,8 @@ register struct thread_info *__current_t
 #define ALPHA_UAC_MASK		(1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
 				 1 << TIF_UAC_SIGBUS)
 
+#ifndef __ASSEMBLY__
+
 #define SET_UNALIGN_CTL(task,value)	({				     \
 	task_thread_info(task)->flags = ((task_thread_info(task)->flags &    \
 		~ALPHA_UAC_MASK)					     \
@@ -112,5 +113,7 @@ register struct thread_info *__current_t
 		 (int __user *)(value));				\
 	})
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_THREAD_INFO_H */

-- 
