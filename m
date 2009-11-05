Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZKEXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZKEXlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbZKEXlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:41:51 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60080 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZKEXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aL8LGNBVwWsqY60C2IaB8y/JQYClgbrfV+pN5CEjqDUlEDw7W3fKl3YgGYADeAumyn
         ypCSk6fcnc9Zxvc4U3R3XSbN5sWB1r9iA7vMGorRfyzQuAQdCA1GigL7++jYRq/bolZb
         zzud+es45pJq6gAhC9TGlj6bF/CO5iKL9aoVs=
Message-ID: <4AF36364.9090004@gmail.com>
Date: Thu, 05 Nov 2009 19:44:36 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Intermittent early panic in try_to_wake_up
References: <4AE0EBBD.6090005@gmail.com> <1256289781.22979.11.camel@marge.simson.net>
In-Reply-To: <1256289781.22979.11.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Thu, 2009-10-22 at 20:33 -0300, Kevin Winchester wrote:
>> Hi,
>>
>> A week or two ago I saw a panic on boot in try_to_wake_up, but it was not
>> reproducible and I had not written down any trace information.  This
>> evening I saw it twice more, but then on the third boot things worked fine.
>> This time I copied down the stack trace:
>>
>> try_to_wake_up+0x2e/0x102
>> wake_up_process+0x10/0x12
>> kthread_create+0x88/0x12c
>> ?ksoftirqd+0x00/0xb7
>> cpu_callback+0x42/0x8f
>> ?spawn_ksoftirqd+0x0/0x39
>> spawn_ksoftirqd+0x17/0x39
>> do_one_initcall+0x58/0x147
>>
>> The first time it happened, I remember checking the git logs and it was
>> shortly after:
>>
>> commit f5dc37530ba8a35aae0f7f4f13781d1904f71e94
>> Author: Mike Galbraith <efault@gmx.de>
>> Date:   Fri Oct 9 08:35:03 2009 +0200
>>
>>     sched: Update the clock of runqueue select_task_rq() selected
>>     
>>     In try_to_wake_up(), we update the runqueue clock, but
>>     select_task_rq() may select a different runqueue than the one we
>>     updated, leaving the new runqueue's clock stale for a bit.
>>     
>>     This patch cures occasional huge latencies reported by latencytop
>>     when coming out of idle on a mostly idle NO_HZ box.
>>     
>>     Signed-off-by: Mike Galbraith <efault@gmx.de>
>>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>     LKML-Reference: <1255070103.7639.30.camel@marge.simson.net>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>>
>> ...so perhaps that has something to do with it.
> 
> I don't think that's very likely.  Box did explode near my grubby
> fingerprints though.
> 
>> Config below.  Any help would be appreciated.
> 
> Building with your config, try_to_wake_up+0x2e is around..
> 
> (gdb) list *try_to_wake_up+0x2e
> 0xffffffff81029107 is in try_to_wake_up (kernel/sched.c:2324).
> 2319            this_cpu = get_cpu();
> 2320
> 2321            smp_wmb();
> 2322            rq = orig_rq = task_rq_lock(p, &flags);
> 2323            update_rq_clock(rq);
> 2324            if (!(p->state & state))
> 2325                    goto out;
> 2326
> 2327            if (p->se.on_rq)
> 2328                    goto out_running;
> 
> I don't see how any of that can explode without something very bad
> having happened to ksoftirqd before we tried to wake it.
> 

I thought this problem had solved itself, but I've hit it again three times
in the last few days.

I've expanded the CC list a little (based on get_maintainer for
kernel/softirq.c, since that seems to be involved somehow, and Rafael since
this definitely seems to be a regression), to see if anyone else has any
ideas.

-- 
Kevin Winchester

