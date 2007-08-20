Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbXHTS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbXHTS3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXHTS3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:29:20 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:40203 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXHTS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:29:19 -0400
Subject: Re: [accounting regression since rc1]  scheduler updates
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070820180810.GA25160@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	 <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu>
	 <1187629438.8541.40.camel@localhost>  <20070820180810.GA25160@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 20 Aug 2007 20:33:02 +0200
Message-Id: <1187634782.4028.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 20:08 +0200, Ingo Molnar wrote:
> For sched_clock()'s behavior while the virtual CPU is idle: my current 
> idea for that is the patch below (a loosely analoguous problem exists 
> with nohz/dynticks): it makes sched_clock() valid across idle periods 
> too and uses wall-clock time for that.

Ok, that would mean that sched_clock can just return the virtual cpu
time and the two hooks starts and stops the idle periods as far as the
scheduler is concerned. In this case we can use the patch from Jan with
the new implementation for sched_clock and add the two hooks to the
places where the cpu-idle notifiers are done (do_monitor_call and
default_idle). In fact this could be an idle-notifier. Hmm, I take a
closer look tomorrow when I'm back at the office.

> If a virtual CPU is idle then i think the "real = steal, virtual = 0" 
> way of thinking about idle looks a bit unnatural to me - wouldnt it be 
> better to think in terms of "steal = 0, virtual = real" ? Basically a 
> virtual CPU can idle at "perfect speed", without the host "stealing" any 
> cycles from it. And with that way of thinking, if s390 passed in the 
> real-idle-time value to the new callbacks below it would all fall into 
> place. Hm?

How you think about an idle cpu depends on your viewpoint. The source
for the virtual cpu time on s390 is the cpu timer. This timer is stopped
when a virtual cpu looses the physical cpu, so it seems natural to me to
think that real=steal, virtual=0 because the cpu timer is stopped while
the cpu is idle. The other way of thinking about it is as valid though.

> that way we'd have a meaningful sched_clock() across idle periods too, 
> useful for tracers, better scheduler debug-statistics, etc.

That would be good.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


