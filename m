Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZEFXTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZEFXTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZEFXTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:19:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50489 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbZEFXTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:19:38 -0400
Date: Thu, 7 May 2009 01:13:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
Message-ID: <20090506231332.GA3756@redhat.com>
References: <20090505224729.GA965@redhat.com> <20090506224650.GZ3036@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506224650.GZ3036@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Chris Wright wrote:
>
> * Oleg Nesterov (oleg@redhat.com) wrote:
> > +	write_lock_irq(&tasklist_lock);
> >  	retval = -EPERM;
> >  	if (unlikely(task->exit_state))
> > -		goto bad;
> > +		goto unlock_tasklist;
> >  	if (task->ptrace)
> > -		goto bad;
> > +		goto unlock_tasklist;
>
> So, task->ptrace now protected by tasklist_lock to keep concurrent tracers
> from both attaching to same task?

Yes,

> (re-oredered)
>
> What do you think?

I think I need your help!

> What does this do for setprocattr()?
>
>                 task_lock(p);
>                 tracer = tracehook_tracer_task(p);
>                 if (tracer)
>                         ptsid = task_sid(tracer);
>                 task_unlock(p);
>
> Looks like it is racy.

Looks like you are right, but I don't understand selinux at all.

> cpu1 (tracer)				cpu2 (tracee, changing sid)
> -------------				---------------------------
> task_lock(tracee);
> __ptrace_may_access(tracee, ATTACH);
> task_unlock(tracee);
> 					task_lock(tracee)
> <security check passes>			tracer = tracehook_tracer_task(tracee);
> 					if (tracer) <-- NULL, !tracee->ptrace
> 					...
> 					update sid w/out checking against tracer
> write_lock_irq(&tasklist_lock);
> ...
> tracee->ptrace = PT_PTRACED;
> ...
> now we are tracing task w/ a sid
> that we didn't authorize to trace

But this can happen without this change too?

- cpu2 takes task_lock(), tracehook_tracer_task() returns NULL because
  we are not traced yet.

- cpu1 does ptrace_attach() and succeds, because cpu2 didn't update sid
  yet

- cpu2 continues, it doesn't check avc_has_perm() (tracer == 0) and
  updates sid.

No?

Shouldn't selinux_setprocattr() take ->cred_exec_mutex, like we do in
selinux_bprm_set_creds() path?

Oleg.

