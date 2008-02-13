Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbYBMH1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbYBMH1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYBMH1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:27:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbYBMH1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:27:06 -0500
Date: Wed, 13 Feb 2008 08:26:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: asm-x86/sigcontext.h changes break userland
Message-ID: <20080213072650.GA4363@elte.hu>
References: <20080213001532.GJ24887@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213001532.GJ24887@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jakub Jelinek <jakub@redhat.com> wrote:

> x86: use generic register names in struct sigcontext 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=742fa54a62be6a263df14a553bf832724471dfbe
> 
> changeset breaks userland, e.g. it is not possible to compile gcc 
> anymore (both 32-bit and 64-bit libgcc), and I expect any other 
> program which pokes into struct sigcontext.  The register names with e 
> resp. r have been in use for years, what's the point breaking it now?

ok - does the patch below solve the problem for you?

	Ingo

------------>
Subject: x86: fix sigcontext.h user export
From: Ingo Molnar <mingo@elte.hu>

Jakub Jelinek reported that some user-space code that relies on
kernel headers has built dependency on the sigcontext->eip/rip
register names - which have been unified in commit:

  commit 742fa54a62be6a263df14a553bf832724471dfbe
  Author: H. Peter Anvin <hpa@zytor.com>
  Date:   Wed Jan 30 13:30:56 2008 +0100

      x86: use generic register names in struct sigcontext

so give the old layout to user-space. This is not particularly
pretty, but it's an ABI so there's no danger of the two definitions
getting out of sync.

Reported-by: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/sigcontext.h |   66 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

Index: linux/include/asm-x86/sigcontext.h
===================================================================
--- linux.orig/include/asm-x86/sigcontext.h
+++ linux/include/asm-x86/sigcontext.h
@@ -58,6 +58,7 @@ struct _fpstate {
 
 #define X86_FXSR_MAGIC		0x0000
 
+#ifdef __KERNEL__
 struct sigcontext {
 	unsigned short gs, __gsh;
 	unsigned short fs, __fsh;
@@ -82,6 +83,35 @@ struct sigcontext {
 	unsigned long oldmask;
 	unsigned long cr2;
 };
+#else /* __KERNEL__ */
+/*
+ * User-space might still rely on the old definition:
+ */
+struct sigcontext {
+	unsigned short gs, __gsh;
+	unsigned short fs, __fsh;
+	unsigned short es, __esh;
+	unsigned short ds, __dsh;
+	unsigned long edi;
+	unsigned long esi;
+	unsigned long ebp;
+	unsigned long esp;
+	unsigned long ebx;
+	unsigned long edx;
+	unsigned long ecx;
+	unsigned long eax;
+	unsigned long trapno;
+	unsigned long err;
+	unsigned long eip;
+	unsigned short cs, __csh;
+	unsigned long eflags;
+	unsigned long esp_at_signal;
+	unsigned short ss, __ssh;
+	struct _fpstate __user * fpstate;
+	unsigned long oldmask;
+	unsigned long cr2;
+};
+#endif /* !__KERNEL__ */
 
 #else /* __i386__ */
 
@@ -102,6 +132,7 @@ struct _fpstate {
 	__u32	reserved2[24];
 };
 
+#ifdef __KERNEL__
 struct sigcontext {
 	unsigned long r8;
 	unsigned long r9;
@@ -132,6 +163,41 @@ struct sigcontext {
 	struct _fpstate __user *fpstate;	/* zero when no FPU context */
 	unsigned long reserved1[8];
 };
+#else /* __KERNEL__ */
+/*
+ * User-space might still rely on the old definition:
+ */
+struct sigcontext {
+	unsigned long r8;
+	unsigned long r9;
+	unsigned long r10;
+	unsigned long r11;
+	unsigned long r12;
+	unsigned long r13;
+	unsigned long r14;
+	unsigned long r15;
+	unsigned long rdi;
+	unsigned long rsi;
+	unsigned long rbp;
+	unsigned long rbx;
+	unsigned long rdx;
+	unsigned long rax;
+	unsigned long rcx;
+	unsigned long rsp;
+	unsigned long rip;
+	unsigned long eflags;		/* RFLAGS */
+	unsigned short cs;
+	unsigned short gs;
+	unsigned short fs;
+	unsigned short __pad0;
+	unsigned long err;
+	unsigned long trapno;
+	unsigned long oldmask;
+	unsigned long cr2;
+	struct _fpstate __user *fpstate;	/* zero when no FPU context */
+	unsigned long reserved1[8];
+};
+#endif /* !__KERNEL__ */
 
 #endif /* !__i386__ */
 
