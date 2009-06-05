Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZFENWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZFENWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZFENWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:22:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:33800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZFENWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:22:16 -0400
Date: Fri, 5 Jun 2009 13:21:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] x86: Set context.vdso before installing the mapping
Message-ID: <tip-f7b6eb3fa07269da20dbbde8ba37a0273fdbd9c9@git.kernel.org>
Git-Commit-ID: f7b6eb3fa07269da20dbbde8ba37a0273fdbd9c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 13:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7b6eb3fa07269da20dbbde8ba37a0273fdbd9c9
Gitweb:     http://git.kernel.org/tip/f7b6eb3fa07269da20dbbde8ba37a0273fdbd9c9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Jun 2009 14:04:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 14:46:40 +0200

x86: Set context.vdso before installing the mapping

In order to make arch_vma_name() work from inside
install_special_mapping() we need to set the context.vdso
before calling it.

( This is needed for performance counters to be able to track
  this special executable area. )

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/vdso/vdso32-setup.c |    6 +++++-
 arch/x86/vdso/vma.c          |    7 +++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 1241f11..58bc00f 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -338,6 +338,8 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		}
 	}
 
+	current->mm->context.vdso = (void *)addr;
+
 	if (compat_uses_vma || !compat) {
 		/*
 		 * MAYWRITE to allow gdb to COW and set breakpoints
@@ -358,11 +360,13 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			goto up_fail;
 	}
 
-	current->mm->context.vdso = (void *)addr;
 	current_thread_info()->sysenter_return =
 		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
 
   up_fail:
+	if (ret)
+		current->mm->context.vdso = NULL;
+
 	up_write(&mm->mmap_sem);
 
 	return ret;
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7133cdf..93b7a29 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -115,15 +115,18 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		goto up_fail;
 	}
 
+	current->mm->context.vdso = (void *)addr;
+
 	ret = install_special_mapping(mm, addr, vdso_size,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
 				      VM_ALWAYSDUMP,
 				      vdso_pages);
-	if (ret)
+	if (ret) {
+		current->mm->context.vdso = NULL;
 		goto up_fail;
+	}
 
-	current->mm->context.vdso = (void *)addr;
 up_fail:
 	up_write(&mm->mmap_sem);
 	return ret;
