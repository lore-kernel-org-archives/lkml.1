Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYHPVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYHPVeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYHPVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 17:34:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYHPVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 17:34:03 -0400
Date: Sat, 16 Aug 2008 14:33:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fair rwlock
In-Reply-To: <20080816211954.GB7358@Krystal>
Message-ID: <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Aug 2008, Mathieu Desnoyers wrote:
> 
> Tweakable contention behavior seems interesting, but I don't think it
> deals with the fact that on a mainline kernel, when an interrupt handler
> comes in and asks for a read lock, it has to get it on the spot.

Right. Which is exactly why I'd suggest using the extra space for saying 
"this CPU is busy-looping waiting for a write lock", and then the 
read-lock contention case can say

 - ok, there's a pending write lock holder on _my_ CPU, so I need to just 
   succeed right away despite the fact that there is contention.

In other words, there are a few cases:

 - you actually *got* the write lock

   interrupts obviously have to be disabled here, because any reader can 
   simply not get the lock.

 - you are waiting to get the write lock.

   Mark this CPU as "pending" in the rwlock (by making the extended thing 
   be a queue, or by simply only ever allowing a single pendign CPU), and 
   re-enable interrupts while you wait for it. An interrupt that comes in 
   and wants a read-lock sees that it's pending, so it should then ignore 
   the contention bit, and only wait for the write bit to go away.

See? This way you only need to actually disable interrupts while holding 
literally the lock, not while waiting for it. While still giving priority 
to writers (except for the _one_ CPU, where new readers will have to get 
through).

So this way you can be fair, and not allow readers to starve a writer. The 
only reader that is allowed past a waiting writer is the reader on that 
same CPU.

And notice how the fast-path needs no spinlock or anything else - it's 
still just a single locked instruction. In comparison, if I read your 
example code right, it is absolutely horrid and has an extra spinlock 
access for the fair_write_lock case.

			Linus
