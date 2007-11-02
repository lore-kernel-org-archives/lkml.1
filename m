Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXKBOY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXKBOY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXKBOYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:24:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:18552 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbXKBOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=FfoIYt6raRcPZugX7gIahH10rrI/faFptnd5HKPQtkH59fF4WNHkausIXCiB9EhOxEtDlEU14Vw/xSsYqnAoMD77t5S/NSS0go9l4iamx2ARECfbF9lAuDwzbgBYnSGKOX2LnRycBQ45C8oDbOsGJlxKUM95SVjCjTeBkrIERQE=
Message-ID: <472B3316.2070802@gmail.com>
Date: Fri, 02 Nov 2007 10:24:22 -0400
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <4729E567.1050402@gmail.com> <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 1 Nov 2007, Gregory Haskins wrote:
>> I had observed this phenomenon on some 8-ways here as well, but I didn't
>> have the bandwidth to code something up.  Thumbs up!
> 
> Can you test under interesting loads?

Sure thing.  Ill try this next week.

> 
> We're interested in:
>  - is the unfairness fix really noticeable (or does it just move the 
>    problem somewhere else, and there is no real change in behaviour)
>  - what is the performance impact?
> 
> In particular, unfair spinlocks have the potential to perform much better. 

I see where you are going here, and I mostly agree.  I think the key is
that "given equal contention, let the guy with the hottest cache win".
The problem with the current implementation is that the spinlocks have
no way to gauge the details of the contention.  They can only gauge
instantaneous snapshots of state as viewed by each TSL invocation, which
effectively resets your position each time.

On the flip side, Nick's patches take the opposite extreme.  If a lock
is contended, get in line. ;)  This has the desirable property of
avoiding starvation.  However, it will also tend to cause more bouncing
since you are virtually guaranteed not to re-win the contended lock, as
you point out next.

> Not so much because the spinlock itself acts all that differently, but 
> because being unfair also fundmanetally tends to keep the data structures 
> that are *protected* by the spinlock on just one CPU.

My issue here is that this behavior can also be described as precisely
part of the problem being addressed:  That is, both CPUs presumably
*want/need* access to the data or they wouldn't be taking the spinlock
to begin with.  So its really not a question of keeping the structures
on one cpu per se (at least, not for unbounded durations or the system
won't operate properly).

Rather, I think the key is to minimize the impact by bouncing things
intelligently. ;)  I.e. If all things are equal, favor the hottest task
so the data only bounces once instead of twice.  Outside of this
condition, operate strict FIFO.  If we can reasonably calculate when
this optimization is possible, we will have the best of both worlds.  I
have some ideas about ways to extend Nicks algorithm to support this
which I will submit ASAP.

I think the rest of what you said is very fair:  Prove that it's a
problem, this concept helps, and we don't make things worse ;)

Will do, ASAP.

Regards,
-Greg

