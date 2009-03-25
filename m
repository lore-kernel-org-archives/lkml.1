Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbZCYOAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbZCYOAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZCYOAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:00:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59147 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZCYOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nrTudDFxUuhL0ZRGkhp614+ujV9HVwlftH6u5zCJKPbXV6J0iLr6kPnqnNrxSNMOxJ
         Y60rpWegPAx+m567SdEF5sXABFL+KslqgpUSlzmiB3+65PCwW5zVZrJtVpO/6CQY0g1h
         hx7NUY/JdJ9lV6V17ChnrXXzWqEVSHAqNcob0=
Date: Wed, 25 Mar 2009 15:00:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       miaoxie <miaox@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init,cpuset: fix initialize order
Message-ID: <20090325140037.GI5976@nowhere>
References: <49C9F416.1050707@cn.fujitsu.com> <20090325135138.GG5976@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325135138.GG5976@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 02:51:39PM +0100, Frederic Weisbecker wrote:
> On Wed, Mar 25, 2009 at 05:06:30PM +0800, Lai Jiangshan wrote:
> > 
> > (After these two fixes applied:
> > [PATCH 1/2] trace_stat: keep original order
> > [PATCH 2/2] trace_workqueues: fix empty line's output
> > )
> > When I read /debugfs/tracing/trace_stat/workqueues,
> > and the I got this:
> > 
> > # CPU  INSERTED  EXECUTED   NAME
> > # |      |         |          |
> > 
> >   0      0          0       cpuset
> >   0    285        285       events/0
> >   0      2          2       work_on_cpu/0
> >   0   1115       1115       khelper
> >   0    325        325       kblockd/0
> >   0      0          0       kacpid
> >   0      0          0       kacpi_notify
> >   0      0          0       ata/0
> >   0      0          0       ata_aux
> >   0      0          0       ksuspend_usbd
> >   0      0          0       aio/0
> >   0      0          0       nfsiod
> >   0      0          0       kpsmoused
> >   0      0          0       kstriped
> >   0      0          0       kondemand/0
> >   0      1          1       hid_compat
> >   0      0          0       rpciod/0
> > 
> >   1     64         64       events/1
> >   1      2          2       work_on_cpu/1
> >   1      5          5       kblockd/1
> >   1      0          0       ata/1
> >   1      0          0       aio/1
> >   1      0          0       kondemand/1
> >   1      0          0       rpciod/1
> > 
> > I found "cpuset" is at the earliest.
> > ---------
> > 
> > Subject: [PATCH] init,cpuset: fix initialize order
> > 
> > Impact: cpuset_wq should be initialized after init_workqueues()
> > 
> > I found a create_singlethread_workqueue() is earlier than
> > init_workqueues():
> > 
> > kernel_init()
> > ->cpuset_init_smp()
> >   ->create_singlethread_workqueue()
> > ->do_basic_setup()
> >   ->init_workqueues()
> > 
> > I think it's better that create_singlethread_workqueue() is called
> > after workqueue subsystem has been initialized.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> 
> 
> Indeed it seems to be a bug.
> If init_workqueues() have not been called:
> 
> - cpu_singlethread_map = NULL
> - singlethread_cpu = 0
> 
> create_workqueue_thread() will be called with cpu = 0 and
> then: kthread_create(worker_thread, cwq, fmt, wq->name, cpu = 0);
> 
> Meaning that cpuset is only bound to the first cpu.
> 
> Frederic.
> 


Ah no, kthread_bind is called just after with -1 for the cpu.

Frederic.

 
> > diff --git a/init/main.c b/init/main.c
> > index 1ce6931..91d5047 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -773,6 +773,7 @@ static void __init do_basic_setup(void)
> >  {
> >  	rcu_init_sched(); /* needed by module_init stage. */
> >  	init_workqueues();
> > +	cpuset_init_smp();
> >  	usermodehelper_init();
> >  	driver_init();
> >  	init_irq_proc();
> > @@ -869,8 +870,6 @@ static int __init kernel_init(void * unused)
> >  	smp_init();
> >  	sched_init_smp();
> >  
> > -	cpuset_init_smp();
> > -
> >  	do_basic_setup();
> >  
> >  	/*
> > 
> > 
> 

