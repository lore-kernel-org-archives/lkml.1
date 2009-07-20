Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZGTMpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZGTMpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZGTMpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:45:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZGTMpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:45:18 -0400
Message-ID: <4A64672E.8020005@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 20:46:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c handler"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) This fix breaks our tools.
      This fix changes the ABI. panic_on_oops is default 0,
   and a lots system do not specify the boot option "panic",
   thus, Sysrq-c will not cause CrashDump(Kdump) as expected.

2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
   command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
   But this fix makes it a valid command and let it do a
   hazard thing: cause a page fault(NULL dereference) in kernel.

So, we revert this fix.

|commit d6580a9f15238b87e618310c862231ae3f352d2d
|Author: Neil Horman <nhorman@tuxdriver.com>
|Date:   Wed Jun 17 16:28:17 2009 -0700

|    kexec: sysrq: simplify sysrq-c handler

|    Currently the sysrq-c handler is bit over-engineered.  Its behavior is
|    dependent on a few compile time and run time factors that alter its
|    behavior which is really unnecessecary.

|    If CONFIG_KEXEC is not configured, sysrq-c, crashes the system with a NULL
|    pointer dereference.  If CONFIG_KEXEC is configured, it calls crash_kexec
|    directly, which implies that the kexec kernel will either be booted (if
|    its been previously loaded), or it will simply do nothing (the no kexec
|    kernel has been loaded).

|    It would be much easier to just simplify the whole thing to dereference a
|    NULL pointer all the time regardless of configuration.  That way, it will
|    always try to crash the system, and if a kexec kernel has been loaded into
|    reserved space, it will still boot from the page fault trap handler
|    (assuming panic_on_oops is set appropriately).


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 0db3585..39a05b5 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -121,17 +121,20 @@ static struct sysrq_key_op sysrq_unraw_op = {
 #define sysrq_unraw_op (*(struct sysrq_key_op *)0)
 #endif /* CONFIG_VT */
 
-static void sysrq_handle_crash(int key, struct tty_struct *tty)
+#ifdef CONFIG_KEXEC
+static void sysrq_handle_crashdump(int key, struct tty_struct *tty)
 {
-	char *killer = NULL;
-	*killer = 1;
+	crash_kexec(get_irq_regs());
 }
 static struct sysrq_key_op sysrq_crashdump_op = {
-	.handler	= sysrq_handle_crash,
-	.help_msg	= "Crash",
-	.action_msg	= "Trigger a crash",
+	.handler	= sysrq_handle_crashdump,
+	.help_msg	= "Crashdump",
+	.action_msg	= "Trigger a crashdump",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
+#else
+#define sysrq_crashdump_op (*(struct sysrq_key_op *)0)
+#endif
 
 static void sysrq_handle_reboot(int key, struct tty_struct *tty)
 {



   

