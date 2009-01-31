Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZAaRqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZAaRqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZAaRqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:46:08 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856AbZAaRqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:46:07 -0500
Date: Sat, 31 Jan 2009 11:45:59 -0600
From: Martin Hicks <mort@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
       heukelum@mailshack.com, linux-kernel <linux-kernel@vger.kernel.org>,
       kdb@sgi.com
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
Message-ID: <20090131174559.GI7872@alcatraz.americas.sgi.com>
References: <20090130165053.GE7872@alcatraz.americas.sgi.com> <49838F39.6060603@zytor.com> <49839CC8.7060502@zytor.com> <20090131003921.GA13709@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090131003921.GA13709@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, Jan 31, 2009 at 01:39:21AM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > H. Peter Anvin wrote:
> >> Martin Hicks wrote:
> >>> Hi,
> >>>
> >>> KDB was using this information.  Could this be pushed towards 2.6.29  
> >>> please?
> >>>
> >>> This re-adds the old stack pointer to the top of the irqstack to help
> >>> with unwinding.  It was removed in commit  
> >>> d99015b1abbad743aa049b439c1e1dede6d0fa49
> >>> as part of the save_args out-of-line work.
> >>>
> >>
> >> This bothers me... why should we add even a single instruction to what  
> >> is arguably the single hottest path in the kernel to support an  
> >> out-of-tree debugger, especially if kgdb (which is in-tree) doesn't 
> >> need it?
> >>
> >> What does kgdb do differently (or is kgdb broken too)?
> >>

I was searching around, trying to find out if there was another way for
kdb to do this, and I think removing the backlink is breaking other
stuff also.  dump_trace() in dumpstack_64.S is using the same trick as
KDB to trace out of the interrupt stack:

            /*
             * We link to the next stack (which would be
             * the process stack normally) the last
             * pointer (index -1 to end) in the IRQ stack:
             */
            stack = (unsigned long *) (irqstack_end[-1]);
            irqstack_end = NULL;
            ops->stack(data, "EOI");
            continue;


mh

