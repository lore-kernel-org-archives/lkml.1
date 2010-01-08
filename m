Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312Ab0AHEnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0AHEnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 23:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651Ab0AHEnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 23:43:52 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:53319 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0AHEnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 23:43:51 -0500
X-IronPort-AV: E=Sophos;i="4.49,239,1262581200"; 
   d="scan'208";a="9883355"
Subject: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
From: Li Yi <yi.li@analog.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
CC: uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 8 Jan 2010 12:45:25 +0800
Message-ID: <1262925925.27700.15.camel@adam-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2010 04:43:45.0214 (UTC) FILETIME=[2923BDE0:01CA901D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"irqsoff" tracer may cause stack overflow on architectures using
asm-generic/atomic.h, due to recursive invoking of, e.g.
trace_hardirqs_off().

trace_hardirqs_off() -> start_critical_timing() -> atomic_inc() ->
atomic_add_return() -> local_irq_save() -> trace_hardirqs_off()

Signed-off-by: Yi Li <yi.li@analog.com>
---
 include/asm-generic/atomic.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index c99c64d..c3e5f4b 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -60,11 +60,11 @@ static inline int atomic_add_return(int i, atomic_t
*v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	temp = v->counter;
 	temp += i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -82,11 +82,11 @@ static inline int atomic_sub_return(int i, atomic_t
*v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	temp = v->counter;
 	temp -= i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 
 	return temp;
 }
@@ -139,9 +139,9 @@ static inline void atomic_clear_mask(unsigned long
mask, unsigned long *addr)
 	unsigned long flags;
 
 	mask = ~mask;
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	*addr &= mask;
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-- 
1.6.0.4


