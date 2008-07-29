Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYG2GUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYG2GUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYG2GT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:19:59 -0400
Received: from gw.goop.org ([64.81.55.164]:46260 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbYG2GT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:19:58 -0400
Message-ID: <488EB68A.2080301@goop.org>
Date: Mon, 28 Jul 2008 23:19:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
References: <488E534F.2030204@goop.org> <20080728233455.GA2919@elte.hu> <200807291430.08220.nickpiggin@yahoo.com.au>
In-Reply-To: <200807291430.08220.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> It definitely is not a clear win. They do not have the same characteristics.
> So numbers will be needed.
>
> smp_call_function is now properly scalable in smp_call_function_single
> form. The more general case of multiple targets is not so easy and it still
> takes a global lock and touches global cachelines.
>
> I don't think it is a good use of time, honestly. Do you have a good reason?
>   

Code cleanup, unification.  It took about 20 minutes to do.  It probably 
won't take too much longer to unify kernel/tlb.c.  It seems that if 
there's any performance loss in making the transition, then we can make 
it up again by tuning smp_call_function_mask, benefiting all users.

But, truth be told, the real reason is that I think there may be some 
correctness issue around smp_call_function* - I've seen occasional 
inexplicable crashes, all within generic_smp_call_function() - and I 
just can't exercise that code enough to get a solid reproducing case.  
But if it gets used for tlb flushes, then any bug is going to become 
pretty obvious.  Regardless of whether these patches get accepted, I can 
use it as a test vehicle.

> No. The rewrite makes it now very good at synchronously sending a function
> to a single other CPU.
>
> Sending asynchronously requires a slab allocation and then a remote slab free
> (which is nasty for slab) at the other end, and bouncing of locks and
> cachelines. No way you want to do that in the reschedule IPI.
>
> Not to mention the minor problem that it still deadlocks when called with
> interrupts disabled ;)
>   

In the async case?  Or because it can become spontaneously sync if 
there's an allocation failure?

    J
