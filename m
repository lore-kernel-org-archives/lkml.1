Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZBCTo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZBCTo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZBCTor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:44:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51800 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbZBCTor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:44:47 -0500
Date: Tue, 3 Feb 2009 20:42:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: do_each_pid_task() needs rcu lock
Message-ID: <20090203194214.GA23703@redhat.com>
References: <20090203193904.GA23695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203193904.GA23695@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Oleg Nesterov wrote:
>
> "ftrace: use struct pid" commit 978f3a45d9499c7a447ca7615455cefb63d44165
> converted ftrace_pid_trace to "struct pid*". But we can't use
> do_each_pid_task() without rcu_read_lock() even if we know the pid
> itself can't go away (it was pinned in ftrace_pid_write). The exiting
> task can detach itself from this pid at any moment.

Q: why do we use do_each_pid_task(PIDTYPE_PID) ? We can never have more
than 1 task in the loop. Perhaps,

	static void set_ftrace_pid(struct pid *pid)
	{
		struct task_struct *p;

		rcu_read_lock();
		p = pid_task(pid, PIDTYPE_PID);
		if (p)
			set_tsk_trace_trace(p);
		rcu_read_unlock();
	}

looks better?

Oleg.

