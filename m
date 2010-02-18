Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0BRSAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:00:42 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:42184 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab0BRSAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZOrB71geZk9Vp68x0Mpzwcg8vhfwFt1XHTzQ3f+MWdAftQI/q3wvz/d+CIt+RtH/fu
         YcTkG8Btt9+A9IlilBrpvFJyIFINBJmMzpjRrEko3RhXJW/7GjEJnmHCXtipjhddkGkT
         EP8wdCnr4/p//yjpPAvpGlLIUINljKT7V2fQU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Stefaniuc <mstefani@redhat.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 1/2] hw-breakpoints: Accept breakpoints on NULL address
Date: Thu, 18 Feb 2010 19:00:00 +0100
Message-Id: <1266516001-7753-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <4B7881AC.5070209@redhat.com>
References: <4B7881AC.5070209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we had a generic breakpoint API, ptrace was accepting
breakpoints on NULL address in x86. The new API refuse them,
without given strong reasons. We need to follow the previous
behaviour as some userspace apps like Wine need such NULL
breakpoints to ensure old emulated software protections
are still working.

This fixes a 2.6.32 - 2.6.33-x ptrace regression.

Reported-by: Michael Stefaniuc <mstefani@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Maneesh Soni <maneesh@linux.vnet.ibm.com>
Cc: Alexandre Julliard <julliard@winehq.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 05d5fec..bb6006e 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -212,25 +212,6 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
 
-/*
- * Store a breakpoint's encoded address, length, and type.
- */
-static int arch_store_info(struct perf_event *bp)
-{
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	/*
-	 * For kernel-addresses, either the address or symbol name can be
-	 * specified.
-	 */
-	if (info->name)
-		info->address = (unsigned long)
-				kallsyms_lookup_name(info->name);
-	if (info->address)
-		return 0;
-
-	return -EINVAL;
-}
-
 int arch_bp_generic_fields(int x86_len, int x86_type,
 			   int *gen_len, int *gen_type)
 {
@@ -362,10 +343,13 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 		return ret;
 	}
 
-	ret = arch_store_info(bp);
-
-	if (ret < 0)
-		return ret;
+	/*
+	 * For kernel-addresses, either the address or symbol name can be
+	 * specified.
+	 */
+	if (info->name)
+		info->address = (unsigned long)
+				kallsyms_lookup_name(info->name);
 	/*
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.
-- 
1.6.2.3

