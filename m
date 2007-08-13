Return-Path: <linux-kernel-owner+w=401wt.eu-S972256AbXHMPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972256AbXHMPXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031108AbXHMNMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:12:39 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:52910
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S942048AbXHMNMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:12:36 -0400
Message-Id: <46C0751E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 13 Aug 2007 14:13:34 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: optionally show last exception from/to
	register contents
References: <46C05D91.76E4.0078.0@novell.com>
 <20070813130845.GA3406@bingen.suse.de>
In-Reply-To: <20070813130845.GA3406@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 13.08.07 15:08 >>>
>On Mon, Aug 13, 2007 at 12:33:05PM +0100, Jan Beulich wrote:
>> +		if (__get_cpu_var(ler_msr)) {
>> +			u32 from, to, hi;
>> +
>> +			rdmsr(__get_cpu_var(ler_msr), from, hi);
>> +			rdmsr(__get_cpu_var(ler_msr) + 1, to, hi);
>> +			printk("LER: %08x -> %08x\n", from, to);
>> +		}
>
>This seems racy -- AFAIK the MSR will record the last branch
>before an interrupt too, and the trap handlers enable interrupts
>before coming here. 
>
>Can't think of a good way to avoid that for page fault at least
>without impacting interrupt latency or reading the MSR always.

That's the problem. Other than either going through interrupt gates *and* keeping
interrupts disabled long enough, there's nothing you can do, except turning of
tracing before re-enabling interrupts, which in turn you would likely reject because
of the performance overhead of the necessary rdmsr/wrmsr pair.

>The other thing is that this should use print_symbol()

I considered this, but decided against it due to the address pair being displayed.
But I could certainly change that.

>> @@ -360,6 +367,18 @@ int is_valid_bugaddr(unsigned long eip)
>>  	return ud2 == 0x0b0f;
>>  }
>>  
>> +DEFINE_PER_CPU(u32, ler_msr);
>> +int ler_enabled = 0;
>> +
>> +void ler_enable(void) {
>> +	if (__get_cpu_var(ler_msr)) {
>> +		u64 debugctl;
>> +
>> +		rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
>> +		wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl | 1);
>
>Better use checking_rd/wrmsrl and disable on fail -- often emulators 
>fake specific CPUs, but don't implement all debugging features.

Okay, if you consider emulators important here (this is one of the reasons for
having to turn on the feature via command line option).

>> +static int __init ler_setup(char *s)
>> +{
>> +	ler_enabled = 1;
>> +	return 1;
>> +}
>> +__setup("ler", ler_setup);
>
>I don't think the option is very useful.

Apart from the above, I assume it's also useful initially to avoid boot problems
in case the model->msr mapping isn't fully cooked, yet (obviously I don't have
machines with all the different CPU families/models around to test, so the coding
of what I wasn't able to test is purely based on the manuals).

>BTW I have a patch somewhere to save/report last branch on exception
>too, but it never seemed suitable for mainline because of its

I though you did, but since I never saw it appear in any release, I posted
this one...

So especially with the first concern of yours - is it worth at all rev-ing this
patch to address the other change requests you voiced?

>high overhead. If someone submitted a full BTS driver I would
>be tempted though :)

That shouldn't be too difficult.

Jan

