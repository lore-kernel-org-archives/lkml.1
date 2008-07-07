Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYGGLbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYGGLbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYGGLbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:31:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2371 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYGGLbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a51w07GZ1pGR4wcVsCBP9QCi9Cq24lEZYYhMWow281RzCTKcDePxPHV7MvQu/Rtnkf
         L2267qVNhHW87OXfKzLECQMInhMDNN4XZ1Ad9PiiIshaFAOMDTFH9MkAZBgC+RzT9phf
         BXlB6rW5NXkXk1Vc1uTRg45gepBZP/5EDjVlQ=
Message-ID: <b647ffbd0807070431x633c9d88x8104801bd0efdc20@mail.gmail.com>
Date: Mon, 7 Jul 2008 13:31:41 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: miaox@cn.fujitsu.com
Subject: Re: [BUG] CFS vs cpu hotplug
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Avi Kivity" <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4871EF49.6000501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080619161949.GA11062@osiris.ibm.com>
	 <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
	 <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>
	 <20080630091711.GA26637@elte.hu> <4869F770.6050103@cn.fujitsu.com>
	 <20080701093124.GC31309@elte.hu> <486B2AB0.1080506@cn.fujitsu.com>
	 <b647ffbd0807020150y650c3172me64b70710a8158d7@mail.gmail.com>
	 <486B490C.3090902@cn.fujitsu.com> <4871EF49.6000501@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/7 Miao Xie <miaox@cn.fujitsu.com>:
> on 3:59 Lai Jiangshan wrote:
>> Dmitry Adamushko wrote:
>>>
>>> [ ... ]
>>>
>>> We should see then all tasks that have been migrated (or failed to be
>>> migrated) during migration_call(CPU_DEAD, ...).
>>>
>> Thank you. I'll test it again with your debugging patch applied
>> and get more info.
>
> I tested it with Dmitry's patch, and found that all the tasks on the offline
> cpu were migrated to an online cpu by migrate_live_tasks() in migration_call().
> But some tasks(such as klogd and so on)was moved back to the offline cpu
> immediately before BUG_ON(rq->nr_running != 0) checking, even before acquiring
> rq's lock.
>
>        static int __cpuinit
>        migration_call(struct notifier_block *nfb, unsigned long action, void *
>        {
>                ...
>                switch (action) {
>                ...
>                case CPU_DEAD:
>                case CPU_DEAD_FROZEN:
>                        cpuset_lock();
>                        migrate_live_tasks(cpu);
>                        rq = cpu_rq(cpu);
>                        ...
>                        spin_lock_irq(&rq->lock);
>                        ...
>                        migrate_dead_tasks(cpu);
>                        spin_unlock_irq(&rq->lock);
>                        cpuset_unlock();
>                        migrate_nr_uninterruptible(rq);
>                        BUG_ON(rq->nr_running != 0);
>                        ...
>                        break;
>                }
>                ...
>        }
>
> By debuging, I found this bug was caused by select_task_rq_fair().

Thanks for tracking this down!


> After migrating the tasks on the offline cpu to an online cpu, the kernel would
> wake up these migrated tasks quickly by try_to_wake_up(). try_to_wake_up() would
> invoke select_task_rq_fair() to find a lower-load cpu in sched domains for them.
> But the sched domains weren't updated and the offline cpu was still in the sched
> domains.

Hmm... if so, then this should be fixed, not select_task_rq_fair(). I
don't think this is expected behavior.


> So select_task_rq_fair() might return the offline cpu's id, then the
> bug occurred.
>
> I fix the bug just by checking the select_task_rq_fair()'s return value in
> try_to_wake_up().
>
> [ ... ]


-- 
Best regards,
Dmitry Adamushko
