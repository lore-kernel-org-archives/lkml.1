Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbZCVXPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbZCVXPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZCVXPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:15:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48696 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbZCVXPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:15:04 -0400
Date: Mon, 23 Mar 2009 00:11:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Lojkin <ia6432@inbox.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl
Subject: Re: 2.6.28, limiting cpu time doesn't work
Message-ID: <20090322231111.GA21775@redhat.com>
References: <20090322201436.GA12838@redhat.com> <E1LlVpr-0000Rv-00.ia6432-inbox-ru@f62.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LlVpr-0000Rv-00.ia6432-inbox-ru@f62.mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Peter Lojkin wrote:
>
> Oleg Nesterov wrote:
>
> > Found this message on http://bugzilla.kernel.org/show_bug.cgi?id=12911 ...
> >
> > I _think_ posix_cpu_timers_init_group() is not right, it should copy
> > cputime_expires->prof_exp.
> >
> > Peter, any chance you can test the (uncompiled/untested) patch below?
>
> yes, with this patch 2.6.28.8 works as expected, thank you!

Great, thanks!

> if you need to test any more patches on the subject i'm ready to do it.
> regression test system for our project depends on ability to limit cpu time,
> so it's major problem for us...

I am not sure what should we do, this needs more discussion.

Probably the most simple patch for -stable and 2.6.29 is below.
(with this patch we don't even need update_rlimit_cpu(), afaics).

Oleg.

--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1263,7 +1263,8 @@ static inline int fastpath_timer_check(s
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
-	return 0;
+
+	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
 }
 
 /*

