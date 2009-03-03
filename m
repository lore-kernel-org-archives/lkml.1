Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZCCP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZCCP5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCCP4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:56:49 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:50168 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZCCP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:56:49 -0500
From: Dan Smith <danms@us.ibm.com>
To: containers@lists.osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
Date: Tue,  3 Mar 2009 10:56:03 -0500
Message-Id: <1236095764-19325-3-git-send-email-danms@us.ibm.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Dave[1], this provides us a way to make the copy-in and
copy-out processes symmetric.  CR_COPY_ARRAY() provides us a way to do
the same thing but for arrays.  It's not critical, but it helps us unify
the checkpoint and restart paths for some things.

Changelog:
    Feb 27:
            . Changed CR_COPY() to use assignment, eliminating the need
              for the CR_COPY_BIT() macro
            . Add CR_COPY_ARRAY() macro to help copying register arrays,
              etc
            . Move the macro definitions inside the CR #ifdef
    Feb 25:
            . Changed WARN_ON() to BUILD_BUG_ON()

Signed-off-by: Dan Smith <danms@us.ibm.com>

1: https://lists.linux-foundation.org/pipermail/containers/2009-February/015821.html (all the way at the bottom)
---
 include/linux/checkpoint.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index 217cf6e..735668f 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -142,6 +142,26 @@ static inline void __task_deny_checkpointing(struct task_struct *task,
 #define task_deny_checkpointing(p)  \
 	__task_deny_checkpointing(p, __FILE__, __LINE__)
 
+#define CR_CPT 1
+#define CR_RST 2
+
+#define CR_COPY(op, a, b)				        \
+	do {							\
+		if (op == CR_CPT)				\
+			a = b;					\
+		else						\
+			b = a;					\
+	} while (0);
+
+#define CR_COPY_ARRAY(op, a, b, count)				\
+	do {							\
+		BUILD_BUG_ON(sizeof(*a) != sizeof(*b));		\
+		if (op == CR_CPT)				\
+			memcpy(a, b, count * sizeof(*a));	\
+		else						\
+			memcpy(b, a, count * sizeof(*a));	\
+	} while (0);
+
 #else
 
 static inline void task_deny_checkpointing(struct task_struct *task) {}
-- 
1.6.1

