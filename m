Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbYEAQyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbYEAQyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYEAQyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:54:38 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:2763 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYEAQyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:54:37 -0400
Message-Id: <4819BDA3.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 01 May 2008 10:54:59 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Bahi" <DBahi@novell.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix inv_weight calc
References: <20080430171521.5454.91644.stgit@ghaskins-t60p.haskins.net>
 <1209581148.6433.47.camel@lappy>
In-Reply-To: <1209581148.6433.47.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Peter and I have been discussing this on IRC, but thought we should take some new findings to a wider audience)....

>>> On Wed, Apr 30, 2008 at  2:45 PM, in message <1209581148.6433.47.camel@lappy>,
Peter Zijlstra <peterz@infradead.org> wrote: 
> On Wed, 2008-04-30 at 13:15 -0400, Gregory Haskins wrote:
>> We currently have a bug in sched-devel where the system will fail to
>> balance tasks if CONFIG_FAIR_GROUP_SCHED=n.  To reproduce, simply launch
>> a workload with multiple tasks and observe (either via top or
>> /proc/sched_debug) that the tasks do not distribute much (if at all)
>> around to all available cores. Instead, they tend to clump on one processor
>> while the other cores are idle.
>> 
>> Bisecting, we found the culprit to be:
>> 
>> 	commit 1b9552e878a5db3388eba8660e8d8400020a07e9
>> 	Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> 	Date:   Tue Apr 29 13:47:36 2008 +0200
>> 	Subject: sched: higher granularity load on 64bit systems
>> 
>> Once we identified this patch as the problem, I studied what possible
>> effect it could have with FAIR_GROUP_SCHED=n vs y.  Most of the code in
>> 1b9552e8 would be compiled out if we disable group-scheduling, but there
>> is one particular logic change in calc_delta_mine() that affects both modes
>> that looked suspicious.  It changes the computation of the inverse-weight
>> from:
>> 
>>     inv_weight = (WMULT_CONST-weight/2)/(weight+1)
>> 
>> to
>> 
>>     inv_weight = 1+(WMULT_CONST-weight/2)/(weight+1)
>> 
>> This patch restores the algorithm to its original logic, and seems to solve
>> the regression for me.  I can't really wrap my head around the original
>> intent of the "+1" change, or whether reverting the change will cause a
>> ripple effect somewhere else.  All I can confirm is that the system will
>> once again balance load with this logic reverted to its previous form.
> 
> I didn't intend that change to sneak into this patch - but it was
> sort-of intentional. My rationale was, a normal rounding division does:
> 
>   (x + y/2) / y
> 
> Since our 'x' is at the upper end of our modulo space we can't add to it
> for it would wrap and end up small. Therefore we do:
> 
>  (x - y/2) / y
> 
> Which would result in 1 less than expected, hence I added that 1 back.

Ah, yes.  That makes sense.

> 
> Now I'm equally puzzled on its effect. Nor do I mind its removal, but I
> would like to understand why it has such drastic effects.

Nevermind my patch, its bogus.  I was mistaken earlier in thinking it was better with the "+1" removed.  Subsequent testing has demonstrated that the issue is still present, even with my "fix" applied.  The root issue seems to be real, but I cant spy it in the code via visual inspection.  Reverting the patch outright does seem to restore proper balancer behavior.  (Note that the commit-id for Peter's patch has since changed...probably due to a recent rebase in sched-devel).  Perhaps someone with a better understanding of the load calculation will see it.

Regards,
-Greg



