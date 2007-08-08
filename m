Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbXHHHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbXHHHKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXHHHIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXHHHIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:05 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 8/25] [PATCH] use macro for sti/cli in spinlock definitions
Date: Wed,  8 Aug 2007 01:18:55 -0300
Message-Id: <1186546785346-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865467812610-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches the cli and sti instructions into macros.
In this header, they're just defined to the instructions they
refer to. Later on, when paravirt is defined, they will be
defined to something with paravirt abilities.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/spinlock.h |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86_64/spinlock.h b/include/asm-x86_64/spinlock.h
index 88bf981..a81e27a 100644
--- a/include/asm-x86_64/spinlock.h
+++ b/include/asm-x86_64/spinlock.h
@@ -5,6 +5,14 @@
 #include <asm/rwlock.h>
 #include <asm/page.h>
 #include <asm/processor.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define CLI_STI_INPUT_ARGS
+#define CLI_STI_CLOBBERS
+#define CLI_STRING "cli"
+#define STI_STRING "sti"
+#endif
 
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
@@ -48,12 +56,12 @@ static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long fla
 		"jns 5f\n"
 		"testl $0x200, %1\n\t"	/* interrupts were disabled? */
 		"jz 4f\n\t"
-	        "sti\n"
+		STI_STRING "\n\t"
 		"3:\t"
 		"rep;nop\n\t"
 		"cmpl $0, %0\n\t"
 		"jle 3b\n\t"
-		"cli\n\t"
+		CLI_STRING "\n\t"
 		"jmp 1b\n"
 		"4:\t"
 		"rep;nop\n\t"
@@ -61,7 +69,9 @@ static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long fla
 		"jg 1b\n\t"
 		"jmp 4b\n"
 		"5:\n\t"
-		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
+		: "+m" (lock->slock)
+		: "r" ((unsigned)flags), CLI_STI_INPUT_ARGS
+		: "memory", CLI_STI_CLOBBERS);
 }
 #endif
 
-- 
1.4.4.2

