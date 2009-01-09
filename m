Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbZAIN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbZAIN2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZAIN2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:28:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:50892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZAIN2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:28:41 -0500
Subject: Re: [PATCH 0/9] Performance counters for POWER
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 14:28:35 +0100
Message-Id: <1231507715.11687.618.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 21:40 +1100, Paul Mackerras wrote:
> The following series of patches extends Ingo and Thomas's performance
> counter framework to add support for 64-bit POWER processors.
> Currently I have the PPC970 family and POWER6 done.
> 
> The approach I have taken is to do the constraint checking and the
> search through the space of alternative event codes as each group of
> counters is added at the time a task is scheduled in. 

Hmm, the model I thought would make most sense for power and other
machines with such heavy constraints was that you'd compose a register
set when you create groups, and then when you RR the groups, you just
program the pre-computed sets.

The create code already has hooks to validate constraints -- so that you
cannot create a group that would never fit on the machine. If you use
this to generate and store a register set, you'd only need to program
them in the counter scheduler.

My current understanding of the counter scheduler is that it RR groups,
each schedule event throws out the last state, queuing whatever groups
it had at the tail, and then adds as many possible new groups from the
head of the list. Which by the above constraint checking is guaranteed
to be at least 1.

With pre-computed regs sets it would be hard to go beyond the 1 group at
a time, therefore I imagine your current approach is more flexible, but
I worry about the cost.

>  That means we
> are potentially doing the search several times in a row, with
> interrupts disabled.  I think it will be OK since there are only a few
> events that have alternatives (and not many of them), and the
> constraint checking is fast since it is just simple integer
> operations. 

>  However, one of the things I plan to do is to instrument
> that code to find out how long it takes in the worst case.  (If it
> takes too long then I will need some major changes to the generic
> code.)

Right, esp on high context switch rates it might dominate the machine.
