Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXLBBgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXLBBgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 20:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXLBBf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 20:35:56 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38353 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXLBBf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 20:35:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, pageexec@freemail.hu,
       Yinghai Lu <yinghai.lu@sun.com>
Subject: [PATCH] fix x86-32 early fixmap initialization.
References: <47520F37.20657.4A6846F1@pageexec.freemail.hu>
Date: Sat, 01 Dec 2007 18:34:06 -0700
In-Reply-To: <47520F37.20657.4A6846F1@pageexec.freemail.hu>
	(pageexec@freemail.hu's message of "Sun, 02 Dec 2007 01:49:43 +0200")
Message-ID: <m163zh5181.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pageexec@freemail.hu writes:

> hello,
>
> i've just noticed that the chunk in i386/kernel/head.S ended up in a
> weird place, namely, it's not going to be executed as it's just after
> a 'jmp 3f' and before startup_32_smp, probably not what you intended.
> on a sidenote, the whole thing can be done in a single insn, like:
>
> movl $(swapper_pg_pmd - __PAGE_OFFSET + 0x067), (swapper_pg_dir -
> __PAGE_OFFSET+ 4092)
>
> PS: your email address ebiderman@xmisson.com in the commit seems to
> be wrong as well.

Yes.  YH refresh one of my old patches and apparently got my email
address wrong.

Thanks for the reminder I thought we had fixed this problem a while ago.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 374b7ec..ac0637a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -193,6 +193,12 @@ default_entry:
 	jb 10b
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
+	/* Do an early initialization of the fixmap area */
+	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
+	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
+	addl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
+	movl %eax, 4092(%edx)
+
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
 /*
@@ -208,12 +214,6 @@ default_entry:
 .section .init.text,"ax",@progbits
 #endif
 
-	/* Do an early initialization of the fixmap area */
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
-	addl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
-	movl %eax, 4092(%edx)
-
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
