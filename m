Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZBTTQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZBTTQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZBTTQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:16:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZBTTQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:16:41 -0500
Date: Fri, 20 Feb 2009 20:13:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] ptrace_untrace: fix the SIGNAL_STOP_STOPPED
	check
Message-ID: <20090220191321.GA7564@redhat.com>
References: <20090213105442.GA24328@redhat.com> <20090220034928.741F6FC2F7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220034928.741F6FC2F7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Roland McGrath wrote:
>
> > This bug is ancient too. ptrace_untrace() must not resume the task
> > if the group stop in progress, we should set TASK_STOPPED instead.
>
> Right, the change looks correct.
>
> > Unfortunately, we still have problems here:
> >
> > 	- if the process/thread was traced, SIGNAL_STOP_STOPPED
> > 	  does not necessary means this thread group is stopped.
> >
> > 	- ptrace breaks the bookkeeping of ->group_stop_count.
>
> Neither of these should be true today as I understand the code.

Suppose we have

	int main(void)
	{
		kill(getpid(), SIGSTOP);

		for (;;)
			;
	}

If you strace this task nobody clears SIGNAL_STOP_STOPPED.

As for bookkeeping of ->group_stop_count, I think ptrace_stop() is wrong
in many ways. For example, it decrements ->group_stop_count but doesn't
set SIGNAL_STOP_STOPPED if it becomes zero.

Oleg.

