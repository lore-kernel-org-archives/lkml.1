Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYGWPLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYGWPLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYGWPL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:11:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46249 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYGWPL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:11:27 -0400
Date: Wed, 23 Jul 2008 19:14:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, daniel@hozac.com,
       roland@redhat.com, Pavel Emelyanov <xemul@sw.ru>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: Re: + signals-introduce-kill_pid_ns_info.patch added to -mm tree
Message-ID: <20080723151458.GA2983@tv-sign.ru>
References: <200807220822.m6M8M1Xl018412@imap1.linux-foundation.org> <20080722141655.GA3345@tv-sign.ru> <m1ljzshfqb.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljzshfqb.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/mm-commits/lkml/

On 07/23, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > <troll mode on>
> >
> > 	Sadly, I can't see some really bad problems with this patch ;)
> >
> > 	Because with this change it is much harder to remove tasklist_lock
> > 	for the "kill(-1)" case.
> >
> > 	kill(-1) is not time critical, the problem it holds tasklist_lock.
> > 	And this patch makes things worse for the global namespace.
> 
> Slightly.  It leaves the code very readable in all namespaces, and it
> puts all of the logic in one function where it can be more easily
> worked with.
> 
> I have yet to see an instance where we can safely drop tasklist_lock.  In
> the kill -1 case.

Afaics, all we need is the patch below. Then we can s/tasklist/rcu/ + add
fat comment to explain why this is safe.

Oleg.

--- kernel/signal.c
+++ kernel/signal.c
@@ -1110,6 +1110,23 @@ out_unlock:
 EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
 
 /*
+ * Same as group_send_sig_info(), but make sure we don't race
+ * with exec() when we don't hold tasklist_lock
+ */
+int kill_xxx(int sig, struct siginfo *info, struct task_struct *g)
+{
+	struct task_struct *p = g;
+
+	do {
+		ret = group_send_sig_info(sig, info, p);
+		if (ret != -ESRCH)
+			break;
+	} while_each_thread(g, p);
+
+	return ret;
+}
+
+/*
  * kill_something_info() interprets pid in interesting ways just like kill(2).
  *
  * POSIX specifies that kill(-1,sig) is unspecified, but what we have
@@ -1137,7 +1154,9 @@ static int kill_something_info(int sig, 
 
 		for_each_process(p) {
 			if (p->pid > 1 && !same_thread_group(p, current)) {
-				int err = group_send_sig_info(sig, info, p);
+				int err = kill_xxx(sig, info, p);
+				if (err = -ESRCH) /* not possible under tasklist */
+					continue;
 				++count;
 				if (err != -EPERM)
 					retval = err;

