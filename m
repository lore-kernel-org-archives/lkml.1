Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbYBFMP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbYBFMP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762257AbYBFMPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:15:49 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:24589 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762222AbYBFMPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:15:49 -0500
Message-ID: <47A9A4D5.4030200@siemens.com>
Date: Wed, 06 Feb 2008 13:15:17 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] beautification of debugger_active usage
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a beautification of using debugger_active for checking the debugger
state.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

---
 arch/x86/kernel/kgdb.c |    6 +++---
 include/linux/kgdb.h   |    7 ++++++-
 kernel/kgdb.c          |    8 ++++----
 kernel/sched.c         |    7 +------
 4 files changed, 14 insertions(+), 14 deletions(-)

Index: b/arch/x86/kernel/kgdb.c
===================================================================
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -442,14 +442,14 @@ static int kgdb_notify(struct notifier_b
 
 	switch (cmd) {
 	case DIE_NMI:
-		if (atomic_read(&debugger_active)) {
+		if (kgdb_active()) {
 			/* KGDB CPU roundup */
 			kgdb_nmihook(raw_smp_processor_id(), regs);
 			return NOTIFY_STOP;
 		}
 		return NOTIFY_DONE;
 	case DIE_NMI_IPI:
-		if (atomic_read(&debugger_active)) {
+		if (kgdb_active()) {
 			/* KGDB CPU roundup */
 			if (kgdb_nmihook(raw_smp_processor_id(), regs))
 				return NOTIFY_DONE;
@@ -457,7 +457,7 @@ static int kgdb_notify(struct notifier_b
 		}
 		return NOTIFY_DONE;
 	case DIE_NMIWATCHDOG:
-		if (atomic_read(&debugger_active)) {
+		if (kgdb_active()) {
 			/* KGDB CPU roundup */
 			kgdb_nmihook(raw_smp_processor_id(), regs);
 			return NOTIFY_STOP;
Index: b/include/linux/kgdb.h
===================================================================
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -285,8 +285,13 @@ int kgdb_nmihook(int cpu, void *regs);
 extern int		debugger_step;
 extern atomic_t		debugger_active;
 
+static inline int kgdb_active(void)
+{
+	return (atomic_read(&debugger_active) != 0);
+}
+
 #else /* !CONFIG_KGDB */
-static const atomic_t	debugger_active = ATOMIC_INIT(0);
+#define kgdb_active()		0
 #endif /* !CONFIG_KGDB */
 
 #endif /* _KGDB_H_ */
Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -774,7 +774,7 @@ static void kgdb_wait(struct pt_regs *re
 	 * gaurd in case the master CPU had not been selected if
 	 * this was an entry via nmi.
 	 */
-	while (!atomic_read(&debugger_active))
+	while (!kgdb_active())
 		cpu_relax();
 
 	/* Wait till master CPU goes completely into the debugger. */
@@ -1901,7 +1901,7 @@ int kgdb_nmihook(int cpu, void *regs)
 static int
 kgdb_panic_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
 {
-	if (atomic_read(&debugger_active) != 0) {
+	if (kgdb_active()) {
 		printk(KERN_ERR "KGDB: Cannot handle panic while"
 				"debugger active\n");
 		dump_stack();
@@ -1923,7 +1923,7 @@ void kgdb_console_write(struct console *
 
 	/* If we're debugging, or KGDB has not connected, don't try
 	 * and print. */
-	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
+	if (!kgdb_connected || kgdb_active())
 		return;
 
 	local_irq_save(flags);
@@ -2104,7 +2104,7 @@ kgdb_notify_reboot(struct notifier_block
 	 * If we're debugging, or KGDB has not connected, don't try
 	 * and print:
 	 */
-	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
+	if (!kgdb_connected || kgdb_active())
 		return 0;
 
 	if (code == SYS_RESTART || code == SYS_HALT || code == SYS_POWER_OFF) {
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7264,12 +7264,7 @@ void __might_sleep(char *file, int line)
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
-#ifdef CONFIG_KGDB
-	if (atomic_read(&debugger_active))
-		return;
-#endif
-
-	if ((in_atomic() || irqs_disabled()) &&
+	if ((in_atomic() || irqs_disabled()) && !kgdb_active() &&
 	    system_state == SYSTEM_RUNNING && !oops_in_progress) {
 		if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 			return;
