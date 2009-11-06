Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZKFFxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZKFFxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZKFFxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:53:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:36464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZKFFxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:53:45 -0500
Message-ID: <4AF3B9BD.9050300@kernel.org>
Date: Fri, 06 Nov 2009 14:53:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri.

Jiri Kosina wrote:
> Hmm, I wonder why I don't see this lockdep warning myself with 
> head on 1836d9592, even though I have 
> 
> 	CONFIG_PROVE_LOCKING=y
> 	CONFIG_TRACE_IRQFLAGS=y
> 
> ... ?

You need pcpu_mem_free() hit vfree() to trigger the warning by
allocating a lot of small percpu areas so that allocation map inside a
chunk becomes larger than 4k and then get extended once more.

> Anyway, how about something like this? (I can't verify myself that it even 
> fixes the warning, as I don't see it for some odd reason)
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: lockdep: avoid false positives about irq-safety
> 
> Commit 403a91b1 ("percpu: allow pcpu_alloc() to be called
> with IRQs off") introduced this warning:
> 
> 	=========================================================
> 	[ INFO: possible irq lock inversion dependency detected ]
> 	2.6.32-rc5-tip-04815-g12f0f93-dirty #745
> 	---------------------------------------------------------
> 	hub 1-3:1.0: state 7 ports 2 chg 0000 evt 0004
> 	ksoftirqd/65/199 just changed the state of lock:
> 	 (pcpu_lock){..-...}, at: [<ffffffff81130e04>] free_percpu+0x38/0x104
> 	but this lock took another, SOFTIRQ-unsafe lock in the past:
> 	 (vmap_area_lock){+.+...}
> 
> 	and interrupts could create inverse lock ordering between them.
> 
> This warning is bogus -- sched_init() is being called very early with IRQs
> disabled, and the irqsave/restore code paths in pcpu_alloc() are only for early
> init. The path can never be called from irq context once the early init
> finishes. Rationale for this is explained in changelog of the commit mentioned
> above.
> 
> This problem can be encountered generally in any other early code running
> with IRQs off and using irqsave/irqrestore.
> 
> Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Looks good to me.  Ingo, what do you think?

Thanks.

-- 
tejun
