Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab0CBGAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:00:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41738 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0CBGAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:00:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 2 Mar 2010 14:56:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX][PATCH] memcg: fix oom kill behavior v2
Message-Id: <20100302145644.0f8fbcca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100302143738.5cd42026.nishimura@mxp.nes.nec.co.jp>
References: <20100302115834.c0045175.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302135524.afe2f7ab.kamezawa.hiroyu@jp.fujitsu.com>
	<20100302143738.5cd42026.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 14:37:38 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Tue, 2 Mar 2010 13:55:24 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Very sorry, mutex_lock is called after prepare_to_wait.
> > This is a fixed one.
> I'm willing to test your patch, but I have one concern.
> 
> > +/*
> > + * try to call OOM killer. returns false if we should exit memory-reclaim loop.
> > + */
> > +bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
> >  {
> > -	mem_cgroup_walk_tree(mem, NULL, record_last_oom_cb);
> > +	DEFINE_WAIT(wait);
> > +	bool locked;
> > +
> > +	/* At first, try to OOM lock hierarchy under mem.*/
> > +	mutex_lock(&memcg_oom_mutex);
> > +	locked = mem_cgroup_oom_lock(mem);
> > +	if (!locked)
> > +		prepare_to_wait(&memcg_oom_waitq, &wait, TASK_INTERRUPTIBLE);
> > +	mutex_unlock(&memcg_oom_mutex);
> > +
> > +	if (locked)
> > +		mem_cgroup_out_of_memory(mem, mask);
> > +	else {
> > +		schedule();
> > +		finish_wait(&memcg_oom_waitq, &wait);
> > +	}
> > +	mutex_lock(&memcg_oom_mutex);
> > +	mem_cgroup_oom_unlock(mem);
> > +	/* TODO: more fine grained waitq ? */
> > +	wake_up_all(&memcg_oom_waitq);
> > +	mutex_unlock(&memcg_oom_mutex);
> > +
> > +	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
> > +		return false;
> > +	/* Give chance to dying process */
> > +	schedule_timeout(1);
> > +	return true;
> >  }
> >  
> Isn't there such race conditions ?
> 
> 	context A				context B
>   mutex_lock(&memcg_oom_mutex)
>   mem_cgroup_oom_lock()
>     ->success
>   mutex_unlock(&memcg_oom_mutex)
>   mem_cgroup_out_of_memory()
> 					mutex_lock(&memcg_oom_mutex)
> 					mem_cgroup_oom_lock()
> 					  ->fail
> 					prepare_to_wait()
> 					mutex_unlock(&memcg_oom_mutex)
>   mutex_lock(&memcg_oom_mutex)
>   mem_cgroup_oom_unlock()
>   wake_up_all()
>   mutex_unlocklock(&memcg_oom_mutex)
> 					schedule()
> 					finish_wait()
> 
> In this case, context B will not be waken up, right?
> 

No. 
	prerape_to_wait();
	schedule();
	finish_wait();
call sequence is for this kind of waiting.


1. Thread B. call prepare_to_wait(), then, wait is queued and task's status
   is changed to be TASK_INTERRUPTIBLE
2. Thread A. wake_up_all() check all waiters in queue and change their status
   to be TASK_RUNNING.
3. Thread B. calles schedule() but it's status is TASK_RUNNING,
   it will be scheduled soon, no sleep.

Then, mutex_lock after prepare_to_wait() is bad ;)

Thanks,
-Kame




