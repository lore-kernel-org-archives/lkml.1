Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZIVTjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZIVTjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZIVTju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:39:50 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39120 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZIVTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Zx5enuHiEpuwdibxzN03nicO7sq3/72F4Dq63Q/X3ivkB28kUO94vRBaTaoqEFmYh9
         N1Ex6SGcBLvUqP8b73cNU02HC6GUj9ODPJMPoLxqo+oy3X4ANj2Grsjx+HxqUKX2bpgQ
         fUlkwc42/VmeTFas1AnwWhHp2AVK9uspt1hec=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 24/24] kprobes: Prevent re-registration of the same kprobe
Date: Tue, 22 Sep 2009 21:38:22 +0200
Message-Id: <1253648302-5771-25-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

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
-- 
1.6.2.3

