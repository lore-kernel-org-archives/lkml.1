Return-Path: <linux-kernel-owner+w=401wt.eu-S1945896AbXCWOu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945896AbXCWOu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945908AbXCWOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:50:59 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:55853 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945896AbXCWOu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:50:57 -0400
Message-ID: <4603E85B.4030901@hitachi.com>
Date: Fri, 23 Mar 2007 23:46:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][Patch 3/4] jprobe fast unregisteration
References: <4603E7A4.50300@hitachi.com>
In-Reply-To: <4603E7A4.50300@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch introduces unregister_jprobe_fast() for jprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
 This patch introduces unregister_jprobe_fast() for jprobe.

 include/linux/kprobes.h |   12 +++++++++++-
 kernel/kprobes.c        |    6 ------
 2 files changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.21-rc4-mm1/include/linux/kprobes.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/include/linux/kprobes.h
+++ linux-2.6.21-rc4-mm1/include/linux/kprobes.h
@@ -198,7 +198,14 @@ void commit_kprobes(void);
 int setjmp_pre_handler(struct kprobe *, struct pt_regs *);
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
-void unregister_jprobe(struct jprobe *p);
+static inline void unregister_jprobe(struct jprobe *jp)
+{
+	unregister_kprobe(&jp->kp);
+}
+static inline void unregister_jprobe_fast(struct jprobe *jp)
+{
+	unregister_kprobe_fast(&jp->kp);
+}
 void jprobe_return(void);

 int register_kretprobe(struct kretprobe *rp);
@@ -242,6 +249,9 @@ static inline int register_jprobe(struct
 static inline void unregister_jprobe(struct jprobe *p)
 {
 }
+static inline void unregister_jprobe_fast(struct jprobe *p)
+{
+}
 static inline void jprobe_return(void)
 {
 }
Index: linux-2.6.21-rc4-mm1/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/kernel/kprobes.c
@@ -797,11 +797,6 @@ int __kprobes register_jprobe(struct jpr
 		(unsigned long)__builtin_return_address(0));
 }

-void __kprobes unregister_jprobe(struct jprobe *jp)
-{
-	unregister_kprobe(&jp->kp);
-}
-
 #ifdef ARCH_SUPPORTS_KRETPROBES

 /*
@@ -1013,6 +1008,5 @@ EXPORT_SYMBOL_GPL(unregister_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe_fast);
 EXPORT_SYMBOL_GPL(commit_kprobes);
 EXPORT_SYMBOL_GPL(register_jprobe);
-EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(jprobe_return);
 EXPORT_SYMBOL_GPL(register_kretprobe);

