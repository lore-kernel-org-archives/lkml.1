Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab0CAQad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:30:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:49658 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0CAQab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:30:31 -0500
Message-ID: <4B8BEE01.4040006@kernel.org>
Date: Tue, 02 Mar 2010 01:40:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 17/43] workqueue: update cwq alignement
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-18-git-send-email-tj@kernel.org> <20100228171255.GA20167@redhat.com>
In-Reply-To: <20100228171255.GA20167@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 16:29:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/01/2010 02:12 AM, Oleg Nesterov wrote:
> On 02/26, Tejun Heo wrote:
>>
>> +static struct cpu_workqueue_struct *alloc_cwqs(void)
>> +{
>> +	const size_t size = sizeof(struct cpu_workqueue_struct);
>> +	const size_t align = 1 << WORK_STRUCT_FLAG_BITS;
>> +	struct cpu_workqueue_struct *cwqs;
>> +#ifndef CONFIG_SMP
>> +	void *ptr;
>> +
>> +	/*
>> +	 * On UP, percpu allocator doesn't honor alignment parameter
>> +	 * and simply uses arch-dependent default.  Allocate enough
>> +	 * room to align cwq and put an extra pointer at the end
>> +	 * pointing back to the originally allocated pointer which
>> +	 * will be used for free.
>> +	 */
>> +	ptr = __alloc_percpu(size + align + sizeof(void *), 1);
>> +	cwqs = PTR_ALIGN(ptr, align);
>> +	*(void **)per_cpu_ptr(cwqs + 1, 0) = ptr;
>> +#else
> 
> Nice trick, but perhaps it would be more simple/clear to just add
> "void *my_memory" into cpu_workqueue_struct, under !CONFIG_SMP ?

I agree that it's ugly but wanted to contain it inside
alloc/free_cwqs() as this is something which should be handled by the
allocator not the workqueue code.  The right thing to do would be
adding alignment code to UP percpu allocator.  I'll leave the ugly
code as it is for now but add big fat FIXME: there and will update
percpu allocator code later and then remove this ugliness.

Thank you.

-- 
tejun
