Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbYFXIIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbYFXIIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYFXIIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:08:15 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:11499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbYFXIIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=n5zkUsJfFZMeLsV4gclQsPfWbJLO1JQvybJa0zf+0YArGEF91Q9be1+fhP2Roz8REA
         6kUfjobIKahTLkoqZdSlEl2NMqv38glVt3ewKqwdEP/kb2AeXEULZ7+NgP7esaCA0duI
         /fodRBKj2nHJP1iCdhnUwBrnQCoPfnLMq96WM=
Message-ID: <505766fa0806240107hacebf36q6c5b4d97278272b4@mail.gmail.com>
Date: Tue, 24 Jun 2008 16:07:58 +0800
From: hyl <heyongli@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [RT] remove_waiter does not need to do chain walk?(2.6.25.4-rt)
Cc: mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

lets us just focus on remove_waiter in rt_spin_lock_slowlock
(2.6.25.4-rt).  refer to bellowing brief code .

i notice the comments above calling the  remove_waiter , but i can't
figure out the  sequence which meet
the comment.

I  do figure out a event sequence to proof  we must call
remove_waiter , but chain walk seems is not needed.

 0).  current process block on this lock (note:block on lock not the process)
 1).  adaptive_wait  continue  the loop without sleeping due to event
2): owner change( held no lock while adaptive wait)
 2.)  owner free the lock, another process be selected as pending
owner, then release lock
 2.x) then  current be boosted , and become pending owner's top
waiter, so pending owner be boosted too
 3.  in the new round loop: do_try_to_take_rt_mutex->try_to_steal_lock
lucky own the lock,
     and at this time, waiter.task is not NULL

 Question is: seems pending owner's block_on is null,   remove_waiter
seems need no chain walk?

 My scenario may not be the one of author,  please don't hesitate to
offer a example to clarity this question,
i think discuss about this make it clear and easy to maintain.


rt_spin_lock_slowlock(struct rt_mutex *lock)
{
      .........
	for (;;) {
		if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
		...
		if (!waiter.task) {
		  . ..
		}
         	....
		if (adaptive_wait(&waiter, orig_owner)) {
		......
		}

	.....
	}
	....
	/*
	 * Extremely rare case, if we got woken up by a non-mutex wakeup,
	 * and we managed to steal the lock despite us not being the
	 * highest-prio waiter (due to SCHED_OTHER changing prio), then we
	 * can end up with a non-NULL waiter.task:
	 */
	if (unlikely(waiter.task))
		remove_waiter(lock, &waiter, flags);
.....
}

Regards
hyl
