Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbYLYR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbYLYR1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLYR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:27:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:12727 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYLYR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:27:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Q6S2Rm/X/BucppL+scAWsw0YiUpfB41OG3Ya7OgcRYVOFIGlyfslAY2h+y5Jg/wpWr
         6pJWowPC230ZVhVAN+RNcUhXgWyfSnXnsde9CuBoVQVlG3z/f7BXltZSdGlE0SmHiNEn
         LLJ0K2tHt2LafAZG1N8Jj0r4fv/s8Ql7SRiFo=
Date: Fri, 26 Dec 2008 01:26:12 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [Patch] signal: let valid_signal() check more
Message-ID: <20081226012612.GI3130@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Teach valid_signal() to check sig > 0 case.

Tested on UML only.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>

---
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 8944ce5..e7568ff 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -727,7 +727,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	{
 		if (!perm || !capable(CAP_KILL))
 			goto eperm;
-		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
+		if (!valid_signal((int)arg) || arg == SIGKILL)
 			ret = -EINVAL;
 		else {
 			spin_lock_irq(&vt_spawn_con.lock);
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 549daf8..32c8677 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -313,11 +313,10 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		break;
 	case F_SETSIG:
 		/* arg == 0 restores default behaviour. */
-		if (!valid_signal(arg)) {
-			break;
+		if (arg == 0 || valid_signal((int)arg)) {
+			err = 0;
+			filp->f_owner.signum = arg;
 		}
-		err = 0;
-		filp->f_owner.signum = arg;
 		break;
 	case F_GETLEASE:
 		err = fcntl_getlease(filp);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 84f997f..cddf220 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -227,9 +227,9 @@ static inline void init_sigpending(struct sigpending *sig)
 extern void flush_sigqueue(struct sigpending *queue);
 
 /* Test if 'sig' is valid signal. Use this instead of testing _NSIG directly */
-static inline int valid_signal(unsigned long sig)
+static inline int valid_signal(int sig)
 {
-	return sig <= _NSIG ? 1 : 0;
+	return sig <= _NSIG ? (sig > 0) : 0;
 }
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..096beb5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -376,7 +376,7 @@ static void set_special_pids(struct pid *pid)
  */
 int allow_signal(int sig)
 {
-	if (!valid_signal(sig) || sig < 1)
+	if (!valid_signal(sig))
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
@@ -397,7 +397,7 @@ EXPORT_SYMBOL(allow_signal);
 
 int disallow_signal(int sig)
 {
-	if (!valid_signal(sig) || sig < 1)
+	if (!valid_signal(sig))
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 4c8bcd7..e8eb715 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -369,7 +369,7 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 
 static int ptrace_resume(struct task_struct *child, long request, long data)
 {
-	if (!valid_signal(data))
+	if (!valid_signal((int)data))
 		return -EIO;
 
 	if (request == PTRACE_SYSCALL)
diff --git a/kernel/signal.c b/kernel/signal.c
index 4530fc6..8355426 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1411,7 +1411,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = -1;
 	}
-	if (valid_signal(sig) && sig > 0)
+	if (valid_signal(sig))
 		__group_send_sig_info(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
@@ -2308,7 +2308,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	struct k_sigaction *k;
 	sigset_t mask;
 
-	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
+	if (!valid_signal(sig) || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
 	k = &t->sighand->action[sig-1];
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..06dc092 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1631,7 +1631,7 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 
 	switch (option) {
 		case PR_SET_PDEATHSIG:
-			if (!valid_signal(arg2)) {
+			if (!valid_signal((int)arg2)) {
 				error = -EINVAL;
 				break;
 			}
