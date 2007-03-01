Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbXCALPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbXCALPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbXCALPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:15:38 -0500
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:53587 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933233AbXCALPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:15:37 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Date: Thu, 1 Mar 2007 22:13:25 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <1172707341.7027.95.camel@Homer.simpson.net> <20070301084657.GA31728@elte.hu>
In-Reply-To: <20070301084657.GA31728@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703012213.25629.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 19:46, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> > I see no real difference between the two assertions.  Nice is just a
> > mechanism to set priority, so I applied your assertion to a different
> > range of priorities than nice covers, and returned it to show that the
> > code contradicts itself.  It can't be bad for a nice 1 task to run
> > with a nice 0 task, but OK for a minimum RT task to run with a maximum
> > RT task.  Iff HT without corrective measures breaks nice, then it
> > breaks realtime priorities as well.
>
> i'm starting to lean towards your view that we should not artificially
> keep tasks from running, when there's a free CPU available. We should
> still keep the 'other half' of SMT scheduling: the immediate pushing of
> tasks to a related core, but this bit of 'do not run tasks on this CPU'
> dependent-sleeper logic is i think a bit fragile. Plus these days SMT
> siblings do not tend to influence each other in such a negative way as
> older P4 ones where a HT sibling would slow down the other sibling
> significantly.

Well it is meant to be tuned to the cpu type in per_cpu_gain. So it should be 
easy to be set to the appropriate scaling. It was never meant to be a one 
value fits all as the processors changed.

> plus with an increasing number of siblings (which seems like an
> inevitable thing on the hardware side), the dependent-sleeper logic
> becomes less and less scalable. We'd have to cross-check every other
> 'related' CPU's current priority to decide what to run.

Yes even I've commented before that this current system is unworkable come 
multiple shared power threads. This I do see as a real problem with it - in 
the future.

> if then there should be a mechanism /in the hardware/ to set the
> priority of a CPU - and then the hardware could decide how to prioritize
> between siblings. Doing this in software is really hard.

And that's the depressing part because of course I was interested in that as 
the original approach to the problem (and it was a big problem). When I spoke 
to Intel and AMD (of course to date no SMT AMD chip exists) at kernel summit 
they said it was too hard to implement hardware priorities well. Which is 
real odd since IBM have already done it with Power...

Still I think it has been working fine in software till now, but now it has to 
deal with the added confusion of dynticks, so I already know what will happen 
to it.

Hrm it's been a good time for my code all round... I think I'll just swap 
prefetch myself up the staircase to some pluggable scheduler that would 
hyperthread me to sleep as an idle priority task.

-- 
-ck
