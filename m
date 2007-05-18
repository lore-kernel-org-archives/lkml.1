Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXERNMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXERNMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXERNMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:12:09 -0400
Received: from omta01ps.mx.bigpond.com ([144.140.82.153]:20506 "EHLO
	omta01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbXERNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:12:08 -0400
Message-ID: <464DA61A.4040406@bigpond.net.au>
Date: Fri, 18 May 2007 23:11:54 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu>
In-Reply-To: <20070518071325.GB28702@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01ps.mx.bigpond.com from [144.131.192.218] using ID pwil3058@bigpond.net.au at Fri, 18 May 2007 13:11:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>> I've now done this test on a number of kernels: 2.6.21 and 2.6.22-rc1 
>> with and without CFS; and the problem is always present.  It's not 
>> "nice" related as the all four tasks are run at nice == 0.
> 
> could you try -v13 and did this behavior get better in any way?

It's still there but I've got a theory about what the problems is that 
is supported by some other tests I've done.

What I'd forgotten is that I had gkrellm running as well as top (to 
observe which CPU tasks were on) at the same time as the spinners were 
running.  This meant that between them top, gkrellm and X were using 
about 2% of the CPU -- not much but enough to make it possible that at 
least one of them was running when the load balancer was trying to do 
its thing.

This raises two possibilities: 1. the system looked balanced and 2. the 
system didn't look balanced but one of  top, gkrellm or X was moved 
instead of one of the spinners.

If it's 1 then there's not much we can do about it except say that it 
only happens in these strange circumstances.  If it's 2 then we may have 
to modify the way move_tasks() selects which tasks to move (if we think 
that the circumstances warrant it -- I'm not sure that this is the case).

To examine these possibilities I tried two variations of the test.

a. run the spinners at nice == -10 instead of nice == 0.  When I did 
this the load balancing was perfect on 10 consecutive runs which 
according to my calculations makes it 99.9999997 certain that this 
didn't happen by chance.  This supports theory 2 above.

b. run the tests without gkrellm running but use nice == 0 for the 
spinners.  When I did this the load balancing was mostly perfect but was 
quite volatile (switching between a 2/2 and 1/3 allocation of spinners 
to CPUs) but the %CPU allocation was quite good with the spinners all 
getting approximately 49% of a CPU each.  This also supports theory 2 
above and gives weak support to theory 1 above.

This leaves the question of what to do about it.  Given that most CPU 
intensive tasks on a real system probably only run for a few tens of 
milliseconds it probably won't matter much on a real system except that 
a malicious user could exploit it to disrupt a system.

So my opinion is that we probably do need to do something about it but 
that it's not urgent.

One thing that might work is to jitter the load balancing interval a 
bit.  The reason I say this is that one of the characteristics of top 
and gkrellm is that they run at a more or less constant interval (and, 
in this case, X would also be following this pattern as it's doing 
screen updates for top and gkrellm) and this means that it's possible 
for the load balancing interval to synchronize with their intervals 
which in turn causes the observed problem.  A jittered load balancing 
interval should break the synchronization.  This would certainly be 
simpler than trying to change the move_task() logic for selecting which 
tasks to move.

What do you think?
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
