Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZEFXgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZEFXgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZEFXgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:36:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35684 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZEFXgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:36:05 -0400
Date: Thu, 7 May 2009 01:30:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace: cleanup check/set of PT_PTRACED during
	attach
Message-ID: <20090506233027.GB3756@redhat.com>
References: <20090505224727.GA958@redhat.com> <20090506074421.GE17457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506074421.GE17457@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > ptrace_attach() and ptrace_traceme() are the last functions which 
> > look as if the untraced task can have task->ptrace != 0, this must 
> > not be possible. Change the code to just check ->ptrace != 0 and 
> > s/|=/=/ to set PT_PTRACED.
> >
> > Also, a couple of trivial whitespace cleanups in ptrace_attach().
> >
> > And move ptrace_traceme() up near ptrace_attach() to keep them 
> > close to each other.
>
> btw., while at it, please also fix the typos in 
> include/linux/ptrace.h's PT_* flags section:
>
> /*
>  * Ptrace flags
>  *
>  * The owner ship rules for task->ptrace which holds the ptrace
>  * flags is simple.  When a task is running it owns it's task->ptrace
>  * flags.  When the a task is stopped the ptracer owns task->ptrace.
>  */
>
> s/owner ship/ownership
> s/it's/its

Yes, thanks.

We should change this comment anyway, because it is not right.

The only case when a task owns (iow, can change it safely) its ->ptrace
is: it is running _and_ traced. I think this is what the comment tried
to say.

But this doesn't really matter, because afaics the correct comment
should say: the task should never touch its ->ptrace, ptracer always
owns it.

There is only one exception afaics, de_thread() or do_wait() can call
release_task()->ptrace_unlink() and clear ->ptrace on behalve of
another (not ptracer) task.

Roland, what do you think?

Oleg.

