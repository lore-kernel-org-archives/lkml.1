Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZIBVzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZIBVzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZIBVzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZIBVzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:55:14 -0400
Date: Wed, 2 Sep 2009 23:51:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] core: allow setrlimit to non-current tasks
Message-ID: <20090902215101.GA4767@redhat.com>
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com> <20090902135024.GA6452@redhat.com> <4A9EBCF8.1020609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9EBCF8.1020609@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Jiri Slaby wrote:
>
> On 09/02/2009 03:50 PM, Oleg Nesterov wrote:
> > But there is another minor problem. If we use read_lock(ttasklist), then
> > the write to /proc/application_pid/limits can race with application doing
> > sys_setrlimits().
> >
> > Nothing bad can happen, but this means that "echo ... > /proc/limits" can
> > be lost. Not good, if admin wants to lower ->rlim_max we should try to ensure
> > this always works.
>
> Actually, process cpu timer may be set to a wrong value. When

Yes, I thought about this too. In fact I was going to complain, but then
decided this is OK.

> * somebody unrelated holds sighand->siglock
> * process one stores rlim_new to rlim and gets stuck on spin_lock(siglock)
> * process two does the same

s/process/thread/. (I am talking about the current code). IOW, if the
application is stupid and does setrlimit() from multimple threads at
the same time - we can't help, the result is not predictable.

But, unless I missed something I think this case is fine, please see below.

> * somebody releases sighand->siglock
> * process one continues...

Now, it is possible that cputime_expires.xxx_exp does not match
->rlim[RLIMIT_CPU].rlim_cur.

But we don't care. update_rlimit_cpu() must ensure that cputime_expires.xxx_exp
is not greater than necessary, nothing else.

> I can't think of anything else than doing all the checks and updates
> under alloc_lock, introducing coarse grained static mutex in setrlimit
> to protect it,

Oh, please don't ;)

Or I missed your point?


But if you mean this series, then yes, I agree. We should try to do something
to ensure that at least rlim_max can be always lowered when admin writes to
/proc/pid/limits.

Oleg.

