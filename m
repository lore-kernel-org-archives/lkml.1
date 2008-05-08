Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYEHDaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYEHDaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 23:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYEHD34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 23:29:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYEHD3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 23:29:52 -0400
Date: Wed, 7 May 2008 20:29:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <1210214696.3453.87.camel@ymzhang>
Message-ID: <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>  <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>  <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org>  <20080507114643.GR19219@parisc-linux.org>  <87hcdab8zp.fsf@basil.nowhere.org>
  <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>  <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Zhang, Yanmin wrote:
>
> Congratulations! The patch really fixes the regression completely!
> vmstat showed cpu idle is 0%, just like 2.6.25's.

Well, that shows that it was the BKL.

That said, "idle 0%" is easy when you spin. Do you also have actual 
performance numbers? I'd hope that not only do we use full CPU time, it's 
also at least as fast as the old semaphores were?

While I've been dissing sleeping locks (because their overhead is so 
high), at least in _theory_ they can get better behavior when not 
spinning. Now, that's not going to happen with the BKL, I'm 99.99% sure, 
but I'd still like to hear actual performance numbers too, just to be 
sure.

Anyway, at least the "was it the BKL or some other semaphore user" 
question is entirely off the table.

So we need to

 - fix the BKL. My patch may be a good starting point, but there are 
   alternatives:

    (a) reinstate the old BKL code entirely

	Quite frankly, I'd prefer not to. Not only did it have three 
	totally different cases, some of them were apparently broken (ie 
	BKL+regular preempt didn't cond_resched() right), and I just don't 
	think it's worth maintaining three different versions, when 
	distro's are going to pick one anyway. *We* should pick one, and 
	maintain it.

    (b) screw the special BKL preemption - it's a spinlock, we don't 
	preempt other spinlocks, but at least fix BKL+preempt+cond_resched
	thing. 

	This would be "my patch + fixes" where at least one of the fixes 
	is the known (apparently old) cond_preempt() bug.

    (c) Try to keep the 2.6.25 code as closely as possible, but just 
	switch over to mutexes instead.

	I dunno. I was never all that enamoured with the BKL as a sleeping 
	lock, so I'm biased against this one, but hey, it's just a 
	personal bias.

 - get rid of the BKL anyway, at least in anything that is noticeable.

	Matthew's patch to file locking is probably worth doing as-is, 
	simply because I haven't heard any better solutions. The BKL 
	certainly can't be it, and whatever comes out of the NFSD 
	discussion will almost certainly involve just making sure that 
	those leases just use the new fs/locks.c lock.

	This is also why I'd actually prefer the simplest possible 
	(non-preempting) spinlock BKL. Because it means that we can get 
	rid of all that "saved_lock_depth" crud (like my patch already 
	did). We shouldn't aim for a clever BKL, we should aim for a BKL 
	that nobody uses.

I'm certainly open to anything. Regardless, we should decide fairly soon, 
so that we have the choice made before -rc2 is out, and not drag this out, 
since regardless of the choice it needs to be tested and people comfy with 
it for the 2.6.26 release.

			Linus
