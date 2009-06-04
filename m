Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZFDPhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZFDPhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZFDPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:37:05 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:58391 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZFDPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:37:04 -0400
Date: Thu, 4 Jun 2009 21:06:58 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: David Daney <ddaney@caviumnetworks.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 11/12] hw-breakpoints: ftrace plugin for kernel symbol
	tracing using HW Breakpoint interfaces
Message-ID: <20090604153658.GA5336@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com> <1243982616-18212-12-git-send-email-fweisbec@gmail.com> <4A25B1C8.7030708@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A25B1C8.7030708@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 04:12:08PM -0700, David Daney wrote:
> Frederic Weisbecker wrote:
>> From: K.Prasad <prasad@linux.vnet.ibm.com>
>>
>> This patch adds an ftrace plugin to detect and profile memory access over kernel
>> variables. It uses HW Breakpoint interfaces to 'watch memory addresses.
>>
>> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/Kconfig          |   21 ++
>>  kernel/trace/Makefile         |    1 +
>>  kernel/trace/trace.h          |   23 ++
>>  kernel/trace/trace_ksym.c     |  525 +++++++++++++++++++++++++++++++++++++++++
>>  kernel/trace/trace_selftest.c |   53 ++++
>>  5 files changed, 623 insertions(+), 0 deletions(-)
>>  create mode 100644 kernel/trace/trace_ksym.c
> [...]
>> +	entry->ksym_hbp->info.name = ksymname;
>> +	entry->ksym_hbp->info.type = op;
>> +	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
>> +#ifdef CONFIG_X86
>> +	entry->ksym_hbp->info.len = HW_BREAKPOINT_LEN_4;
>> +#endif
>
> What if the symbol referred to an object of size other than 4?  This  
> would clearly be incorrect in that case.
>

I don't see a way in which we could automatically detect the size of a
variable using the symbol name and use that as the 'len' (as this would
be the ideal case). However, in this case we can circumvent this problem by
using the least of the possible lengths (HW_BREAKPOINT_LEN_1 for x86)
as it would be valid for symbols of all sizes. I will change this.
Thanks for pointing it out!

>> +	entry->ksym_hbp->triggered = (void *)ksym_hbp_handler;
>> +
>> +	ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
>
> I hate to sound like a broken record, but could some one explain to me  
> again why it is a good idea to design a new API that requires processor  
> specific #ifdefs to be sprinkled all around generic kernel code?
>
> Back in:
> http://lkml.org/lkml/2008/12/4/329
> and
> http://lkml.org/lkml/2009/5/21/189
>
> I raised doubts about this hw-breakpoint thing being generic and the  
> responses made think that the processor specific portions would be  
> isolated in the processor specific parts of the kernel.  I now see that  
> I was wrong.
>
> When we add sparc, MIPS, ppc...  Support it would be nice to not have to  
> add all our own #ifdefs to this, but instead have a generic interface  
> that will not need changes.
>
> David Daney

One of the ways in which we could do this for 'len' field is to allow
numeric lengths to be specified (as suggested by David Gibson in another
mail thread), say "entry->ksym_hbp->info.len = 4;".

The length encoding based on register layout can be done in
arch-specific code. I think this would make the code more usable and I
should be implementing it in a patch soon.

As far as the 'type' information is concerned, some of the common
breakpoint types (such as HW_BREAKPOINT_READ, HW_BREAKPOINT_WRITE,
HW_BREAKPOINT_EXECUTE) can be defined in generic files and as NULL
for those architectures that don't implement them.

However it might be a source of confusion to the end-user about
supported breakpoint types on a given architecture.

Thanks,
K.Prasad

