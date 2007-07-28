Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbXG1N3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbXG1N3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 09:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXG1N25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 09:28:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:32995 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbXG1N24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 09:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gzu4nilX9E6p29aNbMHH6a3lF+Ij+lPrtn/Jq8fu7byFaM1SvoG3ABqJXV0fIh2rxPXnIIQzsB0y+UFlKPdzu/4/Mqq8tZK5M0oe1kxkVLRDME5JbsA+eEnnWMQVQmIIBtH45RdGIcjhyrgcUyS5ES3vQhwvhmEDnkUlbURif20=
Message-ID: <b647ffbd0707280628t55552d22i3e134b7b9972a659@mail.gmail.com>
Date: Sat, 28 Jul 2007 15:28:55 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Volanomark slows by 80% under CFS
Cc: tim.c.chen@linux.intel.com, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46AA8E57.8010105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185573687.19777.44.camel@localhost.localdomain>
	 <46AA8E57.8010105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/07, Chris Snook <csnook@redhat.com> wrote:
> [ ... ]
>   Under CFS, the yielding process will still be leftmost in the rbtree,
> otherwise it would have already been scheduled out.

Not actually true. The position of the 'current' task within the
rb-tree is updated with a timer tick's frequency. Being called
somewhere in between 2 ticks, sched_yield() may trigger a reschedule
which would otherwise take place upon the next tick.

Moreover, 'scheduling granularity' may also take effect. e.g.
effectively, the yielding task's 'fair_key' was already != 'left_most'
upon the previous timer tick but an actual reschedule has been delayed
due to the 'scheduling granularity' taking effect... and sched_yield()
may trigger it.


> Zeroing out wait_runtime on sched_yield strikes me as completely appropriate.
> If the process wanted to sleep a finite duration, it should actually call a
> sleep function, but sched_yield is essentially saying "I don't have anything
> else to do right now", so it's hardly fair to claim you've been waiting for your
> chance when you just gave it up.

'wait_runtime' describes dynamic behavior of a task on the rq. It
doesn't matter what the task is about to do as 'wait_runtime' is
something it fully deserves. Note, 'wait_runtime' can be both positive
and negative, meaning credit/punishment appropriately.

When it's negative, 'zeroing it out' effectively means the task gets
helped -- in the sense that it doen't get 'punished' for some amount
of time it actually spent running. Which is wrong.

One more thing: we don't take time accounted to 'wait_runtime' just
from the thin air.
e.g. sleepers get an additional bonus to their 'wait_runtime' upon a
wakeup _but_ the amount of "wait_runtime" == "a given bonus" will be
additionally substracted from tasks which happen to run later on (grep
for "sleeper_bonus" in sched_fair.c). That said, the sum (of
additionally given/taken wait_runtime) is zero.

All in all, I doubt the "zeroing out wait_runtime on sched_yield"
thing is really appropriate.


>
>         -- Chris
>

-- 
Best regards,
Dmitry Adamushko
