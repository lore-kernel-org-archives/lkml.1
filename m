Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZH0HeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZH0HeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZH0HeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:34:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZH0HeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:34:19 -0400
Message-ID: <4A9636EB.7020408@kernel.org>
Date: Thu, 27 Aug 2009 16:34:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make use of inc/dec conditional
References: <4A8BCA850200007800010836@vpn.id2.novell.com> <4A8C2CDE.1010405@zytor.com> <4A8D13740200007800010BC7@vpn.id2.novell.com>
In-Reply-To: <4A8D13740200007800010BC7@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 27 Aug 2009 07:34:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

Jan Beulich wrote:
>>>> "H. Peter Anvin" <hpa@zytor.com> 19.08.09 18:48 >>>
>> On 08/19/2009 12:48 AM, Jan Beulich wrote:
>>> According to gcc's instruction selection, inc/dec can be used without
>>> penalty on most CPU models, but should be avoided on others. Hence we
>>> should have a config option controlling the use of inc/dec, and
>>> respective abstraction macros to avoid making the resulting code too
>>> ugly. There are a few instances of inc/dec that must be retained in
>>> assembly code, due to that code's dependency on the instruction not
>>> changing the carry flag.
>> One thing: I doubt it matters one measurable iota when it comes to
>> locked operations.
> 
> Okay, I think I agree to this point.
> 
>> Furthermore:
>>
>> -		     "decl %2	;\n"
>> +		     _ASM_DECL "%2	;\n"
>> 		     "jne 1b		;\n"
>> 		     "adcl $0, %0	;\n"
>>
>> It looks to me that the carry flag is live across the dec there.  The
> 
> Indeed, I overlooked that when going through and checking for the
> CF-is-live instances.
> 
>> other csum code look scary to me too.
>>
>> The rest of them look technically okay, but you're bloating them by two
>> bytes (one byte in 64-bit mode) for every instance.  You may want to
>> consider if any particular instance is more icache-critical than
>> stall-critical.  This is probably more of a concern for inlines than for
>> regular single-instance code like the string operations.
> 
> So the background really is that I wanted to introduce a percpu_inc()
> operation subsequently (here with the goal to reduce code size by one
> byte in a couple of places - initially just for inc_irq_stat(), didn't look
> for other potential users), but then realized that it wouldn't be nice
> to unconditionally introduce a possible stall here. Hence I went and
> first created said config option, and then also went through and
> identified the uses of inc/dec that could be replaced based on that
> config option.

Given that we're already sprinkling inc/dec's via atomic ops, I think
this part can proceed independently.  Also, if the only affected
machine is the hot p4, I don't think it would worth any amount of
code.  :-)

For the percpu part, wouldn't it be better to have
__builtin_contant_p() on the add/sub parameter, use inc/dec if the
param is constant and 1 and make simple wrapper for inc/dec if still
necessary?

Thanks.

-- 
tejun
