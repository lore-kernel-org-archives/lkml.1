Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZFXUvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZFXUvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFXUvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:51:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZFXUvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:51:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
In-Reply-To: Oleg Nesterov's message of  Wednesday, 24 June 2009 19:13:57 +0200 <20090624171357.GA30435@redhat.com>
References: <20090622170437.GA4906@redhat.com>
	<20090624091316.73D0F4059B@magilla.sf.frob.com>
	<20090624152143.GB23848@redhat.com>
	<20090624185701.AA74C4059B@magilla.sf.frob.com>
	<20090624161111.GA27890@redhat.com>
	<20090624194239.A29174059B@magilla.sf.frob.com>
	<20090624171357.GA30435@redhat.com>
Emacs: the only text editor known to get indigestion.
Message-Id: <20090624205112.3EA944059B@magilla.sf.frob.com>
Date: Wed, 24 Jun 2009 13:51:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > an untraced thread calls do_notify_parent_cldstop() but its group_leader
> > is ptrace_reparented().  Then waitee->group_leader->real_parent is who
> > gets the wakeup, but __wake_up_parent->child_wait_wakeup would check
> > only waiter == waitee->group_leader->parent.
> 
> ... and in this case we do not wake up ->group_leader->real_parent.
> 
> But this is fine? It doesn't make sense to wake up, wait_consider_task()
> will notice task_ptrace() and do nothing?

Right.  I knew it needed more thought (that's why I said "maybe wrong" to
begin with ;-).

> I really need to think with a fresh head, but it seems to me we could add
> BUG_ON(p->parent != parent) into wait_consider_task() after "if (ptrace...)"
> check.
> 
> And this "proves" your check in child_wait_callback() is correct, with
> __WNOTHREAD do_wait_thread(parent) is always called with parent ==
> sleeper, the caller of do_wait().
> 
> No?

Yes, I think that's right.

> Btw, this reminds me that wait_consider_task() doesn't need the "parent"
> argument. I noticed this after adding wait_opts, but forgot to send a
> patch.

With the wq.private now in wait_opts, yes.


Thanks,
Roland
