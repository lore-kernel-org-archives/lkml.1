Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZKEOQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZKEOQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbZKEOQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:16:06 -0500
Received: from mailgw.miraclelinux.com ([122.216.84.157]:40039 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbZKEOQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:16:05 -0500
Message-ID: <4AF2DE2D.5060902@miraclelinux.com>
Date: Thu, 05 Nov 2009 23:16:13 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
References: <4AEACFBF.4060108@miraclelinux.com> <20091030143333.414ea29c.akpm@linux-foundation.org> <1256939158.1917.43.camel@Joe-Laptop.home> <1256944907.1917.109.camel@Joe-Laptop.home> <20091102155823.GA31535@elte.hu>
In-Reply-To: <20091102155823.GA31535@elte.hu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> 
>> Add a printk_ratelimited statement expression macro that uses a 
>> per-call ratelimit_state so that multiple subsystems output messages 
>> are not suppressed by a global __ratelimit state.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index f4e3184..555560c 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -407,6 +407,50 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>>  #endif
>>  
>>  /*
>> + * ratelimited messages with local ratelimit_state,
>> + * no local ratelimit_state used in the !PRINTK case
>> + */
>> +#ifdef CONFIG_PRINTK
>> +#define printk_ratelimited(fmt, ...)  ({		\
>> +	static struct ratelimit_state _rs = {		\
>> +		.interval = DEFAULT_RATELIMIT_INTERVAL, \
>> +		.burst = DEFAULT_RATELIMIT_BURST,       \
>> +	};                                              \
>> +							\
>> +	if (!__ratelimit(&_rs))                         \
>> +		printk(fmt, ##__VA_ARGS__);		\
>> +})
>> +#else
>> +/* No effect, but we still get type checking even in the !PRINTK case: */
>> +#define printk_ratelimited printk
>> +#endif
>> +
>> +#define pr_emerg_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
>> +#define pr_alert_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
>> +#define pr_crit_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
>> +#define pr_err_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>> +#define pr_warning_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
>> +#define pr_notice_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
>> +#define pr_info_rl(fmt, ...) \
>> +        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>> +/* no pr_cont_rl, don't do that... */
>> +/* If you are writing a driver, please use dev_dbg instead */
>> +#if defined(DEBUG)
>> +#define pr_debug_rl(fmt, ...) \
>> +	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>> +#else
>> +#define pr_debug_rl(fmt, ...) \
>> +	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
>> +				     ##__VA_ARGS__); 0; })
>> +#endif
>> +
> 
> Looks like a useful addition. Somewhat bloatier, but then again, more 
> correct and the bloat problem can be solved by explicit state 
> definitions.
> 
> 	Ingo

I waiting for this patch to merge.
And then, I think I will remake my patch.

How do you delete printk_ratelimit() in this patch at a same time ?

I have a personal question.
Why aren't they codes in the include/linux/ratelimit.h ?


Thanks.
Naohiro Ooiwa

