Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbXHMUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbXHMUxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762334AbXHMUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:51:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:22790 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967790AbXHMUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XoWEbKPgreL0DZ0iCarJduUuTwbDA8XB6U6U0oRCr0g2iEXMErGH1PjxGE2Z/wrRQ20kmcMw6BR71Vuv3XUGDZkWSF65Mza1wPwIDf9e/4FQzVo5YnyIcm7sE+0AugTgLy1E4K264ALLRCB0pX1qeHmSYmnxz8rosH9nD2VG2uA=
Date: Tue, 14 Aug 2007 00:51:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] Immediate Values - Architecture Independent Code
Message-ID: <20070813205137.GA5870@martell.zuzino.mipt.ru>
References: <20070812150702.769065566@polymtl.ca> <20070812150814.414317013@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812150814.414317013@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:07:04AM -0400, Mathieu Desnoyers wrote:
> Immediate values are used as read mostly variables that are rarely updated. They
> use code patching to modify the values inscribed in the instruction stream. It
> provides a way to save precious cache lines that would otherwise have to be used
> by these variables.
> 
> There is a generic _immediate_read() version, which uses standard global
> variables, and optimized per architecture immediate_read() implementations,
> which use a load immediate to remove a data cache hit. When the immediate values
> functionnality is disabled in the kernel, it falls back to global variables.
> 
> It adds a new rodata section "__immediate" to place the pointers to the enable
> value. Immediate values activation functions sits in kernel/immediate.c.
> 
> Immediate values refer to the memory address of a previously declared integer.
> This integer holds the information about the state of the immediate values
> associated, and must be accessed through the API found in linux/immediate.h.
> 
> At module load time, each immediate value is checked to see if it must be
> enabled. It would be the case if the variable they refer to is exported from
> another module and already enabled.
> 
> In the early stages of start_kernel(), the immediate values are updated to
> reflect the state of the variable they refer to.
> 
> * Why should this be merged *
> 
> It improves performances on heavy memory I/O workloads.
> 
> An interesting result shows the potential this infrastructure has by
> showing the slowdown a simple system call such as getppid() suffers when it is
> used under heavy user-space cache trashing:
> 
> Random walk L1 and L2 trashing surrounding a getppid() call:
> (note: in this test, do_syscal_trace was taken at each system call, see
> Documentation/immediate.txt in these patches for details)
> - No memory pressure :   getppid() takes  1573 cycles
> - With memory pressure : getppid() takes 15589 cycles
> 
> We therefore have a slowdown of 10 times just to get the kernel variables from
> memory. Another test on the same architecture (Intel P4) measured the memory
> latency to be 559 cycles. Therefore, each cache line removed from the hot path
> would improve the syscall time of 3.5% in these conditions.

I still think this is bad idea:
1) already existing CPU erratas against popular models. As I learned
   yesterday -- SILENT reboot (often) or hang (rare).
2) new type pretending to be standard and idiomatic -- immediate_t
3) new almost-C-keyword -- immediate_if. What does it mean? You'll never
   guess just by looking at it.
4) numbers! it's very entertaining to look at numbers with 4 digits
   after comma and without any attempts to do error estimates.
5) examples!

	DEFINE_IMMEDIATE_TYPE(struct task_struct*, immediate_task_struct_ptr_t);
	immediate_task_struct_ptr_t myptr;

   this is close to hungarian notation, and threats were made to use
   immediate stuff everywhere.
6) hundreds lines of new code playing with dynamic modifying


For what you ask?


For 1 (one) cacheline saving in schedule() which
unlike getpid/getppid is non-trivial function, so all rosy numbers about
speed savings aren't really applicable. And nobody measured how big it is
on macro benchmark.


So, this stuff should be put into CoolHacks case and put aside.
It just not worth it!




A side note, folks at KS can discuss barrier for merging speed improvements.
My feelings are around 1%.

