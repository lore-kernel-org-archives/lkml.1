Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXKAFyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXKAFyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXKAFyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:54:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48967 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbXKAFyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:54:03 -0400
Date: Thu, 1 Nov 2007 11:36:38 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched: fix new task startup crash
Message-ID: <20071101060638.GA3134@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1193846459.27652.220.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193846459.27652.220.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 05:00:59PM +0100, Peter Zijlstra wrote:
> Hi,

Hi Peter,

> Commit: b9dca1e0fcb696716840a3bc8f20a6941b484dbf
> 
> seems to me that by calling enqueue_fair_task() from task_new_fair() is
> wrong. The wakeup=1 in enqueue_fair_task() will cause all non-top

s/non-top/non-task?

> sched_entities to be re-positioned by place_entity().

yes, provided they weren't on the tree before (i.e the task being
enqueued is the first task of that group on that particular cpu).

If a group doesn't have any tasks on a particular cpu, then the group's
sched entity object for that cpu will not be present in a cfs_rq
(tg->se[i]->on_rq = 0). Subsequently, after some time T, when a task gets
added to the group's cfs_rq on that cpu, then the group sched entity
object also gets added to the cfs_rq. 

This time T is effectively the sleep time for the group sched entity
object, when it was sleeping waiting for tasks to get added on that cpu.
Hence enqueue of group level sched entity objects is always treated as
if they woke up from sleep (and be repositioned in the tree via
place_entity, rather than go back to the same position it was (se->vruntime) 
when it went to sleep).

That sounds correct to me. If we don't treat enqueue of group level
entities as "wakeup from sleep", then a group that gets a task added
on a cpu after long time, will "hog" the cpu trying to catch up for all
lost time?

> Although the current implementation thereof seems to avoid doing
> something horrible.

-- 
Regards,
vatsa
