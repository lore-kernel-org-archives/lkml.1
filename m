Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbXLTLzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbXLTLzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbXLTLyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:54:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760051AbXLTLyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:54:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 04/43] user_regset helpers
Message-Id: <20071220115436.850E726F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:54:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some inlines to linux/regset.h intended for arch code to use in
its user_regset get and set functions.  These make it pretty easy to deal
with the interface's optional kernel-space or user-space pointers and its
generalized access to a part of the register data at a time.

In simple cases where the internal data structure matches the exported
layout (core dump format), a get function can be nothing but a call to
user_regset_copyout, and a set function a call to user_regset_copyin.

In other cases the exported layout is usually made up of a few pieces each
stored contiguously in a different internal data structure.  These helpers
make it straightforward to write a get or set function by processing each
contiguous chunk of the data in order.  The start_pos and end_pos arguments
are always constants, so these inlines collapse to a small amount of code.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/regset.h |  116 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/include/linux/regset.h b/include/linux/regset.h
index 85d0fb0..761c931 100644
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -15,6 +15,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/uaccess.h>
 struct task_struct;
 struct user_regset;
 
@@ -203,4 +204,119 @@ struct user_regset_view {
 const struct user_regset_view *task_user_regset_view(struct task_struct *tsk);
 
 
+/*
+ * These are helpers for writing regset get/set functions in arch code.
+ * Because @start_pos and @end_pos are always compile-time constants,
+ * these are inlined into very little code though they look large.
+ *
+ * Use one or more calls sequentially for each chunk of regset data stored
+ * contiguously in memory.  Call with constants for @start_pos and @end_pos,
+ * giving the range of byte positions in the regset that data corresponds
+ * to; @end_pos can be -1 if this chunk is at the end of the regset layout.
+ * Each call updates the arguments to point past its chunk.
+ */
+
+static inline int user_regset_copyout(unsigned int *pos, unsigned int *count,
+				      void **kbuf,
+				      void __user **ubuf, const void *data,
+				      const int start_pos, const int end_pos)
+{
+	if (*count == 0)
+		return 0;
+	BUG_ON(*pos < start_pos);
+	if (end_pos < 0 || *pos < end_pos) {
+		unsigned int copy = (end_pos < 0 ? *count
+				     : min(*count, end_pos - *pos));
+		data += *pos - start_pos;
+		if (*kbuf) {
+			memcpy(*kbuf, data, copy);
+			*kbuf += copy;
+		} else if (__copy_to_user(*ubuf, data, copy))
+			return -EFAULT;
+		else
+			*ubuf += copy;
+		*pos += copy;
+		*count -= copy;
+	}
+	return 0;
+}
+
+static inline int user_regset_copyin(unsigned int *pos, unsigned int *count,
+				     const void **kbuf,
+				     const void __user **ubuf, void *data,
+				     const int start_pos, const int end_pos)
+{
+	if (*count == 0)
+		return 0;
+	BUG_ON(*pos < start_pos);
+	if (end_pos < 0 || *pos < end_pos) {
+		unsigned int copy = (end_pos < 0 ? *count
+				     : min(*count, end_pos - *pos));
+		data += *pos - start_pos;
+		if (*kbuf) {
+			memcpy(data, *kbuf, copy);
+			*kbuf += copy;
+		} else if (__copy_from_user(data, *ubuf, copy))
+			return -EFAULT;
+		else
+			*ubuf += copy;
+		*pos += copy;
+		*count -= copy;
+	}
+	return 0;
+}
+
+/*
+ * These two parallel the two above, but for portions of a regset layout
+ * that always read as all-zero or for which writes are ignored.
+ */
+static inline int user_regset_copyout_zero(unsigned int *pos,
+					   unsigned int *count,
+					   void **kbuf, void __user **ubuf,
+					   const int start_pos,
+					   const int end_pos)
+{
+	if (*count == 0)
+		return 0;
+	BUG_ON(*pos < start_pos);
+	if (end_pos < 0 || *pos < end_pos) {
+		unsigned int copy = (end_pos < 0 ? *count
+				     : min(*count, end_pos - *pos));
+		if (*kbuf) {
+			memset(*kbuf, 0, copy);
+			*kbuf += copy;
+		} else if (__clear_user(*ubuf, copy))
+			return -EFAULT;
+		else
+			*ubuf += copy;
+		*pos += copy;
+		*count -= copy;
+	}
+	return 0;
+}
+
+static inline int user_regset_copyin_ignore(unsigned int *pos,
+					    unsigned int *count,
+					    const void **kbuf,
+					    const void __user **ubuf,
+					    const int start_pos,
+					    const int end_pos)
+{
+	if (*count == 0)
+		return 0;
+	BUG_ON(*pos < start_pos);
+	if (end_pos < 0 || *pos < end_pos) {
+		unsigned int copy = (end_pos < 0 ? *count
+				     : min(*count, end_pos - *pos));
+		if (*kbuf)
+			*kbuf += copy;
+		else
+			*ubuf += copy;
+		*pos += copy;
+		*count -= copy;
+	}
+	return 0;
+}
+
+
 #endif	/* <linux/regset.h> */
-- 
1.5.3.6

