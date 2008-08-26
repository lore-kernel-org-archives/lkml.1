Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYHZHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYHZHqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYHZHqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:46:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47646
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYHZHqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:46:11 -0400
Date: Tue, 26 Aug 2008 00:46:07 -0700 (PDT)
Message-Id: <20080826.004607.253712060.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, Alan.Brunelle@hp.com, travis@sgi.com,
       tglx@linutronix.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080826072220.GB31876@elte.hu>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>
	<20080826072220.GB31876@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 26 Aug 2008 09:22:20 +0200

> And i guess the next generation of 4K CPUs support should just get away 
> from cpumask_t-on-kernel-stack model altogether, as the current model is 
> not maintainable. We tried the on-kernel-stack variant, and it really 
> does not work reliably. We can fix this in v2.6.28.

I recenetly did some work on sparc64 to use cpumask pointers
as much as possible.

The only case that didn't work was due to a limitation in
arch interfaces for the new generic smp_call_function() code.
It passes a cpumask_t instead of a pointer to one via
arch_send_call_function_ipi().

But other than that, the whole sparc64 SMP stuff uses cpumask_t
pointers only.

What it comes down to is that you have to do the "self cpu"
and other tests in the cross-call dispatch routines themselves,
instead of at the top-level working on cpumask_t objects.

Otherwise you have to modify cpumask_t objects and thus pluck
them onto the stack where they take up silly amounts of space.
