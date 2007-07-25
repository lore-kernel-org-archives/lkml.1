Return-Path: <linux-kernel-owner+w=401wt.eu-S1764595AbXGYU6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764595AbXGYU6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbXGYU6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:58:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49116 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbXGYU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:58:45 -0400
Date: Wed, 25 Jul 2007 22:59:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Nathan Lynch <ntl@pobox.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: x86_64 has 2 x arch_vma_name() - can we drop one?
Message-ID: <20070725205959.GA29548@uranus.ravnborg.org>
References: <20070725183132.GA28408@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725183132.GA28408@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 08:31:32PM +0200, Sam Ravnborg wrote:
> In include/linux/mm.h arch_vma_name() is declared __weak.
> This hide the fact that x86_64 has 2 implementations of
> said function.
> 
> In arch/x86_64/mm/init.c:
> const char *arch_vma_name(struct vm_area_struct *vma)
> {
> 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
> 		return "[vdso]";
> 	if (vma == &gate_vma)
> 		return "[vsyscall]";
> 	return NULL;
> }
> 
> And in arch/x86_64/ia32/syscall32.c:
> const char *arch_vma_name(struct vm_area_struct *vma)
> {
> 	if (vma->vm_start == VSYSCALL32_BASE &&
> 	    vma->vm_mm && vma->vm_mm->task_size == IA32_PAGE_OFFSET)
> 		return "[vdso]";
> 	return NULL;
> }
> 
> As no comment were preceeding the fucntions this seems not to be on
> purpose.
> If I am correct which one should die?
> 
> The reason why this popped up is that the __weak definition in mm.h
> causes problems on at least powerpc (trigger a binutils bug).
> A similar bug is present at ia64 - but I have not confirmed if the
> same fix is needed.

I cooked up following patch - but I do not claim I understand this
code. It was done only by merging the functionality into one function.
I need this patch or a similar one to be added so the weak declaration
of arch_vma_name in mm.h can be made a normal prototype.

	Sam


[PATCH] x86_64: merge two identical named funtion into one

The function arch_vma_name() is declared weak and thus it was
not noticed that x86_64 had two almost identical implementations.

It was introduced in syscall32.c by: c633090e3105e779c97d4978e5e3d7d66b291cfb
It was introduced in mm/init.c by: 2aae950b21e4bc789d1fc6668faf67e8748300b7

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland McGrath <roland@redhat.com>
---
diff --git a/arch/x86_64/ia32/syscall32.c b/arch/x86_64/ia32/syscall32.c
index fc4419f..15013ba 100644
--- a/arch/x86_64/ia32/syscall32.c
+++ b/arch/x86_64/ia32/syscall32.c
@@ -49,14 +49,6 @@ int syscall32_setup_pages(struct linux_binprm *bprm, int exstack)
 	return ret;
 }
 
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma->vm_start == VSYSCALL32_BASE &&
-	    vma->vm_mm && vma->vm_mm->task_size == IA32_PAGE_OFFSET)
-		return "[vdso]";
-	return NULL;
-}
-
 static int __init init_syscall32(void)
 { 
 	char *syscall32_page = (void *)get_zeroed_page(GFP_KERNEL);
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 38f5d63..6f608d8 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -43,6 +43,7 @@
 #include <asm/proto.h>
 #include <asm/smp.h>
 #include <asm/sections.h>
+#include <asm/vsyscall32.h>
 
 #ifndef Dprintk
 #define Dprintk(x...)
@@ -734,6 +735,9 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 {
 	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
 		return "[vdso]";
+	if (vma->vm_mm && vma->vm_start == VSYSCALL32_BASE &&
+	    vma->vm_mm->task_size == IA32_PAGE_OFFSET)
+		return "[vdso]";
 	if (vma == &gate_vma)
 		return "[vsyscall]";
 	return NULL;
