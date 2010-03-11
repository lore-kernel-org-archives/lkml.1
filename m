Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0CKUDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:03:49 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:41581 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0CKUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:03:48 -0500
Subject: [PATCH] MIPS: Fix compile error implicit declaration of function
 cpu_local_wrap
From: Philby John <pjohn@mvista.com>
Reply-To: pjohn@mvista.com
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       David Daney <ddaney@caviumnetworks.com>
Content-Type: text/plain
Date: Fri, 12 Mar 2010 01:33:36 +0530
Message-Id: <1268337816.29250.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 38b7827fc removed cpu_local_xx macros that lead to
a compile error: implicit declaration of function 'cpu_local_wrap',
when compiled for the MIPS Cavium Octeon processors. Revert back
to old code.

CC: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>
CC: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Philby John <pjohn@mvista.com>
---
 arch/mips/include/asm/local.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
index bdcdef0..65ec69d 100644
--- a/arch/mips/include/asm/local.h
+++ b/arch/mips/include/asm/local.h
@@ -193,4 +193,29 @@ static __inline__ long local_sub_return(long i, local_t * l)
 #define __local_add(i, l)	((l)->a.counter+=(i))
 #define __local_sub(i, l)	((l)->a.counter-=(i))
 
+/* Need to disable preemption for the cpu local counters otherwise we could
+   still access a variable of a previous CPU in a non atomic way. */
+#define cpu_local_wrap_v(l)             \
+	({ local_t res__;               \
+	   preempt_disable();           \
+	   res__ = (l);                 \
+	   preempt_enable();            \
+	   res__; })
+#define cpu_local_wrap(l)               \
+	({ preempt_disable();           \
+	   l;                           \
+	   preempt_enable(); })         \
+
+#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
+#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
+#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
+#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
+#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
+#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
+
+#define __cpu_local_inc(l)      cpu_local_inc(l)
+#define __cpu_local_dec(l)      cpu_local_dec(l)
+#define __cpu_local_add(i, l)   cpu_local_add((i), (l))
+#define __cpu_local_sub(i, l)   cpu_local_sub((i), (l))
+
 #endif /* _ARCH_MIPS_LOCAL_H */
-- 
1.6.3.3.311.g7ec7



