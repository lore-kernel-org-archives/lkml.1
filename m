Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbXHBVIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbXHBVIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761182AbXHBVFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:05:38 -0400
Received: from wudika.de ([213.239.211.247]:48267 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777AbXHBVFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:05:36 -0400
Message-ID: <46B2471C.5060801@felicis.org>
Date: Thu, 02 Aug 2007 23:05:32 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org> <20070802114012.GA4067@elte.hu> <46B1F182.3010608@felicis.org> <20070802150350.GA3030@elte.hu> <46B1F4BA.4010107@felicis.org> <20070802151916.GA8688@elte.hu> <46B1FC6D.7010202@felicis.org> <20070802194825.GA23245@elte.hu>
In-Reply-To: <20070802194825.GA23245@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.2007 21:48, Ingo Molnar wrote:
> * Martin Roehricht <ml@felicis.org> wrote:
> 
>> On 08/02/2007 05:19 PM, Ingo Molnar wrote:
>> >* Martin Roehricht <ml@felicis.org> wrote:
>> >
>> >>That's fine with me, that within the same priority-queue any task can 
>> >>be chosen. But assume two tasks with highly different priorities, such 
>> >>as 105 and 135 are scheduled on the same processor and one of them is 
>> >>now to be migrated -- shouldn't be the queue with task P=105 
>> >>considered first for migration by this code? Both tasks would use 
>> >>different queues with their own linked lists, right?
>> >
>> >yes. What makes you believe that the lower priority one (prio 135) is 
>> >chosen? [ as i said before, that will only be chosen if all tasks in the 
>> >higher-priority queue (prio 105) are either already running on a CPU or 
>> >have recently run so that the cache-hot logic skips them. ]
>> 
>> This believe is primarily based on my observations of multiple 
>> benchmark runs and also on your statement earlier: »in the SMP 
>> migration code, the 'old scheduler' indeed picks the lowest priority 
>> one«.
> 
> oh, sorry, that was meant to be the 'highest priority one' :-/
> 
> so i think you got it all right, i just typoed that first sentence.

Okay, now I think I understood this part of the code correctly. The 
reason why I observe a continous migration of the _lower_ priority tasks 
is most probably due to the fact that the higher priority one is 
currently running, according to:
	can_migrate_task() in move_tasks(), and therein:

	if (task_running(rq, p))
		return 0;

I tracked down via an extended /proc/schedstats that my tasks fall 
frequently into this pitfall. I basically solved it by making use of the 
more active push-strategy which is called later by load_balance() once 
the move_tasks() function did not succeed. So in case I need the higher 
priority tasks, I return immediately from move_tasks().

Thanks for your help,
Martin
