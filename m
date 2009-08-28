Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZH1G7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZH1G7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZH1G7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:59:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:54085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZH1G7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:59:53 -0400
Message-ID: <4A978052.6000908@kernel.org>
Date: Fri, 28 Aug 2009 15:59:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com> <4A9744F4.7010208@kernel.org> <4A97468A.6080502@kernel.org> <20090828063603.GA21420@elte.hu>
In-Reply-To: <20090828063603.GA21420@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 06:59:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
>> Eh... don't have earlier AMD doc and gotta go now.  Can somebody 
>> please check?  But it looks like we can deadlock by simply sending 
>> RESCHEDULE_VECTOR more than two times while holding rq lock on 
>> AMD?
> 
> We poll ICR in the send-IPI logic before sending it out - so this 
> shouldnt happen. The restrictions above should at most cause extra 
> polling latency (i.e. it's a performance detail, not a lockup 
> source). See all the *wait_icr_idle() methods in the IPI sending 
> logic in arch/x86.

Ah... good.  I'm not all that familiar with the area so I was kind of
shooting in the dark.

> Neither TLB flushes nor reschedule IPIs are idempotent, so if this 
> was broken and if we lost requested events on remote CPUs we'd 
> notice it rather quickly via TLB flush related hangs or scheduling 
> latencies or lost wakeups, on a rather large category of CPUs.

But it still looks like we can quite easily fall into deadlock when
there are multiple cpus.  cpu0 holding rq_lock and sends RESCHEUDLE,
cpu1 waiting on rq_lock with irq disabled and some other cpus already
sent three other IPIs to cpu1 then cpu0 will lock up on the BUSY bit
when it tries to send RESCHEDULE, no?

> I think Linus's suggestion that it's the zero mask quirk on certain 
> older CPUs that is causing problems on that system should be 
> examined ... does .31-rc8 work fine?

Yeap, it would be great if that's the case.

Thanks.

-- 
tejun
