Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbXHUKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbXHUKkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXHUKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:40:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49410 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXHUKkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:40:42 -0400
Date: Tue, 21 Aug 2007 14:40:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Daniel Pittman <daniel@rimspace.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Kirill Korotaev <dev@sw.ru>,
       Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH] fix /sbin/init signal handling
Message-ID: <20070821104042.GB164@tv-sign.ru>
References: <20070819150822.GA7772@tv-sign.ru> <46CAB0EC.4000406@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CAB0EC.4000406@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Pavel Emelyanov wrote:
>
> >+static int sig_init_ignore(struct task_struct *tsk)
> >+{
> >+	// Currently this check is a bit racy with exec(),
> >+	// we can _simplify_ de_thread and close the race.
> >+	if (likely(!is_init(tsk->group_leader)))
> >+		return 0;
> >+
> >+	// ---------------- Multiple pid namespaces ----------------
> >+	// if (current is from tsk's parent pid_ns && !in_interrupt())
> >+	//	return 0;
> >+
> >+	return 1;
> >+}
> >+
> >+static int sig_task_ignore(struct task_struct *tsk, int sig)
> >+{
> >+	void __user * handler = tsk->sighand->action[sig-1].sa.sa_handler;
> >+
> >+	if (handler == SIG_IGN)
> >+		return 1;
> >+
> >+	if (handler != SIG_DFL)
> >+		return 0;
> >+
> >+	return sig_kernel_ignore(sig) || sig_init_ignore(tsk);
> >+}
> 
> These two look like the init ignores "less" than a usual task,
> i.e. the decision of whether a task has to ignore a signal depends
> on whether the init has and some more. This is... strange :)

Strange, indeed... Unless you misread the code or I misundertood your
message ;)

Could you clarify? The intended behaviour is: the SIG_DFL signal is
ignored if sig_kernel_ignore(sig) or we are /sbin/init. This means
init ignores "more", not "less". Unless I am terribly confused...

> >@@ -569,6 +590,9 @@ static void handle_stop_signal(int sig, 
> > 		 */
> > 		return;
> > 
> >+	if (sig_init_ignore(p))
> >+		return;
> >+
> 
> Why do we need for explicit stop handling for init? Shouldn't
> it be automatically checked in get_signal_to_deliver()?

Again, I don't quite understand what you mean.

The current behaviour is not good, we shouldn't do things like
rm_from_queue(SIGCONT) or ->signal->flags = 0 for /sbin/init.

This becomes worse with multiple namespaces if /sbin/init is ptraced
from the parent namespace (yes, such a ptracing is questionable).

Oleg.

