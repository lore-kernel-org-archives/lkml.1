Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYBJHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYBJHOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbYBJHNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:13:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49423 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbYBJHNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:13:44 -0500
Date: Sun, 10 Feb 2008 08:13:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [2/6] uaccess: add probe_kernel_write()
Message-ID: <20080210071326.GB3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add probe_kernel_write() - copy & paste of the existing
probe_kernel_access(), extended to writes.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/uaccess.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux-kgdb.q/include/linux/uaccess.h
===================================================================
--- linux-kgdb.q.orig/include/linux/uaccess.h
+++ linux-kgdb.q/include/linux/uaccess.h
@@ -84,4 +84,26 @@ static inline unsigned long __copy_from_
 		ret;					\
 	})
 
+/**
+ * probe_kernel_write(): safely attempt to write to a location
+ * @addr: address to write to - its type is type typeof(rdval)*
+ * @rdval: write to this variable
+ *
+ * Safely write to address @addr from variable @rdval.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+#define probe_kernel_write(addr, rdval)			\
+	({						\
+		long ret;				\
+		mm_segment_t old_fs = get_fs();		\
+							\
+		set_fs(KERNEL_DS);			\
+		pagefault_disable();			\
+		ret = __put_user(rdval,			\
+	 (__force typeof(rdval) __user *)(addr));	\
+		pagefault_enable();			\
+		set_fs(old_fs);				\
+		ret;					\
+	})
+
 #endif		/* __LINUX_UACCESS_H__ */
