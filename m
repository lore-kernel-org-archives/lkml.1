Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYHRQMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYHRQMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHRQMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:12:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYHRQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:12:23 -0400
Message-ID: <48A99F51.8090504@redhat.com>
Date: Mon, 18 Aug 2008 12:12:01 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, rostedt@goodmis.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
In-Reply-To: <20080818154746.GA26835@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>
> Steve ? I just noticed this :
>
>
> ftrace_modify_code(unsigned long ip, unsigned char *old_code,
>                    unsigned char *new_code)
> {
>         unsigned replaced;
>         unsigned old = *(unsigned *)old_code;
>         unsigned new = *(unsigned *)new_code;
>         int faulted = 0;
>
>         /*
>          * Note: Due to modules and __init, code can
>          *  disappear and change, we need to protect against faulting
>          *  as well as code changing.
>          *
>          * No real locking needed, this code is run through
>          * kstop_machine.
>          */
>         asm volatile (
>                 "1: lwz         %1, 0(%2)\n"
>                 "   cmpw        %1, %5\n"
>                 "   bne         2f\n"
>                 "   stwu        %3, 0(%2)\n"
>                 "2:\n"
>                 ".section .fixup, \"ax\"\n"
>                 "3:     li %0, 1\n"
>                 "       b 2b\n"
>                 ".previous\n"
>                 ".section __ex_table,\"a\"\n"
>                 _ASM_ALIGN "\n"
>                 _ASM_PTR "1b, 3b\n"
>                 ".previous"
>                 : "=r"(faulted), "=r"(replaced)
>                 : "r"(ip), "r"(new),
>                   "0"(faulted), "r"(old)
>                 : "memory");
>
>         if (replaced != old && replaced != new)
>                 faulted = 2;
>
>         if (!faulted)
>                 flush_icache_range(ip, ip + 8);
>
>         return faulted;
> }
>
> What happens if you are really unlucky and get the following execution
> sequence ?
>
>
> Load module A at address 0xddfc3e00
> Populate ftrace function table while the system runs
> Unload module A
> Load module B at address 0xddfc3e00
> Activate ftrace
> -> At that point, since there is another module loaded in the same
> address space, it won't fault. If there happens to be an instruction
> which looks exactly like the instruction we are replacing at the same
> location, we are introducing a bug. True both on x86 ans powerpc...
>
>   

Hi Mathieu,

Yep I know of this issue, and it is very unlikely it would happen.  But 
that's not good enough, so this is why I did this:

http://marc.info/?l=linux-kernel&m=121876928124384&w=2
http://marc.info/?l=linux-kernel&m=121876938524523&w=2

;-)

On powerpc it would be less likely an issue since the code segments are 
all 4 bytes aligned. And a call being replaced would be a call to mcount 
(relative jump). A call to mcount would be the same for both. Then 
again, we could be replacing a nop, but most likely that wouldn't hurt 
either, since nops are seldom used, and if we did call mcount, it would 
probably not hurt. But it would be an issue if Module B happen to put a 
data section that matched the code to jmp to mcount or a nop.

-- Steve

