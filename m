Return-Path: <linux-kernel-owner+w=401wt.eu-S965283AbXCAP3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283AbXCAP3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXCAP3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:29:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965285AbXCAP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:29:06 -0500
Date: Thu, 1 Mar 2007 07:28:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Daniel Hecht <dhecht@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in on_each_cpu?
Message-Id: <20070301072859.aea3c4da.akpm@linux-foundation.org>
In-Reply-To: <45E6BA3A.2040306@vmware.com>
References: <45E6AC1A.8050608@vmware.com>
	<20070301024524.c7c8ea1a.akpm@linux-foundation.org>
	<45E6BA3A.2040306@vmware.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 03:34:18 -0800 Zachary Amsden <zach@vmware.com> wrote:

> > Why is it a bug?  Because there's a deadlock where this CPU is waiting for
> > CPU A to take the IPI, but CPU A is waiting (with interrupts disabled) for
> > this CPU to take an IPI.
> >   
> 
> Then the bug is not in on_each_cpu().  It is in the usage of 
> clock_was_set().  For example, look at do_settimeofday in kernel/timer.c:
> 
>         write_sequnlock_irqrestore(&xtime_lock, flags);
> 
>         /* signal hrtimers about time change */
>         clock_was_set();
> 
>         return 0;

Perhaps a WARN_ON(irqs_disabled()) in clock_was_set() would help.  But probably
the one in smp_call_function() will suffice.

> And timekeeping_resume has similar code (and called from a sysdev 
> callback, so I don't know what the interrupt state should be ).  Either 
> the write_sequnlock_irqrestore is redundant, and should be merely an 
> write_sequnlock_irq, or the callsite is not prepared to handle enabling 
> interrupts temporarily as must be done for on_each_cpu(), which is a 
> pretty scary scenario.
> 
> What would be really, really nice would be to statically check all 
> callsites that issue irq disables actually keep irqs disabled.  
> Presumably, there was a reason they disabled irqs, and re-enabling them 
> underneath their noses, even if it is to avoid a race, breaks the logic 
> behind that reason.

yup.  I once played with adding warnings in places like spin_lock_irq(), 
but there were false positives from places which were odd-but-correct.

It would be worth revisiting however.

