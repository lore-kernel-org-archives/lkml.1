Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYIAOVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYIAOVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYIAOVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:21:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:40333 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYIAOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=laswi7/0hUPrznIt+cpkoR37iYhZvyKnwCJCeMQAAPFXkZhk6oU/RwFJz/VP3FeQpj
         owxrZmL3LyY74vMpCiRMJjbGzbQyQQyJNbKZ1oEs3CD68umvoSt2KWG9a+stXfAX6T0X
         ZbTe0jrO0D1KTakqzhYfbQs0LFM7RmmCrDzSE=
Message-ID: <48BBFA67.9070305@panasas.com>
Date: Mon, 01 Sep 2008 17:21:27 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BC1065.76E4.0078.0@novell.com>
In-Reply-To: <48BC1065.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 15:28 >>>
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -195,7 +195,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>> #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
>>
>> /* Force a compilation error if condition is true */
>> -#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>> +#define BUILD_BUG_ON(condition)					  \
>> +do {									  \
>> +	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;\
>> +} while(0)
>>
>> /* Force a compilation error if condition is true, but also produce a
>>    result (of value 0 and type size_t), so the expression can be used
> 
> I have to admit that I'm surprise this compiles: You replace an expression
> with a statement, and hence you reduce the places where BUILD_BUG_ON()
> can validly be used. 

it is only an expression because of the (void)() cast, which is what
I'm trying to avoid.

> Of course you could wrap the whole thing in ({}),

"do{}while(0)" is effectively an "{}" plus the added bonus
of demanding an ";" ;-)

> but I can't see why not to use a bit-field to achieve the intended effect.

Sure, I can also use my suggested enum construct.
(http://www.spinics.net/lists/kernel/msg772904.html)

But the thing I'm avoiding most is the (void)() cast, which makes the
optimizer very lazy. See:
[PATCH 4/5] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON
that has only popped out when I remove the (void)() cast.

> Also, are you sure the compiler will eliminate the dead variable in all
> cases?
> 
> Finally, using as common a variable as 'x' here seems dangerous, too:
> What if somewhere x is #define-d to something more complex than a
> simple identifier?

No it is scoped in a dead do{}while(0). What gets optimized out most
is the do nothing do{}while(0). The inside is just ignored.

> 
> Jan
> 

I will test for your approach, give me a sec ...

Boaz
 
