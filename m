Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0BLXoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:44:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:53931 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0BLXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:43:59 -0500
Message-ID: <4B75E7AB.4060102@windriver.com>
Date: Fri, 12 Feb 2010 17:43:39 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [PATCH 26/28] kdb,panic,debug_core: Allow the debug core to receive
 a panic before smp_send_stop()
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>	<1266014143-29444-27-git-send-email-jason.wessel@windriver.com> <20100212150027.f875bbde.akpm@linux-foundation.org>
In-Reply-To: <20100212150027.f875bbde.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2010 23:43:26.0875 (UTC) FILETIME=[2C3E66B0:01CAAC3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 12 Feb 2010 16:35:41 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> It is highly desirable to trap into kdb on panic,
>>     
>
> s/kdb/kgdb/
>
> But is it necessary to do it in-kernel?  Why not just put a
> breakpoint at panic(), add that to your .gdbinit?
>
>   

If you don't mind consuming a breakpoint that is ok.  Certainly there is
also the possibility of making this configurable as well.

For now I will omit this patch from any kind of future pull request
while we hash out what makes sense.

>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index c787333..428d15b 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -66,10 +66,13 @@ NORET_TYPE void panic(const char * fmt, ...)
>>  	 */
>>  	preempt_disable();
>>  
>> -	bust_spinlocks(1);
>>  	va_start(args, fmt);
>>  	vsnprintf(buf, sizeof(buf), fmt, args);
>>  	va_end(args);
>> +
>> +	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>> +
>> +	bust_spinlocks(1);
>>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
>>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>>  	dump_stack();
>> @@ -91,8 +94,6 @@ NORET_TYPE void panic(const char * fmt, ...)
>>  	 */
>>  	smp_send_stop();
>>  
>> -	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>> -
>>  	bust_spinlocks(0);
>>  
>>  	if (!panic_blink)
>>     
>
> So the notifier call now happens before all the printks and the kexec
> and kmsg_dump handling.  What effect does this have upon the code which
> implements kexec and kmsg_dump?
>
>   

I certainly don't want to break kexec or alter any behavior, does that
mean kgdb / kdb should hook the kexec for notification?

I think ideally it is a end user's preference as to if they want in via
kexec or the kernel debugger.  Calling the smp_send_stop() prior to the
notifier was a death sentence for the kernel debugger. 

Perhaps I can move the notifier before smp_send_stop()?

Jason.
