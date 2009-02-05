Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZBEBYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZBEBYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761958AbZBEBYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:24:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758873AbZBEBYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:24:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee of
	ptrace_exit()
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 05:29:20 +0100 <20090129042920.GA5111@redhat.com>
References: <20090129042920.GA5111@redhat.com>
X-Shopping-List: (1) Voluptuous tampons
   (2) Harmonious symphonic aspersions
   (3) Numerous hypocritical retentives
   (4) Revised shrub ablutions
Message-Id: <20090205012334.9E60FFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 17:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No functional changes, preparation for the next patch.
> 
> Move the "should we release this child" logic into the separate handler,
> __ptrace_detach().

My inclination is to use bool in new code for true/false return values,
but I don't really care.

Please canonicalize the comment formatting for your new comments.

The preserved comment no longer makes sense, there is no "dead list" in
that function.  Make it a coherent comment at the top that explains the
return value.  

Given its content, this function now better belongs in ptrace.c, I think.


Thanks,
Roland

=====

/*
 * Called with tasklist_lock held for writing.
 * Unlink a traced task, and clean it up if it was a traced zombie.
 * Return true if it needs to be reaped with release_task().
 * (We can't call release_task() here because we already hold tasklist_lock.)
 *
 * If it's a zombie, our attachedness prevented normal parent notification
 * or self-reaping.  Do notification now if it would have happened earlier.
 * If it should reap itself, return true.
 *
 * If it's our own child, there is no notification to do.
 * But if our normal children self-reap, then this child
 * was prevented by ptrace and we must reap it now.
 */
bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
{
	__ptrace_unlink(p);

	if (p->exit_state == EXIT_ZOMBIE) {
		if (!task_detached(p) && thread_group_empty(p)) {
			if (!same_thread_group(p->real_parent, tracer))
				do_notify_parent(p, p->exit_signal);
			else if (ignoring_children(tracer->sighand))
				p->exit_signal = -1;
		}
		if (task_detached(p)) {
			/*
			 * Mark it as in the process of being reaped.
			 */
			p->exit_state = EXIT_DEAD;
			return true;
		}
	}

	return false;
}
