Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162Ab0AUUS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0AUUS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986Ab0AUUS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:18:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0AUUS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:18:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=LvvgB44tUwgA:10 a=7U3hwN5JcxgA:10 a=RohvjoL97AP8R6aLz2sA:9 a=MheSl5-8FtpD39-O3RCa9KwXgicA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       linux-mips <linux-mips@linux-mips.org>
In-Reply-To: <4B58B1B3.6000502@caviumnetworks.com>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
	 <4B58A89A.8050405@caviumnetworks.com>
	 <1264102455.31321.293.camel@gandalf.stny.rr.com>
	 <4B58B1B3.6000502@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 15:18:24 -0500
Message-ID: <1264105104.31321.298.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:57 -0800, David Daney wrote:

> >> Since the current CPU sees the memory accesses in order, what can be 
> >> happening on other CPUs that would require a full mb()?
> > 
> > Lets look at a hypothetical situation with:
> > 
> > 	add_wait_queue();
> > 	current->state = TASK_UNINTERRUPTIBLE;
> > 	smp_wmb();
> > 	if (!x)
> > 		schedule();
> > 
> > 
> > 
> > Then somewhere we probably have:
> > 
> > 	x = 1;
> > 	smp_wmb();
> > 	wake_up(queue);
> > 
> > 
> > 
> > 	   CPU 0			   CPU 1
> > 	------------			-----------
> > 	add_wait_queue();
> > 	(cpu pipeline sees a load
> > 	 of x ahead, and preloads it)
> 
> 
> This is what I thought.
> 
> My cpu (Cavium Octeon) does not have out of order reads, so my wmb() is 

Can you have reads that are out of order wrt writes? Because the above
does not have out of order reads. It just had a read that came before a
write. The above code could look like:

(hypothetical assembly language)

	ld r2, TASK_UNINTERRUPTIBLE
	st r2, (current->state)
	wmb
	ld r1, (x)
	cmp r1, 0

Is it possible for the CPU to do the load of r1 before storing r2? If
so, then the bug still exists.

-- Steve


> in fact a full mb() from the point of view of the current CPU.  So I 
> think I could weaken my bariers in set_current_state() and still get 
> correct operation.  However as you say...
> 


