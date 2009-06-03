Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZFCAiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZFCAiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFCAiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:38:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:12077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZFCAiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=axecUi/6Zb+XJz5UQ7ddFxmVhGn+jNg/NRMa7yTe52hBI63j1uiCqMvzZ0eaOwbPjK
         ih27WvySXCpnPEDmhJCVxiAHDjeGCtBQFoUnD4ZyA7Kh6hKeyPcBrRaE+0JsrKpEn40O
         /ov5OTQZUpdfv4iDCjUsOKamGVvVGOv4bqqDY=
Date: Wed, 3 Jun 2009 02:38:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 11/12] hw-breakpoints: ftrace plugin for kernel symbol
	tracing using HW Breakpoint interfaces
Message-ID: <20090603003811.GF6041@nowhere>
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
>
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

I was discussing about it with Prasad few hours ago :)

The fact is that archs support the hardware breakpoints in
very different ways each.
Some of them support read breakpoint, others not (x86).
Some support addresses range, others (x86).

But still it would be nice to gather the most common
breakpoints operations through a real generic wrapper
that relies on arch specific implmentation in
background.

Such as setting very simple x/w/r breakpoints...

Well Prasad and Alan Stern could tell more about it,
I wait for their answer.

Anyway it's a fairly new Api that can still evolve.
The basis are set but can still be improved and more high level
and generic things can still be implemented.

