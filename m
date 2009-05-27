Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZE0Bk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZE0Bk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZE0BkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:40:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZE0BkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:40:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: do_notify_parent/do_notify_parent_cldstop && info.si_xtime
In-Reply-To: Oleg Nesterov's message of  Tuesday, 26 May 2009 23:13:06 +0200 <20090526211306.GA7065@redhat.com>
References: <20090526211306.GA7065@redhat.com>
X-Shopping-List: (1) Disastrous exorbitant companions
   (2) Melodramatic removal flakes
   (3) Malcontent anomalous exclamations
   (4) Urgent glove contributions
   (5) Gaseous despotic arguments
Message-Id: <20090527014019.52814FC36B@magilla.sf.frob.com>
Date: Tue, 26 May 2009 18:40:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do_notify_parent() reports .si_Xtime = tsk->Xtime + signal->Xtime,
> but do_notify_parent_cldstop() uses .si_Xtime =  tsk->Xtime.
> 
> Is this right?

si_utime and si_stime are not standardized fields, so there is no
completely clear definition of "right" for these.

> Yes, tsk->Xtime + signal->Xtime does not make much sense for
> do_notify_parent_cldstop(), but reporting group_leader->Xtime
> (if not traced) doesn't look very right too. IOW, perhaps we
> need thread_group_cputime() here?

Solaris also has these fields, and a simple test on Solaris 10 indicates
that it does use the cumulative totals including dead threads for its
CLD_STOPPED SIGCHLDs.  That indeed makes sense to me for process job
control stop reports.

However, I think it makes sense to use just task->?time (as we do now) for
ptrace'd stops.  These notifications are per-thread.  Moreover, this is a
hot path in the context of a ptrace'd process.  thread_group_cputime() is
O(n) in the number of threads, so that would be a bad idea for anything
frequent.  (Real non-ptrace job control stops are not frequent like that.)

The caveats are that probably nobody cares about these values anyway but
any application that does care might already have adapted to the manifest
Linux behavior and be expecting leader-only (it doesn't seem likely to me).


Thanks,
Roland
