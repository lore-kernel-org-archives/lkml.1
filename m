Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248Ab0ANBFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0ANBFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088Ab0ANBFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:05:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab0ANBFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:05:51 -0500
Date: Wed, 13 Jan 2010 17:05:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
       schwab@linux-m68k.org
Subject: Re: x86-32: clean up rwsem inline asm statements
In-Reply-To: <4B4E3549.7060405@zytor.com>
Message-ID: <alpine.LFD.2.00.1001131654580.13231@localhost.localdomain>
References: <20100113195828.2611.qmail@science.horizon.com> <4B4E3549.7060405@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jan 2010, H. Peter Anvin wrote:
> 
> There are a number of things that can be done better... for one thing,
> "+m" (sem->count) and "a" (sem) is just bloody wrong.  The right thing
> would be "a" (&sem->count) for proper robustness.

Actually, no.

Strictly speaking, we should use "a" (sem), and then use '%0' (pointing to 
the "+m" (sem->count)) for the actual memory access in the inline asm, 
rather than '(%1)'.

We do need %eax to contain the pointer to the semaphore, because _that_ is 
what we pass in as an argument (and return as a value!) to the rwsem slow 
paths.

So "a" (sem) is absolutely the right thing to do.

The reason we use "(%1)" rather than "%0" is - if I recall correctly - 
that back when we inlined it, gcc would often stupidly use the original 
value of the semaphore address rather than %eax (which obviously also 
contained it), and it generated larger code with big constants etc.

Now, since we only inline it in one place anyway, and the semaphore is 
always an argument to that inlining site anyway, I don't think it matters 
(it's never going to be some global pointer), and we probably could/should 
just do this right. So instead of

	LOCK_PREFIX "  inc%z0      (%1)\n\t"

we'd probably be better off with just

	LOCK_PREFIX "  inc%z0 %0\n\t"

instead, letting gcc generate the memory pointer to "sem->count" itself.

		Linus
