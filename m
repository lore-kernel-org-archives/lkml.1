Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYHOMol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYHOMol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYHOMod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:44:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYHOMoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:44:32 -0400
Date: Fri, 15 Aug 2008 14:43:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
	64b context switch optimization?
Message-ID: <20080815124350.GA26594@elte.hu>
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com> <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com> <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <87fxp8zlx3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxp8zlx3.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> >
> > i find it pretty unacceptable these days that we limit any aspect of 
> > pure 64-bit apps in any way to 4GB (or any other 32-bit-ish limit). 
> 
> It's not limited to 2GB, there's a fallback to >4GB of course. Ok 
> admittedly the fallback is slow, but it's there.

Of course - what you are missing is that _10 milliseconds_ thread 
creation overhead is completely unacceptable overhead: it is so bad as 
if we didnt even support it.

> I would prefer to not slow down the P4s. There are **lots** of them in 
> field. And they ran 64bit still quite well. [...]

Nonsense, i had such a P4 based 64-bit box and it was painful. Everyone 
with half a brain used them as 32-bit machines. Nor is the 
context-switch overhead in any way significant. Plus, as Arjan mentioned 
it, only the earliest P4 64-bit CPUs had this problem.

> [...] Also back then I benchmarked on early K8 and it also made a 
> difference there (but I admit I forgot the numbers)

that's a lot of handwaving with no actual numbers. The numbers in this 
discussion show that the context-switch overhead is small and that the 
overhead on perfectly good systems that hit this limit is obscurely 
high.

I'd love to zap MAP_32BIT this very minute from the kernel, but you 
originally shaped the whole thing in such a stupid way that makes its 
elimination impossible now due to ABI constraints. It would have cost 
you _nothing_ to have added MAP_64BIT_STACK back then, but the quick & 
sloppy solution was to reuse MAP_32BIT for 64-bit tasks. And you are 
stupid about it even now. Bleh.

The correct solution is to eliminate this flag from glibc right now, and 
maybe add the MAP_64BIT_STACK flag as well, as i posted it - if anyone 
with such old boxes still cares (i doubt anyone does). That flag then 
will take its usual slow route. Ulrich?

	Ingo
