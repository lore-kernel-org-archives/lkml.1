Return-Path: <linux-kernel-owner+w=401wt.eu-S1762181AbYBWTmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181AbYBWTmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYBWTl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:41:58 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46134 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbYBWTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:41:57 -0500
Date: Sat, 23 Feb 2008 19:40:17 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mike Travis <travis@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: fix DEBUG_PREEMPT per_cpu checking
Message-ID: <Pine.LNX.4.64.0802231927500.13934@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-rc1 percpu changes broke CONFIG_DEBUG_PREEMPT's per_cpu checking
on several architectures.  On s390, sparc64 and x86 it's been weakened to
not checking at all; whereas on powerpc64 it's become too strict, issuing
warnings from __raw_get_cpu_var in io_schedule and init_timer for example.

Fix this by weakening powerpc's __my_cpu_offset to use the non-checking
local_paca instead of get_paca (which itself contains such a check);
and strengthening the generic my_cpu_offset to go the old slow way via
smp_processor_id when CONFIG_DEBUG_PREEMPT (debug_smp_processor_id is
where all the knowledge of what's correct when lives).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: Mike Travis <travis@sgi.com>
---
I posted this a couple of weeks ago, but it seems we all expected
someone else to forward it to you.

 include/asm-generic/percpu.h |    2 ++
 include/asm-powerpc/percpu.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- 2.6.25-rc2-git/include/asm-generic/percpu.h	2008-02-08 11:31:30.000000000 +0000
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
--- 2.6.25-rc2-git/include/asm-powerpc/percpu.h	2008-02-08 11:31:31.000000000 +0000
+++ linux/include/asm-powerpc/percpu.h	2008-02-08 12:29:17.000000000 +0000
@@ -13,7 +13,7 @@
 #include <asm/paca.h>
 
 #define __per_cpu_offset(cpu) (paca[cpu].data_offset)
-#define __my_cpu_offset get_paca()->data_offset
+#define __my_cpu_offset local_paca->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
 #endif /* CONFIG_SMP */
