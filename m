Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbZEGUaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbZEGUaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZEGUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:30:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZEGUaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:30:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -rc] [BUGFIX] kprobes: fix to use text_mutex around arm/disarm
	kprobe
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 07 May 2009 16:31:26 -0400
Message-ID: <20090507203126.5399.97658.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kprobes to lock text_mutex around some arch_arm/disarm_kprobe() which
are newly added by commit de5bd88d5a5cce3cacea904d3503e5ebdb3852a2.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/kprobes.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index a5e74dd..c0fa54b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -319,6 +319,22 @@ struct kprobe __kprobes *get_kprobe(void *addr)
 	return NULL;
 }
 
+/* Arm a kprobe with text_mutex */
+static void __kprobes arm_kprobe(struct kprobe *kp)
+{
+	mutex_lock(&text_mutex);
+	arch_arm_kprobe(kp);
+	mutex_unlock(&text_mutex);
+}
+
+/* Disarm a kprobe with text_mutex */
+static void __kprobes disarm_kprobe(struct kprobe *kp)
+{
+	mutex_lock(&text_mutex);
+	arch_disarm_kprobe(kp);
+	mutex_unlock(&text_mutex);
+}
+
 /*
  * Aggregate handlers for multiple kprobes support - these handlers
  * take care of invoking the individual kprobe handlers on p->list
@@ -538,7 +554,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 		ap->flags &= ~KPROBE_FLAG_DISABLED;
 		if (!kprobes_all_disarmed)
 			/* Arm the breakpoint again. */
-			arch_arm_kprobe(ap);
+			arm_kprobe(ap);
 	}
 	return 0;
 }
@@ -789,11 +805,8 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (!kprobes_all_disarmed && !kprobe_disabled(old_p)) {
-			mutex_lock(&text_mutex);
-			arch_disarm_kprobe(p);
-			mutex_unlock(&text_mutex);
-		}
+		if (!kprobes_all_disarmed && !kprobe_disabled(old_p))
+			disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
 	} else {
 		if (p->break_handler && !kprobe_gone(p))
@@ -810,7 +823,7 @@ noclean:
 		if (!kprobe_disabled(old_p)) {
 			try_to_disable_aggr_kprobe(old_p);
 			if (!kprobes_all_disarmed && kprobe_disabled(old_p))
-				arch_disarm_kprobe(old_p);
+				disarm_kprobe(old_p);
 		}
 	}
 	return 0;
@@ -1364,7 +1377,7 @@ int __kprobes disable_kprobe(struct kprobe *kp)
 		try_to_disable_aggr_kprobe(p);
 
 	if (!kprobes_all_disarmed && kprobe_disabled(p))
-		arch_disarm_kprobe(p);
+		disarm_kprobe(p);
 out:
 	mutex_unlock(&kprobe_mutex);
 	return ret;
@@ -1393,7 +1406,7 @@ int __kprobes enable_kprobe(struct kprobe *kp)
 	}
 
 	if (!kprobes_all_disarmed && kprobe_disabled(p))
-		arch_arm_kprobe(p);
+		arm_kprobe(p);
 
 	p->flags &= ~KPROBE_FLAG_DISABLED;
 	if (p != kp)

