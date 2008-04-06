Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYDFXst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYDFXst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 19:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYDFXsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 19:48:38 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:43282 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbYDFXsi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 19:48:38 -0400
Date: Mon, 7 Apr 2008 00:48:33 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       lkml <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>, skumar@linux.vnet.ibm.com
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080406234833.GA12131@deepthought>
References: <20080403191916.GA30864@deepthought> <20080404143701.GA13042@linux.vnet.ibm.com> <20080404153232.GC21753@deepthought> <20080405144042.GB24075@linux.vnet.ibm.com> <20080405210347.GA19097@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080405210347.GA19097@deepthought>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2008 at 10:03:47PM +0100, Ken Moffat wrote:
> On Sat, Apr 05, 2008 at 08:10:43PM +0530, Srivatsa Vaddagiri wrote:
> > 
> > Given that you seem to be seeing the problem even without
> > CONFIG_GROUP_SCHED, only the second hunk of the patch seems to be making
> > a difference for your problem i.e just the hunk below applied on
> > 2.6.25-rc8 (to kernel/sched_fair.c) should fix your problem too:
> > 
> > @@ -1145,7 +1145,7 @@ static void check_preempt_wakeup(struct 
> >  	 * More easily preempt - nice tasks, while not making
> >  	 * it harder for + nice tasks.
> >  	 */
> > -	if (unlikely(se->load.weight > NICE_0_LOAD))
> > +	if (unlikely(se->load.weight != NICE_0_LOAD))
> >  		gran = calc_delta_fair(gran, &se->load);
> >  
> >  	if (pse->vruntime + gran < se->vruntime)
> > 
> > [The first hunk is a no-op under !CONFIG_GROUP_SCHED, since
> > entity_is_task() is always 1 for !CONFIG_GROUP_SCHED]
> > 
> > This second hunk changes how fast + or - niced tasks get preempted. 
> > 
> > 2.6.25-rc8 (Bad case):
> > 	Sets preempt granularity for + niced tasks at 5ms (1 CPU)
> > 
> > 2.6.25-rc8 + the hunk above (Good case):
> > 	Sets preempt granularity for + niced tasks at >5ms
> > 
>  Well, I'm no longer sure exactly what was in the config, but after
> I had confirmed the reversion would fix 2.6.24.4 I _did_ try just
> the second part of the patch applied to 2.6.25-rc8 and it gave a 60%
> success rate across 10 tests.
> > 
> > So bumping up preempt granularity for + niced tasks seems to make things
> > work for you. IMO the deeper problem lies somewhere else (perhaps is
> > some race issue in gdm itself), which is easily exposed with 2.6.25-rc8 
> > which lets + niced tasks be preempted quickly.
> > 
> 
>  I agree this is probably exposing a problem somewhere else.
> 
> > To help validate this, can you let us know the result of tuning preempt
> > granularity on native 2.6.25-rc8 (without any patches applied and
> > CONFIG_GROUP_SCHED disabled)?
> > 
> > 	# echo 100000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> > 
> > To check if echo command worked, do:
> > 
> > 	# cat /proc/sys/kernel/sched_wakeup_granularity_ns
> > 
> > It should return 100000000.
> > 
> > Now try shutting down thr' gdm and pls let me know if it makes a
> > difference.
> > 
> > -- 
> > Regards,
> > vatsa
> 
>  Will do, but it might be a day or so before I can get to this.
> 
> Thanks.
> 
> Ken

 Well, I found your analysis convincing.  Unfortunately, my hardware
disagreed.  Testing -rc8 with CONFIG_GROUP_SCHED disabled (a test is
a mixture of 5 attempts to restart and 5 to shutdown):

1. the base version success is 4/10

2. increasing the granularity by a factor of 10 as you requested,
success is 8/10

3. applying the second part of the patch (and not altering the
granularity) success is 3/10

4. applying both parts of the patch (and not altering the
granularity), success is 5/10.

 Clearly, 3/10 and 5/10 may not be meaningfully different on such a
small sample size (but, 10 attempts is probably as much as my mind
and blood-pressure can stand!).  Whether 8/10 is meaningfully better
I don't know, the point is that it still failed some of the time.

 At this point, I started to doubt my previous results, so I
retested rc8 with CONFIG_GROUP_SCHED=y and both parts of the patch,
and again success is 10/10.  So, that combination has run through at
least 20 shutdowns or restarts without a problem.

 Summary: if I apply the patch to revert both hunks, AND use
CONFIG_GROUP_SCHED, everything is good.  All other variations fail
sooner or later within 10 tests (for the little it's worth, the
longest string of successful runs between failures is 6, so a
minimum of 10 tests is probably necessary before saying a version
seems ok).

 If I was confused earlier, I guess I must be dazed and confused
now!

Ken
-- 

das eine Mal als Tragödie, das andere Mal als Farce
