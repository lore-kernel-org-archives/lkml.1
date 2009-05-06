Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbZEFKcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbZEFKcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEFKce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:32:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZEFKcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:32:32 -0400
Date: Wed, 6 May 2009 12:30:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20090506103034.GA25203@elte.hu>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505202219.GL31071@waste.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Tue, May 05, 2009 at 09:52:46PM +0200, Ingo Molnar wrote:
> > 
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > 
> > > Ingo Molnar <mingo@elte.hu> writes:
> > > 
> > > > * Matt Mackall <mpm@selenic.com> wrote:
> > > >
> > > >> As to what's the appropriate sort of RNG for ASLR to use, finding 
> > > >> a balance between too strong and too weak is tricky. [...]
> > > >
> > > > In exec-shield i mixed 'easily accessible and fast' semi-random 
> > > > state to the get_random_int() result: xor-ed the cycle counter, the 
> > > > pid and a kernel address to it. That strengthened the result in a 
> > > > pretty practical way (without strengthening the theoretical 
> > > > randomless - each of those items are considered guessable) and does 
> > > > so without weakening the entropy of the random pool.
> > > 
> > > The trouble is, that thinking completely misses the problem, and I 
> > > expect that is why we have a problem.  Throwing a bunch of 
> > > possibly truly random values into the pot for luck is nice.  But 
> > > you didn't throw in a pseudo random number generator.  An 
> > > unpredictable sequence that is guaranteed to change from one 
> > > invocation to the next.
> > 
> > Alas, i did - it got 'reviewed' out of existence ;)
> > 
> > I still have the backups, here's the original exec-shield RNG:
> > 
> > +/*
> > + * Get a random word:
> > + */
> > +static inline unsigned int get_random_int(void)
> > +{
> > +       unsigned int val = 0;
> > +
> > +       if (!exec_shield_randomize)
> > +               return 0;
> > +
> > +#ifdef CONFIG_X86_HAS_TSC
> > +       rdtscl(val);
> > +#endif
> > +       val += current->pid + jiffies + (int)&val;
> > +
> > +       /*
> > +        * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
> > +        * every second, from the entropy pool (and thus creates a limited
> > +        * drain on it), and uses halfMD4Transform within the second. We
> > +        * also spice it with the TSC (if available), jiffies, PID and the
> > +        * stack address:
> > +        */
> > +       return secure_ip_id(val);
> > +}
> 
> Ingo, what are you on about? On every architecture but X86 with 
> TSC this is identical to the broken code.

Note that this was the exec-shield arch/*86/mm/mmap.c code.

(Also, obviously "only" covering 95% of the Linux systems has its 
use as well. Most other architectures have their own cycle counters 
as well.)

> TSC only helps matters slightly - the timescales involved in 
> process creation are very short and we can probably brute-force 
> attack it with a useful probability of success. ie:
> 
> a) record TSC
> b) fork target process
> c) record TSC
> d) guess TSC value 
> e) attempt attack
> f) repeat

Try that one day and see how much jitter there is in that sequence, 
even on a completely quiescent system.

	Ingo
