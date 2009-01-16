Return-Path: <linux-kernel-owner+w=401wt.eu-S937325AbZAPUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937325AbZAPUs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZAPUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:48:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbZAPUsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:48:18 -0500
Date: Fri, 16 Jan 2009 21:45:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pids: refactor vnr/nr_ns helpers to make them safe
Message-ID: <20090116204540.GA32686@redhat.com>
References: <20090116055520.GA28131@redhat.com> <20090116103522.GA32212@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116103522.GA32212@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Louis,

On 01/16, Louis Rilling wrote:
>
> On 16/01/09  6:55 +0100, Oleg Nesterov wrote:
> > +			struct pid_namespace *ns)
> >  {
> > -	return pid_nr_ns(task_pid(tsk), ns);
> > +	pid_t nr = 0;
> > +
> > +	rcu_read_lock();
> > +	if (!ns)
> > +		ns = current->nsproxy->pid_ns;
> > +	if (likely(pid_alive(task))) {
>
> I don't see what this pid_alive() check buys you. Since tasklist_lock is not
> enforced, nothing prevents another CPU from detaching the pid right after the
> check.

pid_alive() should be renamed. We use it to make sure the task didn't pass
__unhash_process().

Yes, you are right, nothing prevents another CPU from detaching the pid right
after the  check. But this is fine: we read ->pids[].pid under rcu_read_lock(),
and if it is NULL pid_nr_ns() returns. So, we don't need pid_alive() check at
all.

However, we can not use task->group_leader unless we verify the task is still
alive. That is why we need this check. We do not clear ->group_leader when
the task exits, so we can't do

		rcu_read_lock();
		if (task->group_leader)
			do_something(task->group_leader);
		rcu_unread_lock();

Instead we use pid_alive() before using ->group_leader.

> I'm also a bit puzzled by your description with using tasklist_lock when task !=
> current, and not seeing tasklist_lock anywhere in the patch. Does this mean that
> "safe" is for "no access to freed memory is done, but caller has to take
> tasklist_lock or may get 0 as return value"?

I am not sure I understand the question...

This patch doesn't use tasklist, it relies on rcu. With this patch the caller
doesn't need tasklist/rcu to call these helpers (but of course, the caller
must ensure that task_struct is stable).

But, whatever the caller does, it can get 0 as return value anyway if the
task exists, this is correct. Or I misunderstood you?

Oleg.

