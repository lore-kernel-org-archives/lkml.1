Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbYBHSZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbYBHSZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbYBHSYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:24:46 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45185 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221AbYBHSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:24:44 -0500
Date: Fri, 8 Feb 2008 18:23:31 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Mike Travis <travis@sgi.com>
cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: fix DEBUG_PREEMPT per_cpu checking
Message-ID: <Pine.LNX.4.64.0802081818580.6273@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent percpu changes have broken CONFIG_DEBUG_PREEMPT's per_cpu checking
on several architectures.  On s390, sparc64 and x86 it's been weakened to
not checking at all; whereas on powerpc64 it's become too strict, issuing
warnings from __raw_get_cpu_var in io_schedule and init_timer for example.

Fix this by weakening powerpc's __my_cpu_offset to use the non-checking
local_paca instead of get_paca (which itself contains such a check);
and strengthening the generic my_cpu_offset to go the old slow way via
smp_processor_id when CONFIG_DEBUG_PREEMPT (debug_smp_processor_id is
where all the knowledge of what's correct when lives).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
ia64 would be in the first group too, but does not support DEBUG_PREEMPT?

 include/asm-generic/percpu.h |    2 ++
 include/asm-powerpc/percpu.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- 2.6.24-git18/include/asm-generic/percpu.h	2008-02-08 11:31:30.000000000 +0000
+++ linux/include/asm-generic/percpu.h	2008-02-08 12:27:08.000000000 +0000
@@ -32,6 +32,8 @@ extern unsigned long __per_cpu_offset[NR
  */
 #ifndef __my_cpu_offset
 #define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
+#endif
+#ifdef CONFIG_DEBUG_PREEMPT
 #define my_cpu_offset per_cpu_offset(smp_processor_id())
 #else
 #define my_cpu_offset __my_cpu_offset
--- 2.6.24-git18/include/asm-powerpc/percpu.h	2008-02-08 11:31:31.000000000 +0000
+++ linux/include/asm-powerpc/percpu.h	2008-02-08 12:29:17.000000000 +0000
@@ -13,7 +13,7 @@
 #include <asm/paca.h>
 
 #define __per_cpu_offset(cpu) (paca[cpu].data_offset)
-#define __my_cpu_offset get_paca()->data_offset
+#define __my_cpu_offset local_paca->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
 #endif /* CONFIG_SMP */
