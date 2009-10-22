Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZJVGCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZJVGCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZJVGCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:02:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39447 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZJVGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:29 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: Clean up PR_MCE_KILL interface
Date: Thu, 22 Oct 2009 08:02:25 +0200
Message-Id: <1256191352-6903-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-1-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

While writing the manpage I noticed some shortcomings in the
current interface.

- Define symbolic names for all the different values
- Boundary check the kill mode values
- For symmetry add a get interface too. This allows library
code to get/set the current state.
- For consistency define a PR_MCE_KILL_DEFAULT value

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/prctl.h |   12 ++++++++++++
 kernel/sys.c          |   23 ++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 9311505..a3baeb2 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -88,6 +88,18 @@
 #define PR_TASK_PERF_EVENTS_DISABLE		31
 #define PR_TASK_PERF_EVENTS_ENABLE		32
 
+/*
+ * Set early/late kill mode for hwpoison memory corruption.
+ * This influences when the process gets killed on a memory corruption.
+ */
 #define PR_MCE_KILL	33
+# define PR_MCE_KILL_CLEAR   0
+# define PR_MCE_KILL_SET     1
+
+# define PR_MCE_KILL_LATE    0
+# define PR_MCE_KILL_EARLY   1
+# define PR_MCE_KILL_DEFAULT 2
+
+#define PR_MCE_KILL_GET 34
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..f6afe07 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1546,24 +1546,37 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			if (arg4 | arg5)
 				return -EINVAL;
 			switch (arg2) {
-			case 0:
+			case PR_MCE_KILL_CLEAR:
 				if (arg3 != 0)
 					return -EINVAL;
 				current->flags &= ~PF_MCE_PROCESS;
 				break;
-			case 1:
+			case PR_MCE_KILL_SET:
 				current->flags |= PF_MCE_PROCESS;
-				if (arg3 != 0)
+				if (arg3 == PR_MCE_KILL_EARLY)
 					current->flags |= PF_MCE_EARLY;
-				else
+				else if (arg3 == PR_MCE_KILL_LATE)
 					current->flags &= ~PF_MCE_EARLY;
+				else if (arg3 == PR_MCE_KILL_DEFAULT)
+					current->flags &=
+						~(PF_MCE_EARLY|PF_MCE_PROCESS);
+				else
+					return -EINVAL;
 				break;
 			default:
 				return -EINVAL;
 			}
 			error = 0;
 			break;
-
+		case PR_MCE_KILL_GET:
+			if (arg2 | arg3 | arg4 | arg5)
+				return -EINVAL;
+			if (current->flags & PF_MCE_PROCESS)
+				error = (current->flags & PF_MCE_EARLY) ?
+					PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE;
+			else
+				error = PR_MCE_KILL_DEFAULT;
+			break;
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.0.2

