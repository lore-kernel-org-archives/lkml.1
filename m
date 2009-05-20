Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZETDgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZETDgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 23:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZETDgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 23:36:10 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:60562 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZETDgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 23:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q2GqNE8IMJTfpHU3PzyYxOn14UD4iNuCXFHrheOW5Jm8ZkCuMz15VxofpqsAsG3+pB
         gX7yetuLfpTQnLsfaT0F1tEAi/Uet8zKSu8ii4pq5F35lgDbSdt+Ylk9rqWeJxgQJki6
         G7iXfHo84xUI6hcEl1Jb3Hu/Qk8xzVDBh0bnw=
MIME-Version: 1.0
In-Reply-To: <1242747203.4797.39.camel@johannes.local>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu>
	 <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
Date: Wed, 20 May 2009 11:36:10 +0800
Message-ID: <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency at 
	cleanup_workqueue_thread
From: Ming Lei <tom.leiming@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/19 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2009-05-19 at 14:00 +0200, Oleg Nesterov wrote:
>
>> > I'm not familiar enough with the code -- but what are we really trying
>> > to do in CPU_POST_DEAD? It seems to me that at that time things must
>> > already be off the CPU, so ...?
>>
>> Yes, this cpu is dead, we should do cleanup_workqueue_thread() to kill
>> cwq->thread.
>>
>> > On the other hand that calls
>> > flush_cpu_workqueue() so it seems it would actually wait for the work to
>> > be executed on some other CPU, within the CPU_POST_DEAD notification?
>>
>> Yes. Because we can't just kill cwq->thread, we can have the pending
>> work_structs so we have to flush.
>>
>> Why can't we move these works to another CPU? We can, but this doesn't
>> really help. Because in any case we should at least wait for
>> cwq->current_work to complete.
>>
>> Why do we use CPU_POST_DEAD, and not (say) CPU_DEAD to flush/kill ?
>> Because work->func() can sleep in get_online_cpus(), we can't flush
>> until we drop cpu_hotplug.lock.
>
> Right. But exactly this happens in the hibernate case -- the hibernate
> code calls kernel/cpu.c:disable_nonboot_cpus() which calls _cpu_down()
> which calls raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD... Sadly,
> it does so while holding the cpu_add_remove_lock, which is happens to
> have the dependencies outlined in the original email...
>
> The same happens in cpu_down() (without leading _) which you can trigger
> from sysfs by manually removing the CPU, so it's not hibernate specific.
>
> Anyway, you can have a deadlock like this:
>
> CPU 3                   CPU 2                           CPU 1
>                                                        suspend/hibernate
>                        something:
>                        rtnl_lock()                     device_pm_lock()
>                                                        -> mutex_lock(&dpm_list_mtx)
>
>                        mutex_lock(&dpm_list_mtx)

Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CPU2
and depends on rtnl_lock?
Thanks!

>
> linkwatch_work
>  -> rtnl_lock()
>                                                        disable_nonboot_cpus()
>                                                        -> flush CPU 3 workqueue
>
> johannes
>
>



-- 
Lei Ming
