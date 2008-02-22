Return-Path: <linux-kernel-owner+w=401wt.eu-S935960AbYBVWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960AbYBVWZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936616AbYBVWVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:21:15 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:26044 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936612AbYBVWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:21:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Stp72xf/RebQs0X5u8LF65qPuqrHr/k5Wsir/pLBDa7egoFCYLoFBV4+NI1LmblKslFGI+8sAxc+UDf/XXaQc2jmec2uH8KLlQCdB2WmCFMkho9kdCGYh3FnCXDLMRjZ9CjM9egnAikY3Pi7iO6arim46tHvaO337CJcFbrvBgs=
Message-ID: <47BF4AC5.7070507@gmail.com>
Date: Fri, 22 Feb 2008 17:20:53 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 11/14] optimize the !printk fastpath through the
 lock acquisition
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152722.4804.77478.stgit@novell1.haskins.net> <20080222191837.GE6060@ucw.cz>
In-Reply-To: <20080222191837.GE6060@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> Decorate the printk path with an "unlikely()"
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  kernel/rtmutex.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
>> index 122f143..ebdaa17 100644
>> --- a/kernel/rtmutex.c
>> +++ b/kernel/rtmutex.c
>> @@ -660,12 +660,12 @@ rt_spin_lock_fastlock(struct rt_mutex *lock,
>>  		void fastcall (*slowfn)(struct rt_mutex *lock))
>>  {
>>  	/* Temporary HACK! */
>> -	if (!current->in_printk)
>> -		might_sleep();
>> -	else if (in_atomic() || irqs_disabled())
>> +	if (unlikely(current->in_printk) && (in_atomic() || irqs_disabled()))
>>  		/* don't grab locks for printk in atomic */
>>  		return;
>>  
>> +	might_sleep();
> 
> I think you changed the code here... you call might_sleep() in
> different cases afaict.

Agreed, but it's still correct afaict.  I added an extra might_sleep() 
to a path that really might sleep.  I should have mentioned that in the 
header.

In any case, its moot.  Andi indicated this patch is probably a no-op so 
I was considering dropping it on the v2 pass.

Regards,
-Greg



