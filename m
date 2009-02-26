Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZBZWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZBZWDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZBZWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:03:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZBZWDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:03:37 -0500
Date: Thu, 26 Feb 2009 22:59:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
Message-ID: <20090226215945.GA12520@redhat.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225212039.GA11883@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Oleg Nesterov wrote:
>
> On 02/25, Linus Torvalds wrote:
> >
> > > As I think I said before, I don't really know what the actual use case is
> > > for CLONE_PARENT without CLONE_THREAD.  So it's easy to approve changing
> > > its behavior, but I do vaguely worry about who expected what behavior before.
> >
> > I think changing it is wrong.
>
> Perhaps. As I said, I don't know what is the expected behaviour. And in fact
> I can't think of the "obviously good" behaviour.
>
> > I can easily see somebody using CLONE_PARENT to get the correct getppid
> > semantics in the thread, and then setting the signal to zero to not make
> > the parent see the thread go away.
>
> ->exit_signal == 0 doesn't mean the thread silently goes away, it becomes
> a zombie (even if ->parent ignores SIGCHLD). We don't send the signal, but
> that is all.
>
> And if ->parent execs, we reset ->exit_signal to SIGCHLD anyway.

Really, how CLONE_PARENT + exit_signal==0 can be useful?

I still think this patch does the right change. Not because it fixes the
security problem, as I said I do not think the ability to send SIGKILL to
->parent is wrong from the security pov, even if child does setuid/etc,
the problem is that CLONE_PARENT can fool ->xxx_exec_id logic and we can
send SIGKILL after parent/child exec.

But because the current behaviour is just silly. Imho.

But of course, if this change can break the user-space applications, then
it should not be applied.

> > And quite
> > frankly, it would be good to try to see if there are other alternatives.
>
> Agreed. I thought about checking ->xxx_exec_id's in copy_process(),
> but doesn't look very nice...

I meant something like the patch below. But I don't like it.

Anybody has other ideas?

Oleg.

--- kernel/fork.c
+++ kernel/fork.c
@@ -1218,9 +1218,15 @@ static struct task_struct *copy_process(
 		set_task_cpu(p, smp_processor_id());
 
 	/* CLONE_PARENT re-uses the old parent */
-	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
+	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
-	else
+		p->self_exec_id = p->parent_exec_id =
+				p->real_parent->self_exec_id;
+
+		if (current->parent_exec_id != current->real_parent->self_exec_id ||
+		    current->self_exec_id  != current->parent_exec_id)
+			p->exit_signal = SIGCHLD;
+	} else
 		p->real_parent = current;
 
 	spin_lock(&current->sighand->siglock);

