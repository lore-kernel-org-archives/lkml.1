Return-Path: <linux-kernel-owner+w=401wt.eu-S1763502AbXF1Mjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502AbXF1Mjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXF1Mjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:39:41 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:38066 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbXF1Mjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:39:40 -0400
Date: Thu, 28 Jun 2007 08:37:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dan Williams <dan.j.williams@intel.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
References: <20070622040014.234651401@goodmis.org> 
 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> 
 <20070622204058.GA11777@elte.hu>  <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
  <20070622215953.GA22917@elte.hu>  <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
  <1182823276.5493.240.camel@localhost.localdomain>
 <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dan,

On Mon, 25 Jun 2007, Dan Williams wrote:

> Yes you are right, ARM does not flush L1 when prev==next in switch_mm.
>
> > Perhaps something else is at fault here.
> >
> I'll try and dig a bit deeper...

BTW:

 static int __init iop_adma_init (void)
 {
+       iop_adma_workqueue = create_workqueue("iop-adma");
+       if (!iop_adma_workqueue)
+               return -ENODEV;
+

Could you also try upping the prio of all the "iop-adma" threads?

You should see thread names such as (on SMP) "iop-adma/0", "iop-adma/1"
... "iop-adma/N" where N = # of CPUs - 1.

do a "chrt -p -f 98 <pid>"  once for each of the thread's PIDs.  The
chrt can be found in the package "util-linux" on Red Hat / Fedora, and in
schedutils on Debian.

It just dawned on me that workqueues don't run at a high priority by
default.  So it's funny that I'm running all my current tasklets as a low
priority work queues :-)

But that can certainly be a cause of high latency.  I need to update my
patches to make the workqueue thread a higher priority. All benchmarks on
this patch have been using a low priority work queue.

I also don't see any nice API to have the priority set for a workqueue
thread from within the kernel. Looks like one needs to be added,
otherwise, I need to have the wrapper dig into the workqueue structs to
find the thread that handles the workqueue.

Thanks,

-- Steve
