Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZEGSoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZEGSoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZEGSoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:44:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52791 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZEGSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:44:20 -0400
Date: Thu, 7 May 2009 20:41:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to
	non-privileged processes
Message-ID: <20090507184136.GB30659@elte.hu>
References: <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <20090507005016.GJ31071@waste.org> <20090507150231.GB2344@elte.hu> <20090507181434.GL31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507181434.GL31071@waste.org>
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


* Matt Mackall <mpm@selenic.com> wrote:

> > As i mentioned it in the previous mail, i'd _really_ like to 
> > hear your thread model and attack vector description. Does this 
> > overhead justify the threat? Your change will only result in 
> > get_random_int() not being considered fast anymore.
> 
> My threat model is that someone more clever and with a lot more 
> expertise attacking systems than either you or me will be able to 
> leverage the extreme weakness of this hash (O(1) attacks against 
> the *full* version!) into an attack that incrementally exposes the 
> hidden RNG state. I've asked a couple such people whether they 
> think that's likely, and they've said yes.

My question was whether the variant laced with the cycle counter 
could be exposable.

I'd say that's almost impossible physically, in all but the most 
trivial cases. Yes, you can do it with a static PRNG and a static 
pool, but neither pool is static in reality (irqs are coming in all 
the time) nor is the cycle counter static. The cycle counter will 
mix in things like cache miss delays.

You need a really, really fast probe and a really quiet system to 
pull off a statistical attack like that. In all other realistic 
cases you have to play catch-up with the current state of the pool, 
trying to guess it. And even if you have a reasonably good idea 
about it, there's no _guarantee_ that your guess about the pool's 
state is when a critical context you'd like to attack seeds its ASLR 
or whatever other secret state.

> In fact, it's been known for over a decade that reduced-round MD4 
> such as ours is *not one way* and that preimages (aka our hidden 
> state) can be found in less than an hour on a *mid-90s era PC*:
> 
> http://citeseer.ist.psu.edu/old/182935.html

But that is completely inapposite to the PRNG i posted. Getting to 
preimage in a static MD4 hash where you have a reasonable number of 
probes right after the unknown result is possible.

Eliminating cycle counter noise out of a _static_ secret permutated 
via a PRNG is probably also possible, if the probe can be done 
faster than the natural noise level of the cycle counter is.

_Combining_ the two and attacking _that_ (combined with the addition 
of jiffies and a kernel stack address) - seems close to impossible 
to me. You'd have to guess the precise cycle counter value at the 
point of the hashing, and your samples wont help with that. They 
might give an estimation, but that's really what ASLR is about: the 
moment an attack isnt 100% sure, other measures (such as crash 
monitoring) can save the day.

The really serious attackers avoid uncertainty like the plague. 

It's the same reason why three letter agencies rather drop slam-dunk 
court cases than expose their sources and methods. A failed attack 
against a system exposes the attack and since the attack failed, 
there's no way to erase traces of the attack.

Furthermore, ASLR is mostly about changing the dynamics of worm 
attacks via the network. If an attack has only a 10% chance to 
succeed, that might break the propagation dynamics of a worm. So 
just a handful of bits are enough there.

> Combine that with greatly improved techniques for attacking hashes 
> in the MD4 family in the last five years and you're probably 
> looking at less than a second of CPU time. Combine that with the 
> fact that we're using the hash in a feedback mode, and things only 
> get easier.
> 
> On the question of 'what if we add in the TSC?', I'd first say (a) 
> we can't and shouldn't assume a TSC is available, though we 
> certainly should use it if it is. Second I'd say that there are 
> numerous timing attacks that have been done that suggest that 
> guessing the TSC can be done with useful probability. For 
> instance, see the branch prediction attacks against AES and RSA.

That is something completely different again, and i'm not sure 
whether you are trolling here or not...

Branch prediction attacks against AES and RSA are _completely 
different_ and the TSC connection is only there in name. They are 
about using timing as a _sample_ of the secret state and its effects 
on runtime.

Here the TSC is taken once, and mixed. _This_ TSC is not taken ever 
again, nor saved. There's no statistical method to recover it! You 
might know it up to a certain precision if you are lucky and can run 
right after the call, but a couple of bits of true randomness will 
be there for sure. In most cases more than a coupleof bits - an exec 
takes 200-300 usecs and you have to run on that same CPU - so to get 
a sample you have to go back almost 1 million TSC cycles ... That's 
20 bits of TSC space.

	Ingo
