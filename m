Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbZFIKcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbZFIKcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbZFIKVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:08 -0400
Received: from kroah.org ([198.145.64.141]:55306 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760394AbZFIKVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:06 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:07 2009
Message-Id: <20090609094106.861813779@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 63/87] ptrace: kill __ptrace_detach(), fix ->exit_state check
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 95c3eb76dc07fd81289888ffc42948196b34b444 upstream.

Move the code from __ptrace_detach() to its single caller and kill this
helper.

Also, fix the ->exit_state check, we shouldn't wake up EXIT_DEAD tasks.
Actually, I think task_is_stopped_or_traced() makes more sense, but this
needs another patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/ptrace.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -235,16 +235,6 @@ out:
 	return retval;
 }
 
-static inline void __ptrace_detach(struct task_struct *child, unsigned int data)
-{
-	child->exit_code = data;
-	/* .. re-parent .. */
-	__ptrace_unlink(child);
-	/* .. and wake it up. */
-	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
-}
-
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
 	if (!valid_signal(data))
@@ -254,10 +244,16 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */
-	if (child->ptrace)
-		__ptrace_detach(child, data);
+	write_lock_irq(&tasklist_lock);
+	if (child->ptrace) {
+		child->exit_code = data;
+
+		__ptrace_unlink(child);
+
+		if (!child->exit_state)
+			wake_up_process(child);
+	}
 	write_unlock_irq(&tasklist_lock);
 
 	return 0;


