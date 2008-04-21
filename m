Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYDUOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYDUOFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYDUOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:05:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:55348 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596AbYDUOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:05:23 -0400
Message-ID: <480C9F0E.30500@windriver.com>
Date: Mon, 21 Apr 2008 09:05:02 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: fix optional arch functions and probe_kernel_*
References: <200804181742.m3IHgsoG012669@hera.kernel.org> <20080418154800.82f814e0.akpm@linux-foundation.org> <20080421140058.GO9554@elte.hu>
In-Reply-To: <20080421140058.GO9554@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 14:04:52.0107 (UTC) FILETIME=[AB2AADB0:01C8A3B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> On Fri, 18 Apr 2008 17:42:54 GMT
>> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>>
>>     
>>> --- a/mm/maccess.c
>>> +++ b/mm/maccess.c
>>> @@ -17,11 +17,14 @@
>>>  long probe_kernel_read(void *dst, void *src, size_t size)
>>>  {
>>>  	long ret;
>>> +	mm_segment_t old_fs = get_fs();
>>>  
>>> +	set_fs(KERNEL_DS);
>>>  	pagefault_disable();
>>>  	ret = __copy_from_user_inatomic(dst,
>>>  			(__force const void __user *)src, size);
>>>  	pagefault_enable();
>>> +	set_fs(old_fs);
>>>  
>>>  	return ret ? -EFAULT : 0;
>>>  }
>>>       
>> Oh.  Well that rather invalidates my earlier comments.  It looks like 
>> this change could have been folded, but I understand that this 
>> sometimes gets wearisome and isn't terribly important if
>>
>> a) the fix doesn't repair build breakage and
>>
>> b) the fix doesn't fix runtime breakage and
>>
>> c) the fix fixes code which the git-bisect user won't have enabled in
>>    config anyway.
>>     
>
> yeah. I mentioned it in the pull request that i kept the fixes apart to 
> demonstrate the overall fix dynamics of the KGDB tree over a full kernel 
> cycle. I normally backmerge and create a clean queue - but that creates 
> a false perception that the tree is 'too fresh' and trust is harder to 
> be expressed.
>
>   
>> Still.  Do we need the set_fs() in there?  __copy_from_user_inatomic() 
>> is a "__" uaccess function and hence shouldn't be running access_ok()?
>>     
>
> yeah, i guess that's true. Jason?
>
>   

In so far as the testing showed, it worked ok on the X86 arch with and
without the set_fs(), but on ARM it is absolutely required.   This means
we have to decide to make arch specific or leave generic as it stands
right now.

Jason.
