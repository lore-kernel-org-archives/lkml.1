Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbYFZNOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbYFZNOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765478AbYFZNNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:13:09 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:41387 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760649AbYFZNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZhVkCbGye6X+z2Qy/qncZ2D2KcLh4LKP1wH7kMLprm0e5orhF9+I6CaHlXWmzYPTNs
         ATP/Wsww+n3v0Sio3XzGc1R9uOM3wbp9EA2KAsiHruDb9v77GCqVVYAZtmhIIfXiFyPS
         FIahZMTjFAFVpeLSOD7vl/Xbn9PTXErP/xExY=
Message-ID: <505766fa0806260613o759a0636m21070a46aafdf3fd@mail.gmail.com>
Date: Thu, 26 Jun 2008 21:13:04 +0800
From: hyl <heyongli@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [RT] remove_waiter does not need to do chain walk?(2.6.25.4-rt)
Cc: mingo@elte.hu
In-Reply-To: <505766fa0806240107hacebf36q6c5b4d97278272b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <505766fa0806240107hacebf36q6c5b4d97278272b4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/24 hyl <heyongli@gmail.com>:
> Hi, everyone
>
> lets us just focus on remove_waiter in rt_spin_lock_slowlock
> (2.6.25.4-rt).  refer to bellowing brief code .
>
> i notice the comments above calling the  remove_waiter , but i can't
> figure out the  sequence which meet
> the comment.
>
> I  do figure out a event sequence to proof  we must call
> remove_waiter , but chain walk seems is not needed.
>
>  0).  current process block on this lock (note:block on lock not the process)
>  1).  adaptive_wait  continue  the loop without sleeping due to event
> 2): owner change( held no lock while adaptive wait)
>  2.)  owner free the lock, another process be selected as pending
> owner, then release lock
>  2.x) then  current be boosted , and become pending owner's top
> waiter, so pending owner be boosted too
>  3.  in the new round loop: do_try_to_take_rt_mutex->try_to_steal_lock
> lucky own the lock,
>     and at this time, waiter.task is not NULL
>
>  Question is: seems pending owner's block_on is null,   remove_waiter
> seems need no chain walk?
   look into the for(;;){}  loop there are only  one break, it is that
we got the lock.
so we must be the owner,  in remove_waiter,
{
	int first = (waiter == rt_mutex_top_waiter(lock));
	struct task_struct *owner = rt_mutex_owner(lock);
	int chain_walk = 0;

	spin_lock(&current->pi_lock);
	plist_del(&waiter->list_entry, &lock->wait_list);
	waiter->task = NULL;
	current->pi_blocked_on = NULL;
	spin_unlock(&current->pi_lock);

	if (first && owner != current && !task_is_reader(owner)) {
        ==>/*we are the owner, so never a chain walk for
rt_spin_lock_slowlock->remove_waiter,*/

but for mutex/reader/writer senerio, the chain walk is possible.

for rt_spin_lock,  it seems that we are never  going to have a non-mutex wakeup.
FIX ME.


>
>  My scenario may not be the one of author,  please don't hesitate to
> offer a example to clarity this question,
> i think discuss about this make it clear and easy to maintain.
>
>
> rt_spin_lock_slowlock(struct rt_mutex *lock)
> {
>      .........
>        for (;;) {
>                if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
>                ...
>                if (!waiter.task) {
>                  . ..
>                }
>                ....
>                if (adaptive_wait(&waiter, orig_owner)) {
>                ......
>                }
>
>        .....
>        }
>        ....
>        /*
>         * Extremely rare case, if we got woken up by a non-mutex wakeup,
>         * and we managed to steal the lock despite us not being the
>         * highest-prio waiter (due to SCHED_OTHER changing prio), then we
>         * can end up with a non-NULL waiter.task:
>         */
>        if (unlikely(waiter.task))
>                remove_waiter(lock, &waiter, flags);
> .....
> }
>
> Regards
> hyl
>
