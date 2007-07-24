Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbXGXShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbXGXShd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXGXShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:37:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:39361 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXGXShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:37:24 -0400
Date: Tue, 24 Jul 2007 11:36:21 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <20070724145142.GA199@tv-sign.ru>
Message-ID: <Pine.LNX.4.63.0707240827320.25961@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
 <1184662429.12353.426.camel@chaos> <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
 <1184703427.12353.476.camel@chaos> <Pine.LNX.4.63.0707171558570.10358@localhost.localdomain>
 <Pine.LNX.4.63.0707171654020.10358@localhost.localdomain>
 <20070718161156.GA761@tv-sign.ru> <Pine.LNX.4.63.0707181203110.3157@localhost.localdomain>
 <20070720141529.GA218@tv-sign.ru> <Pine.LNX.4.63.0707231858420.9759@localhost.localdomain>
 <20070724145142.GA199@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 24 Jul 2007 18:36:21.0820 (UTC) FILETIME=[883B9FC0:01C7CE21]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Oleg Nesterov wrote:

> On 07/23, Jeremy Katz wrote:
>>
>> On Fri, 20 Jul 2007, Oleg Nesterov wrote:
>>
>>> I still can't believe we have a double-free problem, this looks imposiible.
>>> Do you see the
>>>
>>> 	"idr_remove called for id=%d which is not allocated.\n"
>>>
>>> in syslog?
>>
>> No.  I also added some accounting with atomic counters, and don't see
>> evidence of a second call to release_posix_timer.
>
> Interesting. Could you show the patch? Where does sys_timer_create() set
> counter == 1?

--- kernel/posix-timers.c.old      2007-07-24 11:21:29.000000000 -0700
+++ kernel/posix-timers.c       2007-07-20 15:49:51.000000000 -0700
@@ -409,13 +409,17 @@ static struct k_itimer * alloc_posix_tim
  #define IT_ID_NOT_SET  0
  static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
  {
+       atomic_inc(&tmr->freecount);
@@ -443,6 +447,7 @@ sys_timer_create(const clockid_t which_c
         new_timer = alloc_posix_timer();
         if (unlikely(!new_timer))
                 return -EAGAIN;
+       atomic_set(&new_timer->freecount, 0);

--- include/linux/posix-timers.h.old  2007-07-24 11:32:36.000000000 -0700
+++ include/linux/posix-timers.h      2007-07-20 15:15:44.000000000 -0700
@@ -62,6 +62,7 @@ struct k_itimer {
                         unsigned long expires;
                 } mmtimer;
         } it;
+       atomic_t freecount;
  };

  struct k_clock {


Examination was done through a kgdb session when it caught the bug. 
freecount always had the expected value, 1 during a delete operation, 
and 0 otherwise.

>>> Could you try the patch below? Perhaps we have some wierd problem with
>>> ->sigq corruption.
>>
>> Tried, with apparent effect.
>
> You mean, "null pointer dereference" in release_posix_timer() ? Or it was
> BUG_ON(timr && !timr->sigq) in lock_timer() ?

Sorry.  That should have been "without apparent effect".

> I assume you didn't apply any other patches except Thomas's, yes?

Alone, as well as with Thomas' patch. Neither way changed the behavior.

Jeremy
