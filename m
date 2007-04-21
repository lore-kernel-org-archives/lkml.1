Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDUWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDUWKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXDUWKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:10:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57413 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXDUWKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:10:37 -0400
Date: Sun, 22 Apr 2007 00:10:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Scott Porter <scott@opengridcomputing.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Akinobu Mita <Akinobu.Mita@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: Fault Injection issues: stacktrace x86_64 and failslab NUMA
Message-ID: <20070421221033.GA30496@one.firstfloor.org>
References: <1177095354.25165.48.camel@scott-desktop.site> <1177192363.25165.101.camel@scott-desktop.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177192363.25165.101.camel@scott-desktop.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no FRAME_POINTER support in the x86_64 code.  Apparently it was
> removed when the unwind code was added but now that has been removed as
> well!

That's because no assembly code in x86-64 knows anything about frame pointers.
You will always get truncated traces if anything assembler is in trace.
That's just dangerous.

> Digging around in the archives it looks like Andi Kleen knew this was an
> issue with the x86_64 fallback stacktrace code.  Now that there is no

No I didn't.

> unwind code to even attempt to avoid the problem what should be done?
> How about:
> 
> (1) Make it clear the Fault Injection with STACKTRACE on x86_64 is at
> best "Russian Roulette" -- maybe a !X86_64 in Kconfig.debug?
> 
> (2) Introduce FRAME_POINTER support back into the x86_64 code.  This is
> what Fault Injection really wants.
> 
> (3) Keep the saved stack address entries array out of sight of the
> fallback save_stack_trace() code.  Lockdep does this by storing it in
> static space but this requires locking which would be ugly for Fault
> Injection.  Another option is to mask the saved addresses so they fail
> the __kernel_text_address() test but fail_stacktrace() uses the same
> mask to make it's comparisons.  There's still the problem of avoiding
> kernel text addresses stored on the stack by other code (that is, other
> than the expected stack chain uses).

Some hack in (3) would be probably best, otherwise (1).
At some point I hope we can get the dwarf2 unwinder back, then
the problem should be also solved. But then you would need to force
the dwarf2 unwinder with fault injection on, but that shouldn't
be a problem.

-Andi
