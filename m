Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYL0FSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYL0FSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYL0FSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:18:25 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:42298 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYL0FSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xvtZwpNKQf13SiWp6+nbA07NYnCPEO5jmoQHJ8fFXKCfpi9DJQyf3vInbI4rqk+deg
         1VWfjdmR1XrXOoYdbRukUQJgMWhJMpq030KxZxUUCo4/eewvspgRjun88S0S6ekXAuHo
         XsDMYfZz/YsXTJ8dxbcAsY7FnLBYU+tL9659g=
Date: Sat, 27 Dec 2008 14:18:17 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/4] x86: arch specific task_struct allocator
Message-ID: <20081227051816.GC3295@localhost.localdomain>
References: <20081227051606.GA3295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20081227051606.GA3295@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines x86 specific task_struct allocator.
It is just duplication of generic task-struct allocator for now.
Forthcoming patch will make actual change to it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/include/asm/thread_info.h |    6 ++++++
 arch/x86/kernel/process.c          |   16 ++++++++++++++++
 2 files changed, 22 insertions(+)

Index: 2.6/arch/x86/kernel/process.c
===================================================================
--- 2.6.orig/arch/x86/kernel/process.c
+++ 2.6/arch/x86/kernel/process.c
@@ -44,8 +44,24 @@ void free_thread_info(struct thread_info
 	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
 }
 
+static struct kmem_cache *task_struct_cachep;
+
+struct task_struct *alloc_task_struct(void)
+{
+	return kmem_cache_alloc(task_struct_cachep, GFP_KERNEL);
+}
+
+void free_task_struct(struct task_struct *tsk)
+{
+	kmem_cache_free(task_struct_cachep, tsk);
+}
+
 void arch_task_cache_init(void)
 {
+	task_struct_cachep = kmem_cache_create("task_struct",
+				sizeof(struct task_struct), ARCH_MIN_TASKALIGN,
+				SLAB_PANIC, NULL);
+
         task_xstate_cachep =
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
Index: 2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- 2.6.orig/arch/x86/include/asm/thread_info.h
+++ 2.6/arch/x86/include/asm/thread_info.h
@@ -260,5 +260,11 @@ extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 #define arch_task_cache_init arch_task_cache_init
+
+#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+
+extern struct task_struct *alloc_task_struct(void);
+extern void free_task_struct(struct task_struct *tsk);
+
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
