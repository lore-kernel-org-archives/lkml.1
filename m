Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYAGXy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYAGXy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbYAGXyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:54:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbYAGXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:54:51 -0500
Message-ID: <4782BAED.7060102@zytor.com>
Date: Mon, 07 Jan 2008 15:51:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Fries <david@fries.net>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] system timer: fix crash in <100Hz system timer
References: <20080105221653.GA10065@spacedout.fries.net> <20080107153650.0cb85eeb.akpm@linux-foundation.org>
In-Reply-To: <20080107153650.0cb85eeb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> diff --git a/include/linux/acct.h b/include/linux/acct.h
>> index 302eb72..86b848d 100644
>> --- a/include/linux/acct.h
>> +++ b/include/linux/acct.h
>> @@ -173,7 +173,11 @@ typedef struct acct acct_t;
>>  static inline u32 jiffies_to_AHZ(unsigned long x)
>>  {
>>  #if (TICK_NSEC % (NSEC_PER_SEC / AHZ)) == 0
>> -	return x / (HZ / AHZ);
>> +	#if HZ < AHZ
>> +		return x * (AHZ / HZ);
>> +	#else
>> +		return x / (HZ / AHZ);
>> +	#endif
>>  #else
>>          u64 tmp = (u64)x * TICK_NSEC;
>>          do_div(tmp, (NSEC_PER_SEC / AHZ));
>> diff --git a/kernel/time.c b/kernel/time.c
>> index 09d3c45..23af26f 100644
>> --- a/kernel/time.c
>> +++ b/kernel/time.c
>> @@ -565,7 +565,11 @@ EXPORT_SYMBOL(jiffies_to_timeval);
>>  clock_t jiffies_to_clock_t(long x)
>>  {
>>  #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
>> +	#if HZ < USER_HZ
>> +	return x * (USER_HZ / HZ);
>> +	#else
>>  	return x / (HZ / USER_HZ);
>> +	#endif
>>  #else
>>  	u64 tmp = (u64)x * TICK_NSEC;
>>  	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
>> @@ -598,7 +602,12 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
>>  u64 jiffies_64_to_clock_t(u64 x)
>>  {
>>  #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
>> -	do_div(x, HZ / USER_HZ);
>> +	#if HZ < USER_HZ
>> +		x *= USER_HZ;
>> +		do_div(x, HZ);
>> +	#else
>> +		do_div(x, HZ / USER_HZ);
>> +	#endif
>>  #else
>>  	/*
>>  	 * There are better ways that don't overflow early,
> 
> Alas, I get 100% rejects due to conflicting changes from Peter's
> avoid-overflows-in-kernel-timec.patch.
> 
> Peter, did that patch propagate this failure, or might it have happily
> fixed it?
> 

My patch doesn't touch any of these functions, nor touches any code 
within 70 lines of this patch -- the last line touched is line 478 -- 
and doesn't touch linux/acct.h at all, so how could it cause a conflict?

But no, it doesn't fix this particular problem, even if using a similar 
technique might very well be a better way to do this kind of conversion.

	-hpa
