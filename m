Return-Path: <linux-kernel-owner+w=401wt.eu-S1765394AbXGPPEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765394AbXGPPEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbXGPPDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:03:49 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.85]:49674 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760438AbXGPPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:03:48 -0400
Message-ID: <469B8887.8020906@andrew.cmu.edu>
Date: Mon, 16 Jul 2007 11:02:31 -0400
From: James Bruce <bruce@andrew.cmu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
References: <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <20070716074102.GA18512@elte.hu>
In-Reply-To: <20070716074102.GA18512@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>> * James Bruce <bruce@andrew.cmu.edu> wrote:
>>> While we're at it, isn't the comment above the wmult table incorrect? 
>>> The multiplier is 1.25, meaning a 25% change per nice level, not 10%.
>> yes, the weight multiplier 1.25, but the actual difference in CPU 
>> utilization, when running two CPU intense tasks, is ~10%:
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>  8246 mingo     20   0  1576  244  196 R   55  0.0   0:11.96 loop
>>  8247 mingo     21   1  1576  244  196 R   45  0.0   0:10.52 loop
>>
>> so the first task 'wins' +10% CPU utilization (relative to the 50% it 
>> had before), the second task 'loses' -10% CPU utilization (relative to 
>> the 50% it had before).
>>
>> so what the comment says is true:
>>
>>  * The "10% effect" is relative and cumulative: from _any_ nice level,
>>  * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
>>  * it's +10% CPU usage.
>>
>> for there to be a ~+10% change in CPU utilization for a task that 
>> races against another CPU-intense task there needs to be a ~25% change 
>> in the weight.
> 
> in any case more documentation is justified, so i've added some 
> clarification to the comments - see the patch below.

Ah ok so it's 10% of the original CPU usage, not relative to a tasks
share from before.  While I guess I still think in terms of relative CPU
share, your comments now make sense to me.  Thanks for the
clarification.

  - Jim

> ------------------------>
> Subject: sched: improve weight-array comments
> From: Ingo Molnar <mingo@elte.hu>
> 
> improve the comments around the wmult array (which controls the weight
> of niced tasks). Clarify that to achieve a 10% difference in CPU
> utilization, a weight multiplier of 1.25 has to be used.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -736,7 +736,9 @@ static void update_curr_load(struct rq *
>   *
>   * The "10% effect" is relative and cumulative: from _any_ nice level,
>   * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
> - * it's +10% CPU usage.
> + * it's +10% CPU usage. (to achieve that we use a multiplier of 1.25.
> + * If a task goes up by ~10% and another task goes down by ~10% then
> + * the relative distance between them is ~25%.)
>   */
>  static const int prio_to_weight[40] = {
>  /* -20 */ 88818, 71054, 56843, 45475, 36380, 29104, 23283, 18626, 14901, 11921,

