Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928Ab0AVJPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0AVJPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870Ab0AVJPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:15:34 -0500
Received: from david.siemens.de ([192.35.17.14]:16132 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0AVJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:15:27 -0500
Message-ID: <4B596C8E.2020600@siemens.com>
Date: Fri, 22 Jan 2010 10:14:54 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
 notifier chain in hw_breakpoint_handler
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20091231003808.GC23808@nowhere> <20091231190217.GC3676@in.ibm.com> <20100110031857.GB15195@nowhere> <4B4B78D1.2080606@siemens.com> <20100116194058.GA31079@in.ibm.com> <20100120060159.GA4859@in.ibm.com>
In-Reply-To: <20100120060159.GA4859@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad wrote:
> On Sun, Jan 17, 2010 at 01:10:58AM +0530, K.Prasad wrote:
>> On Mon, Jan 11, 2010 at 08:15:29PM +0100, Jan Kiszka wrote:
>>> Frederic Weisbecker wrote:
>>>> On Fri, Jan 01, 2010 at 12:32:17AM +0530, K.Prasad wrote:
>>>>> On Thu, Dec 31, 2009 at 01:38:09AM +0100, Frederic Weisbecker wrote:
>>>>>> On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
>>>>>>> The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
>>>>>>> to generate SIGTRAP signal (and not for kernel-space addresses). 
>>>>>>>
>>>>>>> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
>>>>>>> ---
>>>>>>>  arch/x86/kernel/hw_breakpoint.c |    9 +++++++--
>>>>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
>>>>>>> ===================================================================
>>>>>>> --- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
>>>>>>> +++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
>>>>>>> @@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
>>>>>>>  		rcu_read_lock();
>>>>>>>  
>>>>>>>  		bp = per_cpu(bp_per_reg[i], cpu);
>>>>>>> -		if (bp)
>>>>>>> -			rc = NOTIFY_DONE;
>>>>>>>  		/*
>>>>>>>  		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
>>>>>>>  		 * exception handling
>>>>>>> @@ -517,6 +515,13 @@ static int __kprobes hw_breakpoint_handl
>>>>>>>  			rcu_read_unlock();
>>>>>>>  			break;
>>>>>>>  		}
>>>>>>> +		/*
>>>>>>> +		 * Further processing in do_debug() is needed for a) user-space
>>>>>>> +		 * breakpoints (to generate signals) and b) when the system has
>>>>>>> +		 * taken exception due to multiple causes
>>>>>>> +		 */
>>>>>>> +		if (bp->attr.bp_addr < TASK_SIZE)
>>>>>>> +			rc = NOTIFY_DONE;
>>>>>>>  
>>>>>>>  		perf_bp_event(bp, args->regs);
>>>>>>>  
>>>>>>>
>>>>>> Oh and now that I see this patch, the previous one indeed makes sense
>>>>>> with this check:
>>>>>>
>>>>>> if (dr6 & (~DR_TRAP_BITS))
>>>>>> 	rc = NOTIFY_DONE;
>>>>>>
>>>>>> That said, it means thread.debugreg6 won't get the reserved bits anymore.
>>>>>> I see some use of them from kvm (it restores the reserved bits on guest<->host
>>>>>> switch). Not sure if this inconsistency could affect kvm...
>>>>>>
>>>>> Can you point me to the relevant code?
>>>>
>>>> I see various uses of DR6_VOLATILE and DR6_FIXED_1 in arch/x86/kvm/,
>>>> DR6_FIXED_1 being the fixed unused bits in dr6. Not sure how
>>>> this patch would affect what's set there.
>>>>
>>>> I'll wait for Jan's answer.
>>>>
>>> You may need to synchronize me: What does the patch change, the shadow
>>> register KVM will restore into DR6 on return to the host? Or the
>>> register content KVM finds on guest entry?
>>>
>> Sorry, this mail got buried deeply in my mailbox (hence the delay).
>>
>> Basically, this patch tries to remove DR6 from its reserved bits to help
>> easy checks for certain status bits (such as DR_STEP). For instance, in
>> order to verify if DR_STEP (Bit 14) is set we must now do
>> if ((DR6 & ~DR6_RESERVED) & DR_STEP) {}
>> or
>> if (DR6 & (DR_STEP | DR6_RESERVED)) {}
>> which is redundant.
>>
>> Instead this patch would expunge all reserved bits in DR6 before checks
>> for various status bits (to detect the cause of exception) are made in
>> do_debug().
>>
>> At the outset, I don't think changes in the way the value of DR6 is used
>> for comparison in do_debug() would affect exception handling for either
>> KVM's guest or host OS (given that there are no hooks for the same in
>> do_debug()).
>>
>>> The rules are simple: On entry, KVM assumes nothing about the register
>>> state, just overwrites it (on demand) with the guest state. On exit, it
>>> calls into hw_breakpoint_restore to ensure the host sees a proper state
>>> (if required). But there is at no time an architecturally invalid state
>>> loaded into the real register (that's basically what DR6_VOLATILE and
>>> DR6_FIXED_1 are used for while in guest mode).
>>>
>> Such a behaviour shouldn't be affected by the above change...your
>> confirmation would help!
>>
> 
> Hi Jan,
> 	I presume that the above explanation makes the role of this
> patch/bugfix clear.
> 
> Kindly let me know if you have any further queries.
> 

Nope. There should be really no conflicts of your optimization with kvm.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
