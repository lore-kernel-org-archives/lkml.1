Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZBERYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZBERYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZBERYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:24:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:40851 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376AbZBERYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BTilkXWkJE/3xnws4QEU5Q9xLDced5gnCfCY+zyzcjvKjU3st16zjp0Dl2QBjv/AXv
         +SdupotRIV+lFFH9SDvOQ5OEUkNbmcQvUrcB3sggTLm4vTTF1cgTmCewnwt6C9DQmOYS
         RxGgkAx5s7DFflt2TspHs3oFmlTryY+OKZd6Y=
Date: Thu, 5 Feb 2009 18:24:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090205172429.GA23531@nowhere>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu> <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com> <20090205170156.GA25517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205170156.GA25517@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:01:56PM +0100, Oleg Nesterov wrote:
> On 02/05, Lai Jiangshan wrote:
> >
> > DEADLOCK EXAMPLE for explain my above option:
> >
> > (work_func0() and work_func1() are work callback, and they
> > calls flush_workqueue())
> >
> > CPU#0					CPU#1
> > run_workqueue()                         run_workqueue()
> >   work_func0()                            work_func1()
> >     flush_workqueue()                       flush_workqueue()
> >       flush_cpu_workqueue(0)                  .
> >       flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
> >         waiting work_func1() in cpu#1           waiting work_func0 in cpu#0
> >
> > DEADLOCK!
> 
> I am not sure. Note that when work_func0() calls run_workqueue(),
> it will clear cwq->current_work, so another flush_ on CPU#1 will
> not wait for work_func0, no?


No but CPU#1 can wait for a completion that will never be done, because
CWQ#0 is waiting for CWQ#1.

 
> But anyway. Nobody argues, "if (cwq->thread == current) {...}" code in
> flush_cpu_workqueue() is bad and should die. Otrherwise, we should
> fix the lockdep warning ;)
> 
> The only problem: if we still have the users of this hack, they will
> deadlock. But perhaps it is time to fix them.
> 
> And, if it was not clear, I do agree with this change. And Peter
> seems to agree as well.
> 
> Oleg.
> 

