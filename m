Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZEEU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZEEU0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZEEU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:26:04 -0400
Received: from waste.org ([66.93.16.53]:36824 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZEEU0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:26:03 -0400
Date: Tue, 5 May 2009 15:22:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
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
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090505202219.GL31071@waste.org>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505195246.GC21973@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:52:46PM +0200, Ingo Molnar wrote:
> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > * Matt Mackall <mpm@selenic.com> wrote:
> > >
> > >> As to what's the appropriate sort of RNG for ASLR to use, finding 
> > >> a balance between too strong and too weak is tricky. [...]
> > >
> > > In exec-shield i mixed 'easily accessible and fast' semi-random 
> > > state to the get_random_int() result: xor-ed the cycle counter, the 
> > > pid and a kernel address to it. That strengthened the result in a 
> > > pretty practical way (without strengthening the theoretical 
> > > randomless - each of those items are considered guessable) and does 
> > > so without weakening the entropy of the random pool.
> > 
> > The trouble is, that thinking completely misses the problem, and I 
> > expect that is why we have a problem.  Throwing a bunch of 
> > possibly truly random values into the pot for luck is nice.  But 
> > you didn't throw in a pseudo random number generator.  An 
> > unpredictable sequence that is guaranteed to change from one 
> > invocation to the next.
> 
> Alas, i did - it got 'reviewed' out of existence ;)
> 
> I still have the backups, here's the original exec-shield RNG:
> 
> +/*
> + * Get a random word:
> + */
> +static inline unsigned int get_random_int(void)
> +{
> +       unsigned int val = 0;
> +
> +       if (!exec_shield_randomize)
> +               return 0;
> +
> +#ifdef CONFIG_X86_HAS_TSC
> +       rdtscl(val);
> +#endif
> +       val += current->pid + jiffies + (int)&val;
> +
> +       /*
> +        * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
> +        * every second, from the entropy pool (and thus creates a limited
> +        * drain on it), and uses halfMD4Transform within the second. We
> +        * also spice it with the TSC (if available), jiffies, PID and the
> +        * stack address:
> +        */
> +       return secure_ip_id(val);
> +}

Ingo, what are you on about? On every architecture but X86 with TSC
this is identical to the broken code.

TSC only helps matters slightly - the timescales involved in process
creation are very short and we can probably brute-force attack it with
a useful probability of success. ie:

a) record TSC
b) fork target process
c) record TSC
d) guess TSC value 
e) attempt attack
f) repeat

-- 
Mathematics is the supreme nostalgia of our time.
