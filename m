Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbXFRTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbXFRTYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761940AbXFRTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:24:09 -0400
Received: from mail.ccur.com ([66.10.65.12]:41124 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761776AbXFRTYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:24:08 -0400
Message-ID: <4676DBD4.2030909@ccur.com>
Date: Mon, 18 Jun 2007 15:24:04 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
Subject: Re: [RFC] [PATCH] selective signal ptracing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2007 19:24:06.0163 (UTC) FILETIME=[3CA4AE30:01C7B1DE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Subject: Re: [RFC] [PATCH] selective signal ptracing
 > From: Oleg Nesterov <oleg@tv-sign.ru>
 > Date: Sat, 16 Jun 2007 13:24:15 +0400
 > To: John Blackwood <john.blackwood@ccur.com>
 > CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath 
<roland@redhat.com>, linux-kernel@vger.kernel.org
 >
 > John Blackwood wrote:
 > > >
 > > > By default all signals are ptraced as before. However, a debugger
 > > > may now modify the set of per-task ptraced signals, where only the
 > > > signals in this ptrace signal mask will be ptraced.
 >
 > I must admit, I agree with Roland...
 >
 > > > +void ptrace_update_traced_signals(struct task_struct *child,
 > > > +							sigset_t *new_smaskp)
 > > > +{
 > > > [...snip...]
 > > > +
 > > > +		spin_lock_irqsave(&child->sighand->siglock, flags);
 > > > +
 > > > +		if (child->sighand == NULL) {
 >
 > How so?
 >
 > Oleg.

Hi Oleg.

Right, this above is not a good check for a NULL sighand.

Possibly, this routine could use something like the
rcu_read_lock()/lock_task_sighand() sequences used elsewhere
(shown below).

The whole ptrace_update_traced_signals() where we drain ignored signals
is not dealt with today by ptraced tasks when the debugger exits or
detaches from a target task.  So this whole routine is not entirely
related just to selective signal ptracing.

Thanks for you input.


diff -rup linux-2.6.22-rc4-git5.old/kernel/exit.c 
linux-2.6.22-rc4-git5.new/kernel/exit.c
--- linux-2.6.22-rc4-git5.old/kernel/exit.c	2007-06-18 
14:36:09.000000000 -0400
+++ linux-2.6.22-rc4-git5.new/kernel/exit.c	2007-06-18 
14:31:16.000000000 -0400

+/*
+ * void ptrace_update_traced_signals(
+ *			struct task_struct *child, sigset_t *new_smaskp)
+ *
+ *	Update the signal mask of ptraced signals, removing any ignored
+ *	pending signals that are no longer ptraced.  'new_smaskp' points
+ *	to the new ptrace signal mask which will be stored into
+ *	child->ptrace_sigmask.
+ */
+void ptrace_update_traced_signals(struct task_struct *child,
+							sigset_t *new_smaskp)
+{
+	int sig = 0, index = 0;
+	unsigned long int flags;
+	sigset_t prev_smask;
+
+	/* Get signals that were previously, but no longer ptraced. */
+	signandsets(&prev_smask, &child->ptrace_sigmask, new_smaskp);
+	child->ptrace_sigmask = *new_smaskp;
+	rcu_read_lock();
+	while (!sigisemptyset(&prev_smask)) {
+		while (index < _NSIG_WORDS) {
+			if (prev_smask.sig[index]) {
+                               	sig = ffz(~prev_smask.sig[index]) +
+						(index * _NSIG_BPW) + 1;
+				break;
+			}
+			index++;
+		}
+		/* Remove signal from the previously ptraced signal mask. */
+		sigdelset(&prev_smask, sig);
+
+		if (!lock_task_sighand(child, &flags)) {
+			/* This task is exiting, so just return. */
+			unlock_task_sighand(child, &flags);
+			rcu_read_unlock();
+			return;
+		}
+		if (!sig_ignored(child, sig)) {
+			unlock_task_sighand(child, &flags);
+			continue;
+		}
+		/* Remove any queued signals - they should now be ignored. */
+		rm_from_queue(sigmask(sig), &child->pending);
+		rm_from_queue(sigmask(sig), &child->signal->shared_pending);
+		unlock_task_sighand(child, &flags);
+	}
+	rcu_read_unlock();
+}
