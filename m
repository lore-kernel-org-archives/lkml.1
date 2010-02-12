Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0BLXVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:21:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:51037 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0BLXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:21:09 -0500
Message-ID: <4B75E236.7060108@windriver.com>
Date: Fri, 12 Feb 2010 17:20:22 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 22/28] printk,kdb: capture printk() when in kdb shell
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-23-git-send-email-jason.wessel@windriver.com> <20100212145440.7f0c68d0.akpm@linux-foundation.org>
In-Reply-To: <20100212145440.7f0c68d0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2010 23:20:10.0205 (UTC) FILETIME=[EBC378D0:01CAAC39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 12 Feb 2010 16:35:37 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> @@ -609,6 +610,14 @@ asmlinkage int printk(const char *fmt, ...)
>>  	va_list args;
>>  	int r;
>>  
>> +#ifdef CONFIG_KGDB_KDB
>> +	if (unlikely(kdb_trap_printk)) {
>> +		va_start(args, fmt);
>> +		r = vkdb_printf(fmt, args);
>> +		va_end(args);
>> +		return r;
>> +	}
>> +#endif
>>  	va_start(args, fmt);
>>  	r = vprintk(fmt, args);
>>  	va_end(args);
>>     
>
> this?
>
> --- a/kernel/printk.c~a
> +++ a/kernel/printk.c
> @@ -594,7 +594,11 @@ asmlinkage int printk(const char *fmt, .
>  	int r;
>  
>  	va_start(args, fmt);
> +#ifdef CONFIG_KGDB_KDB
> +	r = vkdb_printf(fmt, args);
> +#else
>  	r = vprintk(fmt, args);
> +#endif
>  	va_end(args);
>  
>  	return r;
> _
>   

If you feel that would be cleaner, I can make that change, but I would
also have to call vprintk() from vkdb_printf when ever kdb_trap_printk
is not set.  Do I understand your recommendation correctly?

The only time the kdb_trap_printk is ever set comes when we are inside
the kernel debug shell, and do something like "bt".  It serves the
purpose of letting folks run the stack dumper and a few other
functions.  We want to trap printk's in this instance because we don't
want them in the log them and also for the case when your debug
connection is not actually a system log console, or if you run the
command via gdb (example is "monitor bt").

Thanks,
Jason.
