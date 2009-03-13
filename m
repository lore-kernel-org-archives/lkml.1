Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZCMMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZCMMXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZCMMXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 08:23:32 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33652 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZCMMXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 08:23:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18874.20538.785519.824803@cargo.ozlabs.ibm.com>
Date: Fri, 13 Mar 2009 23:23:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
In-Reply-To: <1236939816.22914.3714.camel@twins>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
	<1236939816.22914.3714.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> The former case however, you seem to say we should keep software
> counters active even though their associated task is scheduled out? That
> doesn't appear to make sense to me.
> 
> Why would you want to do that?

Because the things that they are based on can get incremented when the
task is scheduled out.  This is most noticeable in the case of the
context switch counter and also happens with the task migrations
counter.  These *always* get incremented when the task is scheduled
out from the perf_counter subsystem's point of view, i.e. after
perf_counter_task_sched_out is called for the task and before the next
perf_counter_task_sched_in call.  I believe page faults can also
happen while the task is scheduled out, via access_process_vm.

I also originally thought that software counters should only count
while their task is scheduled in, which is why I introduced the bug
that I fixed in c07c99b67233ccaad38a961c17405dc1e1542aa4.  That commit
however left us with software counters that counted even when their
group wasn't on; hence the current patch.

Paul.
