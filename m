Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab0BYVXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:23:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:63604 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857Ab0BYVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 26/28] kdb,debug_core: Allow the debug core to receive a panic notification
Date: Thu, 25 Feb 2010 15:21:31 -0600
Message-Id: <1267132893-23624-27-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:22:03.0602 (UTC) FILETIME=[93306B20:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is highly desirable to trap into kdb on panic.  The debug core will
attempt to register as the first in line for the panic notifier.

CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bfdba97..ed42d9e 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -754,11 +754,28 @@ static struct sysrq_key_op sysrq_dbg_op = {
 };
 #endif
 
+static int kgdb_panic_event(struct notifier_block *self,
+			    unsigned long val,
+			    void *data)
+{
+	if (dbg_kdb_mode)
+		kdb_printf("PANIC: %s\n", (char *)data);
+	kgdb_breakpoint();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kgdb_panic_event_nb = {
+       .notifier_call	= kgdb_panic_event,
+       .priority	= INT_MAX,
+};
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
 		kgdb_io_module_registered = 1;
 		kgdb_arch_init();
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
 		register_sysrq_key('g', &sysrq_dbg_op);
 #endif
@@ -778,6 +795,8 @@ static void kgdb_unregister_callbacks(void)
 	 */
 	if (kgdb_io_module_registered) {
 		kgdb_io_module_registered = 0;
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 		kgdb_arch_exit();
 #ifdef CONFIG_MAGIC_SYSRQ
 		unregister_sysrq_key('g', &sysrq_dbg_op);
-- 
1.6.4.rc1

