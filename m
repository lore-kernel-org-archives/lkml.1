Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZEVXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZEVXa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 19:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZEVXaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 19:30:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbZEVXaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 19:30:20 -0400
Message-ID: <4A173580.9050304@zytor.com>
Date: Fri, 22 May 2009 16:30:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <20090522183622.GA8385@elte.hu> <4A16F62B.40207@zytor.com> <200905221721.08495.lkml@morethan.org>
In-Reply-To: <200905221721.08495.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a driver which relies on locked operations to be atomic with
respect to the I/O subsystem, it needs to use true locks, not LOCK_PREFIX.

An interrupt cannot interrupt between two parts of a lockable
instruction even if it isn't locked (there are non-atomic instructions
in the x86 architecture, but they can never be locked.)

The other thing that you might be seeing is that a locked operation may
be slow enough to keep an otherwise-present race condition from being
triggered.

> That tells us nothing, since the CPU technical details are under NDA.

Have you considered that you might be running into a CPU bug or design
error?  There was the out-of-order store bug on the Winchip that needed
workarounds (CONFIG_X86_OOSTORE) that I don't think were ever well
tested and might very well have bitrotted?

> All that can be done in this case is report behavior differences from
> the closest publicly described processor (Pentium-M).
> 
> For that purpose, I suggest that a single processor box, with other 
> hardware that makes memory access independent of the processor's 
> control using a processor older than P-4 is a potential test bed.
> "Other hardware that makes memory access..." I previously termed:
> "buss master DMA" - which is overly specific.  It misleads people
> into thinking I am seeing hardware control issues rather than
> non-exclusive memory access.
> 
> My earlier comments about taking an interrupt between the memory read
> and the memory write operations is from a different manual than the
> one posted.  A manual that only applies to processors older than 
> the ones supported by the Linux kernel.  
> Sorry, my bad, grabbed the wrong book, posted the correct link (SH).
> 
> Until one or more specific usages of the LOCK_PREFIX macro can be 
> demonstrated to be incorrect (at least for some of the processors 
> using this code) - -
> 
> Then making the posted change is a single point change that gives a 
> pair of builds (one with, one without) to compare the behavior of on 
> the test bed.
> 
> It is *not* the preferred change for a general release kernel, the
> preferred change would be one that makes a specific rather than
> general correction.  
> Perhaps only for some functions, perhaps only for some of the 
> processors that currently select this code.
> 
> The observation that executing an unnecessary 'lock' opcode in some
> cases slows down the machine is not felt by myself to be significant 
> to duplicating my observations.  Note: I have been wrong before.

What makes you draw that conclusion, in particular?  A lock prefix
typically slows down the following instruction dramatically, on some
processors by many hundreds of cycles.

> This is as informative as I can make the message.
> 
> PS: *not* a single machine failure, tested on five machines, owned
> by four different people, two brands, with different use histories.

What do they have in common?

	-hpa
