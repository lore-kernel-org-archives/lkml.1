Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077Ab0AWI3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0AWI3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 03:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181Ab0AWI3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 03:29:20 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:50770 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086Ab0AWI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 03:29:20 -0500
Date: Sat, 23 Jan 2010 19:28:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Mullis <don.mullis@gmail.com>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100123082839.GB25842@discord.disaster>
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4vah12u.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 11:43:21AM +0100, Andi Kleen wrote:
> Don Mullis <don.mullis@gmail.com> writes:
> >
> > Being just a dumb library routine, list_sort() has no idea what context
> > it's been called in, how long a list a particular client could pass in,
> > nor how expensive the client's cmp() callback might be.
> >
> > The cmp() callback already passes back a client-private pointer.
> > Hanging off of this could be a count of calls, or timing information,
> > maintained by the client.  Whenever some threshold is reached, the
> > client's cmp() could do whatever good CPU-sharing citizenship required.
> 
> need_resched() does all the timing/thresholding (it checks the 
> reschedule flag set by the timer interrupt). You just have to call it.
> But preferable not in the inner loop, but in a outer one. It's
> not hyper-expensive, but it's not free either.
> 
> The drawback is that if it's called the context always has to
> allow sleeping, so it might need to be optional.
> 
> Anyways a better fix might be simply to ensure in the caller
> that lists never get as long that they become a scheduling
> hazard. But you indicated that ubifs would pass very long lists?
> Perhaps ubifs (and other calls who might have that problem) simply
> needs to be fixed.

Burning CPU time to save on IO is a very valid tradeoff in
filesystem design - burning a few hundred millieseconds of CPU
time can result in savcwinge tens of seconds of IO time. Hence
passing big long lists to be sorted is not an indication of broken
design, it's an indication of understanding CPU time vs IO time
tradeoffs during design...

For example, the use I have for list sort (sorting delayed write
buffers in ascending block order before Io submission) will result
in XFS asking for lists in the order of tens to hundreds of
thousands of items to be sorted. The code I already is showing wall
clock time reductions of 30-40% for stuff like kernel tarball
extraction or creation of millions of small files. This is because
the number of buffers being issued for IO is far larger than we
should sanely hold in the elevator request queues, but pre-sorting
them results in the elevator getting a near 100% merge efficiency of
delayed write buffers instead of near zero.  Hence we get much, much
better IO patterns out of the filesystem and things go faster.

Hence I think scalability and minimising scheduling latency for
list_sort() is definitely important. I was kind of planning to address
this when the problem was a performance limiting factor, but Don
has made a pre-emptive strike. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
