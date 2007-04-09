Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXDILDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXDILDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 07:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXDILDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 07:03:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:35531 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXDILDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 07:03:44 -0400
Date: Mon, 9 Apr 2007 15:03:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] scheduler: first timeslice of the exiting thread
Message-ID: <20070409110333.GA253@tv-sign.ru>
References: <20070409102922.GA216@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409102922.GA216@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Oleg Nesterov wrote:
>
> Satoru Takeuchi wrote:
> >
> >   a) On sched_fork, the creator share its timeslice with new process.
> >   b) On sched_exit, if the exiting process didn't exhaust its first
> >      timeslice yet, it gives its timeslice to the parent.
> >
> > It has no problem on the process model since the creator is the parent.
> > However, on the thread model, the creator is not the parent, it is same
> > as the creator's parent. Hence, on this kind of program, the creator
> > can't retrieve shared timeslice and exausts its timeslice at a rate of
> > knots. In addition, somehow, the parent (typically shell?) gets extra
> > timeslice.
> 
> Yes, this is an old oddity.

Perhaps

	void sched_exit(struct task_struct *p)
	{
		task_t *t, *did_fork = p->parent;

		if (!thread_group_leader(p))
			list_for_each_entry(t, p->thread_group)
				if (!t->exit_state) {
					did_fork = t;
					break;
				}

		... give time_slice to did_fork ..
	}

may improve things a little bit, because the rest of time_slice doesn't leak
off the thread group.

However this is not very nice and we have the same problem with CLONE_PARENT.

Oleg.

