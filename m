Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbZKXOjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbZKXOjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbZKXOjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:39:53 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53779 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbZKXOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:39:25 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Michel Lespinasse <walken@google.com>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] perf bench: Add wrappers for atomic operation of GCC
Date: Tue, 24 Nov 2009 23:39:13 +0900
Message-Id: <1259073555-7312-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091118033741.GB23808@google.com>
References: <20091118033741.GB23808@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new file util/include/asm/atomic.h.
It contains wrappers for atomic operation of GCC,
I think this is useful not only for 'perf bench',
but also for entire of perf command.

This patch adds new typedefed struct 'atomic_t'.
I know new typedef is not a thing to welcome,
but I believe that atomic_t is worth to typedef
because it is much general.

I borrowed this file from Darren Hart's futextest.
http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/include/asm/atomic.h |   91 ++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/asm/atomic.h

diff --git a/tools/perf/util/include/asm/atomic.h b/tools/perf/util/include/asm/atomic.h
new file mode 100644
index 0000000..1cef451
--- /dev/null
+++ b/tools/perf/util/include/asm/atomic.h
@@ -0,0 +1,91 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      atomic.h
+ *
+ * DESCRIPTION
+ *      GCC atomic builtin wrappers
+ *      http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-17: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *
+ *****************************************************************************/
+
+#ifndef _PERF_ASM_ATOMIC_H
+#define _PERF_ASM_ATOMIC_H
+
+typedef struct {
+	volatile int val;
+} atomic_t;
+
+#define ATOMIC_INITIALIZER { 0 }
+
+/**
+ * atomic_cmpxchg() - Atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Return the old value of addr->val.
+ */
+static inline int atomic_cmpxchg(atomic_t *addr, int oldval, int newval)
+{
+	return __sync_val_compare_and_swap(&addr->val, oldval, newval);
+}
+
+/**
+ * atomic_inc() - Atomic incrememnt
+ * @addr:	Address of the variable to increment
+ *
+ * Return the new value of addr->val.
+ */
+static inline int atomic_inc(atomic_t *addr)
+{
+	return __sync_add_and_fetch(&addr->val, 1);
+}
+
+/**
+ * atomic_dec() - Atomic decrement
+ * @addr:	Address of the variable to decrement
+ *
+ * Return the new value of addr-val.
+ */
+static inline int atomic_dec(atomic_t *addr)
+{
+	return __sync_sub_and_fetch(&addr->val, 1);
+}
+
+/**
+ * atomic_set() - Atomic set
+ * @addr:	Address of the variable to set
+ * @newval:	New value for the atomic_t
+ *
+ * Return the new value of addr->val.
+ */
+static inline int atomic_set(atomic_t *addr, int newval)
+{
+	addr->val = newval;
+	return newval;
+}
+
+#endif	/* _PERF_ASM_ATOMIC_H */
-- 
1.6.5.2

