Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZJAGth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZJAGth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZJAGtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:49:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:46004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZJAGtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:49:35 -0400
Date: Thu, 1 Oct 2009 06:49:05 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       arjan@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, johnstul@us.ibm.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       arjan@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AC43E7E.1000600@gmail.com>
References: <4AC43E7E.1000600@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don't generate cmpxchg8b_emu if CONFIG_X86_CMPXCHG64=y
Message-ID: <tip-04edbdef02ec4386a2ae38cab7ae7d166e17a756@git.kernel.org>
Git-Commit-ID: 04edbdef02ec4386a2ae38cab7ae7d166e17a756
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 06:49:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04edbdef02ec4386a2ae38cab7ae7d166e17a756
Gitweb:     http://git.kernel.org/tip/04edbdef02ec4386a2ae38cab7ae7d166e17a756
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Thu, 1 Oct 2009 07:30:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 08:42:24 +0200

x86: Don't generate cmpxchg8b_emu if CONFIG_X86_CMPXCHG64=y

Conditionaly compile cmpxchg8b_emu.o and EXPORT_SYMBOL(cmpxchg8b_emu).

This reduces the kernel size a bit.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4AC43E7E.1000600@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/i386_ksyms_32.c |    2 ++
 arch/x86/lib/Makefile           |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 1736c5a..9c3bd4a 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -15,8 +15,10 @@ EXPORT_SYMBOL(mcount);
  * the export, but dont use it from C code, it is used
  * by assembly code and is not using C calling convention!
  */
+#ifndef CONFIG_X86_CMPXCHG64
 extern void cmpxchg8b_emu(void);
 EXPORT_SYMBOL(cmpxchg8b_emu);
+#endif
 
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy_generic);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 3e549b8..85f5db9 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -15,8 +15,10 @@ ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
-
+        lib-y += semaphore_32.o string_32.o
+ifneq ($(CONFIG_X86_CMPXCHG64),y)
+        lib-y += cmpxchg8b_emu.o
+endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
         obj-y += io_64.o iomap_copy_64.o
