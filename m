Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbYCNUth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbYCNUth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYCNUt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:49:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYCNUt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:49:27 -0400
Message-ID: <47DAE2E7.101@redhat.com>
Date: Fri, 14 Mar 2008 16:41:11 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH -mm 4/5] kprobes: add (un)register_jprobes for batch registration
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce unregister_/register_jprobes() for jprobe
batch registration.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 include/linux/kprobes.h |    9 ++++++
 kernel/kprobes.c        |   65 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 65 insertions(+), 9 deletions(-)

Index: 2.6.25-rc5-mm1/include/linux/kprobes.h
===================================================================
--- 2.6.25-rc5-mm1.orig/include/linux/kprobes.h
+++ 2.6.25-rc5-mm1/include/linux/kprobes.h
@@ -240,6 +240,8 @@ int setjmp_pre_handler(struct kprobe *,
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
 void unregister_jprobe(struct jprobe *p);
+int register_jprobes(struct jprobe **jps, int num);
+void unregister_jprobes(struct jprobe **jps, int num);
 void jprobe_return(void);
 unsigned long arch_deref_entry_point(void *);

@@ -279,9 +281,16 @@ static inline int register_jprobe(struct
 {
 	return -ENOSYS;
 }
+static inline int register_jprobes(struct jprobe **jps, int num)
+{
+	return -ENOSYS;
+}
 static inline void unregister_jprobe(struct jprobe *p)
 {
 }
+static inline void unregister_jprobes(struct jprobe **jps, int num)
+{
+}
 static inline void jprobe_return(void)
 {
 }
Index: 2.6.25-rc5-mm1/kernel/kprobes.c
===================================================================
--- 2.6.25-rc5-mm1.orig/kernel/kprobes.c
+++ 2.6.25-rc5-mm1/kernel/kprobes.c
@@ -755,24 +755,69 @@ unsigned long __weak arch_deref_entry_po
 	return (unsigned long)entry;
 }

-int __kprobes register_jprobe(struct jprobe *jp)
+static int __register_jprobes(struct jprobe **jps, int num,
+	unsigned long called_from)
 {
-	unsigned long addr = arch_deref_entry_point(jp->entry);
+	struct jprobe *jp;
+	int ret = 0, i;

-	if (!kernel_text_address(addr))
+	if (num <= 0)
 		return -EINVAL;
+	for (i = 0; i < num; i++) {
+		unsigned long addr;
+		jp = jps[i];
+		addr = arch_deref_entry_point(jp->entry);
+
+		if (!kernel_text_address(addr))
+			ret = -EINVAL;
+		else {
+			/* Todo: Verify probepoint is a function entry point */
+			jp->kp.pre_handler = setjmp_pre_handler;
+			jp->kp.break_handler = longjmp_break_handler;
+			ret = __register_kprobe(&jp->kp, called_from);
+		}
+		if (ret < 0 && i > 0) {
+			unregister_jprobes(jps, i);
+			break;
+		}
+	}
+	return ret;
+}

-	/* Todo: Verify probepoint is a function entry point */
-	jp->kp.pre_handler = setjmp_pre_handler;
-	jp->kp.break_handler = longjmp_break_handler;
-
-	return __register_kprobe(&jp->kp,
+int __kprobes register_jprobe(struct jprobe *jp)
+{
+	return __register_jprobes(&jp, 1,
 		(unsigned long)__builtin_return_address(0));
 }

 void __kprobes unregister_jprobe(struct jprobe *jp)
 {
-	unregister_kprobe(&jp->kp);
+	unregister_jprobes(&jp, 1);
+}
+
+int __kprobes register_jprobes(struct jprobe **jps, int num)
+{
+	return __register_jprobes(jps, num,
+		(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_jprobes(struct jprobe **jps, int num)
+{
+	int i;
+
+	if (num <= 0)
+		return;
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < num; i++)
+		if (__unregister_kprobe_top(&jps[i]->kp) < 0)
+			jps[i]->kp.addr = NULL;
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	for (i = 0; i < num; i++) {
+		if (jps[i]->kp.addr)
+			__unregister_kprobe_bottom(&jps[i]->kp);
+	}
 }

 #ifdef CONFIG_KRETPROBES
@@ -1236,6 +1281,8 @@ EXPORT_SYMBOL_GPL(register_kprobes);
 EXPORT_SYMBOL_GPL(unregister_kprobes);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
+EXPORT_SYMBOL_GPL(register_jprobes);
+EXPORT_SYMBOL_GPL(unregister_jprobes);
 #ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(jprobe_return);
 #endif
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com



