Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYKQFHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYKQFHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYKQFG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:06:26 -0500
Received: from ozlabs.org ([203.10.76.45]:46184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYKQFGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:06:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18720.60351.611649.125429@drongo.ozlabs.ibm.com>
Date: Mon, 17 Nov 2008 14:57:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/7] ftrace, ppc: convert to new dynamic ftrace arch API
In-Reply-To: <20081116212515.331278109@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
	<20081116212515.331278109@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> +static int test_24bit_addr(unsigned long ip, unsigned long addr)
> +{
> +	unsigned long diff;
> +
> +	/* can we get to addr from ip in 24 bits? */
> +	diff = ip > addr ? ip - addr : addr - ip;
> +
> +	return !(diff & ((unsigned long)-1 << 24));

Since a branch instruction can reach +/- 32MB, the 24 needs to be 25.
It's 25 not 26 since you have effectively accounted for one bit by
taking the absolute value of the offset.  Also, this will say that an
offset of -0x2000000 is out of range whereas it is just in range.
That probably doesn't matter unless you're relying on this to give
exactly the same answer in all cases as tests done elsewhere (e.g. in
module_64.c).

Note that the address difference being too large isn't the only reason
for a procedure call to go via a trampoline on ppc64.  A trampoline is
also needed when the called function uses a different TOC from the
caller.  The most obvious example of this is when the caller is in a
module and the callee is in the main kernel or another module.

Currently all functions in the main kernel use the same TOC, but the
linker is capable of dividing up a large executable into groups of
functions and assigning a different TOC to each group, in order to
avoid any of the TOCs getting too large (a TOC is limited to 64kB).
If the linker does that, it automatically inserts trampolines to
handle the TOC change.

Paul.
