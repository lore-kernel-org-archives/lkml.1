Return-Path: <linux-kernel-owner+w=401wt.eu-S933987AbZDATGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbZDATGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933696AbZDATGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:06:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55927 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbZDATGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:06:15 -0400
Date: Wed, 1 Apr 2009 21:01:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090401190113.GA734@elte.hu>
References: <20090325150035.541e707a@skybase> <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904011404240.29839@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> __read_mostly should be packed as tightly as possible to increase 
> the chance that one cacheline includes multiple of the critical 
> variables for the hot code paths. Too much __read_mostly defeats 
> its purpose.

That stance is a commonly held but quite wrong and harmful IMHO.

It stiffles the proper identification of read-mostly variables _AND_ 
it hurts the proper identification of critical write-often variables 
as well. Not good.

The solution for critical write-often variables is what we always 
used: to identify them explicitly and to place them consciously into 
separate cachelines. (Or to per-cpu-ify or object-ify them where 
possible/sensible.)

Then annotate everything that is read-mostly and accessed-frequently 
with the __read_mostly attribute.
 
The rest (unannotated variables) is to be assumed "access-rarely" or 
"we-dont-care", by default. This is actually 95% of the global 
variables.

Yes, a spreading amount of annotations puts increasing pressure on 
the places that are frequently access but not properly annotated - 
but we should be happy about that: it creates the dynamics and 
pressure for them to be properly annotated.

On the other hand, depending on the "put enough data bloat between 
critical variables anyway, no need to care alignment" scheme is a 
sloppy, fragile concept that does not lead to a reliable and 
dependable end result.

It has two problems:

 - Thinking that this solves false cacheline sharing reliably is 
   wrong: there's nothing that guarantees and enforces that slapping 
   a few variables between two critical variables puts them on 
   separate cachelines:

      - Ongoing changes in code can bit-rot the 
        thought-to-be-large-enough distance between two critical 
        variables - and there's no mechanism in place. 
        Explicitly cacheline aligning them will preserve the 
        information long-term.

      - There are architectures with larger cacheline sizes than 
        what you are developing on.

      - .config variations can move variables closer or farther 
        apart from each other, hiding/triggering the false cacheline 
        sharing problem.

   It is not a maintainable concept IMHO and we should not pretend 
   it is.

 - It actually prevents true read-mostly variables from being
   annotated properly. (In such a case a true read-mostly variable
   bouncing around with a frequently-written variable cache line is
   almost as bad in terms of MESI latencies and costs as false
   cacheline sharing between two write-mostly variables.)

Architecturing the layout of variables in a knowingly random and 
.config sensitive way is simply not good design and we should not 
pretend it is.

We might not be able to solve the problem if not enough people care 
about their variables, but we should at least not be proud of a 
non-solution ;-)

	Ingo
