Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYB0OgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYB0OgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYB0OgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:36:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:47511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbYB0OgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:36:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gLboT+po/LuO2z4yZ8WFgX/K8HYm2g7H5Qs/jG+6PEdgjII5ykLL/gkNLXExa+etd/kh4ccUINOV1FRCPzrr21Y75c2CEqBKJpQL9sso2p14qEZzJbnkJMXcHteo2lQj2rKj6TACB3LPoAgPZQYBz696B/J4mJWuWmGEr1B2Cc8=
Date: Tue, 26 Feb 2008 22:51:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] alpha: vmlinux.lds cleanup - use THREAD_SIZE macro
Message-ID: <20080226195159.GC6748@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies thread_info.h header to be able to include it
into linker script and then we're able to use THREAD_SIZE in
vmlinux.lds

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

COMPLETELY UNTESTED
Any comments are welcome!


Index: linux-2.6.git/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/alpha/kernel/vmlinux.lds.S	2008-01-29 18:03:45.000000000 +0300
+++ linux-2.6.git/arch/alpha/kernel/vmlinux.lds.S	2008-02-26 21:49:59.000000000 +0300
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
--- linux-2.6.git.orig/include/asm-alpha/thread_info.h	2008-01-21 19:35:26.000000000 +0300
+++ linux-2.6.git/include/asm-alpha/thread_info.h	2008-02-26 22:00:42.000000000 +0300
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
