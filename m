Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286Ab0AESzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0AESzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117Ab0AESy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:54:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0AESy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:54:58 -0500
Date: Tue, 5 Jan 2010 19:53:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, bblum@google.com, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com,
       containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH 1/2] cgroups: read-write lock CLONE_THREAD
	forking per threadgroup
Message-ID: <20100105185330.GA17545@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org> <20090821102611.GA2611@redhat.com> <20090821104528.GA3487@redhat.com> <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com> <20090822130952.GA4240@redhat.com> <20100103190613.GA13423@andrew.cmu.edu> <20100103190752.GB13423@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100103190752.GB13423@andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03, Ben Blum wrote:
>
> Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup

I didn't actually read this series, but at first glance it still has
problems...

> +struct sighand_struct *threadgroup_fork_lock(struct task_struct *tsk)

static?

> +{
> +	struct sighand_struct *sighand;
> +	struct task_struct *p;
> +
> +	/* tasklist lock protects sighand_struct's disappearance in exit(). */
> +	read_lock(&tasklist_lock);
> +
> +	/* make sure the threadgroup's state is sane before we proceed */
> +	if (unlikely(!thread_group_leader(tsk))) {
> +		/* a race with de_thread() stripped us of our leadership */
> +		read_unlock(&tasklist_lock);
> +		return ERR_PTR(-EAGAIN);

I don't understand how this can close the race with de_thread().

Suppose this tsk is the new leader, after de_thread() changed ->group_leader
and dropped tasklist_lock.

threadgroup_fork_lock() bumps sighand->count

de_thread() continues, notices oldsighand->count != 1 and switches
to the new ->sighand.

After that tsk can spawn other threads, but cgroup_fork() will use
newsighand->threadgroup_fork_lock while cgroup_attach_proc() relies
on oldsighand->threadgroup_fork_lock.

> +	/* now try to find a sighand */
> +	if (likely(tsk->sighand)) {
> +		sighand = tsk->sighand;
> +	} else {
> +		sighand = ERR_PTR(-ESRCH);
> +		/*
> +		 * tsk is exiting; try to find another thread in the group
> +		 * whose sighand pointer is still alive.
> +		 */
> +		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
> +			if (p->sighand) {
> +				sighand = tsk->sighand;

can't understand this "else {}" code... We hold tasklist, if the group
leader is dead (->sighand == NULL), then the whole thread group is
dead.

Even if we had another thread with ->sighand != NULL, what is the point
of "if (unlikely(!thread_group_leader(tsk)))" check then?

Oleg.

