Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZEGPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZEGPE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZEGPEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:04:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZEGPEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:04:13 -0400
Date: Thu, 7 May 2009 17:02:31 +0200
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
Message-ID: <20090507150231.GB2344@elte.hu>
References: <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <20090507005016.GJ31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507005016.GJ31071@waste.org>
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


* Matt Mackall <mpm@selenic.com> wrote:

> On Wed, May 06, 2009 at 12:57:17PM -0500, Matt Mackall wrote:
> > On Wed, May 06, 2009 at 09:48:20AM -0700, Linus Torvalds wrote:
> > > 
> > > Matt, are you willing to ack my suggested patch which adds history to the 
> > > mix? Did somebody test that? I have this memory of there being an 
> > > "exploit" program to show the non-randomness of the values, but I can't 
> > > recall details, and would really want to get a second opinion from 
> > > somebody who cares about PRNG's.
> > 
> > I still don't like it. I bounced it off some folks on the adversarial
> > side of things and they didn't think it looked strong enough either.
> > Full MD5 collisions can be generated about as fast as they can be
> > checked, which makes _reduced strength_ MD4 not much better than an
> > LFSR in terms of attack potential. So I suggest we either:
> > 
> > a) take my original patch 
> > b) respin your patch using at least SHA1 rather than halfMD4 and
> > changing the name to get_random_u32
> > 
> > If you'd prefer (b), I'll do the legwork.
> 
> I've done some basic benchmarks on the primitives here in userspace:
> 
> halfMD4 get_random_int: about .326us per call or 12.2MB/s
> sha1 get_random_int: about .660us per call or 6.1MB/s
> dd /dev/urandom: 3.6MB/s
> 
> So I think the SHA1 solution is quite competitive on the 
> performance front with far fewer concerns about its strength. I'll 
> spin a proper patch tomorrow.

Hm, i'm not happy about that at all - that's like a ~2000 cycles 
cost, probably fully cached! Do you have cache-cold numbers as well?

We have:

 aldebaran:~/l> ./lat_proc fork
 Process fork+exit: 61.7865 microseconds

So what you are talking about is about 1% of our fork performance! 
And fork is a pretty fat operation - it could be much worse for 
something ligther.

As i mentioned it in the previous mail, i'd _really_ like to hear 
your thread model and attack vector description. Does this overhead 
justify the threat? Your change will only result in get_random_int() 
not being considered fast anymore.

So unless a strong reason to do otherwise, i'd really prefer Linus's 
modified patch, the one i tested and sent out yesterday. (attached 
below again)

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Wed, 6 May 2009 22:09:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] random: make get_random_int() more random
Cc: Matt Mackall <mpm@selenic.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
	security@kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	James Morris <jmorris@namei.org>,
	linux-security-module@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Roland McGrath <roland@redhat.com>, mingo@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
	Dave Jones <davej@redhat.com>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 6 May 2009, Matt Mackall wrote:
> 
> > On Wed, May 06, 2009 at 12:30:34PM +0200, Ingo Molnar wrote:
>
> > > (Also, obviously "only" covering 95% of the Linux systems has 
> > > its use as well. Most other architectures have their own cycle 
> > > counters as well.)
> > 
> > X86 might be 95% of desktop. But it's a small fraction of Linux 
> > systems once you count cell phones, video players, TVs, cameras, 
> > GPS devices, cars, routers, etc. almost none of which are 
> > x86-based. In fact, just Linux cell phones (with about an 8% 
> > share of a 1.2billion devices per year market) dwarf Linux 
> > desktops (maybe 5% of a 200m/y market).
> 
> Matt, are you willing to ack my suggested patch which adds history 
> to the mix? Did somebody test that? I have this memory of there 
> being an "exploit" program to show the non-randomness of the 
> values, but I can't recall details, and would really want to get a 
> second opinion from somebody who cares about PRNG's.

I tested it, and besides booting up fine, i also tested the 
get_random_int() randomness. I did this by adding this quick 
trace_printk() line:

   trace_printk("get_random_int(): %08x\n", get_random_int());

