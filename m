Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbYGKBtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbYGKBtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYGKBtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:49:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbYGKBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:49:06 -0400
Date: Thu, 10 Jul 2008 18:48:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080711005243.ADE90154218@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807101824150.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain> <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
 <20080711005243.ADE90154218@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Roland McGrath wrote:
> 
> i386 has never behaved this way, and still doesn't.

Btw, I told you differently, you didn't believe me. So I went back just 
because I have an ego easily the size of Manhattan, and when you doubt me, 
my ego is hurt.

i386 _has_ very much behaved this way. The system call code literally used 
to do

		..
	        cmpl $0,sigpending(%ebx)
	        jne signal_return
		..

and then 'signal_return' case would handle one signal and then return to 
user space:

		..
	        call SYMBOL_NAME(do_signal)
	#ifdef CONFIG_SMP
	        GET_CURRENT(%ebx)
	#endif
	        cli
	        CHECK_SOFTIRQ
	        je restore_all
		..

ie it would call "restore_all" without re-checking signals. I wasn't 
hallucinating.

So that's really old code.

The _really_ ancient code (like a decade ago or more) used to actually 
loop in do_signal() generating multiple signal stacks in one go. Then, a 
long long time ago, that was actually removed, and we expressly only tried 
to queue one signal at a time. I do not remember why, but it was before 
2.4.0. Probably _long_ before, but it's so long ago my memory is 
unreliable.

The "queue multiple signals" code that you claim has always been there is 
in fact pretty recent. For x86-32, it was a thing introduced in commit 
c3ff8ec31c1249d268cd11390649768a12bec1b9: by _you_, just three years ago, 
in 2.6.14, in regular git times.

So the x86-64 behaviour actually matches what the x86-32 behavior was at 
the time before things split.

And I'd also like to point out another commit, namely "[PATCH] fix broken 
vm86 interrupt/signal handling" (4031ff388138b58e5cd472dccce38828bcb8c706) 
that fixed a bug with an endless loop you had introduced in that original 
x86-32 code when you fixed this exact same issue back when.

Heh. That's the kind of thing that worries me.

			Linus
