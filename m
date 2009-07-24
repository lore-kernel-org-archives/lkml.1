Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZGXNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZGXNMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZGXNMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:12:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:52590 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZGXNMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pBLToS7MPCsyLC5ZYX5XHP2GYChKu22mAHrFRl8Lha/CwUqwmzE/2XS3jEBYnJR9Sq
         T+h0ETlOK56xMZgtVXhqGs/WQq1u1SgAXI/jJr9HCouK/wBIC43ySqbl6fW9pNRVSI4p
         z8Vh3P6wOwqjJ0W5r95NI8Zh92k5uXtVTxWew=
MIME-Version: 1.0
In-Reply-To: <1248437670.6987.26.camel@twins>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
Date: Fri, 24 Jul 2009 21:04:46 +0800
Message-ID: <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
Subject: Re: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux is used in many fieldes. SCHED_OTHER tasks is important to
embedded system.

if there is a running state task（a realtime task）, how can we shcedule
the idle task up?
It is ridiculous！

since the throttle has a bug, why not fix it?

we just modify the codes of  checking conditions of picking rt taskes!

static struct task_struct *pick_next_task_rt(struct rq *rq)
{
 ...

       if (rt_rq_throttled(rt_rq)&& rq->cfs.nr_running)
               return NULL;

 ...
}

2009/7/24 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2009-07-24 at 18:57 +0800, sen wang wrote:
>> I find something is wrong about sched_rt.
>>
>>  when I am debugging my system with rt_bandwidth_enabled, there is a
>> running realtime FIFO task in the sched_rt running queue and
>>  the fair running queue is empty.  I found the idle task will be
>> scheduled up when the running task still lie in the  sched_rt running
>> queue!
>>
>> this will happen when rt runqueue passed it's rt_bandwidth_enabled
>> runtime,then the scheduler choose the idle task instead of realtime
>> FIFO task.
>>
>> the reason lie in: when scheduler try to pick up a realtime FIFO task,
>> it will check if rt_throttled is enabled,
>> if so, it'll return and try fair queue but it is empty, then it come
>> to the sched_idle class.
>>
>> I don't think it reasonable, we should give the realtime FIFO task the
>> chance, even when rt runqueue passed it's runtime.
>> because it is cpu's free time.
>>
>> To fix it ,and keep rt_bandwidth works as before, I think
>> pick_next_task_rt() is the best space,
>
> RT is about determinism, sometimes having some extra time dependent on
> the runnability of SCHED_OTHER tasks is utterly useless.
>
> If you don't like the throttle, disable it.
>
>
>
