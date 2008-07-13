Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYGMISl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYGMISl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYGMISd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:18:33 -0400
Received: from c-71-205-80-56.hsd1.mi.comcast.net ([71.205.80.56]:45273 "EHLO
	monolith.glofar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYGMISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:18:31 -0400
Date: Sun, 13 Jul 2008 04:18:36 -0400 (EDT)
From: George Glover <hyperborean@comcast.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Runtime accounting bug?
In-Reply-To: <20080713000703.695ba036.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.1.00.0807130335400.3302@monolith>
References: <alpine.LNX.1.00.0807061330000.21901@monolith> <20080713000703.695ba036.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Andrew Morton wrote:

> On Sun, 6 Jul 2008 14:00:22 -0400 (EDT) George Glover <hyperborean@comcast.net> wrote:
>
>> Hello,
>>
>> I run two copies (dual processor system) of "mprime" from the GIMPS
>> project. After a while running (weeks?) the cumulative runtime reported by
>> top increments faster than real time, then after a while (unknown how long)
>> the value increments normally again.  Then, maybe something overflows - but
>> runtime accounting stops entirely even though the process is in the run state.
>>
>> (mprime is a cpu-bound low priority process like seti@home and friends.)
>>
>> I presently have a stuck process and a one that should soon start to
>> increment faster than possible.
>>
>> I have verified that the "stuck" process is indeed running since it continues
>> to generate output.
>>
>> Here is the "stuck" process:
>>
>> cat /proc/4126/stat; sleep 5;  cat /proc/4126/stat
>> 4126 (mprime) R 2984 4126 2984 34819 4126 4202496 16530 0 4 0 2124505930 661087 0 0 39 19 1 0 8442861 21483520 3733 4294967295 134512640 138881564 3220348480 3220345732 135248565 0 0 0 16386 0 0 0 17 1 0 0 0 0 0
>                                                                ^^^^^^^^^^
>> 4126 (mprime) R 2984 4126 2984 34819 4126 4202496 16530 0 4 0 2124505930 661087 0 0 39 19 1 0 8442861 21483520 3733 4294967295 134512640 138881564 3220348480 3220345736 135241038 0 0 0 16386 0 0 0 17 1 0 0 0 0 0
>                                                                ^^^^^^^^^^
>
> yes?  The 14th column, do_task_stat()'s cputime_to_clock_t(utime)?

Yup, that is what I discovered with a brief tour of the source I could 
find.  That particular task started to count up again a few days later, 
however at an accelerated rate 1.4-1.6x real time measuring that 14th 
field.  I am wondering if it is related to a timer problem that has been
reported recently:

 	http://lkml.org/lkml/2008/7/9/330

I can't say I've noticed my system clock advancing any faster however, 
maybe it's affecting only of the cpus and my clock app runs on the other.

I've rebooted since I wrote the message, so it may be a while before repeat 
behavior.

> My suspicion wold be that some of the arithmetic in here:
>
> static cputime_t task_utime(struct task_struct *p)
> {
> 	clock_t utime = cputime_to_clock_t(p->utime),
> 		total = utime + cputime_to_clock_t(p->stime);
> 	u64 temp;
>
> 	/*
> 	 * Use CFS's precise accounting:
> 	 */
> 	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
>
> 	if (total) {
> 		temp *= utime;
> 		do_div(temp, total);
> 	}
> 	utime = (clock_t)temp;
>
> 	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> 	return p->prev_utime;
> }
>
> is suffering overflows at very high values of p->utime.
>
> It's a 32bit machine, yes?

Yes it is.

> It would useful to know what your values of TICK_NSEC, NSEC_PER_SEC and
> USER_HZ are.

    TICK_NSEC is 999848
NSEC_PER_SEC is 1000000000
      USER_HZ is 100

Since the process did start ticking again I wonder if is not an overflow 
and related to that other post I linked.  I don't know enough about the 
various areas to judge though.

Let me know what else I can do if anything,

George
