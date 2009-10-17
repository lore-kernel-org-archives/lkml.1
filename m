Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZJQKDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZJQKDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZJQKDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:03:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZJQKCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:02:55 -0400
Date: Sat, 17 Oct 2009 10:02:09 GMT
From: tip-bot for Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090915051307.GB26458@in.ibm.com>
References: <20090915051307.GB26458@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes: Prevent re-registration of the same kprobe
Message-ID: <tip-1f0ab40976460bc4673fa204ce917a725185d8f2@git.kernel.org>
Git-Commit-ID: 1f0ab40976460bc4673fa204ce917a725185d8f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:02:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f0ab40976460bc4673fa204ce917a725185d8f2
Gitweb:     http://git.kernel.org/tip/1f0ab40976460bc4673fa204ce917a725185d8f2
Author:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
AuthorDate: Tue, 15 Sep 2009 10:43:07 +0530
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 17 Sep 2009 04:24:57 +0200

kprobes: Prevent re-registration of the same kprobe

Prevent re-registration of the same kprobe. This situation, though
unlikely, needs to be flagged since it can lead to a system crash if
it's not handled.

The core change itself is small, but the helper routine needed to be
moved around a bit; hence the diffstat.

Signed-off-by: Ananth N Mavinakayanahalli<ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090915051307.GB26458@in.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/kprobes.c |   58 +++++++++++++++++++++++++++++++++++------------------
 1 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 00d01b0..b946761 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -676,6 +676,40 @@ static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
 }
 
+/* Check passed kprobe is valid and return kprobe in kprobe_table. */
+static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
+{
+	struct kprobe *old_p, *list_p;
+
+	old_p = get_kprobe(p->addr);
+	if (unlikely(!old_p))
+		return NULL;
+
+	if (p != old_p) {
+		list_for_each_entry_rcu(list_p, &old_p->list, list)
+			if (list_p == p)
+			/* kprobe p is a valid probe */
+				goto valid;
+		return NULL;
+	}
+valid:
+	return old_p;
+}
+
+/* Return error if the kprobe is being re-registered */
+static inline int check_kprobe_rereg(struct kprobe *p)
+{
+	int ret = 0;
+	struct kprobe *old_p;
+
+	mutex_lock(&kprobe_mutex);
+	old_p = __get_valid_kprobe(p);
+	if (old_p)
+		ret = -EINVAL;
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+
 int __kprobes register_kprobe(struct kprobe *p)
 {
 	int ret = 0;
@@ -688,6 +722,10 @@ int __kprobes register_kprobe(struct kprobe *p)
 		return -EINVAL;
 	p->addr = addr;
 
+	ret = check_kprobe_rereg(p);
+	if (ret)
+		return ret;
+
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr)) {
@@ -757,26 +795,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
-/* Check passed kprobe is valid and return kprobe in kprobe_table. */
-static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
-{
-	struct kprobe *old_p, *list_p;
-
-	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p))
-		return NULL;
-
-	if (p != old_p) {
-		list_for_each_entry_rcu(list_p, &old_p->list, list)
-			if (list_p == p)
-			/* kprobe p is a valid probe */
-				goto valid;
-		return NULL;
-	}
-valid:
-	return old_p;
-}
-
 /*
  * Unregister a kprobe without a scheduler synchronization.
  */
