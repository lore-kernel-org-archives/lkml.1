Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYHZUpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYHZUpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYHZUpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:45:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35385
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbYHZUpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:45:40 -0400
Date: Tue, 26 Aug 2008 13:45:35 -0700 (PDT)
Message-Id: <20080826.134535.193703558.davem@davemloft.net>
To: travis@sgi.com
Cc: mingo@elte.hu, torvalds@linux-foundation.org, Alan.Brunelle@hp.com,
       tglx@linutronix.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
From: David Miller <davem@davemloft.net>
In-Reply-To: <48B4542A.1050004@sgi.com>
References: <20080826072220.GB31876@elte.hu>
	<20080826.004607.253712060.davem@davemloft.net>
	<48B4542A.1050004@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>
Date: Tue, 26 Aug 2008 12:06:18 -0700

> David Miller wrote:
> > The only case that didn't work was due to a limitation in
> > arch interfaces for the new generic smp_call_function() code.
> > It passes a cpumask_t instead of a pointer to one via
> > arch_send_call_function_ipi().
> > 
> > But other than that, the whole sparc64 SMP stuff uses cpumask_t
> > pointers only.
> > 
> > What it comes down to is that you have to do the "self cpu"
> > and other tests in the cross-call dispatch routines themselves,
> > instead of at the top-level working on cpumask_t objects.
> > 
> > Otherwise you have to modify cpumask_t objects and thus pluck
> > them onto the stack where they take up silly amounts of space.
> 
> Yes, I had proposed either modifying, or supplementing a new
> smp_call function to pass the cpumask_t as a pointer (similar
> to set_cpus_allowed_ptr.)  But an ABI change such as this was
> not well received at the time.

What it seems to come down to is that any cpumask_t not inside of
a dynamically allocated object should be marked const.

And that is something we can enforce at compile time.

Linus has just suggested dynamically allocating cpumask_t's
for such cases but I don't see that as the fix either.

Just mark them const and enforce that cpumask_t objects can only
be modified when they appear in dynamically allocated objects.

You really don't need to modify the ones that passed around functions
anyways.  The only code that wants to change bits in these things is
the cpu cross-call dispatch stuff, and that cpu choice logic can just
live where it belongs down in the cross-call dispatch code.

