Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZK3Vgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZK3Vgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZK3Vgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:36:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37286 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZK3Vgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:36:45 -0500
Message-ID: <4B143AE8.5090608@us.ibm.com>
Date: Mon, 30 Nov 2009 13:36:40 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joseph Parmelee <jparmele@wildbear.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
References: <alpine.LNX.2.00.0911291057100.2912@bruno>
In-Reply-To: <alpine.LNX.2.00.0911291057100.2912@bruno>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Parmelee wrote:

Hi Joseph,

Adding futex folks on CC.

> Greetings all:
> 
> Sometime between 2.6.28.6 and 2.6.31.5 a regression (feature?) in the futex
> system now causes futex test failures on glibc-2.9 which where not present
> before.  That is, recompiling the binaries of glibc-2.9 and rerunning its
> test suite now produces futex errors that passed previously.  The problem
> appears now with glibc-2.9 compiled with either gcc-4.1.2 or gcc-4.4.2, and
> with glibc-2.11 compiled with gcc-4.4.2, which is what I am currently
> running on this machine, failures and all.
> 
> The system under discussion is a uniprocessor pentium3 with an AMI BIOS. 
> Full details available on request should that prove necessary.
> 
> I have tracked the test failures down to the fact that 
> futex_cmpxchg_enabled
> is not set because the test in futex_init now "fails" (actually 
> succeeds). This appears to be happening because the expected page fault 
> intentionally
> provoked by a null dereference appears to be working now in kernel mode. 
> This *may* (rank speculation) be associated with the AMI BIOS low-memory
> corruption protection added sometime during this gap, and which is 
> activated
> on this machine.

Hrm... interesting...

> 
> Before I muck any further with this, especially involving the quite tricky
> futex mess, I would appreciate some insight into the idea behind the 
> test in
> futex_init.  I don't understand why you would bother to invoke a fault in
> what is apparently a test to determine if the cmpxchg instruction works. 

I suspect this is because the test asks for a userspace address. So rather
than hack something up to use a real userspace address, we just send NULL.
EFAULT=success and ENOSYS=failure.

> The fault is supposed to occur as a result of a null dereference that takes
> place *before* the cmpxchg instruction is even executed.  If you want to
> test that cmpxchg works, why not just make a little test in futex_init that
> uses it and fails (not succeeds) if it doesn't behave as expected, or if
> there is a fault of some kind (like illegal instruction)?  Or is the fact
> that we don't get a fault the whole point here?

I believe the NULL pointer is just a convenience.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
