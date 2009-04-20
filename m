Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZDTXsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZDTXsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZDTXsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:48:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:12889 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDTXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fJHC8gQi/EBLCt5TYfOhIR5PKuSgF4UKYJOfVLXEZ1gN5fj2R2VKR8NeH0LXkoox7w
         QY3jMdqVKNGtx0/O2CmhnuS2wxocVeTk7YL18tB+n1vprrFFgfOerMYST8k4g9a/Jpjy
         TgFw9z1imbp5pl78pLw2OYUGsxjf4e2YgCgbE=
Date: Tue, 21 Apr 2009 01:48:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090420234835.GC5997@nowhere>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com> <20090420084631.GA32625@elte.hu> <20090420222514.GA15680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420222514.GA15680@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 12:25:14AM +0200, Oleg Nesterov wrote:
> On 04/20, Ingo Molnar wrote:
> >
> > Andrew, Oleg: if you plan to make unhappy noises about this level of
> > instrumentation in the workqueue code, please do it sooner rather
> > than later, as there's quite some effort injected into this already.
> > A tentative non-NAK now (patches are still being sorted out) and an
> > Ack on the final topic tree from you (once we send it and if it's
> > good) and general happiness would be the ideal outcome :)
> 
> Imho, this info is useful, and the changes are fine.
> 
> But I didn't study kernel/trace/trace_workqueue.c yet... Sorry, I was
> going to do this, but I didn't.
> 
> At first glance, with or without these new changes some parts of
> trace_workqueue.c looks suspicious.
> 
> For example, I don't understand cpu_workqueue_stats->pid. Why it is
> needed? Why can't we just record wq_thread itself? And if we copy
> wq_thread->comm to cpu_workqueue_stats, we don't even need get/put
> task_struct, afaics.


We record the pid because of a race condition that can happen
against the stat tracing framework.

For example,

- the user opens the stat file
- then the entries are loaded and sorted into memory
- one of the workqueues is destroyed
- the user reads the file. We try to get the task struct
  of each workqueues that were recorded using their pid.
  If the task is destroyed then this is fine, we don't get
  any struct. If we were using the task_struct as an identifier,
  me would have derefenced a freed pointer.

 
> probe_workqueue_destruction() does cpumask_first(cwq->cpus_allowed),
> this doesn't look right. When workqueue_cpu_callback() calls
> cleanup_workqueue_thread(), wq_thread is no longer affine to CPU it
> was created on. This means probe_workqueue_destruction() can't always
> find the correct cpu_workqueue_stats in workqueue_cpu_stat(cpu), no?


Ah, at this stage of cpu_down() the cpu is cleared on
tsk->cpu_allowed ?

Thanks for looking at this.

Frederic.


> Oleg.
> 

