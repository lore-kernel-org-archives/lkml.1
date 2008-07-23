Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYGWVWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYGWVWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYGWVWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:22:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:43247 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYGWVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xju6HtkiYBqlQAHFXrQNQYr+AE/dpMav1xi/Js2KgPJs0yBiiPgyuJ78To9w5COIUj
         HEiOo5tkd3b6NnenIkbvSZGRsReVmqwMnFKbSbVJiejzQ3Qt3TGfi723Nx7fq9oTKWC4
         FdOhff9nzDXg9EHHxWfbYiCoUXGdqjzX6k8b0=
Message-ID: <b647ffbd0807231422w546e59e9p8362ee798b169a25@mail.gmail.com>
Date: Wed, 23 Jul 2008 23:22:24 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <19f34abd0807231352j1ba1414am84ee9683df9b5657@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
	 <19f34abd0807231352j1ba1414am84ee9683df9b5657@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/23 Vegard Nossum <vegard.nossum@gmail.com>:
> On Wed, Jul 23, 2008 at 10:31 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
>> On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
>>> Hi,
>>>
>>> I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
>>> yesterday):
>>
>> Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
>> changes.
>>
>
> Humm... I got something different now on plain 2.6.26:
>
> ------------[ cut here ]------------
> WARNING: at kernel/sched_fair.c:815 hrtick_start_fair+0x158/0x170()

that's interesting. As a first step and if it's easily reproducible,
would you try something like below?

(hope, it compiles :-)

If it doesn't crash immediately, then 'p' is likely to be a real task
(well, we'll see then with p->comm) and if its cpu is different from
rq->cpu (must be in this case), then we might have a funny race
somewhere...

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -813,6 +813,9 @@ static void hrtick_start_fair(struct rq *rq,
struct task_struct *p)
        struct cfs_rq *cfs_rq = cfs_rq_of(se);

        WARN_ON(task_rq(p) != rq);
+       if (task_rq(p) != rq)
+               printk(KERN_ERR "task (%s)'s cpu (%d), rq's (%d)\n",
+                               p->comm, task_cpu(p), rq->cpu);

        if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
                u64 slice = sched_slice(cfs_rq, se);

>
> [ ... ]
>

-- 
Best regards,
Dmitry Adamushko
