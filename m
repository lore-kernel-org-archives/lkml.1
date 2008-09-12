Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYILNWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYILNWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYILNWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:22:08 -0400
Received: from rs02.intra2net.com ([81.169.173.116]:43217 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYILNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:22:07 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2008 09:22:06 EDT
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: linux-kernel@vger.kernel.org
Subject: RFC: [patch] log fatal signals like SIGSEGV
Date: Fri, 12 Sep 2008 15:02:14 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.25.14-108.fc9.i686; KDE/4.1.0; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121502.15264.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello together,

we've created a small patch that helped us troubleshoot obscure hardware
faults several times. Imagine someone calls and complains his box is
freezing from time to time. We usually check the logs and find various tasks
segfaulting between the freezes. Most of the time the hardware is broken.

Attached patch logs fatal signal like SIGSEGV or SIGBUS. It also features
a log flood protection, though I'm not sure if it works with dynamic ticks.
The code is a stripped down version of grsecurity's signal logger.

The patch doesn't have Kconfig support or other fancy stuff yet as I first
wanted to ask if it would make sense to integrate something like this
upstream. For us it made remote diagnosis a lot easier.

Please CC: comments.

Best regards,
Thomas Jarosch

--------------------------------------------------------
Log fatal signals like SIGSEGV or SIGBUS
to aid debugging of obscure problems.

The code is a stripped down version
of grsecurity's signal logger.

Signed-Off-By: Gerd v. Egidy <gve@intra2net.com>
Signed-Off-By: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -u -r -p linux-2.6.22/kernel/signal.c linux.siglog/kernel/signal.c
--- linux-2.6.22/kernel/signal.c	Mon Jul  9 01:32:17 2007
+++ linux.siglog/kernel/signal.c	Wed Aug 22 11:08:58 2007
@@ -514,6 +514,64 @@ static int rm_from_queue(unsigned long m
 }
 
 /*
+ * Stuff needed for signal logger
+ */
+
+spinlock_t siglog_lock = SPIN_LOCK_UNLOCKED;
+unsigned long volatile siglog_wtime = 0;
+unsigned long volatile siglog_fyet = 0;
+
+/* time span in which flooding is measured */
+#define SIGLOG_FLOOD_SECONDS 5
+
+/* how many log entries are allowed in this time span */
+#define SIGLOG_FLOOD_BURST_LINES 20
+
+/*
+ * Log fatal signals
+ */
+void
+log_fatal_signal(const int sig, const struct task_struct *t)
+{
+	if ((sig == SIGSEGV) || (sig == SIGILL) || (sig == SIGABRT)
+        || (sig == SIGBUS) || (sig == SIGKILL) || (sig == SIGFPE)) {
+
+		/* flood protection */
+		spin_lock(&siglog_lock);
+		if (!siglog_wtime || jiffies - siglog_wtime > SIGLOG_FLOOD_SECONDS * HZ) {
+			/* no logging activity yet */
+			siglog_wtime = jiffies;
+			siglog_fyet = 0;
+		} else if ((jiffies - siglog_wtime <= SIGLOG_FLOOD_SECONDS * HZ)
+                    && (siglog_fyet < SIGLOG_FLOOD_BURST_LINES)) {
+			/* logging within SIGLOG_FLOOD_SECONDS, but below threshold */
+			siglog_fyet++;
+		} else {
+			/* flooding detected, warn once and return */
+			if (siglog_fyet == SIGLOG_FLOOD_BURST_LINES) {
+				siglog_wtime = jiffies;
+				siglog_fyet++;
+				printk(KERN_ALERT "siglog: more alerts, logging disabled for"
+                       " %d seconds\n", SIGLOG_FLOOD_SECONDS);
+			}
+			spin_unlock(&siglog_lock);
+			return;
+		}
+		spin_unlock(&siglog_lock);
+
+		read_lock(&tasklist_lock);
+		printk(KERN_WARNING "signal %d sent to %.30s[%d] uid:%u, "
+               "parent %.30s[%d] uid:%u by %.30s[%d] uid:%u, "
+               "parent %.30s[%d] uid:%u\n", sig, t->comm, t->pid, t->uid,
+               t->parent->comm, t->parent->pid, t->parent->uid,
+               current->comm, current->pid, current->uid,
+               current->parent->comm, current->parent->pid, current->parent->uid);
+		read_unlock(&tasklist_lock);
+	}
+	return;
+}
+
+/*
  * Bad permissions for sending the signal
  */
 static int check_kill_permission(int sig, struct siginfo *info,
@@ -536,6 +594,8 @@ static int check_kill_permission(int sig
 	    && !capable(CAP_KILL))
 		return error;
 
+	log_fatal_signal(sig, t);
+
 	return security_task_kill(t, info, sig, 0);
 }
 
@@ -773,6 +833,9 @@ force_sig_info(int sig, struct siginfo *
 		}
 	}
 	ret = specific_send_sig_info(sig, info, t);
+
+	log_fatal_signal(sig, t);
+
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 
 	return ret;

