Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYILPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYILPxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYILPxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:53:09 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:40305 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYILPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:53:08 -0400
Message-ID: <48CA9059.1020209@nortel.com>
Date: Fri, 12 Sep 2008 09:52:57 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: ego@in.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
 one	task
References: <20080905123004.GD6238@in.ibm.com>
In-Reply-To: <20080905123004.GD6238@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2008 15:53:01.0642 (UTC) FILETIME=[A2B722A0:01C914EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> sched: Fix __load_balance_iterator() for cfq with only one task.
> 
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> The __load_balance_iterator() returns a NULL when there's only one
> sched_entity which is a task. It is caused by the following code-path.
> 
> 
> 	/* Skip over entities that are not tasks */
> 	do {
> 		se = list_entry(next, struct sched_entity, group_node);
> 		next = next->next;
> 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> 
> 	if (next == &cfs_rq->tasks)
> 		return NULL;
> 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>       This will return NULL even when se is a task.

Thank you!  I'd been looking suspiciously at this routine as well due to 
strange load-balancing behaviour that I saw while testing the fair group 
code, but I hadn't yet tracked down the exact problem.

Peter/Ingo, this appears to explain the issues described in the mail I 
sent on the 4th.  After applying this change the imbalance between tasks 
in the same group is substantially reduced.

Chris
