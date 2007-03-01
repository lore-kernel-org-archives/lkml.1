Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXCAGQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXCAGQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 01:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932674AbXCAGQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 01:16:39 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbXCAGQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 01:16:38 -0500
Date: Wed, 28 Feb 2007 22:16:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com,
       anil.s.keshavamurthy@intel.com, amul.shah@unisys.com
Subject: Re: [PATCH]: Use stop_machine_run in the Intel RNG driver
Message-Id: <20070228221619.dc135f3c.akpm@linux-foundation.org>
In-Reply-To: <45E42268.30209@redhat.com>
References: <20070227120835.14880.38530.sendpatchset@prarit.boston.redhat.com>
	<45E42268.30209@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 07:22:00 -0500 Prarit Bhargava <prarit@redhat.com> wrote:

> Replace call_smp_function with stop_machine_run in the Intel RNG driver.
> 
> CPU A has done read_lock(&lock)
> CPU B has done write_lock_irq(&lock) and is waiting for A to release the lock.
> 
> A third CPU calls call_smp_function and issues the IPI.  CPU A takes CPU C's
> IPI.  CPU B is waiting with interrupts disabled and does not see the IPI.
> CPU C is stuck waiting for CPU B to respond to the IPI.
> 
> Deadlock.

I think what you're describing here is just the standard old
smp_call_function() deadlock, rather than anything which is specific to
intel-rng, yes?

It is "well known" that you can't call smp_call_function() with local
interrupts disabled.  In fact i386 will spit a warning if you try it.


intel-rng doesn't do that, but what it _does_ do is:

	smp_call_function(..., wait = 0);
	local_irq_disable();

so some CPUs will still be entering the IPI while this CPU has gone and
disabled interrupts, thus exposing us to the deadlock, yes?

In which case a suitable fix might be to make intel-rng spin until all the
other CPUs have entered intel_init_wait().

> The solution is to use stop_machine_run instead of call_smp_function
> (call_smp_function should not be called in situations where the CPUs may
> be suspended).

But that seems to be a nice change anyway.  It took rather a lot of code
churn to do it, and it does find it necessary to export stop_machine_run()
to modules, but that seems OK too.

