Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZK3W1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZK3W1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZK3W1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:27:23 -0500
Received: from www.tglx.de ([62.245.132.106]:47528 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZK3W1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:27:22 -0500
Date: Mon, 30 Nov 2009 23:26:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Joseph Parmelee <jparmele@wildbear.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
In-Reply-To: <4B143AE8.5090608@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain>
References: <alpine.LNX.2.00.0911291057100.2912@bruno> <4B143AE8.5090608@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Darren Hart wrote:
> > The system under discussion is a uniprocessor pentium3 with an AMI BIOS. 
> > Full details available on request should that prove necessary.
> > 
> > I have tracked the test failures down to the fact that 
> > futex_cmpxchg_enabled
> > is not set because the test in futex_init now "fails" (actually 
> > succeeds). This appears to be happening because the expected page fault 
> > intentionally
> > provoked by a null dereference appears to be working now in kernel mode. 

Can you please printk the return value of that cmpxchg() test and
provide a full bootlog (dmesg) of your machine ?

Could you also please do a quick check in which kernel version this
got introduced ?

> > This *may* (rank speculation) be associated with the AMI BIOS low-memory
> > corruption protection added sometime during this gap, and which is 
> > activated on this machine.

That'd be a serious bug as it would let every NULL pointer dereference
in the kernel proceed.

> > Before I muck any further with this, especially involving the quite tricky
> > futex mess, I would appreciate some insight into the idea behind the 
> > test in
> > futex_init.  I don't understand why you would bother to invoke a fault in
> > what is apparently a test to determine if the cmpxchg instruction works. 

The point is that we have to deal with architectures where we do not
know at compile time whether we actually have a working cmpxchg. So we
use cmpxchg with a NULL pointer which is supposed to fault and return
-EFAULT and if cmpxchg is not working on the machine the arch code is
supposed to return -ENOSYS. 

See arch/x86/include/asm/futex.h:futex_atomic_cmpxchg_inatomic() for
an example.

> I suspect this is because the test asks for a userspace address. So rather
> than hack something up to use a real userspace address, we just send NULL.
> EFAULT=success and ENOSYS=failure.

We have no real user space address at this point.

> > The fault is supposed to occur as a result of a null dereference that takes
> > place *before* the cmpxchg instruction is even executed.  If you want to

No, the fault happens _when_ cmpxchg is executed on the NULL pointer.

> > test that cmpxchg works, why not just make a little test in futex_init that
> > uses it and fails (not succeeds) if it doesn't behave as expected, or if
> > there is a fault of some kind (like illegal instruction)?  Or is the fact
> > that we don't get a fault the whole point here?

Again, we expect it to fault.

IIRC, we tried to use a valid address for the test and let the
exception fixup code return -EFAULT when the instruction is not
available. That worked on x86 but did not work on other archs.

Thanks,

	tglx
