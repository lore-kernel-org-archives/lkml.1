Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZEJXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZEJXM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZEJXMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:12:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZEJXMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:12:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
In-Reply-To: Oleg Nesterov's message of  Saturday, 9 May 2009 20:43:03 +0200 <20090509184303.GA10396@redhat.com>
References: <20090505224722.GA954@redhat.com>
	<20090506020223.A4F1AFC328@magilla.sf.frob.com>
	<20090506045241.GA26214@redhat.com>
	<20090507055159.8AFA1FC39E@magilla.sf.frob.com>
	<20090509184303.GA10396@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090510231112.5DABDFC35D@magilla.sf.frob.com>
Date: Sun, 10 May 2009 16:11:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On second look, what does __ptrace_may_access() need task_lock() for anyway?
> 
> Just for get_dumpable(task->mm), I think.

Ah.  That's really only for using the mm, right?  i.e. it could be using
get_task_mm() instead.  set_dumpable() does not use task_lock() to
synchronize the actual changes that affect get_dumpable().

> OK, so this change is not purely cosmetic as I thought.

Right.

> We can fix this in many ways. We can extract the ->cred and ->mm checks
> from __ptrace_may_access() into another helper which is called before
> write_lock(tasklist), and then call security_ptrace_may_access under tasklist.
> Or we can do get_task_mm() in advance and call __ptrace_may_access() without
> task_lock().

get_task_mm() makes sense to me.  It seems like those checks being under
the tasklist_lock (i.e. the lock governing ptrace attach) might matter.

> Or, perhaps, we can just check ->ptrace before __ptrace_may_access()
> lockless (just to prevent the scenario above), and then check it again
> under tasklist? This looks like a simplest option.

Doesn't that still have a possible race with PTRACE_TRACEME?  If
ptrace_traceme() runs between the lockless check and the lock-taking, we
want PTRACE_ATTACH to fail without calling security_ptrace_may_access().
Maybe the cred mutex should be excluding that here anyway.


Thanks,
Roland
