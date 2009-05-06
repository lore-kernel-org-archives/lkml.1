Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZEFWsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZEFWsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZEFWsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:48:23 -0400
Received: from sous-sol.org ([216.99.217.87]:34781 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbZEFWsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:48:22 -0400
Date: Wed, 6 May 2009 15:46:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
Message-ID: <20090506224650.GZ3036@sequoia.sous-sol.org>
References: <20090505224729.GA965@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505224729.GA965@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@redhat.com) wrote:
> +	write_lock_irq(&tasklist_lock);
>  	retval = -EPERM;
>  	if (unlikely(task->exit_state))
> -		goto bad;
> +		goto unlock_tasklist;
>  	if (task->ptrace)
> -		goto bad;
> +		goto unlock_tasklist;

So, task->ptrace now protected by tasklist_lock to keep concurrent tracers
from both attaching to same task?  What does this do for setprocattr()?

                task_lock(p);
                tracer = tracehook_tracer_task(p);
                if (tracer)
                        ptsid = task_sid(tracer);
                task_unlock(p);

Looks like it is racy.

cpu1 (tracer)				cpu2 (tracee, changing sid)
-------------				---------------------------
task_lock(tracee);
__ptrace_may_access(tracee, ATTACH);
task_unlock(tracee);
					task_lock(tracee)
<security check passes>			tracer = tracehook_tracer_task(tracee);
					if (tracer) <-- NULL, !tracee->ptrace
					...
					update sid w/out checking against tracer
write_lock_irq(&tasklist_lock);
...
tracee->ptrace = PT_PTRACED;
...
now we are tracing task w/ a sid
that we didn't authorize to trace

What do you think?

thanks,
-chris
