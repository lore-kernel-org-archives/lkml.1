Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZFQTxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZFQTxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZFQTxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:53:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZFQTxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:53:22 -0400
Date: Wed, 17 Jun 2009 21:48:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [rfc] ptrace: wait_task_zombie: fix the racy EXIT_ZOMBIE setting
Message-ID: <20090617194813.GA26428@redhat.com>
References: <20090615212648.GA22751@redhat.com> <20090616004510.2885FFC3D3@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616004510.2885FFC3D3@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't try to test this patch, just for early review. I think we need
a helper or two for "if (noreap)" branches.

>From now EXIT_DEAD really means the task is dead and should be ignored.
Fixes the race with ->real_parent doing do_wait().


Problem: if we untrace but do not set EXIT_DEAD, ->real_parent can release
the task before getrusage(). In that case k_getrusage() silently fails, and
we fill ->wo_rusage with zeros.

Do you see any solution? Or can we ignore this minor (I think) problem?

On 06/15, Roland McGrath wrote:
>
> ACK, but I think it warrants a comment explaining that task_detached() here
> always means "ptrace'd but not reparented".

Yes. And the name of "int traced" is very bad and confusing.

But I am wondering, shouldn't we always untrace the traced chils, regardless
of ptrace_reparented() ? This looks more clean to me.

Oleg.

