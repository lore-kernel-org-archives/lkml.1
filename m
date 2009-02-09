Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZBIFRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZBIFRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZBIFQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:16:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZBIFQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:16:55 -0500
Date: Mon, 9 Feb 2009 06:14:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090209051400.GA5450@redhat.com>
References: <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com> <20090205030553.49650FC381@magilla.sf.frob.com> <3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com> <20090205161544.GA24799@redhat.com> <20090205212234.934D1FC381@magilla.sf.frob.com> <20090205232223.GB10345@redhat.com> <20090209033335.5DE77FC330@magilla.sf.frob.com> <20090209045234.GA3213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209045234.GA3213@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Oleg Nesterov wrote:
>
> Yes sure. I meant, instead of just checking task_is_stopped_or_traced() in
> wait_consider_task(), we should do somthing like

In short, please see the "patch" below. I doubt it can be compiled,
just for the illustration.

Oleg.

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1417,6 +1417,19 @@ static int wait_task_zombie(struct task_
 	return retval;
 }
 
+static int *wait_xxx(struct task_struct *p, int ptrace)
+{
+	if (ptrace) {
+		if (task_is_stopped_or_traced(p))
+			return &p->exit_code;
+	} else {
+		if (p->signal->flags & SIGNAL_STOPPED_STOPPED)
+			return &p->signal->group_exit_code;
+	}
+
+	return NULL;
+}
+
 /*
  * Handle sys_wait4 work for one task in state TASK_STOPPED.  We hold
  * read_lock(&tasklist_lock) on entry.  If we return zero, we still hold
@@ -1427,7 +1440,7 @@ static int wait_task_stopped(int ptrace,
 			     int options, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code, why;
+	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
@@ -1437,22 +1450,16 @@ static int wait_task_stopped(int ptrace,
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
-	if (unlikely(!task_is_stopped_or_traced(p)))
-		goto unlock_sig;
-
-	if (!ptrace && p->signal->group_stop_count > 0)
-		/*
-		 * A group stop is in progress and this is the group leader.
-		 * We won't report until all threads have stopped.
-		 */
+	p_code = wait_xxx(p, ptrace);
+	if (unlikely(!p_code))
 		goto unlock_sig;
 
-	exit_code = p->exit_code;
+	exit_code = *p_code;
 	if (!exit_code)
 		goto unlock_sig;
 
 	if (!unlikely(options & WNOWAIT))
-		p->exit_code = 0;
+		*p_code = 0;
 
 	/* don't need the RCU readlock here as we're holding a spinlock */
 	uid = __task_cred(p)->uid;
@@ -1608,7 +1615,7 @@ static int wait_consider_task(struct tas
 	 */
 	*notask_error = 0;
 
-	if (task_is_stopped_or_traced(p))
+	if (wait_xxx(p, ptrace))
 		return wait_task_stopped(ptrace, p, options,
 					 infop, stat_addr, ru);
 

