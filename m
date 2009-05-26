Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZEZVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZEZVkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZEZVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:40:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZEZVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:40:47 -0400
Date: Tue, 26 May 2009 23:33:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090526213346.GA7073@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Roland McGrath wrote:
>
> Acked-by: Roland McGrath <roland@redhat.com>
>
> Yes, all cases setting .si_pid should set it using the pid_ns of the
> recipient.  Numerous other cases look wrong too, though maybe Sukadev has
> outstanding patches for those already?  (It's been a while since we went
> around on this, and I am fuzzy on some of the details.)  ptrace_notify,
> ptrace_signal,

Yes. Perhaps it would be nice to add a helper,

	task_pid_xxx(struct task_struct child, struct task_struct *parent)
	{
		rcu_read_lock();
		ret = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
		rcu_read_unlock();

		return ret;
	}

ptrace_notify/ptrace_signal can race with untrace + clear ->nsproxy,
probably we don't care.

> sys_kill, do_tkill all look wrong to me.

They should be fine, note the

	if (from_ancestor_ns)
		q->info.si_pid = 0;

in __send_signal(). If we send the signal "down" to the sub-namespace,
si_pid == 0 is correct. And, unlike do_notify_parent/ptrace_notify/etc
kill/tkill can't send the signal "up".

Oleg.

