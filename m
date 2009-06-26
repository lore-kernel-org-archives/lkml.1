Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZFZAQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZFZAQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZFZAPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:15:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42347 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZFZAPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:15:40 -0400
Date: Fri, 26 Jun 2009 09:14:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH 1/2] memcg: cgroup fix rmdir hang
Message-Id: <20090626091407.9a3df2be.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090625145044.37d6c56c.akpm@linux-foundation.org>
References: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090623160854.93abeecb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090625145044.37d6c56c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

On Thu, 25 Jun 2009 14:50:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Jun 2009 16:08:54 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, cgroup has a logic to wait until ready-to-rmdir for avoiding
> > frequent -EBUSY at rmdir.
> >  (See Commit ec64f51545fffbc4cb968f0cea56341a4b07e85a
> >   cgroup: fix frequent -EBUSY at rmdir.
> > 
> > Nishimura-san reported bad case for waiting and This is a fix to
> > make it reliable. A thread waiting for thread cannot be waken up
> > when a refcnt gotten by css_tryget() isn't put immediately.
> > (Original code assumed css_put() will be called soon.)
> > 
> > memcg has this case and this is a fix for the problem. This adds
> > retry_rmdir() callback to subsys and check we can sleep or not.
> > 
> > Note: another solution will be adding "rmdir state" to subsys.
> > But it will be much complicated than this do-enough-check solution.
> > 
> 
> A few issues..
> 
> Firstly, this code (both before and after the patch) looks like a
> rather horrid hack.  
> 
> <ooh look, a comment!>
> 
> 	/*
> 	 * css_put/get is provided for subsys to grab refcnt to css. In typical
> 	 * case, subsystem has no reference after pre_destroy(). But, under
> 	 * hierarchy management, some *temporal* refcnt can be hold.
> 	 * To avoid returning -EBUSY to a user, waitqueue is used. If subsys
> 	 * is really busy, it should return -EBUSY at pre_destroy(). wake_up
> 	 * is called when css_put() is called and refcnt goes down to 0.
> 	 */
> 
> (The correct word here is "temporary").
> 
yes.

> Where and under what circumstances is this temporary reference taken? 

Typical case is when we're using "hierarchy". In following hirerarchy,

	group-A/01
		02
		03

There are several codes which needs to scan A,01,02,03. Even while 03 is
under rmdir(), this scan can happen. Most of cause is memory.stat file
and hierarchical reclaim.

Without this "sleep" logic, we can see very frequent -EBUSY in following
case.

  (Shell-1)# while true; do cat group-A/memory.stat > myfile ; done
  (Shell-2)# rmdir group-A/03

> Is there any way in which we can fix all this properly, so that the
> directory removal will happen deterministically, without needing the
> in-kernel polling loop?
> 
> ie: refcounting?
> 
> (I have a vague feeling that I've asked all this before.  But that's OK
> - the code's still horrid ;))
> 
Sorry..

As far as this "rmdir" problem patch concerns, one way to go is removing
css->ref per page at at all. 

A problem I feel recently is that the cgroup is designed to stand on "task"
and not for others like pages and bios, etc...So making memcg's refcounting
against "page" should be removed. (and no permanent refcnt which requires
pre_destroy())

Option "A" we have (but painful for me) is
 1. revert commit:ec64f51545fffbc4cb968f0cea56341a4b07e85a
 2. remove all css reference per page for memcg. And just use "temporal" ones.
 3. retry commit:ec64f51545fffbc4cb968f0cea56341a4b07e85a

We'll see frequent EBUSY again at rmdir but this can keep codes clean.
And there will be "misaccouted usage against dead cgroup" probelm. This race
will be a difficult one, anyway.


Option "B" is making pre_destroy() stateful.
 1. add cancel_destroy().
 2. When pre_destroy() is called, we record memcg that "we're under rmdir" 
    And don't do any charge after that.
 3. clear "we're under rmdir" when cancel_destroy() is called.

Concern of this option is tons of racy case I can expect.
So, I didn't select this.

> 
> > Index: fix-rmdir-cgroup/include/linux/cgroup.h
> > ===================================================================
> > --- fix-rmdir-cgroup.orig/include/linux/cgroup.h
> > +++ fix-rmdir-cgroup/include/linux/cgroup.h
> > @@ -374,6 +374,7 @@ struct cgroup_subsys {
> >  	struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
> >  						  struct cgroup *cgrp);
> >  	int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> > +	int (*retry_rmdir)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> 
> This is poorly named.  The reader will expect that a function called
> "retry_rmdir" will, umm, retry an rmdir.
> 
> But this function doesn't do that.  It's a predicate which the caller
> will use to determine whether the caller should retry the rmdir.
> 
> A better name would be should_retry_rmdir(), for example.
> 
Ah, thanks.

> But even that isn't very good, because "should_retry_rmdir()" implies
> that the caller will only use this function for a single purpose.  The
> callee shouldn't assume this!
> 
ok.

> So can we come up with a name which accurately reflects what the
> function actually does?  Like "has_remaining_references()", or somesuch?
> 
> Also, making the return value `bool' would have come clarification
> benefits.
> 
Thank you for suggestions. I'll update this.




> >  	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> >  	int (*can_attach)(struct cgroup_subsys *ss,
> >  			  struct cgroup *cgrp, struct task_struct *tsk);
> > Index: fix-rmdir-cgroup/kernel/cgroup.c
> > ===================================================================
> > --- fix-rmdir-cgroup.orig/kernel/cgroup.c
> > +++ fix-rmdir-cgroup/kernel/cgroup.c
> > @@ -636,6 +636,23 @@ static int cgroup_call_pre_destroy(struc
> >  		}
> >  	return ret;
> >  }
> > +/*
> > + * Call subsys's retry_rmdir() handler. If this returns non-Zero, we retry
> > + * rmdir immediately and call pre_destroy again.
> > + */
> > +static int cgroup_check_retry_rmdir(struct cgroup *cgrp)
> > +{
> > +	struct cgroup_subsys *ss;
> > +	int ret = 0;
> > +
> > +	for_each_subsys(cgrp->root, ss)
> > +		if (ss->pre_destroy) {
> > +			ret = ss->retry_rmdir(ss, cgrp);
> > +			if (ret)
> > +				break;
> > +		}
> > +	return ret;
> > +}
> 
> There's an important and subtle precondition for this function: it is
> called in state TASK_INTERRUPTIBLE.  This means that the ->retry_rmdir
> handler must be careful to not disturb that state.  For if that
> function were to accidentally enter state TASK_RUNNING (say, it does a
> mutex_lock/unlock) then the kernel could enter a busy loop and would use
> lots of CPU time.  I guess that code comments are sufficient to cover
> this.  It's a property of ->retry_rmdir, really.
> 
> Also, what sense does it make to call ->retry_rmdir() if ->pre_destroy
> is non-NULL?  Was that actually intentional?  If so, it is strange to link
> those two fields in this way.  The retry_rmdir() documentation didn't describe
> this.
> 
ok, How about this ?

rename retry_rmdir() as
	bool should_rerun_pre_destroy(cgroup, subsys).
Then, function name describes its functionality.

Hmm, the code is being complicated/dirty day by day..(most of reason is me..)


Thanks,
-Kame


> >  static void free_cgroup_rcu(struct rcu_head *obj)
> >  {
> > @@ -2722,7 +2739,8 @@ again:
> >  
> >  	if (!cgroup_clear_css_refs(cgrp)) {
> >  		mutex_unlock(&cgroup_mutex);
> > -		schedule();
> > +		if (!cgroup_check_retry_rmdir(cgrp))
> > +			schedule();
> >  		finish_wait(&cgroup_rmdir_waitq, &wait);
> >  		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
> >  		if (signal_pending(current))
> >
> > ...
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

