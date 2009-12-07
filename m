Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbZLGEeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbZLGEeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934480AbZLGEeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:34:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:39913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934476AbZLGEeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:34:06 -0500
Message-ID: <4B1C85D3.3080401@kernel.org>
Date: Mon, 07 Dec 2009 13:34:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
In-Reply-To: <1259923381.3977.1934.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 12/04/2009 07:43 PM, Peter Zijlstra wrote:
>>> force_cpus_allowed() will be used for concurrency-managed workqueue.
>>
>> Would still like to know why all this is needed.
> 
> That is, what problem do these new-fangled workqueues have and why is
> this a good solution.

This is the original RFC posting of cmwq which includes the whole
thing.  I'm a few days away from posting a new version but the usage
of force_cpus_allowed() remains the same.

  http://thread.gmane.org/gmane.linux.kernel/896268/focus=896294

There are two tests which are bypassed by the force_ variant.

* PF_THREAD_BOUND.  This is used to mark tasks which are bound to a
  cpu using kthread_bind() to be bound permanently.  However, new
  trustee based workqueue hotplugging decouples per-cpu workqueue
  flushing with cpu hot plug/unplugging.  This is necessary because
  with cmwq, long running works can be served by regular workqueues,
  so delaying completion of hot plug/unplugging till certain works are
  flushed isn't feasible.  So, what becomes necessary is the ability
  to re-bind tasks which has PF_THREAD_BOUND set but unbound from its
  now offline cpu which is coming online again.

* cpu_active() test.  CPU activeness encloses cpu online status which
  is the actual on/offline state.  Workqueues need to keep running
  while a cpu is going down and with cmwq keeping workqueues running
  involves creation of new workers (it consists part of
  forward-progress guarantee and one of cpu down callbacks might end
  up waiting on completion of certain works).

  The problem with active state is that during cpu down, active going
  off doesn't mean all tasks have been migrated off the cpu, so
  without a migration interface which is synchronized with the actual
  offline migration, it is difficult to guarantee that all works are
  either running on the designated cpu if the cpu is online or all
  work on other cpus if the cpu is offline.

  Another related problem is that there's no way to monitor the cpu
  activeness change notifications.

Thanks.

-- 
tejun
