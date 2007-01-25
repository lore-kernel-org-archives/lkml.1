Return-Path: <linux-kernel-owner+w=401wt.eu-S1030651AbXAYX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbXAYX43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030652AbXAYX42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:56:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030651AbXAYX42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:56:28 -0500
Message-ID: <45B943B7.8070500@redhat.com>
Date: Thu, 25 Jan 2007 18:56:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] i386: add option to show more code in oops reports
References: <45B7C019.1040209@redhat.com> <20070125145504.c8c0a98a.akpm@osdl.org>
In-Reply-To: <20070125145504.c8c0a98a.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 24 Jan 2007 15:22:49 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
>
>   
>> Sometimes we may need to see more code than the default in an oops,
>> so add an option for that.
>>     
>
> spose so, but some more justification would be nice.  As would an x86_64
> version?
>   

Can't think of a way to word the justification, but I've wanted to see more
code a few times.

As for x86_64, Andi doesn't want to print any code before the failure
and just
printing more afterwards didn't seem to make much sense.
>   
>> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
>>     
>
> ooh, congrats.
>   
Thanks. Looks like I'll have plenty to do here...
>   
>> --- 2.6.20-rc5-32.orig/arch/i386/kernel/traps.c
>> +++ 2.6.20-rc5-32/arch/i386/kernel/traps.c
>> @@ -94,6 +94,7 @@ asmlinkage void spurious_interrupt_bug(v
>>  asmlinkage void machine_check(void);
>>  
>>  int kstack_depth_to_print = 24;
>> +int code_bytes = 64;
>>     
>
> static scope, please.  And I think it should be unsigned.
>
>   
>>  ATOMIC_NOTIFIER_HEAD(i386die_chain);
>>  
>>  int register_die_notifier(struct notifier_block *nb)
>> @@ -324,7 +325,7 @@ void show_registers(struct pt_regs *regs
>>  	 */
>>  	if (in_kernel) {
>>  		u8 *eip;
>> -		int code_bytes = 64;
>> +		int code_prologue = code_bytes * 43 / 64;
>>  		unsigned char c;
>>  
>>  		printk("\n" KERN_EMERG "Stack: ");
>> @@ -332,7 +333,7 @@ void show_registers(struct pt_regs *regs
>>  
>>  		printk(KERN_EMERG "Code: ");
>>  
>> -		eip = (u8 *)regs->eip - 43;
>> +		eip = (u8 *)regs->eip - code_prologue;
>>  		if (eip < (u8 *)PAGE_OFFSET ||
>>  			probe_kernel_address(eip, c)) {
>>  			/* try starting at EIP */
>>     
>
> You missed this bit:
>
> 		if (eip < (u8 *)PAGE_OFFSET ||
> 			probe_kernel_address(eip, c)) {
> 			/* try starting at EIP */
> 			eip = (u8 *)regs->eip;
> 			code_bytes = 32;
> 		}
>
> Do we really want to be modifying the global variable here?
>   
Oops.
>   
>> @@ -1191,3 +1192,15 @@ static int __init kstack_setup(char *s)
>>  	return 1;
>>  }
>>  __setup("kstack=", kstack_setup);
>> +
>> +static int __init code_bytes_setup(char *s)
>> +{
>> +	code_bytes = simple_strtoul(s, NULL, 0);
>> +	if (code_bytes < 64)
>> +		code_bytes = 64;
>> +	if (code_bytes > 1024)
>> +		code_bytes = 1024;
>> +
>> +	return 1;
>> +}
>> +__setup("code_bytes=", code_bytes_setup);
>>     
>
> I'm OK with the upper limit, but I'd sugegst that we remove the lower
> limit: someone might _want_ to be able to set code_bytes=0, who knows?
>
> And if code_bytes is unsigned, the single comparison with 1024 will suffice.
>
> OTOH, why have any checks at all in there?  If the user sets
> code_bytes=0xfffffff0 and things break, he gets to own both pieces...
>
>   
It's multiplying the number by 43 and dividing by 64, so we need to
avoid overflow.
(I couldn't think of an easy way to preserve current behavior.)