to sys_prctl() and triggered sys_prctl() in a loop, which gave a 
list of get_random_int() numbers:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |	 |          |         |
           <...>-6288  [000]   618.151323: sys_prctl: get_random_int(): 2e927f66
           <...>-6290  [000]   618.152924: sys_prctl: get_random_int(): d210df1f
           <...>-6293  [000]   618.155326: sys_prctl: get_random_int(): 753ad860
           <...>-6295  [000]   618.156939: sys_prctl: get_random_int(): c74d935f
           <...>-6298  [000]   618.159334: sys_prctl: get_random_int(): bb4e7597
           <...>-6300  [000]   618.160936: sys_prctl: get_random_int(): b0119885
           <...>-6303  [000]   618.163331: sys_prctl: get_random_int(): 093f5c70

Full list attached.

I then wrote a quick script to write those numbers out into a 
continous binary file (result also attached).

I then ran the FIPS randomness test over the first 20,000 bits [2.5K 
data], which it passed:

rngtest: bits received from input: 20064
rngtest: bits sent to output: 20000
rngtest: FIPS 140-2 successes: 1
rngtest: FIPS 140-2 failures: 0
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3.104; avg=3.104; max=3.104)Gibits/s
rngtest: FIPS tests speed: (min=110.892; avg=110.892; max=110.892)Mibits/s
rngtest: output channel speed: (min=544.957; avg=544.957; max=544.957)Mibits/s
rngtest: Program run time: 294 microseconds

So it looks good enough - that's a sample of 800+ pseudo-random 
integers.

I also modified your patch to include two more random sources, 
get_cycles() [which all 22 architectures define - albeit not all 
have the hw to actually do fine-grained cycle counts - so for some 
it's always-zero or a low-res return value], plus a kernel stack 
address.

The relevant line is:

+	hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;

The argument is that the more layers we have here, the harder it 
becomes to _reliably_ attack a given system. Works-100%-sure is an 
important prize for certain types of attackers - and with the cycle 
counter, jiffies, PID and a kernel address all mixed in that becomes 
quite hard to achieve.

I tested this too - it also results in good random numbers. Find the 
patch below.

	Ingo


--------------->
Subject: random: make get_random_int() more random
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 May 2009 08:17:43 -0700 (PDT)

It's a really simple patch that basically just open-codes the current
"secure_ip_id()" call, but when open-coding it we now use a _static_
hashing area, so that it gets updated every time.

And to make sure somebody can't just start from the same original seed of
all-zeroes, and then do the "half_md4_transform()" over and over until
they get the same sequence as the kernel has, each iteration also mixes in
the same old "current->pid + jiffies" we used - so we should now have a
regular strong pseudo-number generator, but we also have one that doesn't
have a single seed.

Note: the "pid + jiffies" is just meant to be a tiny tiny bit of noise. It
has no real meaning. It could be anything. I just picked the previous
seed, it's just that now we keep the state in between calls and that will
feed into the next result, and that should make all the difference.

I made that hash be a per-cpu data just to avoid cache-line ping-pong:
having multiple CPU's write to the same data would be fine for randomness,
and add yet another layer of chaos to it, but since get_random_int() is
supposed to be a fast interface I did it that way instead. I considered
using "__raw_get_cpu_var()" to avoid any preemption overhead while still
getting the hash be _mostly_ ping-pong free, but in the end good taste won
out.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/random.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: linux/drivers/char/random.c
===================================================================
--- linux.orig/drivers/char/random.c
+++ linux/drivers/char/random.c
@@ -1665,15 +1665,20 @@ EXPORT_SYMBOL(secure_dccp_sequence_numbe
  * value is not cryptographically secure but for several uses the cost of
  * depleting entropy is too high
  */
+DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
 unsigned int get_random_int(void)
 {
-	/*
-	 * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
-	 * every second, from the entropy pool (and thus creates a limited
-	 * drain on it), and uses halfMD4Transform within the second. We
-	 * also mix it with jiffies and the PID:
-	 */
-	return secure_ip_id((__force __be32)(current->pid + jiffies));
+	struct keydata *keyptr;
+	__u32 *hash = get_cpu_var(get_random_int_hash);
+	int ret;
+
+	keyptr = get_keyptr();
+	hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;
+
+	ret = half_md4_transform(hash, keyptr->secret);
+	put_cpu_var(get_random_int_hash);
+
+	return ret;
 }
 
 /*
