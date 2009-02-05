Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZBEUwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZBEUwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZBEUv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:51:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZBEUv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:51:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of
	->signal to check the task is alive
In-Reply-To: Oleg Nesterov's message of  Thursday, 5 February 2009 16:54:54 +0100 <20090205155454.GD20953@redhat.com>
References: <20090203231717.GA5028@redhat.com>
	<20090205033120.2294BFC381@magilla.sf.frob.com>
	<20090205155454.GD20953@redhat.com>
X-Zippy-Says: Yow!  I like my new DENTIST...
Message-Id: <20090205204521.E1642FC381@magilla.sf.frob.com>
Date: Thu,  5 Feb 2009 12:45:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can't use them as refcounts. You can't bump ->live or ->count without
> breaking group_dead or exec logic. Perhaps we can use ->count, but then
> we need other changes. 

We certainly need to clean up exec anyway.

> But this has nothing to do with this patch.

Agreed.

> The goal is to keep task->signal after release_task(), it will be freed
> by __put_task_struct(). This allows a lot of simplifications and we can
> move some fields from task_struct to signal_struct.

That sounds fine to me in theory, but I still wonder what the story will be
about the use of siglock.

> But first we should change the code which does [...]

I did understand the rationale given the signal_struct lifetime change.

> > Uses here protecting cpu_clock_sample_group() e.g., are
> > around looking at ->signal->foobar, so if ->signal is still there, why not
> > look at it and be able to get the sample in whatever small window this is?
> 
> What if arm_timer() sees ->signal != NULL, proceeds, and attaches the
> timer to the signal_struct of the already dead task? This signal_strcut
> will be released with the pending timer.

Of course.  I distinctly mentioned the read-only uses (sample).

> Even cpu_clock_sample_group() is not safe, unless we add other changes.

Why?  It does no locking and only relies on the signal_struct lifetime.

> But in any case. Even if we don't need the further changes, do you
> agree this patch is correct and doesn't change the behaviour?

Yes.


Thanks,
Roland
