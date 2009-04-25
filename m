Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZDYRbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZDYRbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 13:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZDYRav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 13:30:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39153 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZDYRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 13:30:51 -0400
Date: Sat, 25 Apr 2009 19:25:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: ptrace && cred_exec_mutex (Was: [PATCH] ptrace:
	tracehook_unsafe_exec: remove the stale comment)
Message-ID: <20090425172524.GA3432@redhat.com>
References: <20090424163949.GA12035@redhat.com> <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com> <31842.1240656853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31842.1240656853@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Yes. Except it looks like ->cred_exec_mutex is never used in fact.
>
> I must to be missing something...  I see that:
>
> 	int ptrace_attach(struct task_struct *task)
> 	{
> 	...
> 		/* Protect exec's credential calculations against our interference;
> 		 * SUID, SGID and LSM creds get determined differently under ptrace.
> 		 */
> 		retval = mutex_lock_interruptible(&current->cred_exec_mutex);
> 	...
> 	}
>
> And:
>
> 	int do_execve(...)
> 	{
> 	...
> 		retval = mutex_lock_interruptible(&current->cred_exec_mutex);
> 		if (retval < 0)
> 			goto out_free;
> 	...
> 	}

Sorry David, I was very unclear.

These 2 current's are different tasks, and hence we take to unrelated locks.

We can never block taking current->cred_exec_mutex because nobody else
touches this mutex, we always use current. This means this lock is "nop".

Unless I missed something, ptrace_attach() should take task->cred_exec_mutex.

Oleg.

