Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbZAMNxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbZAMNxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbZAMNws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:52:48 -0500
Received: from tservice.net.ru ([195.178.208.66]:60538 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760981AbZAMNws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:52:48 -0500
Date: Tue, 13 Jan 2009 16:52:46 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090113135246.GA29251@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:51:08PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Well, Kenny has to die, but if we still decide to change the world, here
> > is the fist step.
> 
> NAK this entire thing - we have an existing interface that does the job
> far better.

Mwahaha, I just checked how scores are calculated, so that userspace
could adjust them. Let's start with beginning:

	list_for_each_entry(child, &p->children, sibling) {
		task_lock(child);
		if (child->mm != mm && child->mm)
			points += child->mm->total_vm/2 + 1;
		task_unlock(child);
	}

	/*
	 * CPU time is in tens of seconds and run time is in thousands
         * of seconds. There is no particular reason for this other than
         * that it turned out to work very well in practice.
	 */
	cpu_time = (cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
		>> (SHIFT_HZ + 3);

	if (uptime >= p->start_time.tv_sec)
		run_time = (uptime - p->start_time.tv_sec) >> 10;
	else
		run_time = 0;

	s = int_sqrt(cpu_time);
	if (s)
		points /= s;
	s = int_sqrt(int_sqrt(run_time));
	if (s)
		points /= s;

Do you _REALLY_ think anyone can calculate it yourself and then properly
calculate adjustment used to properly select oom-killed process?

I can not and will not even try if I would be an admin of the given
system. So, Alan, until you can calc that numbers in mind and then do
this for the whole heavy loaded system, please do not spread the idea
that oom_adj can be used to tune the oom-killer.
And no, reading data from /proc/.../oom_score is not enough, since
they change with time, so the same will be needed to be done to tune
the adjustment?

So far my patch is the sanest way to deal with the OOM selection, when
we have to differentiate some processes. I agree, it is not the best
solution, but it is way ahead of what we have right now for the users
and not hardcore kernel hackers.

-- 
	Evgeniy Polyakov
