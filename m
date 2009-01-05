Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZAEWL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZAEWL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZAEWLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:11:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49643 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZAEWLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:11:47 -0500
Message-ID: <49628574.20401@redhat.com>
Date: Mon, 05 Jan 2009 17:11:00 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: =?UTF-8?B?IkNoZW5nIFJlbnF1YW4gKOeoi+S7u+WFqCki?= <crquan@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Matt Helsley <matthltc@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
References: <91b13c310901042312o44afa166t66b23e8ad10d104f@mail.gmail.com> <200901051416.04816.rjw@sisk.pl>
In-Reply-To: <200901051416.04816.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rafael J. Wysocki wrote:
> On Monday 05 January 2009, Cheng Renquan (程任全) wrote:
>> 1. "check_safety" in "kernel/kprobes.c" call thaw_processes if both
>> CONFIG_PREEMPT and CONFIG_PM defined,
>> 2. "thaw_processes" function is implemented in "kernel/power/process.c",
>> 3. but it is only used if CONFIG_FREEZER defined, from <linux/freezer.h>,
>> 4. else (CONFIG_FREEZER undefined) it's a null macro defined in
>> <linux/freezer.h>,
>> 5. but process.o only get compile if CONFIG_PM_SLEEP defined, from
>> "kernel/power/Makefile",
>>
>> Now I'm confused on how to resolve this?
> 
> I'd make process.o depend on CONFIG_FREEZER (patch below).

Thank you for fixing.
In addition, I think that kprobes also should check CONFIG_FREEZER
instead of CONFIG_PM.
---
From: Masami Hiramatsu <mhiramat@redhat.com>

Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.

This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
and CONFIG_FREEZER=n.

Reported-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/ia64/kernel/kprobes.c |    2 +-
 arch/x86/kernel/kprobes.c  |    2 +-
 kernel/kprobes.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: 2.6.28/arch/ia64/kernel/kprobes.c
===================================================================
--- 2.6.28.orig/arch/ia64/kernel/kprobes.c
+++ 2.6.28/arch/ia64/kernel/kprobes.c
@@ -868,7 +868,7 @@ static int __kprobes pre_kprobes_handler
 		return 1;

 ss_probe:
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
 	if (p->ainsn.inst_flag == INST_FLAG_BOOSTABLE && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		ia64_psr(regs)->ri = p->ainsn.slot;
Index: 2.6.28/arch/x86/kernel/kprobes.c
===================================================================
--- 2.6.28.orig/arch/x86/kernel/kprobes.c
+++ 2.6.28/arch/x86/kernel/kprobes.c
@@ -445,7 +445,7 @@ void __kprobes arch_prepare_kretprobe(st
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 				       struct kprobe_ctlblk *kcb)
 {
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_FREEZER)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
Index: 2.6.28/kernel/kprobes.c
===================================================================
--- 2.6.28.orig/kernel/kprobes.c
+++ 2.6.28/kernel/kprobes.c
@@ -122,7 +122,7 @@ static int collect_garbage_slots(void);
 static int __kprobes check_safety(void)
 {
 	int ret = 0;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
+#if defined(CONFIG_PREEMPT) && defined(CONFIG_FREEZER)
 	ret = freeze_processes();
 	if (ret == 0) {
 		struct task_struct *p, *q;



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


