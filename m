Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYIPN12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYIPN12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYIPN1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:27:20 -0400
Received: from re01.intra2net.com ([82.165.28.202]:57259 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYIPN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:27:19 -0400
X-Greylist: delayed 1678 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 09:27:19 EDT
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: [patch] log fatal signals like SIGSEGV
Date: Tue, 16 Sep 2008 14:59:16 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.25.14-108.fc9.i686; KDE/4.1.1; i686; ; )
References: <200809121502.15264.thomas.jarosch@intra2net.com> <20080912171055.GA5532@joi>
In-Reply-To: <20080912171055.GA5532@joi>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161459.17750.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12. September 2008 19:11:09 Marcin Slusarz wrote:
> Note that on current kernel when process segfaults it printks:
> a.out[5974]: segfault at 0 ip 00000000004004c1 sp 00007fffdd1a3ce0 error 6
> in a.out[400000+1000]

Thank you for your feedback Marcin, it was really helpful.

The log message above is a good start. There's also the
"print-fatal-signals" kernel parameter which prints out
much more than just the basic info:

 =======================
sleep/3277: potentially unexpected fatal signal 11.
code at 001b7571: 89 d3 3d 01 f0 ff ff 73 01 c3 53 e8 00 00 00 00

Pid: 3277, comm: sleep Not tainted (2.6.26-2.i2nsmp #7)
EIP: 0073:[<001b7571>] EFLAGS: 00000246 CPU: 0
EIP is at 0x1b7571
EAX: fffffdfc EBX: bffae0d4 ECX: bffae0d4 EDX: 00215c80
ESI: bffae0d4 EDI: bffae1e8 EBP: bffae268 ESP: bffae0a0
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 007b
CR0: 8005003b CR2: b7fbf55c CR3: 369db000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 =======================

This is way too much information to leave it on all the time.

The new code just adds one line of information to the log
and is rate limited. The idea is to aid troubleshooting
later on by looking through the logs. I guess you'll
hardly notice it during normal system operation.

> Please look at Documentation/SubmittingPatches.
> (Signed-off-by capitalization and lack of (?) From field)

scripts/checkpatch.pl is happy now :-)

I've reworked the locking using CONFIG_LOCKDEP and ran  

while /bin/true; do
  sleep 10 &
  kill -9 $!
done

for over twenty minutes with no noticable issue.
The printk_ratelimit() works perfect.

Here's the new version:
-----------------------------------------------------------------
From: Thomas Jarosch <thomas.jarosch@intra2net.com>

Log the signals SIGSEGV, SIGILL, SIGABRT, SIGBUS, SIGKILL and SIGFPE
to aid debugging of obscure problems. Also logs the sender of the signal.

The log message looks like this:
"kernel: signal 9 sent to freezed[2634] uid:100,
 parent init[1] uid:0 by bash[3168] uid:0, parent sshd[3164] uid:0"

The printing code is based on grsecurity's signal logger.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Gerd v. Egidy <gve@intra2net.com>

diff -u -r -p linux-2.6.26.vanilla/kernel/signal.c linux-2.6.26/kernel/signal.c
--- linux-2.6.26.vanilla/kernel/signal.c	Tue Sep 16 13:45:34 2008
+++ linux-2.6.26/kernel/signal.c	Tue Sep 16 14:02:54 2008
@@ -801,6 +801,24 @@ static inline int legacy_queue(struct si
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
+static void log_signal_and_sender(const int sig, const struct task_struct *t)
+{
+	if (!((sig == SIGSEGV) || (sig == SIGILL) || (sig == SIGABRT)
+		|| (sig == SIGBUS) || (sig == SIGKILL) || (sig == SIGFPE)))
+			return;
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
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group)
 {
@@ -810,6 +828,8 @@ static int send_signal(int sig, struct s
 	assert_spin_locked(&t->sighand->siglock);
 	if (!prepare_signal(sig, t))
 		return 0;
+
+	log_signal_and_sender(sig, t);
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*

