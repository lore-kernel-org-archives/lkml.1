Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZK0XJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZK0XJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZK0XJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:09:27 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60473 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 14/27] resource: add helpers for fetching rlimits
Date: Sat, 28 Nov 2009 00:05:54 +0100
Message-Id: <1259363167-9347-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
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
index 75e6e60..cf4205b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2574,6 +2574,28 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 }
 #endif /* CONFIG_MM_OWNER */
 
+static inline unsigned long task_rlim_get_cur(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
+}
+
+static inline unsigned long task_rlim_get_max(const struct task_struct *tsk,
+		unsigned int limit)
+{
+	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_max);
+}
+
+static inline unsigned long rlim_get_cur(unsigned int limit)
+{
+	return task_rlim_get_cur(current, limit);
+}
+
+static inline unsigned long rlim_get_max(unsigned int limit)
+{
+	return task_rlim_get_max(current, limit);
+}
+
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
 #endif /* __KERNEL__ */
-- 
1.6.5.3

