Return-Path: <linux-kernel-owner+w=401wt.eu-S969333AbXFHQHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969333AbXFHQHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969796AbXFHQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:07:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969397AbXFHQHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:07:23 -0400
Message-ID: <46697D23.4060506@redhat.com>
Date: Fri, 08 Jun 2007 18:00:35 +0200
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Steve Grubb <sgrubb@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH, v2] Audit: Add TTY input auditing
References: <4666832D.8080603@redhat.com>	<46668814.7080404@redhat.com>	<20070606174113.b7fc31da.akpm@linux-foundation.org>	<4668D9BB.3010600@redhat.com> <20070607233139.de85725f.akpm@linux-foundation.org>
In-Reply-To: <20070607233139.de85725f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/mixed;
 boundary="------------020800040505000203010604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020800040505000203010604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton napsal(a):
> On Fri, 08 Jun 2007 06:23:23 +0200 Miloslav Trmac <mitr@redhat.com> wrote:
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index d58e74b..d9d734c 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -506,6 +506,8 @@ struct signal_struct {
>>  #ifdef CONFIG_TASKSTATS
>>  	struct taskstats *stats;
>>  #endif
>> +	unsigned audit_tty;
>> +	struct tty_audit_buf *tty_audit_buf;
>>  };
> 
> Can we ifdef these?
Sure, here's an incremental patch.
	Mirek

--------------020800040505000203010604
Content-Type: text/x-patch;
 name="linux-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.patch"

From: Miloslav Trmac <mitr@redhat.com>

Only add TTY audit state to struct signal_struct if CONFIG_AUDIT.  Move the
copying of TTY audit state on fork () to tty_audit.c.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
---
 drivers/char/tty_audit.c |   13 +++++++++++++
 include/linux/sched.h    |    2 ++
 include/linux/tty.h      |    5 +++++
 kernel/exit.c            |    2 +-
 kernel/fork.c            |    6 ++----
 5 files changed, 23 insertions(+), 5 deletions(-)

diff -u b/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
--- b/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -134,6 +134,19 @@
 }
 
 /**
+ *	tty_audit_fork	-	Copy TTY audit state for a new task
+ *
+ *	Set up TTY audit state in @sig from current.  @sig needs no locking.
+ */
+void tty_audit_fork(struct signal_struct *sig)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	sig->audit_tty = current->signal->audit_tty;
+	spin_unlock_irq(&current->sighand->siglock);
+	sig->tty_audit_buf = NULL;
+}
+
+/**
  *	tty_audit_push_task	-	Flush task's pending audit data
  */
 void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
diff -u b/include/linux/sched.h b/include/linux/sched.h
--- b/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -506,8 +506,10 @@
 #ifdef CONFIG_TASKSTATS
 	struct taskstats *stats;
 #endif
+#ifdef CONFIG_AUDIT
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
+#endif
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff -u b/include/linux/tty.h b/include/linux/tty.h
--- b/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -178,6 +178,7 @@
 #define L_IEXTEN(tty)	_L_FLAG((tty),IEXTEN)
 
 struct device;
+struct signal_struct;
 /*
  * Where all of the state associated with a tty is kept while the tty
  * is open.  Since the termios state should be kept even if the tty
@@ -347,6 +348,7 @@
 extern void tty_audit_add_data(struct tty_struct *tty, unsigned char *data,
 			       size_t size);
 extern void tty_audit_exit(void);
+extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_push(struct tty_struct *tty);
 extern void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid);
 extern void tty_audit_opening(void);
@@ -358,6 +360,9 @@
 static inline void tty_audit_exit(void)
 {
 }
+static inline void tty_audit_fork(struct signal_struct *sig)
+{
+}
 static inline void tty_audit_push(struct tty_struct *tty)
 {
 }
diff -u b/kernel/exit.c b/kernel/exit.c
--- b/kernel/exit.c
+++ b/kernel/exit.c
@@ -922,7 +922,7 @@
 	if (unlikely(tsk->compat_robust_list))
 		compat_exit_robust_list(tsk);
 #endif
-	if (group_dead && unlikely(tsk->signal->tty_audit_buf))
+	if (group_dead)
 		tty_audit_exit();
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
diff -u b/kernel/fork.c b/kernel/fork.c
--- b/kernel/fork.c
+++ b/kernel/fork.c
@@ -49,6 +49,7 @@
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
+#include <linux/tty.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -897,10 +898,7 @@
 	}
 	acct_init_pacct(&sig->pacct);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sig->audit_tty = current->signal->audit_tty;
-	spin_unlock_irq(&current->sighand->siglock);
-	sig->tty_audit_buf = NULL;
+	tty_audit_fork(sig);
 
 	return 0;
 }

--------------020800040505000203010604--
