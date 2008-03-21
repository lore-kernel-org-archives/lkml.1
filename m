Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYCUNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYCUNQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYCUNQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:16:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9478 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbYCUNQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:16:02 -0400
Date: Fri, 21 Mar 2008 14:15:59 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and  smp_call_function_single()
Message-ID: <20080321131558.GA15355@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321095343.GA21409@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > The patch series is also available in the 'generic-ipi' branch from
> > 
> > git://git.kernel.dk/linux-2.6-block.git
> > 
> > and the 'io-cpu-affinity' branch is directly based on this.
> 
> i'm still wondering about the following fundamental bit: why not use
> per CPU kernel threads? That way you get a fast (lockless) IPI "for
> free" as SMP wakeups already do this.

The kernel thread variant wont be any more lockless than the
smp_call_function_single() approach, they both have to grab the
destination queue lock. If you recall, I pushed forward on the kernel
thread variant and even still have it online here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=io-cpu-affinity-kthread

which is pretty much identical to io-cpu-affinity, except it uses kernel
threads for completion.

The reason why I dropped the kthread approach is that it was slower.
Time from signal to run was about 33% faster with IPI than with
wake_up_process(). Doing benchmark runs, and the IPI approach won hands
down in cache misses as well.

> smp_call_function() is quirky and has deep limitations on atomicity,
> etc., so we are moving away from it and should not base more
> functionality on it.

The patchset does not build on smp_call_function(), it merely cleans
that stuff up instead of having essentially the same code in each arch.
As more archs are converted, it'll remove lots more code.

The block stuff builds on smp_call_function_single(), which doesn't
suffer from any of the badness that smp_call_function() does.

-- 
Jens Axboe

