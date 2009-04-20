Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZDTD3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZDTD3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 23:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZDTD3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 23:29:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbZDTD3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 23:29:32 -0400
Date: Sun, 19 Apr 2009 20:20:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
       efault@gmx.de, len.brown@intel.com, mingo@elte.hu,
       rusty@rustcorp.com.au, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [patch for 2.6.30 2/2]
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts
Message-Id: <20090419202014.9a511aa9.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0904192252550.10996@localhost.localdomain>
References: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
	<alpine.LFD.2.00.0904192252550.10996@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009 22:57:24 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:

> 
> 
> > +++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > @@ -197,9 +197,22 @@ static void do_drv_write(void *_cmd)
> >  
> >  static void drv_read(struct drv_cmd *cmd)
> >  {
> > -	cmd->val = 0;
> > +	int target_cpu;		/* The CPU on which to perform thr rdmsr() */
> > +	int this_cpu;
> > +
> > +	/*
> > +	 * If the current CPU is in cmd->mask then run the rdmsr() on this
> > +	 * CPU to avoid the cross-cpu interrupt.
> > +	 */
> > +	this_cpu = get_cpu();
> > +	if (cpu_isset(this_cpu, *(cmd->mask)))
> > +		target_cpu = this_cpu;
> > +	else
> > +		target_cpu = cpumask_any(cmd->mask);
> >  
> > -	smp_call_function_single(cpumask_any(cmd->mask), do_drv_read, cmd, 1);
> > +	cmd->val = 0;
> > +	smp_call_function_single(target_cpu, do_drv_read, cmd, 1);
> > +	put_cpu();
> >  }
> >  
> >  static void drv_write(struct drv_cmd *cmd)
> > _
> 
> Rather than this patch I would expect we would want to either:
> 
> A. as we went to the trouble to detect the local case
>    in drv_read, why call smp_call_function at all for that case?

Sure, that would work.

I felt it was a little cleaner to always delegate the call to
smp_call_function() rather than open-coding smp_call_function()'s
internal implementation details at this site.  We'd need to do:

	local_irq_disable();		/* Because this is what smp_call_function_single() does */
	do_drv_read(...);
	local_irq_enable();

> or
> 
> B. optimize smp_call_function_single to beneift all users
>    instead of just this customer.

Yep.  That would be a new smp_call_function_any() which takes a cpumask
rather than a single CPU number.  I think Rusty was cooking something
up..

