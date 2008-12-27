Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYL0FTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYL0FTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYL0FTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:19:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:44184 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYL0FTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tBxZ3vcVwLeKvfQbWpqc/XkL0zDedK7SYiYeknVHPr97qUeqAmLRjHpXskwPEq/1u8
         6NAGPfFPwOb6GVyGYUA08QdxB/hQhEuuaxrzE8DMOnBtPIcWC7Di20B8PRCNhrQgCcDm
         /AKdt1oHEHRLbOIhZ1xAvwNTNgrtIrpIWkcAo=
Date: Sat, 27 Dec 2008 14:19:08 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] x86: call free_thread_xstate() in free_task_struct()
Message-ID: <20081227051907.GD3295@localhost.localdomain>
References: <20081227051606.GA3295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20081227051606.GA3295@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 arch specific free_thread_info() accesses thread_info->task to call
free_thread_xstate(). But the thread_info may not be initialized yet.
So invalid pointer derefence may happen in free_thread_xstate().

It happens in the following scenario in dup_task_struct()

1. call alloc_task_struct() to allocate empty task_struct
2. call alloc_thread_info() to allocate empty thread_info
3. call arch_dup_task_struct()

x86 arch specific arch_dup_task_struct() copies task_struct from source
task_struct. it also allocates empty xstate and copy from source if
source task_struct has ->thread.xstate.

If the xstate allocation failed, arch_dup_task_struct() returns error.

4. call free_thread_info() to deallocate thread_info

x86 arch specific free_thread_info() calls free_thread_xstate() with
thread_info->task. But the thread_info is not initialized yet.

This patch resolves the issue by moving the free_thread_xstate() call
into free_task_struct().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6/arch/x86/kernel/process.c
===================================================================
--- 2.6.orig/arch/x86/kernel/process.c
+++ 2.6/arch/x86/kernel/process.c
@@ -40,7 +40,6 @@ void free_thread_xstate(struct task_stru
 
 void free_thread_info(struct thread_info *ti)
 {
-	free_thread_xstate(ti->task);
 	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
 }
 
@@ -53,6 +52,7 @@ struct task_struct *alloc_task_struct(vo
 
 void free_task_struct(struct task_struct *tsk)
 {
+	free_thread_xstate(tsk);
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 
