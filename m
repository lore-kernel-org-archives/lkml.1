Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZBLP6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZBLP6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZBLP5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:57:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:33612 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZBLP5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:57:54 -0500
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>, rusty <rusty@rustcorp.com.au>
In-Reply-To: <alpine.DEB.1.10.0902121039230.15469@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere>
	 <20090212081801.GA22979@elte.hu> <20090212081923.GA26838@elte.hu>
	 <1234430564.23438.205.camel@twins>  <20090212100756.GA12790@elte.hu>
	 <1234433770.23438.210.camel@twins> <1234440554.23438.264.camel@twins>
	 <alpine.DEB.1.10.0902121039230.15469@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 16:57:36 +0100
Message-Id: <1234454256.10603.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 10:43 -0500, Steven Rostedt wrote:
> > +     data = kmalloc(sizeof(*data), GFP_ATOMIC);
> > +     if (data)
> > +             data->csd.flags = CSD_FLAG_ALLOC;
> > +     else {
> > +             data = &per_cpu(cfd_data, me);
> > +             while (data->csd.flags & CSD_FLAG_LOCK)
> > +                     cpu_relax();
> > +             data->csd.flags = CSD_FLAG_LOCK;
> 
> Wont the first CPU that runs the callback unlock this? And then we run the
> risk of two back to back callers on the same CPU, having the second
> caller possibly corrupt the first.

No, there's a ref count in there that ensures the last one unlocks it.

But that's still not enough, the global queue is RCU protected.

Suppose you have 4 cpus, and use smp_function_call_mask() to 2 others,
now its possible the 4th is also doing global ipis and is traversing the
global queue.

Therefore, if you remove the cfd when its done, it might be the 4th cpu
is in it trying to iterate to the next entry --> BANG.

The solution used is RCU freeing cfd's. This also means we have to RCU
free the LOCK flag, sadly an RCU grace period is waaaay too long to spin
wait on.

Hence this whole solution is not quite feasible.

There's various alternative solutions, but I'm not quite sure which
makes most sense.

The one I'm currently pondering is using the global queue only for
all-but-self cfd's, this matches the all-but-self ipi APIC case.

For smaller masks we could queue a csd per queue and send single ipis.



