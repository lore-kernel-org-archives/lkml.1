Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbZE3OsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbZE3OsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760016AbZE3OsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:48:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49065 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbZE3OsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:48:16 -0400
Message-ID: <4A214753.8080005@redhat.com>
Date: Sat, 30 May 2009 10:48:51 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH -tip v8 5/7] x86: add pt_regs register and stack access
 APIs
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090529000347.17532.34038.stgit@localhost.localdomain> <20090530081303.GB15755@infradead.org>
In-Reply-To: <20090530081303.GB15755@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Thank you for review.

Christoph Hellwig wrote:
> You might want to run this past linux-arch to make sure this is suitable
> for other architectures.

Frankly, I'm not sure about linux-arch, could you explain it?
Anyway, I'm interested in that idea.

>> --- a/arch/x86/include/asm/ptrace.h
>> +++ b/arch/x86/include/asm/ptrace.h
>> @@ -7,6 +7,7 @@
>>  
>>  #ifdef __KERNEL__
>>  #include <asm/segment.h>
>> +#include <asm/page_types.h>
>>  #endif
> 
> I really wonder if we should split asm/ptrace.h into one file
> just defining pt_regs both for userspace and the kernel, and one with
> all kinds of register access helpers and maybe another one for the
> ptrace architecture interface.

Agreed, pt_regs is used more broadly than ptrace itself in kernel.

> Unforuntately we would have to keep the ptrace.h name for the one
> carrying pt_regs as it's exposed to userland.

Perhaps, we should split pt_regs from ptrace.h, like as ptrace-regs.h.

>> +static inline unsigned long get_register(struct pt_regs *regs, unsigned offset)
>> +{
> 
> I woner if all these names aren't a bit generic.  Shoud we maybe add a
> regs_ prefix to make it clear it operates on a pt_regs register set?

Indeed.

> Also some kerneldoc documentation for all these helpers would be nice.

Sure.

>> +/* Get Nth argument at function call */
>> +static inline unsigned long get_argument_nth(struct pt_regs *regs, unsigned n)
>> +{
>> +#ifdef CONFIG_X86_32
>> +#define NR_REGPARMS 3
> 
> I think completely separate version for 32 vs 64 bit for this one would
> be cleaner.

Agreed,

> 
>> +	if (n < NR_REGPARMS) {
>> +		switch (n) {
>> +		case 0: return regs->ax;
>> +		case 1: return regs->dx;
>> +		case 2: return regs->cx;
>> +		}
> 
> Normal kernel style would be
> 
> 		switch (n) {
> 		case 0:
> 			return regs->ax;
> 		case 1:
> 			return regs->dx;
> 		case 2:
> 			return regs->cx;
> 		}

Oops, thanks,

> 
>> +#define REG_OFFSET(r) offsetof(struct pt_regs, r)
>> +#define REG_OFFSET_NAME(r) {.name = #r, .offset = REG_OFFSET(r)}
>> +#define REG_OFFSET_END {.name = NULL, .offset = 0}
> 
> At least the REG_OFFSET macro seems superflous to me.
> 

Exactly.

Thank you again!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

