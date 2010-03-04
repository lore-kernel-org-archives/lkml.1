Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0CDQhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:37:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:46554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0CDQhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:37:31 -0500
Date: Thu, 4 Mar 2010 16:33:38 GMT
From: tip-bot for Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       will.deacon@arm.com, efault@gmx.de, jamie.iles@picochip.com,
       fweisbec@gmail.com, linux@arm.linux.org.uk, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, will.deacon@arm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jamie.iles@picochip.com,
       fweisbec@gmail.com, linux@arm.linux.org.uk, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1267616878-2154-1-git-send-email-will.deacon@arm.com>
References: <1267616878-2154-1-git-send-email-will.deacon@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, ARM: Modify kuser rmb() call to compile for Thumb-2
Message-ID: <tip-da7196e1f986c846ffa8b2ec385223fad38e8518@git.kernel.org>
Git-Commit-ID: da7196e1f986c846ffa8b2ec385223fad38e8518
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:33:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da7196e1f986c846ffa8b2ec385223fad38e8518
Gitweb:     http://git.kernel.org/tip/da7196e1f986c846ffa8b2ec385223fad38e8518
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Wed, 3 Mar 2010 11:47:58 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:13:28 +0100

perf, ARM: Modify kuser rmb() call to compile for Thumb-2

The Thumb-2 instruction set does not provide an encoding
for sub pc, r0, #95 as present in the rmb() definition used
by perf. This results in compilation failure when using a
compiler targetting an instruction set other than ARM.

This patch redefines rmb() for ARM by casting the address
of the kuser helper to a function pointer, therefore getting
the compiler to take care of making the call.

Patch taken against tip/master.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Iles <jamie.iles@picochip.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1267616878-2154-1-git-send-email-will.deacon@arm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 75f941b..6fb379b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -65,9 +65,7 @@
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
  */
-#define rmb()		asm volatile("mov r0, #0xffff0fff; mov lr, pc;" \
-				     "sub pc, r0, #95" ::: "r0", "lr", "cc", \
-				     "memory")
+#define rmb()		((void(*)(void))0xffff0fa0)()
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
