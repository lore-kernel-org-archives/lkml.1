Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402Ab0ADKsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0ADKsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389Ab0ADKsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:48:38 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40509 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0ADKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:48:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, nhorman@tuxdriver.com,
       mingo@elte.hu, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] resource: add helpers for fetching rlimits
Date: Mon,  4 Jan 2010 11:48:15 +0100
Message-Id: <1262602095-17591-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <4B41C750.9080305@gmail.com>
References: <4B41C750.9080305@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be sure that compiler fetches the limit variable only
once, so add helpers for fetching current and maximal resource
limits which do that.

Add them to sched.h (instead of resource.h) due to circular dependency
 sched.h->resource.h->task_struct
Alternative would be to create a separate res_access.h or similar.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f842d..8d4991b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2601,6 +2601,28 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 }
 #endif /* CONFIG_MM_OWNER */
 
+static inline unsigned long task_rlimit(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
+}
+
+static inline unsigned long task_rlimit_max(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_max);
+}
+
+static inline unsigned long rlimit(unsigned int limit)
+{
+	return task_rlimit(current, limit);
+}
+
+static inline unsigned long rlimit_max(unsigned int limit)
+{
+	return task_rlimit_max(current, limit);
+}
+
 #endif /* __KERNEL__ */
 
 #endif
-- 
1.6.5.7

