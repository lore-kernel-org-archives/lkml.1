Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZH0CdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZH0CdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932302AbZH0CdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:33:07 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62931 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbZH0CdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xKavyoi8DLAuD0/o2fsjacHsxuru9iJcMpXrHA8fuBtwd4y4TQVve1zZVps9CH4Wxl
         uj2x+pTpWlmXXDsioW3eHN20Ka30AVg30BUF8/I9joI8w0Ls1oj7GuJyn93B/k8EdZEc
         c31mCB0Cl5iLtlmcOMw08wc7VtC5cnyw5ei9Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [PATCH 18/18] tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion
Date: Thu, 27 Aug 2009 04:32:17 +0200
Message-Id: <1251340337-5640-19-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes can enter into a probing recursion, ie: a kprobe that does an
endless loop because one of its core mechanism function used during
probing is also probed itself.

This patch helps pinpointing the kprobe that raised such recursion
by dumping it and raising a BUG instead of a warning (we also disarm
the kprobe to try avoiding recursion in BUG itself). Having a BUG
instead of a warning stops the stacktrace in the right place and
doesn't pollute the logs with hundreds of traces that eventually end
up in a stack overflow.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/x86/kernel/kprobes.c |    8 ++++++--
 include/linux/kprobes.h   |    2 ++
 kernel/kprobes.c          |    7 +++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 16ae961..ecee3d2 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -490,9 +490,13 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 			/* A probe has been hit in the codepath leading up
 			 * to, or just after, single-stepping of a probed
 			 * instruction. This entire codepath should strictly
-			 * reside in .kprobes.text section. Raise a warning
-			 * to highlight this peculiar case.
+			 * reside in .kprobes.text section.
+			 * Raise a BUG or we'll continue in an endless
+			 * reentering loop and eventually a stack overflow.
 			 */
+			arch_disarm_kprobe(p);
+			dump_kprobe(p);
+			BUG();
 		}
 	default:
 		/* impossible cases */
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index bcd9c07..87eb79c 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -296,6 +296,8 @@ void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 int disable_kprobe(struct kprobe *kp);
 int enable_kprobe(struct kprobe *kp);
 
+void dump_kprobe(struct kprobe *kp);
+
 #else /* !CONFIG_KPROBES: */
 
 static inline int kprobes_built_in(void)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ef177d6..f72e96c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1141,6 +1141,13 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 	arch_remove_kprobe(p);
 }
 
+void __kprobes dump_kprobe(struct kprobe *kp)
+{
+	printk(KERN_WARNING "Dumping kprobe:\n");
+	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
+	       kp->symbol_name, kp->addr, kp->offset);
+}
+
 /* Module notifier call back, checking kprobes on the module */
 static int __kprobes kprobes_module_callback(struct notifier_block *nb,
 					     unsigned long val, void *data)
-- 
1.6.2.3

