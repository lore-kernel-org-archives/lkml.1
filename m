Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXKOBGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXKOBGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXKOBGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:06:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52120 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbXKOBGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:06:40 -0500
Subject: Re: x86 32-bit machine check handler
From: Max Asbock <masbock@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
In-Reply-To: <p73abpiz0x8.fsf@bingen.suse.de>
References: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com>
	 <p73abpiz0x8.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 17:06:11 -0800
Message-Id: <1195088771.9979.31.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 15:15 +0100, Andi Kleen wrote:
> Max Asbock <masbock@us.ibm.com> writes:
> 
> > Now that the 32-bit and 64-bit x86 machine check handlers live next to
> > each other a certain asymmetry in functionality is apparent. Notably,
> > the 64-bit machine check handler implements a timer that periodically
> > polls for silent machine check errors and makes them accessible to user
> > space through /dev/mcelog. 
> 
> Actually 32bit implements that too (non-fatal.c). But it misses some
> of the more advanced functionality like AMD Threshold Interrupts.
> 
> > Are there reasons the x86 32-bit machine
> > check handler couldn't do the same?
> 
> The 32bit machine check code has some serious design problems. The
> best would be probably to just move 32bit over to the 64bit code too.  In
> fact there was a patch to do that some time ago, but it ran into some
> minor problems and was unfortunately never merged. But it would be the
> right thing to do.

I found patch from about three years ago that implemented a 32-bit
version of the x86_64 machine check handler. Do you know of any newer
attempts?
However, given the merge of x86, a single implementation should be able
to handle both the 32-bit and 64-bit cases. I tried to build the 64-bit
machine check handler (mce_64.c) for 32-bit to see what kind problems it
would run into. So far I found a few things:
- there is no idle_notifier_register in 32-bit x86
- there is no oops_begin in 32-bit x86
- register names are different (rip, cs)
- some data types would have to adjusted to be 64 bit 
The issues seem to be surmountable.

> The only missing functionality on the 64bit side would be support for
> old non IA compliant old machine checks like P5 or WinChip. One option
> would be to simply drop them. AFAIK these CPUs don't really have
> anywhere near usable machine check capability anyways so dropping it
> would not make much difference. Or alternatively keep p5.c/winchip.c
> around. But if you look at them they don't do much except simple
> printk with not much information and printk in a machine check handler
> is always wrong because it can deadlock. I personally would prefer
> dropping.
> 
> And I think one or two K7 quirks are also missing on 64bit, but these
> would be very easy to add. Other than that it should just work on
> 32bit CPUs.
> 
So it looks like giving 32-bit x86 the same machine check support as in
64-bit is both feasible and desirable.
Are there any plans to do this or is anybody currently working on it?

thanks,
Max


