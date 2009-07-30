Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZG3BUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZG3BUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZG3BUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:20:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62783 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZG3BUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:20:05 -0400
Message-ID: <4A70F4EA.8010503@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 09:18:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       jens.axboe@oracle.com, nickpiggin@yahoo.com.au, peterz@infradead.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 -mm] generic-ipi: fix hotplug_cfd()
References: <4A6983D8.8090805@cn.fujitsu.com>	<4A6FFFE9.5070204@cn.fujitsu.com> <20090729162756.20a34174.akpm@linux-foundation.org>
In-Reply-To: <20090729162756.20a34174.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07:27, Andrew Morton wrote:
> On Wed, 29 Jul 2009 15:53:13 +0800
> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> Use CONFIG_HOTPLUG_CPU, not CONFIG_CPU_HOTPLUG
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  kernel/smp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index bf9f18b..1b5fd2e 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -54,7 +54,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>>  			return NOTIFY_BAD;
>>  		break;
>>  
>> -#ifdef CONFIG_CPU_HOTPLUG
>> +#ifdef CONFIG_HOTPLUG_CPU
>>  	case CPU_UP_CANCELED:
>>  	case CPU_UP_CANCELED_FROZEN:
>>  
> 
> Dammit, that mistake is easy to make.  We should have used #if from day
> one, not #ifdef.  Oh well.
> 
> What's the impact of this bug?  Do we think the fix should be present
> in 2.6.31?  2.6.30.x?
> 

When hot-unpluging a cpu, it will leak memory allocated at cpu hotplug,
but only if CPUMASK_OFFSTACK=y, which is default to n, and I guess no
distro turns it on? All that said, I agree to add this patch to
-stable.

The bug is introduced by:

| commit 8969a5ede0f9e17da4b943712429aef2c9bcd82b
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Wed Feb 25 13:59:47 2009 +0100
|
|    generic-ipi: remove kmalloc()

So this patch can be applied to 2.6.29..2.6.31

