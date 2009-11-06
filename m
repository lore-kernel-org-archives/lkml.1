Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZKFHrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZKFHrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZKFHrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:47:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:42700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZKFHrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:47:13 -0500
Message-ID: <4AF3D428.8000804@kernel.org>
Date: Fri, 06 Nov 2009 16:45:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu>
In-Reply-To: <20091106071711.GA20946@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> This warning is bogus -- sched_init() is being called very early with IRQs
>>> disabled, and the irqsave/restore code paths in pcpu_alloc() are only for early
>>> init. The path can never be called from irq context once the early init
>>> finishes. Rationale for this is explained in changelog of the commit mentioned
>>> above.
>>>
>>> This problem can be encountered generally in any other early code running
>>> with IRQs off and using irqsave/irqrestore.
>>>
>>> Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> Looks good to me.  Ingo, what do you think?
> 
> Ugh, this explanation is _BOGUS_. As i said, taking a lock with irqs 
> disabled does _NOT_ mark a lock as 'irq safe' - if it did, we'd have 
> false positives left and right.
> 
> Read the lockdep message please, consider all the backtraces it prints, 
> it says something different.

Ah... okay, the pcpu_free() path is correctly marking the lock
irqsafe.  I assumed this was caused by recent pcpu_alloc() change.
Sorry about that.  The lock inversion problem has always been there,
it just never showed up because none has use allocation map that large
I suppose.

So, the correct fix would be either 1. push down irqsafeness down to
vmalloc locks or 2. the rather ugly unlock-lock dancing in
pcpu_extend_area_map() I posted earlier.  For 2.6.32, I guess we'll
have to go with #2.  For longer term, we'll probably have to do #1 as
it's required to implement atomic percpu allocations too.

I'll try to reproduce the problem here and verify the previous locking
dance patch.

Thanks.

-- 
tejun
