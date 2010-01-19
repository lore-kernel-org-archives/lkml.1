Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011Ab0ASBVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0ASBVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958Ab0ASBVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:21:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51991 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0ASBVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:21:48 -0500
Message-ID: <4B5508AF.1080302@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 09:19:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf_event: fix race in	perf_swevent_get_recursion_context()
References: <4B54654A.4090601@cn.fujitsu.com> <20100118164128.GI10364@nowhere>
In-Reply-To: <20100118164128.GI10364@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Mon, Jan 18, 2010 at 09:42:34PM +0800, Xiao Guangrong wrote:
>> It only disable preemption in perf_swevent_get_recursion_context()
>> it can't avoid race of hard-irq and NMI
>>
>> In this patch, we use atomic operation to avoid it and reduce
>> cpu_ctx->recursion size, it also make this patch no need diable
>> preemption
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> 
> 
> I don't understand what is racy in what we have currently.
> 

It's because hard-irq(we can handle interruption with interruption enabled)
and NMI are nested, for example:

int perf_swevent_get_recursion_context(void)
{
	......
	if (cpuctx->recursion[rctx]) {
		put_cpu_var(perf_cpu_context);
		return -1;
	}

	/*
	 * Another interruption handler/NMI will re-enter there if it
	 * happed, it make the recursion value chaotic
	 */
	cpuctx->recursion[rctx]++;
	......
}

> 
> 
>>  int perf_swevent_get_recursion_context(void)
>>  {
>> -	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
>> +	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
>>  	int rctx;
>>  
>>  	if (in_nmi())
>> @@ -3933,13 +3933,8 @@ int perf_swevent_get_recursion_context(void)
>>  	else
>>  		rctx = 0;
>>  
>> -	if (cpuctx->recursion[rctx]) {
>> -		put_cpu_var(perf_cpu_context);
>> +	if (test_and_set_bit(rctx, &cpuctx->recursion))
>>  		return -1;
> 
> 
> 
> This looks broken. We don't call back perf_swevent_put_recursion_context
> in fail case, so the bit won't ever be cleared once we recurse.
> 

Um, i think we can't clear the bit in this fail case, consider below
sequence:

 path A:                                path B

                                set bit but find the bit already set
 atomic set bit                                 |
    |                                           |
    V                                           |
 handle SW event                                | 
    |                                           V
    V                               exit and not clear the bit 
 atomic clear bit

After A and B, the bit is still zero

Right? :-)

Thanks,
Xiao
