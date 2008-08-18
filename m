Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYHRREy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYHRREy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYHRREq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:04:46 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:64938 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbYHRREq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:04:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskIAFVFqUhMRKxB/2dsb2JhbACBYoEssTKBWA
Date: Mon, 18 Aug 2008 13:04:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, rostedt@goodmis.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Message-ID: <20080818170442.GA29337@Krystal>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A99F51.8090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A99F51.8090504@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:03:38 up 74 days, 21:44,  6 users,  load average: 5.91, 2.65,
	1.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (srostedt@redhat.com) wrote:
> Mathieu Desnoyers wrote:
>>
>> Steve ? I just noticed this :
>>
>>
>> ftrace_modify_code(unsigned long ip, unsigned char *old_code,
>>                    unsigned char *new_code)
>> {
>>         unsigned replaced;
>>         unsigned old = *(unsigned *)old_code;
>>         unsigned new = *(unsigned *)new_code;
>>         int faulted = 0;
>>
>>         /*
>>          * Note: Due to modules and __init, code can
>>          *  disappear and change, we need to protect against faulting
>>          *  as well as code changing.
>>          *
>>          * No real locking needed, this code is run through
>>          * kstop_machine.
>>          */
>>         asm volatile (
>>                 "1: lwz         %1, 0(%2)\n"
>>                 "   cmpw        %1, %5\n"
>>                 "   bne         2f\n"
>>                 "   stwu        %3, 0(%2)\n"
>>                 "2:\n"
>>                 ".section .fixup, \"ax\"\n"
>>                 "3:     li %0, 1\n"
>>                 "       b 2b\n"
>>                 ".previous\n"
>>                 ".section __ex_table,\"a\"\n"
>>                 _ASM_ALIGN "\n"
>>                 _ASM_PTR "1b, 3b\n"
>>                 ".previous"
>>                 : "=r"(faulted), "=r"(replaced)
>>                 : "r"(ip), "r"(new),
>>                   "0"(faulted), "r"(old)
>>                 : "memory");
>>
>>         if (replaced != old && replaced != new)
>>                 faulted = 2;
>>
>>         if (!faulted)
>>                 flush_icache_range(ip, ip + 8);
>>
>>         return faulted;
>> }
>>
>> What happens if you are really unlucky and get the following execution
>> sequence ?
>>
>>
>> Load module A at address 0xddfc3e00
>> Populate ftrace function table while the system runs
>> Unload module A
>> Load module B at address 0xddfc3e00
>> Activate ftrace
>> -> At that point, since there is another module loaded in the same
>> address space, it won't fault. If there happens to be an instruction
>> which looks exactly like the instruction we are replacing at the same
>> location, we are introducing a bug. True both on x86 ans powerpc...
>>
>>   
>
> Hi Mathieu,
>
> Yep I know of this issue, and it is very unlikely it would happen.  But 
> that's not good enough, so this is why I did this:
>
> http://marc.info/?l=linux-kernel&m=121876928124384&w=2
> http://marc.info/?l=linux-kernel&m=121876938524523&w=2
>
> ;-)
>
> On powerpc it would be less likely an issue since the code segments are all 
> 4 bytes aligned. And a call being replaced would be a call to mcount 
> (relative jump). A call to mcount would be the same for both. Then again, 
> we could be replacing a nop, but most likely that wouldn't hurt either, 
> since nops are seldom used, and if we did call mcount, it would probably 
> not hurt. But it would be an issue if Module B happen to put a data section 
> that matched the code to jmp to mcount or a nop.
>

Ah, I did not see this one passing by :) That's the right solution
indeed. I guess it's not in 2.6.27-rc2/rc3 though ? I wonder if the
bug can be repeated with a module-free kernel ?

Mathieu

> -- Steve
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
