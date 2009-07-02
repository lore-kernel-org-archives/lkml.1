Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZGBKBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZGBKBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZGBKBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:01:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZGBKBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:01:17 -0400
Message-ID: <4A4C85F1.4050706@redhat.com>
Date: Thu, 02 Jul 2009 18:03:29 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Patch] sysctl: forbid too long numbers
References: <20090619072212.6519.10915.sendpatchset@localhost.localdomain> <20090629150123.43f79091.akpm@linux-foundation.org>
In-Reply-To: <20090629150123.43f79091.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Also, fixing this is a non-backward-compatible change which could break
> existing userspace.  Although the chances of this seem fairly small.
>
> Or are they?  One could imagine a script which was tested and developed
> on a 64-bit system, which writes a >4G number into a pseudo file.  That
> script happens to work on 32-bit systems (it might not work _well_, but
> it'll work).  With this change, the write will fail on the 32-bit
> system and the entire application could bale out or something.
>
> I'm not saying that this is a reason to avoid making the change, but
> it's all a worry and needs consideration.
>
>   

Ah, I didn't consider this situation...
Hmm... but only taking the lower 32-bits really looks strange.

> The other worrisome thing about this change is that there may well be
> existing userspace which does
>
> 	echo 42foo > /proc/whatever
>
> and the conversion to strict_strtoul() will cause that script to
> newly fail.
>
> And the chances that there are scripts which do this are pretty darned
> good - it's fairly easy to accidentally leave junk like this in strings
> when hacking stuff together in scripting languages.
>
>   

Yeah, maybe, but that is really tricky...
>
>   
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>> index 756ccaf..ff2ca5c 100644
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
>> @@ -163,11 +163,14 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
>>  	char *tail;
>>  	unsigned long val;
>>  	size_t len;
>> +	char tmp[32];
>>  
>>  	*res = 0;
>>  	len = strlen(cp);
>>  	if (len == 0)
>>  		return -EINVAL;
>> +	if (len > snprintf(tmp, "%ld", ULONG_MAX))
>> +		return -EINVAL;
>>  
>>  	val = simple_strtoul(cp, &tail, base);
>>  	if (tail == cp)
>>     
>
> And here we're doing a check for that overflow, yes?
>
> - We don't need tmp[].  vsnprintf(NULL, ...) can be used to query the
>   length of an sprintf.  See how kvasprintf() does this.
>
> - The strict_strtoul() documentation should be updated?
>
> - The above change affects strict_strtol() too.
>
> - The same change should be made to strict_strtoull() and hence
>   strict_strtoll()?
>
>   
Good points!
I agree, so maybe we only need to change this part?
Hmm, I need to check the callers of strict_strtol()...

Thank you!


