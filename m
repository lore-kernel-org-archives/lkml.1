Return-Path: <linux-kernel-owner+w=401wt.eu-S1764946AbXGYVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764946AbXGYVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbXGYVX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:23:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbXGYVX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:23:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Nathan Lynch <ntl@pobox.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86_64 has 2 x arch_vma_name() - can we drop one?
In-Reply-To: Sam Ravnborg's message of  Wednesday, 25 July 2007 22:59:59 +0200 <20070725205959.GA29548@uranus.ravnborg.org>
X-Shopping-List: (1) Obnoxious secretion suicides
   (2) Cretaceous Alcoholic load livers
   (3) Postdoctoral translucent yies
   (4) Traitorous bread
Message-Id: <20070725212321.247864D058D@magilla.localdomain>
Date: Wed, 25 Jul 2007 14:23:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Your version should work, but I would do it a little differently.


Thanks,
Roland

---
[PATCH] x86_64: fix arch_vma_name

The function arch_vma_name() is declared weak and thus it was
not noticed that x86_64 had two almost identical implementations.

It was introduced in syscall32.c by: c633090e3105e779c97d4978e5e3d7d66b291cfb
It was introduced in mm/init.c by: 2aae950b21e4bc789d1fc6668faf67e8748300b7

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86_64/ia32/ia32_binfmt.c |    5 +++--
 arch/x86_64/ia32/syscall32.c   |    8 --------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86_64/ia32/ia32_binfmt.c b/arch/x86_64/ia32/ia32_binfmt.c
index b70f3e7..90b37fc 100644
--- a/arch/x86_64/ia32/ia32_binfmt.c
+++ b/arch/x86_64/ia32/ia32_binfmt.c
@@ -41,8 +41,9 @@ int sysctl_vsyscall32 = 1;
 #undef ARCH_DLINFO
 #define ARCH_DLINFO do {  \
 	if (sysctl_vsyscall32) { \
-	NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
-	NEW_AUX_ENT(AT_SYSINFO_EHDR, VSYSCALL32_BASE);    \
+		current->mm->context.vdso = (void *)VSYSCALL32_BASE;	\
+		NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, VSYSCALL32_BASE);    \
 	}	\
 } while(0)
 
diff --git a/arch/x86_64/ia32/syscall32.c b/arch/x86_64/ia32/syscall32.c
index fc4419f..6df8ec7 100644
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
