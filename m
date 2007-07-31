Return-Path: <linux-kernel-owner+w=401wt.eu-S940411AbXGaDg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940411AbXGaDg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761845AbXGaDgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:36:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:59328 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936574AbXGaDgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:36:16 -0400
Message-ID: <46AEAE2D.8040001@qumranet.com>
Date: Tue, 31 Jul 2007 06:36:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: add a show-stacktrace-on-all-cpus command
References: <11857049662730-git-send-email-avi@qumranet.com> <20070730140938.4ead69f9.akpm@linux-foundation.org>
In-Reply-To: <20070730140938.4ead69f9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 31 Jul 2007 06:36:13 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 29 Jul 2007 13:29:26 +0300
> Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> If a cpu is spinning in the kernel but still responding to interrupts,
>> pressing sysrq-y will show you where it's spinning.
>>
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>>
>> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
>> index 39cc318..1dda709 100644
>> --- a/drivers/char/sysrq.c
>> +++ b/drivers/char/sysrq.c
>> @@ -45,6 +45,8 @@ int __read_mostly __sysrq_enabled = 1;
>>  
>>  static int __read_mostly sysrq_always_enabled;
>>  
>> +static spinlock_t show_stack_lock = SPIN_LOCK_UNLOCKED;
>>     
>
> Use DEFINE_SPINLOCK to avoid confusing lockdep.
>
>   

Okay.

>>  int sysrq_on(void)
>>  {
>>  	return __sysrq_enabled || sysrq_always_enabled;
>> @@ -309,6 +311,26 @@ static struct sysrq_key_op sysrq_unrt_op = {
>>  	.enable_mask	= SYSRQ_ENABLE_RTNICE,
>>  };
>>  
>> +static void show_cpu_stack(void *garbage)
>> +{
>> +	spin_lock(&show_stack_lock);
>> +	printk("CPU%d stacktrace:\n", raw_smp_processor_id());
>> +	dump_stack();
>> +	sysrq_handle_showregs(0, NULL);
>> +	spin_unlock(&show_stack_lock);
>> +}
>> +
>> +static void sysrq_show_stacks(int key, struct tty_struct *tty)
>> +{
>> +	on_each_cpu(show_cpu_stack, NULL, 0, 1);
>> +}
>> +
>> +static struct sysrq_key_op sysrq_show_stacks_op = {
>> +	.handler	= sysrq_show_stacks,
>> +	.help_msg	= "stacktraces-on-all-cpus(Y)",
>> +	.action_msg	= "Stack traces on all cpus",
>> +};
>> +
>>  /* Key Operations table and lock */
>>  static DEFINE_SPINLOCK(sysrq_key_table_lock);
>>  
>> @@ -356,7 +378,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>>  	&sysrq_showstate_blocked_op,	/* w */
>>  	/* x: May be registered on ppc/powerpc for xmon */
>>  	NULL,				/* x */
>> -	NULL,				/* y */
>> +	&sysrq_show_stacks_op,		/* y */
>>  	NULL				/* z */
>>  };
>>  
>>     
>
> but, but..  sysrq handlers called from hard IRQ.  Are we sure that none of
> the drivers which call into the sysrq code do so with hard IRQs disabled?
>
> Because if we call on_each_cpu() with hard IRQs disabled, the various
> implementations will emit loud warnings due to the deadlockability.
>
>   

Ah, I tested this with /proc/sysrq-trigger.

Maybe we should temporarily enable irqs here; if you press this key,
your system is already on the way out anyway.  But perhaps that would
entrap curious admins checking out what the keys do.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

