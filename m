Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbXLTLzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbXLTLzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbXLTLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:55:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760113AbXLTLzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:55:16 -0500
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
Subject: [PATCH -mm 06/43] user_regset user-copy helpers
Message-Id: <20071220115512.07C0226F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:55:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines two new inlines in linux/regset.h, for use in arch_ptrace
implementations and the like.  These provide simplified wrappers for using
the user_regset interfaces to copy thread regset data into the caller's
user-space memory.  The inlines are trivial, but make the common uses in
places such as ptrace implementation much more concise, easier to read, and
less prone to code-copying errors.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/regset.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/regset.h b/include/linux/regset.h
index 761c931..8abee65 100644
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -318,5 +318,51 @@ static inline int user_regset_copyin_ignore(unsigned int *pos,
 	return 0;
 }
 
+/**
+ * copy_regset_to_user - fetch a thread's user_regset data into user memory
+ * @target:	thread to be examined
+ * @view:	&struct user_regset_view describing user thread machine state
+ * @setno:	index in @view->regsets
+ * @offset:	offset into the regset data, in bytes
+ * @size:	amount of data to copy, in bytes
+ * @data:	user-mode pointer to copy into
+ */
+static inline int copy_regset_to_user(struct task_struct *target,
+				      const struct user_regset_view *view,
+				      unsigned int setno,
+				      unsigned int offset, unsigned int size,
+				      void __user *data)
+{
+	const struct user_regset *regset = &view->regsets[setno];
+
+	if (!access_ok(VERIFY_WRITE, data, size))
+		return -EIO;
+
+	return regset->get(target, regset, offset, size, NULL, data);
+}
+
+/**
+ * copy_regset_from_user - store into thread's user_regset data from user memory
+ * @target:	thread to be examined
+ * @view:	&struct user_regset_view describing user thread machine state
+ * @setno:	index in @view->regsets
+ * @offset:	offset into the regset data, in bytes
+ * @size:	amount of data to copy, in bytes
+ * @data:	user-mode pointer to copy from
+ */
+static inline int copy_regset_from_user(struct task_struct *target,
+					const struct user_regset_view *view,
+					unsigned int setno,
+					unsigned int offset, unsigned int size,
+					const void __user *data)
+{
+	const struct user_regset *regset = &view->regsets[setno];
+
+	if (!access_ok(VERIFY_READ, data, size))
+		return -EIO;
+
+	return regset->set(target, regset, offset, size, NULL, data);
+}
+
 
 #endif	/* <linux/regset.h> */
-- 
1.5.3.6

