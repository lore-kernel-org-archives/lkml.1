Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbZDLA4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbZDLA4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 20:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759562AbZDLAzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 20:55:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759438AbZDLAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 20:55:52 -0400
Date: Sat, 11 Apr 2009 17:46:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       efault@gmx.de, len.brown@intel.com, mingo@elte.hu,
       rusty@rustcorp.com.au, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [patch for 2.6.30 2/2]
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts
Message-Id: <20090411174644.ea6f63c6.akpm@linux-foundation.org>
In-Reply-To: <20090412000605.GA23869@redhat.com>
References: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
	<20090412000605.GA23869@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 20:06:05 -0400 Dave Jones <davej@redhat.com> wrote:

> On Fri, Apr 10, 2009 at 11:17:18PM -0700, Andrew Morton wrote:
>  > From: Andrew Morton <akpm@linux-foundation.org>
>  > 
>  > In drv_read(), check to see whether we can run the rdmsr() on the current
>  > CPU.  If so, do that.  So smp_call_function_single() can avoid the IPI.
> 
> Wouldn't it be a better to make smp_call_function_single do this check
> itself, so all callers benefit from this optimisation?
> 
> *looks*
> 
> Wait, won't this already be caught by this code in smp_call_function_single() ?
> 
> 286         this_cpu = get_cpu();
> ...
> 291         if (cpu == this_cpu) {
> 292                 local_irq_save(flags);
> 293                 func(info);
> 294                 local_irq_restore(flags);
> 295         } else {
> 
> 
> 

The problem is that the caller (acpi-cpufreq) is doing

	cpu = cpumask_any(mask);
	smp_call_function_single(cpu);

and cpumask_any(mask) does cpumask_first(mask).  Which might be a
different CPU, even though this thread of control is running on a CPU
which is present in `mask'.

- We could fix this by making cpumask_any(mask) return this-cpu if
  this-cpu is present `mask'.

- We could fix this by changing smp_call_function_single() to take a
  mask, rather than a particular CPU.  Then of course it preferentially
  chooses this-cpu if possible.

  Or write a new smp_call_function_any(mask, ...);

I suspect that changing cpumask_any() to preferentially return this-cpu
will always give us the behaviour that we prefer, but I haven't looked
into it.


