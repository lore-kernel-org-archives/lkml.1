Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbXJ0OTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbXJ0OTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXJ0OSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:18:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56341 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755946AbXJ0OSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:18:53 -0400
Date: Sat, 27 Oct 2007 16:19:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kprobe_exceptions_notify(): fix NULL dereference
Message-ID: <20071027141914.GW30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes later NULL dereferences spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

BTW: The avr32 and s390 versions of kprobe_exceptions_notify() are
     not touched since they don't contain this check.

 arch/ia64/kernel/kprobes.c    |    2 +-
 arch/powerpc/kernel/kprobes.c |    2 +-
 arch/sparc64/kernel/kprobes.c |    2 +-
 arch/x86/kernel/kprobes_32.c  |    2 +-
 arch/x86/kernel/kprobes_64.c  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

b6f1241ee20dd22210f48b4100bc5055315f3808 
diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 5fd65d8..3663dfb 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -886,11 +886,11 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
-	if (args->regs && user_mode(args->regs))
+	if (args->regs || user_mode(args->regs))
 		return ret;
 
 	switch(val) {
 	case DIE_BREAK:
 		/* err is break number from ia64_bad_break() */
diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 5338e48..913f9cd 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -474,11 +474,11 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
-	if (args->regs && user_mode(args->regs))
+	if (args->regs || user_mode(args->regs))
 		return ret;
 
 	switch (val) {
 	case DIE_BPT:
 		if (kprobe_handler(args->regs))
diff --git a/arch/sparc64/kernel/kprobes.c b/arch/sparc64/kernel/kprobes.c
index d94f901..73372b2 100644
--- a/arch/sparc64/kernel/kprobes.c
+++ b/arch/sparc64/kernel/kprobes.c
@@ -391,11 +391,11 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
-	if (args->regs && user_mode(args->regs))
+	if (args->regs || user_mode(args->regs))
 		return ret;
 
 	switch (val) {
 	case DIE_DEBUG:
 		if (kprobe_handler(args->regs))
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 90f778c..fb5145e 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -658,11 +658,11 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
-	if (args->regs && user_mode_vm(args->regs))
+	if (args->regs || user_mode_vm(args->regs))
 		return ret;
 
 	switch (val) {
 	case DIE_INT3:
 		if (kprobe_handler(args->regs))
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 681b801..67b0585 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -649,11 +649,11 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
-	if (args->regs && user_mode(args->regs))
+	if (args->regs || user_mode(args->regs))
 		return ret;
 
 	switch (val) {
 	case DIE_INT3:
 		if (kprobe_handler(args->regs))


