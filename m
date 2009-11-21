Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZKUAGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZKUAGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbZKUAGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZKUAGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:06:45 -0500
Message-ID: <4B072EF5.2090402@redhat.com>
Date: Fri, 20 Nov 2009 19:06:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <4B071000.9080408@zytor.com>
In-Reply-To: <4B071000.9080408@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

H. Peter Anvin wrote:
> On 11/18/2009 02:43 PM, Jason Baron wrote:
>> Add text_poke_fixup() which takes a fixup address to where a processor
>> jumps if it hits the modifying address while code modifying.
>> text_poke_fixup() does following steps for this purpose.
>>
>>   1. Setup int3 handler for fixup.
>>   2. Put a breakpoint (int3) on the first byte of modifying region,
>>      and synchronize code on all CPUs.
>>   3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>   4. Modify the first byte of modifying region, and synchronize code
>>      on all CPUs.
>>   5. Clear int3 handler.
>>
>> Thus, if some other processor execute modifying address when step2 to step4,
>> it will be jumped to fixup code.
>>
>> This still has many limitations for modifying multi-instructions at once.
>> However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
>> because;
>>   - Replaced instruction is just one instruction, which is executed atomically.
>>   - Replacing instruction is a jump, so we can set fixup address where the jump
>>     goes to.
>>
>
> I just had a thought about this... regardless of if this is safe or not
> (which still remains to be determined)... I have a bit more of a
> fundamental question about it:
>
> This code ends up taking *two* global IPIs for each instruction
> modification.  Each of those requires whole-system synchronization.

As Mathieu and I talked, first IPI is for synchronizing code, and
second is for waiting for all int3 handling is done.

>  How
> is this better than taking one IPI and having the other CPUs wait until
> the modification is complete before returning?

Would you mean using stop_machine()? :-)

If we don't care about NMI, we can use stop_machine() (for
this reason, kprobe-jump-optimization can use stop_machine(),
because kprobes can't probe NMI code), but tracepoint has
to support NMI.

Actually, it might be possible, even it will be complicated.
If one-byte modifying(int3 injection/removing) is always
synchronized, I assume below timechart can work
(and it can support NMI/SMI too).

----
        <CPU0>                  <CPU1>
flag = 0
setup int3 handler
int3 injection[sync]
other-bytes modifying
smp_call_function(func)    func()
wait_until(flag==1)        irq_disable()
                            sync_core() for other-bytes modifying
                            flag = 1
first-byte modifying[sync] wait_until(flag==2)
flag = 2
wait_until(flag==3)        irq_enable()
                            flag = 3
cleanup int3 handler       return
return
----

I'm not so sure that this flag-based step-by-step code can
work faster than 2 IPIs :-(

Any comments are welcome! :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

