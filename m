Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZI0Rtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZI0Rtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZI0Rtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:49:32 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:39725 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZI0Rtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:49:31 -0400
Message-ID: <4ABFA583.6030908@cesarb.net>
Date: Sun, 27 Sep 2009 14:48:51 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>	 <1254060189.20648.462.camel@desktop>  <4ABF8B30.5050801@cesarb.net>	 <1254070336.20648.518.camel@desktop>  <4ABF9FB4.6040608@cesarb.net> <1254072760.20648.524.camel@desktop>
In-Reply-To: <1254072760.20648.524.camel@desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker escreveu:
> On Sun, 2009-09-27 at 14:24 -0300, Cesar Eduardo Barros wrote:
> 
>> I took a quick look, and all uses seem to be directly in a boolean 
>> context (within an if()), so there would be no problem. Besides, the 
>> unlikely() all these macros end with does a double negation, meaning 
>> even if it is an int, it will be either 0 or 1 (but I am not sure I am 
>> reading these macros right - it seems CONFIG_TRACE_BRANCH_PROFILING 
>> turns all unlikely() into likely()).
>>
>> In fact, I was expecting no change at all, since gcc should be able to 
>> see it is being treated as a boolean (perhaps I am trusting gcc too 
>> much). And to make matters even more confusing, my own test changing all 
>> __ret_warn_once to bool and dropping the !! caused an _increase_ of 598 
>> bytes (x86-64 defconfig).
>>
>>     text    data     bss     dec     hex filename
>> 8100553 1207148  991988 10299689         9d2929 vmlinux.warnret.before
>> 8101119 1207180  991988 10300287         9d2b7f vmlinux.warnret.after
>>
>> (And yes, data increased again.)
> 
> Did you have the CONFIG_TRACE_BRANCH_PROFILING option enabled for the
> test above?

CONFIG_BRANCH_PROFILE_NONE=y

CONFIG_TRACE_BRANCH_PROFILING does not even appear in the .config.

> If this was just your regular base line config , then that is odd .. I
> also would think worse case would be no size reduction .. I did my
> compile test on x86-32 btw..

Yes, it is very odd. And I tried compiling a small test module to see if 
I could see the changes in the assembly output:

#include <linux/module.h>
#include <linux/kernel.h>

void test(int value)
{
         WARN_ON_ONCE(value);
}
EXPORT_SYMBOL_GPL(test);

But the assembly output is identical.

I will try looking at the first function which shows a difference in 
size (which appears to be handle_irq) and see what I can find.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
