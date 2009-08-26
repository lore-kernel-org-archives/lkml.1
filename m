Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZHZUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZHZUFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZHZUFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:05:50 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:1610 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994AbZHZUFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:05:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] console_print: change the function api to make it have printk style interface
Date: Wed, 26 Aug 2009 13:05:49 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA93B4@exchange.ZeugmaSystems.local>
In-Reply-To: <20090825172640.af8b9f58.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] console_print: change the function api to make it have printk style interface
Thread-Index: Acol61Wv9pzeGLJmRyKT+GOTgBg5pwAnEHXQ
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <20090825172640.af8b9f58.randy.dunlap@oracle.com>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>Make that prototype be like printk, with the __attribute__ ((format
>(printf, 1, 2))):
>
>
>int printk(const char * fmt, ...)
>	__attribute__ ((format (printf, 1, 2)));
>
>
>

Thanks Randy. These are all very nice comments on the patch. However, I
do think that having a full blown C function is a overkill for such a
thing (except for the case which Linus has already pointed out - use
from assembly code). At the very least we should make it a macro if we
at all decide to keep the interface. I am also completely ok to remove
the interface altogether. The arcs that need that sort of function can
then implement an appropriate version (macro vs proper C function)
locally for it's use.

Since Linus has already agreed for the later, I will post a patch here
to remove the function. I am not very certain as to what we should do
about the only one single case of its genuine use - call from
ia64/head.S. What I have done is one solution. Please feel free to
debate/disagree.

Cheers,

Ani


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
arch/ia64/kernel/head.S    |    1 +
arch/ia64/kernel/head.h    |    1 +
arch/ia64/kernel/process.c |    7 +++++++
drivers/char/serial167.c   |    5 ++---
include/linux/dtlk.h       |    6 +++---
include/linux/tty.h        |    4 ----
kernel/printk.c            |    6 ------
7 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 23f846d..e6c5c3d 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -34,6 +34,7 @@
 #include <asm/mca_asm.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include "head.h"
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define SAL_PSR_BITS_TO_SET				\
diff --git a/arch/ia64/kernel/head.h b/arch/ia64/kernel/head.h
new file mode 100644
index 0000000..2e2ac68
--- /dev/null
+++ b/arch/ia64/kernel/head.h
@@ -0,0 +1 @@
+extern void console_print(const char *s);
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 5d7c0e5..c2bb591 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -161,6 +161,13 @@ show_regs (struct pt_regs *regs)
 		show_stack(NULL, NULL);
 }
 
+/* local support for deprecated console_print */
+void 
+console_print(const char *s)
+{
+	printk(KERN_EMERG "%s", s);
+}
+
 void
 do_notify_resume_user(sigset_t *unused, struct sigscratch *scr, long
in_syscall)
 {
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 51e7a46..5942a9d 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -171,7 +171,6 @@ static int startup(struct cyclades_port *);
 static void cy_throttle(struct tty_struct *);
 static void cy_unthrottle(struct tty_struct *);
 static void config_setup(struct cyclades_port *);
-extern void console_print(const char *);
 #ifdef CYCLOM_SHOW_STATUS
 static void show_status(int);
 #endif
@@ -245,7 +244,7 @@ void SP(char *data)
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	console_print(data);
+	printk(KERN_EMERG "%s", data);
 	local_irq_restore(flags);
 }
 
@@ -255,7 +254,7 @@ void CP(char data)
 	unsigned long flags;
 	local_irq_save(flags);
 	scrn[0] = data;
-	console_print(scrn);
+	printk(KERN_EMERG "%c", scrn);
 	local_irq_restore(flags);
 }				/* CP */
 
diff --git a/include/linux/dtlk.h b/include/linux/dtlk.h
index 2896d90..4f93c45 100644
--- a/include/linux/dtlk.h
+++ b/include/linux/dtlk.h
@@ -4,15 +4,15 @@
 	{ \
 	  if(dtlk_trace) \
 	  { \
-	    console_print(text); \
-	    console_print("\n"); \
+	    printk(KERN_EMERG "%s", text);	\
+	    printk(KERN_EMERG "\n");		\
 	  } \
 	}
 
 #define TRACE_CHR(chr) \
 	{ \
 	  if(dtlk_trace) \
-	    console_print(chr); \
+	    printk(KERN_EMERG "%c", chr); \
 	} \
 
 #endif
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e8c6c91..ba191e3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -517,10 +517,6 @@ extern void serial_console_init(void);
 
 extern int pcxe_open(struct tty_struct *tty, struct file *filp);
 
-/* printk.c */
-
-extern void console_print(const char *);
-
 /* vt.c */
 
 extern int vt_ioctl(struct tty_struct *tty, struct file *file,
diff --git a/kernel/printk.c b/kernel/printk.c
index b4d97b5..32e15ce 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1060,12 +1060,6 @@ void __sched console_conditional_schedule(void)
 }
 EXPORT_SYMBOL(console_conditional_schedule);
 
-void console_print(const char *s)
-{
-	printk(KERN_EMERG "%s", s);
-}
-EXPORT_SYMBOL(console_print);
-
 void console_unblank(void)
 {
 	struct console *c;

