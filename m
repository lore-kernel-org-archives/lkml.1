Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbYBNU0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbYBNU0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYBNUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:25:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbYBNUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:25:57 -0500
Date: Thu, 14 Feb 2008 21:25:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214202535.GA25316@elte.hu>
References: <20080214190050.GA32258@elte.hu> <47B4AAB8.106.FEA5232@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B4AAB8.106.FEA5232@pageexec.freemail.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> really, the best defense is to reduce the useful lifetime of any 
> leaked canary, and you can't get better than syscall granularity 
> without disproportional effort and impact elsewhere (and i'm sure some 
> would find even this disproportional ;).

hm, i think per syscall canaries are really expensive.

The per function call overhead from stackprotector is already pretty 
serious IMO, but at least that's something that GCC _could_ be doing 
(much) smarter (why doesnt it jne forward out to __check_stk_failure, 
instead of generating 4 instructions, one of them a default-mispredicted 
branch instruction??), so that overhead could in theory be something 
like 4 fall-through instructions per function, instead of the current 6.

Also, even with -fstack-protector-all, gcc could detect the _provably_ 
correct and overflow-safe functions and skip their annotation 
altogether. And those are the ones that hurt most: the small and 
straightforward (and also, most of the time, overflow-free) ones.

The heuristics for -fstack-protector were really botched, as you noted 
they happened to mark vmsplice as "safe". So either we do the full thing 
or nothing - anything inbetween is just russian roulette and false sense 
of security.

But per syscall canary randomization is something that would be a drag 
on our null syscall latency forever. I'm really unsure about it. It will 
also be driven in the wrong direction: people would try to "optimize" 
the per syscall random number generation which is a constant erosive 
force on its strength and there's no strong counter-force. (and no clear 
boundary either 'random32 should be plenty enough' is too vague as 
limit.)

So lets perhaps also analyze the security effects of not having per 
system call canaries and make the best out of it: the main threat is 
information leaks via padding and similar initialization mistakes [which 
have almost zero accidental discovery rate], right?

So could we perhaps somehow turn kernel-space information leaks into 
functional, and hence detectable failures? Wouldnt for example kmemcheck 
notice them, once they are copied to user-space? [ If you havent seen 
kmemcheck yet i think you'll love it, it's a similarly neat trick as the 
pte noexec trick you did in the PaX kernel. It's similarly disgusting as 
well ;-) ]

> > TODO: perhaps all vsyscall functions need to move into separate .o 
> > files. (probably academic as the functions affected by that tend to 
> > be very simple and do not deal with anything overflowable.)
> 
> yeah, i wasn't suggesting it for its security value, more like for 
> 'full coverage'. if such a separation isn't useful otherwise (no idea 
> if not having the .vsyscall* code along with related kernel code would 
> be confusing for the reader for example), i'd say this isn't 
> important.

perhaps it would be more useful to have some "no stack protector" gcc 
attribute. We could then stick that into the __vsyscall definition and 
it's all done and self-maintaining from that point on. (because a 
missing __vsyscall annotation results in a runtime failure.) (I'd fully 
expect GCC to not have provided such an attribute.)

but yes, i agree in general that it's easier to maintain something if 
it's full coverage, that way one does not have to keep in mind (and 
cannot accidentally forget ;-) the exceptions.

	Ingo
