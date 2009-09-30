Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZI3QO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZI3QO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZI3QO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:14:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbZI3QOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:14:54 -0400
Date: Wed, 30 Sep 2009 09:14:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <4AC37FE5.7020200@gmail.com>
Message-ID: <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Eric Dumazet wrote:
> 
> lock; cmpxchg8b (%%esi)
> 
> gives 4 bytes opcode : f0 0f c7 0e
> Because alternative (call cmpxchg8b_emu) uses 5 bytes, a nop will be added.
> 
> Choosing ".byte 0xf0, 0x0f, 0xc7, 0x4e, 0x00"  aka "lock cmpxchg8b 0x0(%esi)" is a litle bit better ?

And if you want to be really clever, you would want to handle the non-SMP 
case too, where you have just "cmpxchgb (%%esi)" (three bytes) without the 
lock prefix.

However, at this point I think Arjan's patch is already way superior to 
what we have now (feel free to take a look at what we generate on 32-bit 
without PAE today - just have a barf-bag handy), so all I'd really want is 
a few "tested-by"s to make me feel happier about it, and a few more people 
looking at the emulation routine to all say "ok, looks sane, ACK".

And at that point we can then either make "cmpxchg()" just do the 8-byte 
case natively, or just take your patch to change sched_clock.c to now use 
the no-longer-entirely-disgusting cmpxchg64().

Ingo - I suspect both those patches should just go through you. You do 
both x86 and scheduler, so I'll happily pull the end result.

			Linus
