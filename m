Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbYJTV5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbYJTV5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJTV53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:57:29 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:34069 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJTV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:57:29 -0400
Message-ID: <48FCFEC1.9000800@nortel.com>
Date: Mon, 20 Oct 2008 15:57:21 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 4/4] sched: fix wakeup preemption
References: <20081017172701.047939625@chello.nl> <20081017172829.768067427@chello.nl>
In-Reply-To: <20081017172829.768067427@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2008 21:57:22.0772 (UTC) FILETIME=[D4A95940:01C932FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

 > In my recent wakeup preempt rework I messed up the asym wakeup.
 > The idea is that it should be easier to preempt lighter tasks
 > but not harder to preempt heavier tasks.

 > Index: linux-2.6/kernel/sched_fair.c
 > ===================================================================
 > --- linux-2.6.orig/kernel/sched_fair.c
 > +++ linux-2.6/kernel/sched_fair.c
 > @@ -1243,8 +1243,8 @@ static unsigned long wakeup_gran(struct
 >   	 * More easily preempt - nice tasks, while not making it harder for
 >   	 * + nice tasks.
 >   	 */
 > -	if (sched_feat(ASYM_GRAN))
 > -		gran = calc_delta_mine(gran, NICE_0_LOAD, &se->load);
 > +	if (sched_feat(ASYM_GRAN) && se->load.weight < NICE_0_LOAD)
 > +		gran = (gran * se->load.weight) >> NICE_0_SHIFT;
 >
 >   	return gran;
 >   }

Setting aside whether the asym wakeup is desirable, the code looks 
reasonable but I think you need to change the code comments as well.

The proposed code only affects with a weight of less than NICE_0_LOAD, 
ie. +nice tasks.  The comment suggests the opposite.

Chris
