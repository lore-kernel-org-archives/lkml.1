Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXCAWlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXCAWlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161061AbXCAWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:41:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161071AbXCAWlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:41:47 -0500
Date: Thu, 1 Mar 2007 14:41:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <compudj@google.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-Id: <20070301144138.57d6d8c7.akpm@linux-foundation.org>
In-Reply-To: <45E7308B.3050106@google.com>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
	<20070301103451.2618cc35@dhcp-252-105.norway.atmel.com>
	<20070301014523.e45c3cc5.akpm@linux-foundation.org>
	<45E7308B.3050106@google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 11:59:07 -0800
Mathieu Desnoyers <compudj@google.com> wrote:

> Andrew Morton wrote:
> > On Thu, 1 Mar 2007 10:34:51 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> >
> >   
> >>> On Mon, 26 Feb 2007 12:10:37 -0800 Mathieu Desnoyers <compudj@google.com> wrote:
> >>>       
> >>>> avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
> >>>>         
> >>> No, I don't immediately see anything in the flush_old_exec() code path
> >>> which tells us that nobody else can look up this thread_info (or be holding
> >>> a ref to it) in this context.
> >>>
> >>>
> >>>       
> >>>> avr32/kernel/ptrace.c:                  ti->flags |= TIF_SINGLE_STEP;
> >>>>         
> >>> heh.  Haarvard, you got a bug.
> >>>       
> >> Heh, yeah. That would indeed explain some strange gdb behaviour. It
> >> will only trigger when single-stepping into an exception or interrupt
> >> handler so thanks for pointing it out; I would have had a hard time
> >> figuring it out on my own...
> >>     
> >
> > yup, tricky.
> >
> > If there's a lesson here, it is "don't provide #defines in the header for
> > both versions".
> >
> >   
> 
> Hrm, but the bitmask version is useful (and correctly used) whenever
> the flag is read and tested.
> 
> The proper way to do this would be to change every use the _TIF_* flag 
> in a flag comparison
> for a call to test_ti_thread_flag(). I wonder if gcc optimizes multiple 
> constant test_bit() applying
> on the same variable linked by logical and/or so it becomes a single 
> read and a small set of comparisons.

Well, it's unusual for code to want to test multiple bitflags in the same
operation.  Perhaps thread_info.flags is unusual in that regard.

But one can still do

	if (foo->flags & (1<<bar)|(1<<zot))

Which can get to be a pain if it happens in a lot of places.  But if it
only happens in a few places, this seems a reasonable price to pay, given
the safety gains.

Plus I'm _forever_ having to go into the header file to remember whether
REQ_RW is the bitmask or the bit offset.

