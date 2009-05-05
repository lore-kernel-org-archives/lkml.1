Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbZEET5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbZEET5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZEET46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:56:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZEET45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:56:57 -0400
Date: Tue, 5 May 2009 21:52:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Mackall <mpm@selenic.com>,
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
Message-ID: <20090505195246.GC21973@elte.hu>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ow0ynjm.fsf@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Matt Mackall <mpm@selenic.com> wrote:
> >
> >> As to what's the appropriate sort of RNG for ASLR to use, finding 
> >> a balance between too strong and too weak is tricky. [...]
> >
> > In exec-shield i mixed 'easily accessible and fast' semi-random 
> > state to the get_random_int() result: xor-ed the cycle counter, the 
> > pid and a kernel address to it. That strengthened the result in a 
> > pretty practical way (without strengthening the theoretical 
> > randomless - each of those items are considered guessable) and does 
> > so without weakening the entropy of the random pool.
> 
> The trouble is, that thinking completely misses the problem, and I 
> expect that is why we have a problem.  Throwing a bunch of 
> possibly truly random values into the pot for luck is nice.  But 
> you didn't throw in a pseudo random number generator.  An 
> unpredictable sequence that is guaranteed to change from one 
> invocation to the next.

Alas, i did - it got 'reviewed' out of existence ;)

I still have the backups, here's the original exec-shield RNG:

+/*
+ * Get a random word:
+ */
+static inline unsigned int get_random_int(void)
+{
+       unsigned int val = 0;
+
+       if (!exec_shield_randomize)
+               return 0;
+
+#ifdef CONFIG_X86_HAS_TSC
+       rdtscl(val);
+#endif
+       val += current->pid + jiffies + (int)&val;
+
+       /*
+        * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
+        * every second, from the entropy pool (and thus creates a limited
+        * drain on it), and uses halfMD4Transform within the second. We
+        * also spice it with the TSC (if available), jiffies, PID and the
+        * stack address:
+        */
+       return secure_ip_id(val);
+}

I thought that basing it on the networking PRNG is proper design: 
the networking folks have showed it time and again that they care 
about the PRNG not being brute-forceable easily, while still staying 
fast enough.

I added the TSC and a few other pseudo-random details to increase 
complexity of any brute-force attack. (in the hope of rendering it 
less practical, at minimal cost)

> In a very practical sense a pseudo random generator is completely 
> sufficient.  Throwing in a few truly random numbers guards against 
> attacks on the random number generator.
> 
> What we have now is a hash over an a value that changes every 5 
> minutes and some well known values.

Yes.

	Ingo
