Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZA1MTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZA1MTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 07:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZA1MTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 07:19:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55923 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZA1MTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 07:19:13 -0500
To: Roger Larsson <roger.larsson@e-gatan.se>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Robert Love <rml@tech9.net>, Pavel Machek <pavel@ucw.cz>,
       netdev@vger.kernel.org
Subject: Re: PROBLEM: in_atomic() misuse all over the place
From: Andi Kleen <andi@firstfloor.org>
References: <200901280010.37633.roger.larsson@e-gatan.se>
Date: Wed, 28 Jan 2009 13:18:50 +0100
In-Reply-To: <200901280010.37633.roger.larsson@e-gatan.se> (Roger Larsson's message of "Wed, 28 Jan 2009 00:10:37 +0100")
Message-ID: <87pri7k4id.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Larsson <roger.larsson@e-gatan.se> writes:

[cc netdev since network code is discussed]

> [2.] Full description of the problem/report:
>
> The problem is that in_atomic() only works on preemptive kernels...

That's not fully correct. It works in tasklets/softirqs/spin_lock_bh
on all kernels.

> file:  include/net/sock.h
>
>    static inline gfp_t gfp_any(void)
>    {
>      return in_atomic() ? GFP_ATOMIC : GFP_KERNEL;
>    }

That's typically for softirq vs non softirq, which is important
for the network stack.

That said its undoubtedly possible that some users get
it wrong and assume it applies to spinlocks (without _bh) too. 
But at least the classical uses in the network stack should be ok.

I personally would consider anyone using it inside a normal
spinlock dubious anyways, because GFP_ATOMIC is the wrong
thing to use here. The correct way is to either switch to a mutex/sem
or move the allocation outside the lock.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