--- PTRACE/kernel/exit.c~3_ZOMBIE_DEAD	2009-06-15 23:06:45.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-06-17 21:24:23.000000000 +0200
@@ -1153,7 +1153,7 @@ static int wait_noreap_copyout(struct wa
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
 	unsigned long state;
-	int retval, status, traced;
+	int retval, status, noreap;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
 	struct siginfo __user *infop;
@@ -1161,11 +1161,12 @@ static int wait_task_zombie(struct wait_
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
 
+	get_task_struct(p);
+
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
 		int why, status;
 
-		get_task_struct(p);
 		read_unlock(&tasklist_lock);
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
@@ -1177,84 +1178,105 @@ static int wait_task_zombie(struct wait_
 		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
 
-	/*
-	 * Try to move the task's state to DEAD
-	 * only one thread is allowed to do this:
-	 */
-	state = xchg(&p->exit_state, EXIT_DEAD);
-	if (state != EXIT_ZOMBIE) {
-		BUG_ON(state != EXIT_DEAD);
-		return 0;
-	}
-
-	traced = ptrace_reparented(p);
+	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+		? p->signal->group_exit_code : p->exit_code;
 
-	if (likely(!traced) && likely(!task_detached(p))) {
-		struct signal_struct *psig;
-		struct signal_struct *sig;
+	noreap = ptrace_reparented(p);
+	if (unlikely(noreap)) {
+		read_unlock(&tasklist_lock);
 
+		retval = -EAGAIN;
+		write_lock_irq(&tasklist_lock);
+		if (task_ptrace(p)) {
+			BUG_ON(p->exit_state != EXIT_ZOMBIE);
+			__ptrace_unlink(p);
+			/*
+			 * If this is not a detached task, notify the parent.
+			 * If it's still not detached after that, don't release
+			 * it now.
+			 */
+			if (!task_detached(p))
+				do_notify_parent(p, p->exit_signal);
+			if (task_detached(p)) {
+				p->exit_state = EXIT_DEAD;
+				noreap = 0;
+			}
+			retval = 0;
+		}
+		write_unlock_irq(&tasklist_lock);
+		if (unlikely(retval))
+			goto out;
+	} else {
 		/*
-		 * The resource counters for the group leader are in its
-		 * own task_struct.  Those for dead threads in the group
-		 * are in its signal_struct, as are those for the child
-		 * processes it has previously reaped.  All these
-		 * accumulate in the parent's signal_struct c* fields.
-		 *
-		 * We don't bother to take a lock here to protect these
-		 * p->signal fields, because they are only touched by
-		 * __exit_signal, which runs with tasklist_lock
-		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to parent->signal fields,
-		 * as other threads in the parent group can be right
-		 * here reaping other children at the same time.
+		 * Try to move the task's state to DEAD
+		 * only one thread is allowed to do this:
 		 */
-		spin_lock_irq(&p->real_parent->sighand->siglock);
-		psig = p->real_parent->signal;
-		sig = p->signal;
-		psig->cutime =
-			cputime_add(psig->cutime,
-			cputime_add(p->utime,
-			cputime_add(sig->utime,
-				    sig->cutime)));
-		psig->cstime =
-			cputime_add(psig->cstime,
-			cputime_add(p->stime,
-			cputime_add(sig->stime,
-				    sig->cstime)));
-		psig->cgtime =
-			cputime_add(psig->cgtime,
-			cputime_add(p->gtime,
-			cputime_add(sig->gtime,
-				    sig->cgtime)));
-		psig->cmin_flt +=
-			p->min_flt + sig->min_flt + sig->cmin_flt;
-		psig->cmaj_flt +=
-			p->maj_flt + sig->maj_flt + sig->cmaj_flt;
-		psig->cnvcsw +=
-			p->nvcsw + sig->nvcsw + sig->cnvcsw;
-		psig->cnivcsw +=
-			p->nivcsw + sig->nivcsw + sig->cnivcsw;
-		psig->cinblock +=
-			task_io_get_inblock(p) +
-			sig->inblock + sig->cinblock;
-		psig->coublock +=
-			task_io_get_oublock(p) +
-			sig->oublock + sig->coublock;
-		task_io_accounting_add(&psig->ioac, &p->ioac);
-		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		spin_unlock_irq(&p->real_parent->sighand->siglock);
-	}
+		state = xchg(&p->exit_state, EXIT_DEAD);
+		if (unlikely(state != EXIT_ZOMBIE)) {
+			BUG_ON(state != EXIT_DEAD);
+			goto out;
+		}
 
-	/*
-	 * Now we are sure this task is interesting, and no other
-	 * thread can reap it because we set its state to EXIT_DEAD.
-	 */
-	read_unlock(&tasklist_lock);
+		if (likely(!task_detached(p))) {
+			struct signal_struct *psig;
+			struct signal_struct *sig;
+
+			/*
+			 * The resource counters for the group leader are in its
+			 * own task_struct.  Those for dead threads in the group
+			 * are in its signal_struct, as are those for the child
+			 * processes it has previously reaped.  All these
+			 * accumulate in the parent's signal_struct c* fields.
+			 *
+			 * We don't bother to take a lock here to protect these
+			 * p->signal fields, because they are only touched by
+			 * __exit_signal, which runs with tasklist_lock
+			 * write-locked anyway, and so is excluded here.  We do
+			 * need to protect the access to parent->signal fields,
+			 * as other threads in the parent group can be right
+			 * here reaping other children at the same time.
+			 */
+			spin_lock_irq(&p->real_parent->sighand->siglock);
+			psig = p->real_parent->signal;
+			sig = p->signal;
+			psig->cutime =
+				cputime_add(psig->cutime,
+				cputime_add(p->utime,
+				cputime_add(sig->utime,
+					    sig->cutime)));
+			psig->cstime =
+				cputime_add(psig->cstime,
+				cputime_add(p->stime,
+				cputime_add(sig->stime,
+					    sig->cstime)));
+			psig->cgtime =
+				cputime_add(psig->cgtime,
+				cputime_add(p->gtime,
+				cputime_add(sig->gtime,
+					    sig->cgtime)));
+			psig->cmin_flt +=
+				p->min_flt + sig->min_flt + sig->cmin_flt;
+			psig->cmaj_flt +=
+				p->maj_flt + sig->maj_flt + sig->cmaj_flt;
+			psig->cnvcsw +=
+				p->nvcsw + sig->nvcsw + sig->cnvcsw;
+			psig->cnivcsw +=
+				p->nivcsw + sig->nivcsw + sig->cnivcsw;
+			psig->cinblock +=
+				task_io_get_inblock(p) +
+				sig->inblock + sig->cinblock;
+			psig->coublock +=
+				task_io_get_oublock(p) +
+				sig->oublock + sig->coublock;
+			task_io_accounting_add(&psig->ioac, &p->ioac);
+			task_io_accounting_add(&psig->ioac, &sig->ioac);
+			spin_unlock_irq(&p->real_parent->sighand->siglock);
+		}
+		read_unlock(&tasklist_lock);
+	}
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
-	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
-		? p->signal->group_exit_code : p->exit_code;
 	if (!retval && wo->wo_stat)
 		retval = put_user(status, wo->wo_stat);
 
@@ -1284,27 +1306,10 @@ static int wait_task_zombie(struct wait_
 	if (!retval)
 		retval = pid;
 
-	if (traced) {
-		write_lock_irq(&tasklist_lock);
-		/* We dropped tasklist, ptracer could die and untrace */
-		ptrace_unlink(p);
-		/*
-		 * If this is not a detached task, notify the parent.
-		 * If it's still not detached after that, don't release
-		 * it now.
-		 */
-		if (!task_detached(p)) {
-			do_notify_parent(p, p->exit_signal);
-			if (!task_detached(p)) {
-				p->exit_state = EXIT_ZOMBIE;
-				p = NULL;
-			}
-		}
-		write_unlock_irq(&tasklist_lock);
-	}
-	if (p != NULL)
+	if (likely(!noreap))
 		release_task(p);
-
+out:
+	put_task_struct(p);
 	return retval;
 }
 
@@ -1587,8 +1592,11 @@ repeat:
 			goto end;
 
 		retval = ptrace_do_wait(wo, tsk);
-		if (retval)
+		if (retval) {
+			if (unlikely(retval == -EAGAIN))
+				goto repeat;
 			goto end;
+		}
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;

