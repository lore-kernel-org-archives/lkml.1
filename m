Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYACAhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYACAhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYACAgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:36:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34664 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYACAgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:36:54 -0500
Message-ID: <477C2E1F.2040307@zytor.com>
Date: Wed, 02 Jan 2008 16:36:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jonathan Lim <jlim@sgi.com>, linux-kernel@vger.kernel.org, jlan@sgi.com
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in kernel/tsacct.c
References: <200801022103.m02L3oL1051764@sabah.engr.sgi.com> <20080102162338.c67769af.akpm@linux-foundation.org>
In-Reply-To: <20080102162338.c67769af.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 28 Dec 2007 13:26:07 -0800 (PST) Jonathan Lim <jlim@sgi.com> wrote:
> 
>> It's possible that the values used in and returned from jiffies_to_usecs() are
>> incorrect because of truncation when variables of type u64 are involved.  So a
>> function specific to that type is used instead.
>>
>> Diff'd against: linux/kernel/git/stable/linux-2.6.23.y.git
>>
>> Signed-off-by: Jonathan Lim <jlim@sgi.com>
>>
>> --- a/kernel/tsacct.c	2007-12-28 11:58:05.182065029 -0800
>> +++ b/kernel/tsacct.c	2007-12-28 11:57:37.949013675 -0800
>> @@ -71,6 +71,17 @@ void bacct_add_tsk(struct taskstats *sta
>>  
>>  #ifdef CONFIG_TASK_XACCT
>>  
>> +static inline u64 jiffies_to_usecs_u64(const u64 j)
>> +{
>> +#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
>> +	return (USEC_PER_SEC / HZ) * j;
>> +#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
>> +	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
>> +#else
>> +	return (j * USEC_PER_SEC) / HZ;
>> +#endif
>> +}
>> +
>>  #define KB 1024
>>  #define MB (1024*KB)
>>  /*
>> @@ -81,8 +92,8 @@ void xacct_add_tsk(struct taskstats *sta
>>  	struct mm_struct *mm;
>>  
>>  	/* convert pages-jiffies to Mbyte-usec */
>> -	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
>> -	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
>> +	stats->coremem = jiffies_to_usecs_u64(p->acct_rss_mem1) * PAGE_SIZE / MB;
>> +	stats->virtmem = jiffies_to_usecs_u64(p->acct_vm_mem1) * PAGE_SIZE / MB;
>>  	mm = get_task_mm(p);
>>  	if (mm) {
>>  		/* adjust to KB unit */
> 
> Fair enough.  But I guess that new function should be a kernel-wide thing
> because surely other users will turn up.
> 
> Peter has been working on the accuracy of some of these conversion
> functions and might need to know about this change?

Yes, the function should be coded using the new #defines produced by 
timeconst.h; that way you end up avoiding a possible overflow in the 
multiplication.

I believe all three cases can be folded, then, to:

	return (j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1) / HZ_TO_USEC_DEN;

I would also like to observe that the roundoff behaviour of the function 
  above is inconsistent; in case 2 it will round up, but in case 3 it 
will round down.  The line proposed above has round up behaviour.

	-hpa
