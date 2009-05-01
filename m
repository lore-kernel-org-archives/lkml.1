Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZEABqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZEABqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZEABpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:45:53 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51427 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZEABpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uf7Ha1TRdX5Dc4lYbrk3KZ5GyKF60FG+pMs7Ijr+PPXUXur24fSMMuri18M4P74+6T
         NhtE7xdJ9ybsCLswHWNgeCKlaOVEXJ39PPhm9X4vGuZQHndxmaRZ4ANGI8evYVTBDqGv
         aS/FGntGh+HMjg8T+TH72PurXUY81RDfaFPx4=
MIME-Version: 1.0
In-Reply-To: <20090430181045.516cc106.akpm@linux-foundation.org>
References: <20090430151008.D21C.A69D9226@jp.fujitsu.com>
	 <20090430181045.516cc106.akpm@linux-foundation.org>
Date: Fri, 1 May 2009 10:45:52 +0900
X-Google-Sender-Auth: bdccde56af030258
Message-ID: <2f11576a0904301845m7ae6d501u989810857b96e74b@mail.gmail.com>
Subject: Re: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu 
	cputime count
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> For archs which define VIRT_CPU_ACCOUNTING, every tick would result
>> in >1000 units of cputime updates and since this is much much greater
>> than percpu_batch_counter, we end up taking spinlock on every tick.
>>
>> This patch change batch rule. now, any cpu can store "percpu_counter_bach * jiffies"
>> cputime in per-cpu cache.
>> it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n.
>
> Does this actually matter?
>
> If we're calling cpuacct_update_stats() with large values of `cputime'
> then presumably we're also calling cpuacct_update_stats() at a low
> frequency, so the common lock-taking won't cause performance problems?

VIRT_CPU_ACCOUNTING change cputime_t meaning. but don't change calling
update time frequency.

example,
ia64, HZ=1000, VIRT_CPU_ACCOUNTING=y (1 cputime == 1ns, ie 1 jiffies
== 1000000 cputime)

every tick updating makes 1000000 cputime. (see jiffies_to_cputime)

-----------------------------------------------------------------------------------------
void account_process_tick(struct task_struct *p, int user_tick)
{
        cputime_t one_jiffy = jiffies_to_cputime(1);
        cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
        struct rq *rq = this_rq();

        if (user_tick)
                account_user_time(p, one_jiffy, one_jiffy_scaled);
        else if (p != rq->idle)
                account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
                                    one_jiffy_scaled);
        else
                account_idle_time(one_jiffy);
}
-----------------------------------------------------------------------------------------

but tick updating frequency don't changed.
