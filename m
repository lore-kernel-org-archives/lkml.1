Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZAFUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZAFUR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZAFUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:16:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZAFUQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:16:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
Date: Tue, 6 Jan 2009 21:15:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Cheng Renquan <crquan@gmail.com>
References: <200901062112.29227.rjw@sisk.pl>
In-Reply-To: <200901062112.29227.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062115.33286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.

This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
and CONFIG_FREEZER=n.

Reported-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/ia64/kernel/kprobes.c |    2 +-
 arch/x86/kernel/kprobes.c  |    2 +-
 kernel/kprobes.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/kprobes.c
+++ linux-2.6/arch/ia64/kernel/kprobes.c
@@ -868,7 +868,7 @@ static int __kprobes pre_kprobes_handler
 		return 1;
 
 ss_probe:
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
 	if (p->ainsn.inst_flag == INST_FLAG_BOOSTABLE && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		ia64_psr(regs)->ri = p->ainsn.slot;
Index: linux-2.6/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6/arch/x86/kernel/kprobes.c
@@ -445,7 +445,7 @@ void __kprobes arch_prepare_kretprobe(st
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 				       struct kprobe_ctlblk *kcb)
 {
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
Index: linux-2.6/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/kernel/kprobes.c
+++ linux-2.6/kernel/kprobes.c
@@ -122,7 +122,7 @@ static int collect_garbage_slots(void);
 static int __kprobes check_safety(void)
 {
 	int ret = 0;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
+#if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
 	ret = freeze_processes();
 	if (ret == 0) {
 		struct task_struct *p, *q;

