Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbZA2RvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbZA2RvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759190AbZA2RuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:50:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366AbZA2RuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:50:19 -0500
Date: Thu, 29 Jan 2009 12:50:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
In-Reply-To: <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901291249000.27527@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins>
 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jan 2009, Steven Rostedt wrote:
> 
> > 
> > But to be irq-safe, you now need to protect the _whole_ region against 
> > interrupts, because otherwise an incoming interrupt will hit while the 
> > CSD_FLAG_LOCK bit is set, perhaps _before_ the actual IPI has been sent, 
> > and now nothing will ever clear it. So the interrupt handler that tries to 
> > send an IPI will now spin forever.
> 
> Again, this code is not allowed to run from an interrupt handler.
> 
> > 
> > So NAK on this patch. I think the approach is correct, but the 
> > implementation is buggy.

My whole assumption of this is that smp_call_function_single can not be 
called from an interrupt handler. If it can, then perhaps I just change 
the spinlock to the cmpxchg code, and put a:

	WARN_ON(cpu == smp_processor_id());

-- Steve

