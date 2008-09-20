Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYITRMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYITRMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYITRMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 13:12:06 -0400
Received: from re01.intra2net.com ([82.165.28.202]:42022 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYITRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 13:12:05 -0400
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: linux-kernel@vger.kernel.org
Subject: [patch] log fatal signals like SIGSEGV
Date: Sat, 20 Sep 2008 19:12:39 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.25.14-108.fc9.i686; KDE/4.1.1; i686; ; )
References: <200809121502.15264.thomas.jarosch@intra2net.com> <200809181210.40336.thomas.jarosch@intra2net.com> <20080918202010.GA5656@joi>
In-Reply-To: <20080918202010.GA5656@joi>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809201912.40381.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello together,

here's the reworked version of the signal logging patch.
Many thanks to Marcin Slusarz for reviewing it. 

The idea is to briefly log "fatal" signals by default, the output
should be close to zero during normal system operation.
Faulty hardware gets detected much quicker
if you see crashing apps in the logs.

The patch applies to 2.6.26 and git HEAD.
scripts/checkpatch.pl is happy, too.

I'm off for a vacation, so expect a delay of some days
if there should be additional questions or comments.

Hope the new feature is as useful to others as it has been to me.

Enjoy,
Thomas

------------------------------------------------------
From: Thomas Jarosch <thomas.jarosch@intra2net.com>

Log signals like SIGSEGV, SIGILL, SIGBUS or SIGFPE to aid tracing
of obscure problems. Also logs the sender of the signal.

The log message looks like this:
"kernel: signal 9 sent to freezed[2634] uid:100,
 parent init[1] uid:0 by bash[3168] uid:0, parent sshd[3164] uid:0"

You can control the degree of logging via sysctl: "signal-log-level"
    0 - Signal logging disabled
    1 - Log SIGSEGV, SIGILL, SIGBUS and SIGFPE (default)
    2 - Log SIGKILL and SIGABRT and all signals from log level 1
    3 or higher: Log all signals

The printing code is based on grsecurity's signal logger.

Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Gerd v. Egidy <gve@intra2net.com>
------------------------------------------------------
diff -u -r -p linux-2.6.26.vanilla/kernel/signal.c linux-2.6.26/kernel/signal.c
--- linux-2.6.26.vanilla/kernel/signal.c	Tue Sep 16 13:45:34 2008
+++ linux-2.6.26/kernel/signal.c	Thu Sep 18 10:43:27 2008
@@ -796,6 +796,35 @@ static void complete_signal(int sig, str
 	return;
 }
 
+int signal_log_level __read_mostly = 1;
+
+static void log_signal(const int sig, const struct task_struct *t)
+{
+	bool log_signal = false;
+
+	if (signal_log_level >= 1 && (sig == SIGSEGV || sig == SIGILL
+			|| sig == SIGBUS || sig == SIGFPE))
+		log_signal = true;
+	else if (signal_log_level >= 2 && (sig == SIGKILL || sig == SIGABRT))
+		log_signal = true;
+	else if (signal_log_level >= 3)
+		log_signal = true;
+
+	if (!log_signal)
+		return;
+
+	if (printk_ratelimit()) {
+		/* Note: tasklist_lock is already locked by siglock */
+		printk(KERN_WARNING "signal %d sent to %.30s[%d] uid:%u, "
+				"parent %.30s[%d] uid:%u by %.30s[%d] uid:%u, "
+				"parent %.30s[%d] uid:%u\n", sig, t->comm,
+				t->pid, t->uid, t->parent->comm, t->parent->pid,
+				t->parent->uid, current->comm, current->pid,
+				current->uid, current->parent->comm,
+				current->parent->pid, current->parent->uid);
+	}
+}
+
 static inline int legacy_queue(struct sigpending *signals, int sig)
 {
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
@@ -810,6 +839,8 @@ static int send_signal(int sig, struct s
 	assert_spin_locked(&t->sighand->siglock);
 	if (!prepare_signal(sig, t))
 		return 0;
+
+	log_signal(sig, t);
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
diff -u -r -p linux-2.6.26.vanilla/kernel/sysctl.c linux-2.6.26/kernel/sysctl.c
--- linux-2.6.26.vanilla/kernel/sysctl.c	Sun Jul 13 23:51:29 2008
+++ linux-2.6.26/kernel/sysctl.c	Thu Sep 18 10:08:47 2008
@@ -63,6 +63,7 @@ static int deprecated_sysctl_warning(str
 /* External variables not in a header file. */
 extern int C_A_D;
 extern int print_fatal_signals;
+extern int signal_log_level;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
@@ -398,6 +428,14 @@ static struct ctl_table kern_table[] = {
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "print-fatal-signals",
 		.data		= &print_fatal_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "signal-log-level",
+		.data		= &signal_log_level,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
diff -u -r linux-2.6.26.vanilla/Documentation/sysctl/kernel.txt linux-2.6.26/Documentation/sysctl/kernel.txt
--- linux-2.6.26.vanilla/Documentation/sysctl/kernel.txt	Sun Jul 13 23:51:29 2008
+++ linux-2.6.26/Documentation/sysctl/kernel.txt	Thu Sep 18 10:50:13 2008
@@ -47,6 +47,7 @@
 - rtsig-max
 - rtsig-nr
 - sem
+- signal-log-level
 - sg-big-buff                 [ generic SCSI device (sg) ]
 - shmall
 - shmmax                      [ sysv ipc ]
@@ -349,6 +350,21 @@
 
 ==============================================================
 
+signal-log-level:
+
+Brief logging of signal and sender to aid
+tracing of obscure problems later on.
+
+  0 - Signal logging disabled
+
+  1 - Log SIGSEGV, SIGILL, SIGBUS and SIGFPE (default)
+
+  2 - Log SIGKILL and SIGABRT and all signals from log level 1
+
+  3 or higher: Log all signals
+
+==============================================================
+
 softlockup_thresh:
 
 This value can be used to lower the softlockup tolerance

