Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZFBXNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZFBXNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFBXNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:13:18 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:23674 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZFBXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:13:18 -0400
Message-ID: <4A25B1C8.7030708@caviumnetworks.com>
Date: Tue, 02 Jun 2009 16:12:08 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 11/12] hw-breakpoints: ftrace plugin for kernel symbol
 tracing using HW Breakpoint interfaces
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com> <1243982616-18212-12-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1243982616-18212-12-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2009 23:12:08.0766 (UTC) FILETIME=[8D7775E0:01C9E3D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> From: K.Prasad <prasad@linux.vnet.ibm.com>
> 
> This patch adds an ftrace plugin to detect and profile memory access over kernel
> variables. It uses HW Breakpoint interfaces to 'watch memory addresses.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/Kconfig          |   21 ++
>  kernel/trace/Makefile         |    1 +
>  kernel/trace/trace.h          |   23 ++
>  kernel/trace/trace_ksym.c     |  525 +++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_selftest.c |   53 ++++
>  5 files changed, 623 insertions(+), 0 deletions(-)
>  create mode 100644 kernel/trace/trace_ksym.c
[...]
> +	entry->ksym_hbp->info.name = ksymname;
> +	entry->ksym_hbp->info.type = op;
> +	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
> +#ifdef CONFIG_X86
> +	entry->ksym_hbp->info.len = HW_BREAKPOINT_LEN_4;
> +#endif

What if the symbol referred to an object of size other than 4?  This 
would clearly be incorrect in that case.


> +	entry->ksym_hbp->triggered = (void *)ksym_hbp_handler;
> +
> +	ret = register_kernel_hw_breakpoint(entry->ksym_hbp);

I hate to sound like a broken record, but could some one explain to me 
again why it is a good idea to design a new API that requires processor 
specific #ifdefs to be sprinkled all around generic kernel code?

Back in:
http://lkml.org/lkml/2008/12/4/329
and
http://lkml.org/lkml/2009/5/21/189

I raised doubts about this hw-breakpoint thing being generic and the 
responses made think that the processor specific portions would be 
isolated in the processor specific parts of the kernel.  I now see that 
I was wrong.

When we add sparc, MIPS, ppc...  Support it would be nice to not have to 
add all our own #ifdefs to this, but instead have a generic interface 
that will not need changes.

David Daney
