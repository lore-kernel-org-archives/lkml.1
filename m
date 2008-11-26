Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYKZRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYKZRC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYKZRBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:01:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45754 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbYKZRBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:01:38 -0500
Date: Wed, 26 Nov 2008 17:59:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org,
       eranian@gmail.com, sfr@canb.auug.org.au,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126165948.GA15755@redhat.com>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com> <20081126140027.GC6562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126140027.GC6562@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Ingo Molnar wrote:
>
> * eranian@googlemail.com <eranian@googlemail.com> wrote:
>
> > +static int pfm_task_incompatible(struct pfm_context *ctx,
> > +				 struct task_struct *task)
> > +{
> > +	/*
> > +	 * cannot attach to a kernel thread
> > +	 */
> > +	if (!task->mm) {
> > +		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
> > +		return -EPERM;
> > +	}
> > +
> > +	/*
> > +	 * cannot attach to a zombie task
> > +	 */
> > +	if (task->exit_state == EXIT_ZOMBIE || task->exit_state == EXIT_DEAD) {
> > +		PFM_DBG("cannot attach to zombie/dead task [%d]", task->pid);
> > +		return -EBUSY;
> > +	}
> > +	return 0;
> > +}

I agree with Ingo these checks are pointless. Without the locks
the ->mm or ->exit_state can be changed right after the check.

And, as Ingo pointed out, you don't need this function at all,
if ptrace_check_attach() succeeds the task must have ->mm and
its ->exit_state == 0.

But, please note that the task can be SIGKILL'ed right after
ptrace_check_attach(), it can drop ->mm, it can be released.
(i don't understand the patch, perhaps this doesn't matter for
 you, just in case).

Oleg.

