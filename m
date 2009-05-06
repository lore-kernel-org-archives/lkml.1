Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbZEFUMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbZEFUMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZEFUMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:12:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbZEFUMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:12:15 -0400
Date: Wed, 6 May 2009 22:09:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: [patch] random: make get_random_int() more random
Message-ID: <20090506200954.GA21484@elte.hu>
References: <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
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


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


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

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace.txt"

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-6288  [000]   618.151323: sys_prctl: get_random_int(): 2e927f66
           <...>-6290  [000]   618.152924: sys_prctl: get_random_int(): d210df1f
           <...>-6293  [000]   618.155326: sys_prctl: get_random_int(): 753ad860
           <...>-6295  [000]   618.156939: sys_prctl: get_random_int(): c74d935f
           <...>-6298  [000]   618.159334: sys_prctl: get_random_int(): bb4e7597
           <...>-6300  [000]   618.160936: sys_prctl: get_random_int(): b0119885
           <...>-6303  [000]   618.163331: sys_prctl: get_random_int(): 093f5c70
           <...>-6305  [000]   618.164932: sys_prctl: get_random_int(): 041237bf
           <...>-6308  [000]   618.167334: sys_prctl: get_random_int(): 8728717c
           <...>-6310  [000]   618.168933: sys_prctl: get_random_int(): b4f8ee5b
           <...>-6313  [000]   618.171332: sys_prctl: get_random_int(): c878732e
           <...>-6315  [000]   618.172896: sys_prctl: get_random_int(): 3c4f8609
           <...>-6318  [000]   618.175359: sys_prctl: get_random_int(): 95e66917
           <...>-6320  [000]   618.176919: sys_prctl: get_random_int(): 5c15d7f7
           <...>-6323  [000]   618.179312: sys_prctl: get_random_int(): a30704fa
           <...>-6325  [000]   618.180912: sys_prctl: get_random_int(): 833942d7
           <...>-6328  [000]   618.183313: sys_prctl: get_random_int(): a98634cc
           <...>-6330  [000]   618.184916: sys_prctl: get_random_int(): 66ac3dc9
           <...>-6333  [000]   618.187313: sys_prctl: get_random_int(): 5465b8d1
           <...>-6335  [000]   618.188913: sys_prctl: get_random_int(): d1904f92
           <...>-6338  [000]   618.191316: sys_prctl: get_random_int(): 8092c0b0
           <...>-6340  [000]   618.192916: sys_prctl: get_random_int(): faa7ea03
           <...>-6343  [000]   618.195317: sys_prctl: get_random_int(): 63f1d4b7
           <...>-6345  [000]   618.196922: sys_prctl: get_random_int(): 7a253bca
           <...>-6348  [000]   618.199322: sys_prctl: get_random_int(): 6cee3879
           <...>-6350  [000]   618.200923: sys_prctl: get_random_int(): 620ed75d
           <...>-6353  [000]   618.203325: sys_prctl: get_random_int(): 787c8fab
           <...>-6355  [000]   618.204927: sys_prctl: get_random_int(): 8038f759
           <...>-6358  [000]   618.207329: sys_prctl: get_random_int(): 219875ef
           <...>-6360  [000]   618.208891: sys_prctl: get_random_int(): e6dcad80
           <...>-6363  [000]   618.211339: sys_prctl: get_random_int(): dedfa120
           <...>-6365  [000]   618.212897: sys_prctl: get_random_int(): 899bb25f
           <...>-6368  [000]   618.215346: sys_prctl: get_random_int(): 5a2b5077
           <...>-6370  [000]   618.216908: sys_prctl: get_random_int(): 17f0fd44
           <...>-6373  [000]   618.219304: sys_prctl: get_random_int(): 7166a01b
           <...>-6375  [000]   618.220903: sys_prctl: get_random_int(): 2ea8f988
           <...>-6378  [000]   618.223302: sys_prctl: get_random_int(): f05b68a3
           <...>-6380  [000]   618.224904: sys_prctl: get_random_int(): e98e5fda
           <...>-6383  [000]   618.227306: sys_prctl: get_random_int(): d8e1b0b3
           <...>-6385  [000]   618.228907: sys_prctl: get_random_int(): 13fe3c99
           <...>-6388  [000]   618.231306: sys_prctl: get_random_int(): 8f0ffc91
           <...>-6390  [000]   618.232905: sys_prctl: get_random_int(): ea19eb37
           <...>-6393  [000]   618.235301: sys_prctl: get_random_int(): ccaea83d
           <...>-6395  [000]   618.236909: sys_prctl: get_random_int(): f69c6429
           <...>-6398  [000]   618.239311: sys_prctl: get_random_int(): 2135f269
           <...>-6400  [000]   618.240908: sys_prctl: get_random_int(): 60b8f110
           <...>-6403  [000]   618.243307: sys_prctl: get_random_int(): 17bb9c58
           <...>-6405  [000]   618.244905: sys_prctl: get_random_int(): 8b70e834
           <...>-6408  [000]   618.247302: sys_prctl: get_random_int(): 0396b347
           <...>-6410  [000]   618.248902: sys_prctl: get_random_int(): 86fd4976
           <...>-6413  [000]   618.251296: sys_prctl: get_random_int(): c23c28fd
           <...>-6415  [000]   618.252898: sys_prctl: get_random_int(): c32ffbd7
           <...>-6418  [000]   618.255296: sys_prctl: get_random_int(): 9684d604
           <...>-6420  [000]   618.256907: sys_prctl: get_random_int(): 0e4ccfd3
           <...>-6423  [000]   618.259307: sys_prctl: get_random_int(): ccd69363
           <...>-6425  [000]   618.260910: sys_prctl: get_random_int(): 07993743
           <...>-6428  [000]   618.263309: sys_prctl: get_random_int(): 9f06ba45
           <...>-6430  [000]   618.264873: sys_prctl: get_random_int(): 0dff796c
           <...>-6433  [000]   618.267322: sys_prctl: get_random_int(): 0de2019c
           <...>-6435  [000]   618.268877: sys_prctl: get_random_int(): b8e20895
##### CPU 1 buffer started ####
           <...>-6436  [001]   618.269711: sys_prctl: get_random_int(): 12c85f9d
           <...>-6437  [001]   618.270533: sys_prctl: get_random_int(): 42b96af6
           <...>-6438  [000]   618.271331: sys_prctl: get_random_int(): b60ed1b9
           <...>-6439  [001]   618.272099: sys_prctl: get_random_int(): 3aca8780
           <...>-6440  [000]   618.272884: sys_prctl: get_random_int(): 7b624df1
           <...>-6441  [001]   618.273714: sys_prctl: get_random_int(): 1d82f78b
           <...>-6442  [001]   618.274541: sys_prctl: get_random_int(): 99c1f14b
           <...>-6443  [000]   618.275332: sys_prctl: get_random_int(): 87e1ab89
           <...>-6444  [001]   618.276104: sys_prctl: get_random_int(): a13a6dd2
           <...>-6445  [000]   618.276895: sys_prctl: get_random_int(): a544ec7f
           <...>-6446  [001]   618.277716: sys_prctl: get_random_int(): fa9bbb74
           <...>-6447  [001]   618.278528: sys_prctl: get_random_int(): 30a47646
           <...>-6448  [000]   618.279288: sys_prctl: get_random_int(): 045208d2
           <...>-6449  [001]   618.280062: sys_prctl: get_random_int(): 0961aeb0
           <...>-6450  [000]   618.280894: sys_prctl: get_random_int(): 00d85257
           <...>-6451  [001]   618.281720: sys_prctl: get_random_int(): 7c702f29
           <...>-6452  [001]   618.282532: sys_prctl: get_random_int(): 688eaef9
           <...>-6453  [000]   618.283292: sys_prctl: get_random_int(): 493d53bb
           <...>-6454  [001]   618.284068: sys_prctl: get_random_int(): ba3251b8
           <...>-6455  [000]   618.284891: sys_prctl: get_random_int(): 34b9a5c7
           <...>-6456  [001]   618.285718: sys_prctl: get_random_int(): 188017a9
           <...>-6457  [001]   618.286527: sys_prctl: get_random_int(): 1c3a0cb0
           <...>-6458  [000]   618.287289: sys_prctl: get_random_int(): 66a10117
           <...>-6459  [001]   618.288065: sys_prctl: get_random_int(): 407df3e2
           <...>-6460  [000]   618.288894: sys_prctl: get_random_int(): dfddbea1
           <...>-6461  [001]   618.289717: sys_prctl: get_random_int(): 02a0398a
           <...>-6462  [001]   618.290530: sys_prctl: get_random_int(): ec8b8202
           <...>-6463  [000]   618.291288: sys_prctl: get_random_int(): 1b365cb7
           <...>-6464  [001]   618.292065: sys_prctl: get_random_int(): 7f0cceab
           <...>-6465  [000]   618.292893: sys_prctl: get_random_int(): 396d09da
           <...>-6466  [001]   618.293724: sys_prctl: get_random_int(): 1f004b43
           <...>-6467  [001]   618.294531: sys_prctl: get_random_int(): e56dd2f4
           <...>-6468  [000]   618.295293: sys_prctl: get_random_int(): 6465e491
           <...>-6469  [001]   618.296066: sys_prctl: get_random_int(): 9b972df1
           <...>-6470  [000]   618.296903: sys_prctl: get_random_int(): 8cc79c95
           <...>-6471  [001]   618.297726: sys_prctl: get_random_int(): fc60fce0
           <...>-6472  [001]   618.298539: sys_prctl: get_random_int(): 1c8479bf
           <...>-6473  [000]   618.299301: sys_prctl: get_random_int(): 9e943447
           <...>-6474  [001]   618.300077: sys_prctl: get_random_int(): c4839a07
           <...>-6475  [000]   618.300864: sys_prctl: get_random_int(): 25de1a81
           <...>-6476  [001]   618.301701: sys_prctl: get_random_int(): b533b223
           <...>-6477  [001]   618.302520: sys_prctl: get_random_int(): ecc3e97c
           <...>-6478  [000]   618.303315: sys_prctl: get_random_int(): 661be53c
           <...>-6479  [001]   618.304081: sys_prctl: get_random_int(): 81cdfc85
           <...>-6480  [000]   618.304870: sys_prctl: get_random_int(): 5438b5b1
           <...>-6481  [001]   618.305699: sys_prctl: get_random_int(): 826892ca
           <...>-6482  [001]   618.306526: sys_prctl: get_random_int(): eebb7b17
           <...>-6483  [000]   618.307318: sys_prctl: get_random_int(): 14078113
           <...>-6484  [001]   618.308088: sys_prctl: get_random_int(): abec8b64
           <...>-6485  [000]   618.308870: sys_prctl: get_random_int(): 6c8cb64a
           <...>-6486  [001]   618.309700: sys_prctl: get_random_int(): 1dcf996b
           <...>-6487  [001]   618.310523: sys_prctl: get_random_int(): f8dba2c0
           <...>-6488  [000]   618.311318: sys_prctl: get_random_int(): 2c1b9de7
           <...>-6489  [001]   618.312087: sys_prctl: get_random_int(): 529d827e
           <...>-6490  [000]   618.312874: sys_prctl: get_random_int(): ecd9b61d
           <...>-6491  [001]   618.313701: sys_prctl: get_random_int(): 668b9131
           <...>-6492  [001]   618.314521: sys_prctl: get_random_int(): e58c1182
           <...>-6493  [000]   618.315313: sys_prctl: get_random_int(): 00665371
           <...>-6495  [001]   618.316084: sys_prctl: get_random_int(): e1276ba5
           <...>-6496  [000]   618.316878: sys_prctl: get_random_int(): 948ce25a
           <...>-6497  [000]   618.317687: sys_prctl: get_random_int(): 631b0721
           <...>-6498  [001]   618.318479: sys_prctl: get_random_int(): bdff921d
           <...>-6499  [000]   618.319267: sys_prctl: get_random_int(): 0e461156
           <...>-6500  [001]   618.320035: sys_prctl: get_random_int(): 9fded75e
           <...>-6501  [000]   618.320865: sys_prctl: get_random_int(): 86c92499
           <...>-6502  [001]   618.321702: sys_prctl: get_random_int(): 27cd1b43
           <...>-6503  [001]   618.322520: sys_prctl: get_random_int(): e936bfeb
           <...>-6504  [000]   618.323318: sys_prctl: get_random_int(): d4f80d3c
           <...>-6505  [001]   618.324093: sys_prctl: get_random_int(): 9078a28d
           <...>-6506  [000]   618.324874: sys_prctl: get_random_int(): 25da7a03
           <...>-6507  [000]   618.325682: sys_prctl: get_random_int(): abfa7aa7
           <...>-6508  [001]   618.326475: sys_prctl: get_random_int(): 71b9ee23
           <...>-6509  [000]   618.327262: sys_prctl: get_random_int(): ccb7748d
           <...>-6510  [001]   618.328028: sys_prctl: get_random_int(): de59bd2d
           <...>-6511  [000]   618.328854: sys_prctl: get_random_int(): 4dfae3d0
           <...>-6512  [001]   618.329689: sys_prctl: get_random_int(): 1bcb042f
           <...>-6513  [001]   618.330512: sys_prctl: get_random_int(): 7daa6fdc
           <...>-6514  [000]   618.331306: sys_prctl: get_random_int(): 4a679714
           <...>-6515  [001]   618.332080: sys_prctl: get_random_int(): fe7eb37a
           <...>-6516  [000]   618.332865: sys_prctl: get_random_int(): 7267041c
           <...>-6517  [001]   618.333695: sys_prctl: get_random_int(): b2534334
           <...>-6518  [001]   618.334517: sys_prctl: get_random_int(): c6fc1f18
           <...>-6519  [000]   618.335316: sys_prctl: get_random_int(): 1b2c28c3
           <...>-6520  [001]   618.336084: sys_prctl: get_random_int(): 564f4cff
           <...>-6521  [000]   618.336879: sys_prctl: get_random_int(): e04bf4d1
           <...>-6522  [001]   618.337697: sys_prctl: get_random_int(): 48fc821b
           <...>-6523  [001]   618.338508: sys_prctl: get_random_int(): 36a9b920
           <...>-6524  [000]   618.339269: sys_prctl: get_random_int(): 713d7f6c
           <...>-6525  [001]   618.340043: sys_prctl: get_random_int(): 0ca1b588
           <...>-6526  [000]   618.340871: sys_prctl: get_random_int(): dc392ac5
           <...>-6527  [001]   618.341698: sys_prctl: get_random_int(): 96f4e601
           <...>-6528  [001]   618.342505: sys_prctl: get_random_int(): 7a88ba59
           <...>-6529  [000]   618.343268: sys_prctl: get_random_int(): a7bb7767
           <...>-6530  [001]   618.344042: sys_prctl: get_random_int(): 40b2246c
           <...>-6531  [000]   618.344871: sys_prctl: get_random_int(): 4cf2c778
           <...>-6532  [001]   618.345697: sys_prctl: get_random_int(): 27ce9238
           <...>-6533  [001]   618.346506: sys_prctl: get_random_int(): 82ab97f0
           <...>-6534  [000]   618.347265: sys_prctl: get_random_int(): 0a0af689
           <...>-6535  [001]   618.348042: sys_prctl: get_random_int(): 33ebb048
           <...>-6536  [000]   618.348868: sys_prctl: get_random_int(): 673ca6ef
           <...>-6537  [001]   618.349697: sys_prctl: get_random_int(): 43d8cfc5
           <...>-6538  [001]   618.350504: sys_prctl: get_random_int(): 660c45eb
           <...>-6539  [000]   618.351270: sys_prctl: get_random_int(): 7bdd2fc3
           <...>-6540  [001]   618.352043: sys_prctl: get_random_int(): 42f01405
           <...>-6541  [000]   618.352871: sys_prctl: get_random_int(): 87804684
           <...>-6542  [001]   618.353697: sys_prctl: get_random_int(): 4420e5c6
           <...>-6543  [001]   618.354509: sys_prctl: get_random_int(): ccd3fdba
           <...>-6544  [000]   618.355272: sys_prctl: get_random_int(): 878818a1
           <...>-6545  [001]   618.356045: sys_prctl: get_random_int(): daa3e3d0
           <...>-6546  [000]   618.356877: sys_prctl: get_random_int(): fbba68c2
           <...>-6547  [001]   618.357709: sys_prctl: get_random_int(): 81cbc31a
           <...>-6548  [001]   618.358518: sys_prctl: get_random_int(): e9a915e8
           <...>-6549  [000]   618.359285: sys_prctl: get_random_int(): efc5e143
           <...>-6550  [001]   618.360058: sys_prctl: get_random_int(): 1a08e4d7
           <...>-6551  [000]   618.360847: sys_prctl: get_random_int(): dc1e5771
           <...>-6552  [001]   618.361683: sys_prctl: get_random_int(): 22f974c9
           <...>-6553  [001]   618.362508: sys_prctl: get_random_int(): 6ca9ef3e
           <...>-6554  [000]   618.363302: sys_prctl: get_random_int(): 68eadff1
           <...>-6555  [001]   618.364075: sys_prctl: get_random_int(): 8b316b62
           <...>-6556  [000]   618.364858: sys_prctl: get_random_int(): 4dd386af
           <...>-6557  [001]   618.365690: sys_prctl: get_random_int(): 3ff6a8d7
           <...>-6558  [001]   618.366511: sys_prctl: get_random_int(): 152dd46e
           <...>-6559  [000]   618.367307: sys_prctl: get_random_int(): d28a6969
           <...>-6560  [001]   618.368075: sys_prctl: get_random_int(): 6966cb70
           <...>-6561  [000]   618.368863: sys_prctl: get_random_int(): 43421f85
           <...>-6562  [001]   618.369691: sys_prctl: get_random_int(): 3eb089a8
           <...>-6563  [001]   618.370514: sys_prctl: get_random_int(): 47079d75
           <...>-6564  [000]   618.371306: sys_prctl: get_random_int(): d5c2d282
           <...>-6565  [001]   618.372081: sys_prctl: get_random_int(): 4717efcb
           <...>-6566  [000]   618.372861: sys_prctl: get_random_int(): 25bc29de
           <...>-6567  [000]   618.373670: sys_prctl: get_random_int(): 978343b9
           <...>-6568  [001]   618.374462: sys_prctl: get_random_int(): 62b050be
           <...>-6569  [000]   618.375248: sys_prctl: get_random_int(): fc244f6d
           <...>-6570  [001]   618.376013: sys_prctl: get_random_int(): 1d03388f
           <...>-6571  [000]   618.376844: sys_prctl: get_random_int(): 990deb4b
           <...>-6572  [001]   618.377681: sys_prctl: get_random_int(): 8792427b
           <...>-6573  [001]   618.378507: sys_prctl: get_random_int(): 2344aad3
           <...>-6574  [000]   618.379300: sys_prctl: get_random_int(): 09d99c1c
           <...>-6575  [001]   618.380076: sys_prctl: get_random_int(): b867abae
           <...>-6576  [000]   618.380858: sys_prctl: get_random_int(): 441247c7
           <...>-6577  [000]   618.381668: sys_prctl: get_random_int(): 7022da76
           <...>-6578  [001]   618.382458: sys_prctl: get_random_int(): 6fe33d66
           <...>-6579  [000]   618.383244: sys_prctl: get_random_int(): f813204d
           <...>-6580  [001]   618.384015: sys_prctl: get_random_int(): 846cbe62
           <...>-6581  [000]   618.384842: sys_prctl: get_random_int(): 8839869d
           <...>-6582  [001]   618.385678: sys_prctl: get_random_int(): 1d70b5a5
           <...>-6583  [001]   618.386502: sys_prctl: get_random_int(): 99acdef4
           <...>-6584  [000]   618.387295: sys_prctl: get_random_int(): 60906ac6
           <...>-6585  [001]   618.388067: sys_prctl: get_random_int(): 229c161b
           <...>-6586  [000]   618.388848: sys_prctl: get_random_int(): 3258673e
           <...>-6587  [001]   618.389680: sys_prctl: get_random_int(): e08fadeb
           <...>-6588  [001]   618.390503: sys_prctl: get_random_int(): ac81deea
           <...>-6589  [000]   618.391297: sys_prctl: get_random_int(): 045b32e0
           <...>-6590  [001]   618.392062: sys_prctl: get_random_int(): 97ab145c
           <...>-6591  [000]   618.392849: sys_prctl: get_random_int(): feffb0da
           <...>-6592  [001]   618.393677: sys_prctl: get_random_int(): eb410916
           <...>-6593  [001]   618.394505: sys_prctl: get_random_int(): d84fd38a
           <...>-6594  [000]   618.395297: sys_prctl: get_random_int(): 87ac65df
           <...>-6595  [001]   618.396068: sys_prctl: get_random_int(): d05ab32c
           <...>-6596  [000]   618.396859: sys_prctl: get_random_int(): 591cc16a
           <...>-6597  [001]   618.397683: sys_prctl: get_random_int(): a693034a
           <...>-6598  [001]   618.398495: sys_prctl: get_random_int(): 6d777bce
           <...>-6599  [000]   618.399259: sys_prctl: get_random_int(): 5e0a52ed
           <...>-6600  [001]   618.400034: sys_prctl: get_random_int(): 9f031eed
           <...>-6601  [000]   618.400864: sys_prctl: get_random_int(): bae50780
           <...>-6602  [001]   618.401691: sys_prctl: get_random_int(): 399e3738
           <...>-6603  [001]   618.402505: sys_prctl: get_random_int(): 33d5f421
           <...>-6604  [000]   618.403271: sys_prctl: get_random_int(): 1ea06197
           <...>-6605  [001]   618.404049: sys_prctl: get_random_int(): da59ceee
           <...>-6606  [000]   618.404835: sys_prctl: get_random_int(): 17da30f3
           <...>-6607  [001]   618.405674: sys_prctl: get_random_int(): 900ce3c0
           <...>-6608  [001]   618.406494: sys_prctl: get_random_int(): 4fe22655
           <...>-6609  [000]   618.407291: sys_prctl: get_random_int(): ce917e9c
           <...>-6610  [001]   618.408059: sys_prctl: get_random_int(): 68dd1e3f
           <...>-6611  [000]   618.408847: sys_prctl: get_random_int(): 9825a14e
           <...>-6612  [001]   618.409680: sys_prctl: get_random_int(): 2b008372
           <...>-6613  [001]   618.410499: sys_prctl: get_random_int(): 0d46472b
           <...>-6614  [000]   618.411290: sys_prctl: get_random_int(): 9f589c21
           <...>-6615  [001]   618.412061: sys_prctl: get_random_int(): bd6db092
           <...>-6616  [000]   618.412846: sys_prctl: get_random_int(): 13904117
           <...>-6617  [001]   618.413676: sys_prctl: get_random_int(): 152f6a51
           <...>-6618  [001]   618.414504: sys_prctl: get_random_int(): 62beb5a2
           <...>-6619  [000]   618.415300: sys_prctl: get_random_int(): 8e0b0dbc
           <...>-6620  [001]   618.416068: sys_prctl: get_random_int(): f90e4568
           <...>-6621  [000]   618.416864: sys_prctl: get_random_int(): 3abb9894
           <...>-6622  [001]   618.417685: sys_prctl: get_random_int(): 93e79a16
           <...>-6623  [001]   618.418498: sys_prctl: get_random_int(): 382ee7bc
           <...>-6624  [000]   618.419259: sys_prctl: get_random_int(): 1a9e45ba
           <...>-6625  [001]   618.420033: sys_prctl: get_random_int(): 7c3019f8
           <...>-6626  [000]   618.420857: sys_prctl: get_random_int(): 24e5521d
           <...>-6627  [001]   618.421687: sys_prctl: get_random_int(): 0455d756
           <...>-6628  [001]   618.422496: sys_prctl: get_random_int(): d26e2b36
           <...>-6629  [000]   618.423258: sys_prctl: get_random_int(): 076d46b4
           <...>-6630  [001]   618.424030: sys_prctl: get_random_int(): bbf641d9
           <...>-6631  [000]   618.424858: sys_prctl: get_random_int(): cf438890
           <...>-6632  [001]   618.425681: sys_prctl: get_random_int(): a9420abf
           <...>-6633  [001]   618.426490: sys_prctl: get_random_int(): c4f97cc3
           <...>-6634  [000]   618.427252: sys_prctl: get_random_int(): a15afcff
           <...>-6635  [001]   618.428029: sys_prctl: get_random_int(): 6c0fe9df
           <...>-6636  [000]   618.428854: sys_prctl: get_random_int(): 57dd1080
           <...>-6637  [001]   618.429684: sys_prctl: get_random_int(): af1a3406
           <...>-6638  [001]   618.430491: sys_prctl: get_random_int(): a1267ab6
           <...>-6639  [000]   618.431254: sys_prctl: get_random_int(): ee2bac2f
           <...>-6640  [001]   618.432025: sys_prctl: get_random_int(): 83016889
           <...>-6641  [000]   618.432855: sys_prctl: get_random_int(): 2a328efe
           <...>-6642  [001]   618.433680: sys_prctl: get_random_int(): f6d78972
           <...>-6643  [001]   618.434489: sys_prctl: get_random_int(): 8040699c
           <...>-6644  [000]   618.435998: sys_prctl: get_random_int(): 29dc137a
           <...>-6647  [001]   618.437765: sys_prctl: get_random_int(): 64460b77
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-18309 [000]   627.751792: sys_prctl: get_random_int(): 52310f6f
           <...>-18311 [000]   627.753395: sys_prctl: get_random_int(): 5c5960a1
           <...>-18314 [000]   627.755783: sys_prctl: get_random_int(): d03a9c4f
           <...>-18316 [000]   627.757381: sys_prctl: get_random_int(): 75cb90fb
           <...>-18319 [000]   627.759842: sys_prctl: get_random_int(): 9e3f7384
           <...>-18321 [000]   627.761397: sys_prctl: get_random_int(): 521f9b7f
           <...>-18324 [000]   627.763838: sys_prctl: get_random_int(): 145024e2
           <...>-18326 [000]   627.765396: sys_prctl: get_random_int(): 59f8fc60
           <...>-18327 [000]   627.766205: sys_prctl: get_random_int(): 03a496b0
           <...>-18329 [000]   627.767786: sys_prctl: get_random_int(): dd355d04
           <...>-18331 [000]   627.769386: sys_prctl: get_random_int(): f49c8191
           <...>-18334 [000]   627.771833: sys_prctl: get_random_int(): 83342d58
           <...>-18336 [000]   627.773389: sys_prctl: get_random_int(): b32f9abd
           <...>-18339 [000]   627.775782: sys_prctl: get_random_int(): bdb28608
           <...>-18341 [000]   627.777379: sys_prctl: get_random_int(): 97b35104
           <...>-18344 [000]   627.779830: sys_prctl: get_random_int(): 03e5c046
           <...>-18346 [000]   627.781387: sys_prctl: get_random_int(): 76069298
           <...>-18349 [000]   627.783833: sys_prctl: get_random_int(): 871a9fc2
           <...>-18351 [000]   627.785389: sys_prctl: get_random_int(): f6a7f29d
           <...>-18354 [000]   627.787835: sys_prctl: get_random_int(): 1d5ba7d4
           <...>-18356 [000]   627.789395: sys_prctl: get_random_int(): 955b60b5
           <...>-18359 [000]   627.791795: sys_prctl: get_random_int(): 7a8163a3
           <...>-18361 [000]   627.793401: sys_prctl: get_random_int(): b3e565d0
           <...>-18364 [000]   627.795808: sys_prctl: get_random_int(): 7c27c9f4
           <...>-18366 [000]   627.797410: sys_prctl: get_random_int(): b9ae9f67
           <...>-18369 [000]   627.799816: sys_prctl: get_random_int(): 84104ba4
           <...>-18371 [000]   627.801380: sys_prctl: get_random_int(): c475d325
           <...>-18374 [000]   627.803850: sys_prctl: get_random_int(): 69740e42
           <...>-18376 [000]   627.805407: sys_prctl: get_random_int(): e0d95210
           <...>-18379 [000]   627.807801: sys_prctl: get_random_int(): f4c7cb57
           <...>-18381 [000]   627.809401: sys_prctl: get_random_int(): 8bddd856
           <...>-18384 [000]   627.811793: sys_prctl: get_random_int(): db2eb8b4
           <...>-18386 [000]   627.813396: sys_prctl: get_random_int(): 3b8d152f
##### CPU 1 buffer started ####
           <...>-18387 [001]   627.814231: sys_prctl: get_random_int(): e97aca26
           <...>-18388 [001]   627.815040: sys_prctl: get_random_int(): a8cdf2b8
           <...>-18389 [000]   627.815804: sys_prctl: get_random_int(): 85e89c6f
           <...>-18390 [001]   627.816578: sys_prctl: get_random_int(): 114b1f3d
           <...>-18391 [000]   627.817368: sys_prctl: get_random_int(): 638c4a68
           <...>-18392 [001]   627.818204: sys_prctl: get_random_int(): f6ba825a
           <...>-18393 [001]   627.819026: sys_prctl: get_random_int(): e5174c9d
           <...>-18394 [000]   627.819822: sys_prctl: get_random_int(): a257b6ad
           <...>-18395 [001]   627.820595: sys_prctl: get_random_int(): 70aad3e0
           <...>-18396 [000]   627.821380: sys_prctl: get_random_int(): c94d47c9
           <...>-18397 [000]   627.822190: sys_prctl: get_random_int(): a0c620eb
           <...>-18398 [001]   627.822980: sys_prctl: get_random_int(): 6fdd32fb
           <...>-18399 [000]   627.823768: sys_prctl: get_random_int(): 42f82e7b
           <...>-18400 [001]   627.824537: sys_prctl: get_random_int(): 1c3e424c
           <...>-18401 [000]   627.825364: sys_prctl: get_random_int(): 61cf775e
           <...>-18402 [001]   627.826201: sys_prctl: get_random_int(): bd183fd1
           <...>-18403 [001]   627.827024: sys_prctl: get_random_int(): f5f71d3a
           <...>-18404 [000]   627.827816: sys_prctl: get_random_int(): f46a14cf
           <...>-18405 [001]   627.828587: sys_prctl: get_random_int(): 0b36e2ff
           <...>-18406 [000]   627.829373: sys_prctl: get_random_int(): 28d59de4
           <...>-18407 [001]   627.830201: sys_prctl: get_random_int(): d28737e7
           <...>-18408 [001]   627.831025: sys_prctl: get_random_int(): 0653b0d2
           <...>-18409 [000]   627.831825: sys_prctl: get_random_int(): 54c11a51
           <...>-18410 [001]   627.832595: sys_prctl: get_random_int(): 872a8834
           <...>-18411 [000]   627.833381: sys_prctl: get_random_int(): c21a6299
           <...>-18412 [000]   627.834200: sys_prctl: get_random_int(): 29e928e4
           <...>-18413 [001]   627.834964: sys_prctl: get_random_int(): cc0abad5
           <...>-18414 [000]   627.835755: sys_prctl: get_random_int(): c048aed4
           <...>-18415 [001]   627.836528: sys_prctl: get_random_int(): 858e93ec
           <...>-18416 [000]   627.837350: sys_prctl: get_random_int(): a73c6d44
           <...>-18417 [001]   627.838187: sys_prctl: get_random_int(): 35d5aa36
           <...>-18418 [001]   627.839007: sys_prctl: get_random_int(): 0f0f0463
           <...>-18419 [000]   627.839805: sys_prctl: get_random_int(): affd4d3b
           <...>-18420 [001]   627.840576: sys_prctl: get_random_int(): 16e51420
           <...>-18421 [000]   627.841364: sys_prctl: get_random_int(): 5a3343ab
           <...>-18422 [001]   627.842198: sys_prctl: get_random_int(): 9e664ba2
           <...>-18423 [001]   627.843019: sys_prctl: get_random_int(): 5ee2700c
           <...>-18424 [000]   627.843814: sys_prctl: get_random_int(): fa2f580e
           <...>-18425 [001]   627.844586: sys_prctl: get_random_int(): 326f61cc
           <...>-18426 [000]   627.845371: sys_prctl: get_random_int(): cea84dbd
           <...>-18427 [001]   627.846199: sys_prctl: get_random_int(): 1ca5c991
           <...>-18428 [001]   627.847021: sys_prctl: get_random_int(): 69f6619a
           <...>-18429 [000]   627.847814: sys_prctl: get_random_int(): 57bd10d0
           <...>-18430 [001]   627.848583: sys_prctl: get_random_int(): 3bb05c34
           <...>-18431 [000]   627.849370: sys_prctl: get_random_int(): 7760fc5d
           <...>-18432 [001]   627.850203: sys_prctl: get_random_int(): 65a6bb3e
           <...>-18433 [001]   627.851025: sys_prctl: get_random_int(): 73385e77
           <...>-18434 [000]   627.851820: sys_prctl: get_random_int(): 8c85bb21
           <...>-18435 [001]   627.852593: sys_prctl: get_random_int(): 422f2fcc
           <...>-18436 [000]   627.853377: sys_prctl: get_random_int(): a8e8d794
           <...>-18437 [000]   627.854198: sys_prctl: get_random_int(): 24c1da57
           <...>-18438 [001]   627.854984: sys_prctl: get_random_int(): 6a924143
           <...>-18439 [000]   627.855772: sys_prctl: get_random_int(): 7d0fa9a5
           <...>-18440 [001]   627.856543: sys_prctl: get_random_int(): 50ca3344
           <...>-18441 [000]   627.857367: sys_prctl: get_random_int(): abeaee51
           <...>-18442 [001]   627.858199: sys_prctl: get_random_int(): b5236f5a
           <...>-18443 [001]   627.859021: sys_prctl: get_random_int(): 1a87a04d
           <...>-18444 [000]   627.859814: sys_prctl: get_random_int(): 7f5c71de
           <...>-18445 [001]   627.860585: sys_prctl: get_random_int(): 5bf10a7f
           <...>-18446 [000]   627.861372: sys_prctl: get_random_int(): 1ecd5288
           <...>-18447 [000]   627.862183: sys_prctl: get_random_int(): a9266a23
           <...>-18448 [001]   627.862968: sys_prctl: get_random_int(): 304c0101
           <...>-18449 [000]   627.863754: sys_prctl: get_random_int(): 7cc1b135
           <...>-18450 [001]   627.864522: sys_prctl: get_random_int(): 4f838d1f
           <...>-18451 [000]   627.865344: sys_prctl: get_random_int(): c91b8920
           <...>-18452 [001]   627.866178: sys_prctl: get_random_int(): f0cb88e2
           <...>-18453 [001]   627.867006: sys_prctl: get_random_int(): 9a747948
           <...>-18454 [000]   627.867797: sys_prctl: get_random_int(): c142e039
           <...>-18455 [001]   627.868567: sys_prctl: get_random_int(): 4238d17e
           <...>-18456 [000]   627.869350: sys_prctl: get_random_int(): bff4fde7
           <...>-18457 [001]   627.870187: sys_prctl: get_random_int(): 83343bff
           <...>-18458 [001]   627.871009: sys_prctl: get_random_int(): c098220b
           <...>-18459 [000]   627.871807: sys_prctl: get_random_int(): bb320215
           <...>-18460 [001]   627.872576: sys_prctl: get_random_int(): c74cf7d7
           <...>-18461 [000]   627.873365: sys_prctl: get_random_int(): 090be4c0
           <...>-18462 [001]   627.874201: sys_prctl: get_random_int(): 9e5898d7
           <...>-18463 [001]   627.874964: sys_prctl: get_random_int(): 86ec672c
           <...>-18464 [000]   627.875755: sys_prctl: get_random_int(): edc62d03
           <...>-18465 [001]   627.876527: sys_prctl: get_random_int(): 1a3dd822
           <...>-18466 [000]   627.877352: sys_prctl: get_random_int(): f67f6a20
           <...>-18467 [001]   627.878192: sys_prctl: get_random_int(): b1a95cf3
           <...>-18468 [001]   627.879008: sys_prctl: get_random_int(): 364517e1
           <...>-18469 [000]   627.879805: sys_prctl: get_random_int(): c64e3193
           <...>-18470 [001]   627.880573: sys_prctl: get_random_int(): bfa7483f
           <...>-18471 [000]   627.881358: sys_prctl: get_random_int(): 2032e9f8
           <...>-18472 [001]   627.882187: sys_prctl: get_random_int(): 2a669bac
           <...>-18473 [001]   627.883012: sys_prctl: get_random_int(): 306b1e26
           <...>-18474 [000]   627.883803: sys_prctl: get_random_int(): 2a4eeccc
           <...>-18475 [001]   627.884572: sys_prctl: get_random_int(): 50dcd09e
           <...>-18476 [000]   627.885357: sys_prctl: get_random_int(): 714e88a0
           <...>-18477 [001]   627.886190: sys_prctl: get_random_int(): 52f8906e
           <...>-18478 [001]   627.887013: sys_prctl: get_random_int(): ec01de8c
           <...>-18479 [000]   627.887812: sys_prctl: get_random_int(): c60c4df2
           <...>-18480 [001]   627.888583: sys_prctl: get_random_int(): 759ffb8c
           <...>-18481 [000]   627.889367: sys_prctl: get_random_int(): f65a79e1
           <...>-18482 [001]   627.890191: sys_prctl: get_random_int(): d4733c69
           <...>-18483 [001]   627.890951: sys_prctl: get_random_int(): 1e85a905
           <...>-18484 [000]   627.891741: sys_prctl: get_random_int(): d486b9bf
           <...>-18485 [001]   627.892511: sys_prctl: get_random_int(): b04c0596
           <...>-18486 [000]   627.893335: sys_prctl: get_random_int(): ae431490
           <...>-18487 [001]   627.894187: sys_prctl: get_random_int(): 954b83e4
           <...>-18488 [001]   627.895007: sys_prctl: get_random_int(): 84cdd8f9
           <...>-18489 [000]   627.895803: sys_prctl: get_random_int(): f655c354
           <...>-18490 [001]   627.896576: sys_prctl: get_random_int(): 60f2f7fe
           <...>-18491 [000]   627.897363: sys_prctl: get_random_int(): f15e864f
           <...>-18492 [001]   627.898189: sys_prctl: get_random_int(): 4de26b7a
           <...>-18493 [001]   627.899019: sys_prctl: get_random_int(): 3632d98d
           <...>-18494 [000]   627.899811: sys_prctl: get_random_int(): 6398f233
           <...>-18495 [001]   627.900588: sys_prctl: get_random_int(): 4f19b083
           <...>-18496 [000]   627.901371: sys_prctl: get_random_int(): e696aed7
           <...>-18497 [001]   627.902196: sys_prctl: get_random_int(): 2d6f06fa
           <...>-18498 [001]   627.903006: sys_prctl: get_random_int(): bbd4a5a7
           <...>-18499 [000]   627.903771: sys_prctl: get_random_int(): af4e7caa
           <...>-18500 [001]   627.904541: sys_prctl: get_random_int(): 1e1efc83
           <...>-18501 [000]   627.905372: sys_prctl: get_random_int(): 28dd50e1
           <...>-18502 [001]   627.906197: sys_prctl: get_random_int(): 0faa0489
           <...>-18503 [001]   627.907006: sys_prctl: get_random_int(): 45932529
           <...>-18504 [000]   627.907766: sys_prctl: get_random_int(): 3101de22
           <...>-18505 [001]   627.908542: sys_prctl: get_random_int(): a6616538
           <...>-18506 [000]   627.909365: sys_prctl: get_random_int(): 745b41c5
           <...>-18507 [001]   627.910194: sys_prctl: get_random_int(): 961f937a
           <...>-18508 [001]   627.911001: sys_prctl: get_random_int(): 27bf8b8b
           <...>-18509 [000]   627.911764: sys_prctl: get_random_int(): 6b976e6a
           <...>-18510 [001]   627.912538: sys_prctl: get_random_int(): 04501e6f
           <...>-18511 [000]   627.913369: sys_prctl: get_random_int(): fb3e4bed
           <...>-18512 [001]   627.914204: sys_prctl: get_random_int(): d5ea788d
           <...>-18513 [001]   627.915016: sys_prctl: get_random_int(): ba990947
           <...>-18514 [000]   627.915778: sys_prctl: get_random_int(): 3de8e678
           <...>-18515 [001]   627.916552: sys_prctl: get_random_int(): 191b2192
           <...>-18516 [000]   627.917377: sys_prctl: get_random_int(): dabbcec6
           <...>-18517 [001]   627.918205: sys_prctl: get_random_int(): 02c784aa
           <...>-18518 [001]   627.919012: sys_prctl: get_random_int(): d70791f2
           <...>-18519 [000]   627.919778: sys_prctl: get_random_int(): 43421c09
           <...>-18520 [001]   627.920549: sys_prctl: get_random_int(): e054e4cd
           <...>-18521 [000]   627.921342: sys_prctl: get_random_int(): 581cd65e
           <...>-18522 [001]   627.922180: sys_prctl: get_random_int(): c5306f50
           <...>-18523 [001]   627.922999: sys_prctl: get_random_int(): ccf46cf0
           <...>-18524 [000]   627.923789: sys_prctl: get_random_int(): f1a6e38d
           <...>-18525 [001]   627.924564: sys_prctl: get_random_int(): bcbaf1e5
           <...>-18526 [000]   627.925347: sys_prctl: get_random_int(): ffdcb654
           <...>-18527 [001]   627.926178: sys_prctl: get_random_int(): e3814837
           <...>-18528 [001]   627.927000: sys_prctl: get_random_int(): e2d86125
           <...>-18529 [000]   627.927796: sys_prctl: get_random_int(): 4b575890
           <...>-18530 [001]   627.928565: sys_prctl: get_random_int(): 4bbbaa1e
           <...>-18531 [000]   627.929353: sys_prctl: get_random_int(): dfb1056d
           <...>-18532 [001]   627.930179: sys_prctl: get_random_int(): d4dae55d
           <...>-18533 [001]   627.931002: sys_prctl: get_random_int(): c71c0bb1
           <...>-18534 [000]   627.931793: sys_prctl: get_random_int(): b85cc1bf
           <...>-18535 [001]   627.932567: sys_prctl: get_random_int(): 362cc1a2
           <...>-18536 [000]   627.933350: sys_prctl: get_random_int(): 71b243ce
           <...>-18537 [001]   627.934185: sys_prctl: get_random_int(): 5190e11b
           <...>-18538 [001]   627.934945: sys_prctl: get_random_int(): 5a64d246
           <...>-18539 [000]   627.935740: sys_prctl: get_random_int(): da00778b
           <...>-18540 [001]   627.936509: sys_prctl: get_random_int(): 587621e4
           <...>-18541 [000]   627.937334: sys_prctl: get_random_int(): f3a9e3c8
           <...>-18542 [001]   627.938171: sys_prctl: get_random_int(): df2032bc
           <...>-18543 [001]   627.938994: sys_prctl: get_random_int(): 4117c14e
           <...>-18544 [000]   627.939786: sys_prctl: get_random_int(): a6c328c6
           <...>-18545 [001]   627.940560: sys_prctl: get_random_int(): 6d65f77c
           <...>-18546 [000]   627.941344: sys_prctl: get_random_int(): 32ccd9cf
           <...>-18547 [001]   627.942175: sys_prctl: get_random_int(): 84c21c2e
           <...>-18548 [001]   627.943003: sys_prctl: get_random_int(): 43adc633
           <...>-18549 [000]   627.943797: sys_prctl: get_random_int(): daad681e
           <...>-18550 [001]   627.944566: sys_prctl: get_random_int(): 691fc2ea
           <...>-18551 [000]   627.945355: sys_prctl: get_random_int(): 48d18004
           <...>-18552 [001]   627.946176: sys_prctl: get_random_int(): fd9ffbd2
           <...>-18553 [001]   627.946932: sys_prctl: get_random_int(): 6bf8f482
           <...>-18554 [000]   627.947724: sys_prctl: get_random_int(): f2e85e39
           <...>-18555 [001]   627.948497: sys_prctl: get_random_int(): 4cc7edf2
           <...>-18556 [000]   627.949320: sys_prctl: get_random_int(): a6dcb927
           <...>-18557 [001]   627.950158: sys_prctl: get_random_int(): 9b2e0164
           <...>-18558 [001]   627.950983: sys_prctl: get_random_int(): 3a6a42bd
           <...>-18559 [000]   627.951776: sys_prctl: get_random_int(): 1c47d070
           <...>-18560 [001]   627.952545: sys_prctl: get_random_int(): 16075ee5
           <...>-18561 [000]   627.953333: sys_prctl: get_random_int(): 0382027b
           <...>-18562 [001]   627.954175: sys_prctl: get_random_int(): c5693b95
           <...>-18563 [001]   627.955001: sys_prctl: get_random_int(): 46b315c1
           <...>-18564 [000]   627.955798: sys_prctl: get_random_int(): 1726dfc0
           <...>-18565 [001]   627.956570: sys_prctl: get_random_int(): f2ce9d1e
           <...>-18566 [000]   627.957349: sys_prctl: get_random_int(): 280b1db2
           <...>-18567 [000]   627.958158: sys_prctl: get_random_int(): 34ee77a5
           <...>-18568 [001]   627.958950: sys_prctl: get_random_int(): 3fdea472
           <...>-18569 [000]   627.959739: sys_prctl: get_random_int(): 97367791
           <...>-18570 [001]   627.960508: sys_prctl: get_random_int(): 321129ba
           <...>-18571 [000]   627.961336: sys_prctl: get_random_int(): 2697257c
           <...>-18572 [001]   627.962172: sys_prctl: get_random_int(): 9041082c
           <...>-18573 [001]   627.962993: sys_prctl: get_random_int(): 745f54f6
           <...>-18574 [000]   627.963783: sys_prctl: get_random_int(): f8e8f387
           <...>-18575 [001]   627.964552: sys_prctl: get_random_int(): 56b494c7
           <...>-18577 [000]   627.965334: sys_prctl: get_random_int(): c07b5f17
           <...>-18578 [001]   627.966164: sys_prctl: get_random_int(): 0bfc02a8
           <...>-18579 [001]   627.966987: sys_prctl: get_random_int(): e82d9b2d
           <...>-18580 [000]   627.967780: sys_prctl: get_random_int(): 8296b72b
           <...>-18581 [001]   627.968550: sys_prctl: get_random_int(): 6fabdb15
           <...>-18582 [000]   627.969335: sys_prctl: get_random_int(): 35a70752
           <...>-18583 [001]   627.970163: sys_prctl: get_random_int(): 0ee8fcd3
           <...>-18584 [001]   627.970984: sys_prctl: get_random_int(): c2293934
           <...>-18585 [000]   627.971777: sys_prctl: get_random_int(): 445f7a05
           <...>-18586 [001]   627.972547: sys_prctl: get_random_int(): 2a663058
           <...>-18587 [000]   627.973332: sys_prctl: get_random_int(): 5477fcd5
           <...>-18588 [001]   627.974174: sys_prctl: get_random_int(): 8cc30a16
           <...>-18589 [001]   627.974994: sys_prctl: get_random_int(): b737f4af
           <...>-18590 [000]   627.975792: sys_prctl: get_random_int(): 538c5074
           <...>-18591 [001]   627.976561: sys_prctl: get_random_int(): 3266cbc6
           <...>-18592 [000]   627.977347: sys_prctl: get_random_int(): 7853c392
           <...>-18593 [000]   627.978156: sys_prctl: get_random_int(): 4d326cc5
           <...>-18594 [001]   627.978948: sys_prctl: get_random_int(): aa89393a
           <...>-18595 [000]   627.979733: sys_prctl: get_random_int(): 6c0246da
           <...>-18596 [001]   627.980503: sys_prctl: get_random_int(): 95b86f81
           <...>-18597 [000]   627.981329: sys_prctl: get_random_int(): 536fea63
           <...>-18598 [001]   627.982167: sys_prctl: get_random_int(): f376b88f
           <...>-18599 [001]   627.982988: sys_prctl: get_random_int(): 61300d20
           <...>-18600 [000]   627.983786: sys_prctl: get_random_int(): 4fb7675b
           <...>-18601 [001]   627.984555: sys_prctl: get_random_int(): 05b7519a
           <...>-18602 [000]   627.985342: sys_prctl: get_random_int(): 1dc996df
           <...>-18603 [001]   627.986164: sys_prctl: get_random_int(): b61126a1
           <...>-18604 [001]   627.986915: sys_prctl: get_random_int(): 2ac26f3c
           <...>-18605 [000]   627.987710: sys_prctl: get_random_int(): 19a541ab
           <...>-18606 [001]   627.988482: sys_prctl: get_random_int(): b59bf4af
           <...>-18607 [000]   627.989306: sys_prctl: get_random_int(): 154838a5
           <...>-18608 [001]   627.990146: sys_prctl: get_random_int(): c5f91d79
           <...>-18609 [001]   627.990969: sys_prctl: get_random_int(): 61775e7a
           <...>-18610 [000]   627.991764: sys_prctl: get_random_int(): a310e20c
           <...>-18611 [001]   627.992532: sys_prctl: get_random_int(): 7e3850d9
           <...>-18612 [000]   627.993318: sys_prctl: get_random_int(): 84caa2e8
           <...>-18613 [001]   627.994163: sys_prctl: get_random_int(): b24878e2
           <...>-18614 [001]   627.994991: sys_prctl: get_random_int(): f2653380
           <...>-18615 [000]   627.995786: sys_prctl: get_random_int(): d85cee27
           <...>-18616 [001]   627.996561: sys_prctl: get_random_int(): 9b8505e6
           <...>-18617 [000]   627.997344: sys_prctl: get_random_int(): 257c4522
           <...>-18618 [001]   627.998171: sys_prctl: get_random_int(): e4339624
           <...>-18619 [001]   627.998980: sys_prctl: get_random_int(): 7228a721
           <...>-18620 [000]   627.999745: sys_prctl: get_random_int(): e121b81c
           <...>-18621 [001]   628.000520: sys_prctl: get_random_int(): 8431d816
           <...>-18622 [000]   628.001351: sys_prctl: get_random_int(): 501faecf
           <...>-18623 [001]   628.002178: sys_prctl: get_random_int(): 46b05afc
           <...>-18624 [001]   628.002996: sys_prctl: get_random_int(): eda462d0
           <...>-18625 [000]   628.003755: sys_prctl: get_random_int(): b1697ab1
           <...>-18626 [001]   628.004536: sys_prctl: get_random_int(): 0ec26266
           <...>-18627 [000]   628.005320: sys_prctl: get_random_int(): 3cc19600
           <...>-18628 [001]   628.006160: sys_prctl: get_random_int(): 5a8e9b61
           <...>-18629 [001]   628.006977: sys_prctl: get_random_int(): d4d4a5ee
           <...>-18630 [000]   628.007773: sys_prctl: get_random_int(): 2af9a36f
           <...>-18631 [001]   628.008540: sys_prctl: get_random_int(): 23aaa78d
           <...>-18632 [000]   628.009327: sys_prctl: get_random_int(): 337e8c2a
           <...>-18633 [001]   628.010156: sys_prctl: get_random_int(): 2e04775c
           <...>-18634 [001]   628.010978: sys_prctl: get_random_int(): c16d86a0
           <...>-18635 [000]   628.011771: sys_prctl: get_random_int(): 7918801e
           <...>-18636 [001]   628.012544: sys_prctl: get_random_int(): 9f456e1f
           <...>-18637 [000]   628.013325: sys_prctl: get_random_int(): f3b7cba9
           <...>-18638 [001]   628.014164: sys_prctl: get_random_int(): 3cd20579
           <...>-18639 [001]   628.014923: sys_prctl: get_random_int(): c69f87ca
           <...>-18640 [000]   628.015720: sys_prctl: get_random_int(): 15aa25da
           <...>-18641 [001]   628.016490: sys_prctl: get_random_int(): e2bfeacc
           <...>-18642 [000]   628.017316: sys_prctl: get_random_int(): 93e79b19
           <...>-18643 [001]   628.018150: sys_prctl: get_random_int(): f2d7f276
           <...>-18644 [001]   628.018971: sys_prctl: get_random_int(): 72a4f012
           <...>-18645 [000]   628.019768: sys_prctl: get_random_int(): ac4a3c77
           <...>-18646 [001]   628.020542: sys_prctl: get_random_int(): a3bb226a
           <...>-18647 [000]   628.021325: sys_prctl: get_random_int(): 4a684dfb
           <...>-18648 [001]   628.022158: sys_prctl: get_random_int(): c24b4d0d
           <...>-18649 [001]   628.022978: sys_prctl: get_random_int(): e1e865db
           <...>-18650 [000]   628.023774: sys_prctl: get_random_int(): 52ce4c15
           <...>-18651 [001]   628.024544: sys_prctl: get_random_int(): 8958e813
           <...>-18652 [000]   628.025333: sys_prctl: get_random_int(): d684716f
           <...>-18653 [001]   628.026155: sys_prctl: get_random_int(): da0202bd
           <...>-18654 [001]   628.026909: sys_prctl: get_random_int(): c59d5ed6
           <...>-18655 [000]   628.027700: sys_prctl: get_random_int(): dd10bd34
           <...>-18656 [001]   628.028474: sys_prctl: get_random_int(): 7f7644a6
           <...>-18657 [001]   628.029311: sys_prctl: get_random_int(): 01a431f1
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-23256 [000]   734.874773: sys_prctl: get_random_int(): a64ca595
           <...>-23258 [000]   734.876326: sys_prctl: get_random_int(): e88f5453
           <...>-23261 [000]   734.878769: sys_prctl: get_random_int(): 22ff1a17
           <...>-23263 [000]   734.880324: sys_prctl: get_random_int(): 99fe148a
           <...>-23264 [000]   734.881141: sys_prctl: get_random_int(): 40f6778f
           <...>-23266 [000]   734.882723: sys_prctl: get_random_int(): d769bd9e
           <...>-23268 [000]   734.884325: sys_prctl: get_random_int(): 3dc6a713
           <...>-23271 [000]   734.886707: sys_prctl: get_random_int(): 85f3a9d3
           <...>-23273 [000]   734.888300: sys_prctl: get_random_int(): 8c5015b7
           <...>-23276 [000]   734.890759: sys_prctl: get_random_int(): 50a94bca
           <...>-23278 [000]   734.892313: sys_prctl: get_random_int(): e96a1eb1
##### CPU 1 buffer started ####
           <...>-23280 [001]   734.893969: sys_prctl: get_random_int(): 02c61ff6
           <...>-23281 [000]   734.894760: sys_prctl: get_random_int(): 78595394
           <...>-23282 [001]   734.895533: sys_prctl: get_random_int(): 4edbadf8
           <...>-23283 [000]   734.896315: sys_prctl: get_random_int(): 2a7bfe4a
           <...>-23284 [001]   734.897146: sys_prctl: get_random_int(): 37ceb873
           <...>-23285 [001]   734.897965: sys_prctl: get_random_int(): 3a4ec289
           <...>-23286 [000]   734.898763: sys_prctl: get_random_int(): cf5e9125
           <...>-23287 [001]   734.899529: sys_prctl: get_random_int(): 0456fdf7
           <...>-23288 [000]   734.900316: sys_prctl: get_random_int(): 0c059a10
           <...>-23289 [001]   734.901147: sys_prctl: get_random_int(): 7b469e29
           <...>-23290 [001]   734.901974: sys_prctl: get_random_int(): 5068434d
           <...>-23291 [000]   734.902766: sys_prctl: get_random_int(): e92fba13
           <...>-23292 [001]   734.903539: sys_prctl: get_random_int(): adf80330
           <...>-23293 [000]   734.904321: sys_prctl: get_random_int(): 627a6686
           <...>-23294 [000]   734.905133: sys_prctl: get_random_int(): 9a95dfc0
           <...>-23295 [001]   734.905934: sys_prctl: get_random_int(): e9b7ff83
           <...>-23296 [000]   734.906720: sys_prctl: get_random_int(): caf6f557
           <...>-23297 [001]   734.907488: sys_prctl: get_random_int(): 967bd995
           <...>-23298 [000]   734.908317: sys_prctl: get_random_int(): 09ff7740
           <...>-23299 [001]   734.909145: sys_prctl: get_random_int(): fd15e37b
           <...>-23300 [001]   734.909894: sys_prctl: get_random_int(): 241e1bb5
           <...>-23301 [000]   734.910685: sys_prctl: get_random_int(): 6a3fb579
           <...>-23302 [001]   734.911458: sys_prctl: get_random_int(): 62d7f835
           <...>-23303 [000]   734.912281: sys_prctl: get_random_int(): dc1388de
           <...>-23304 [001]   734.913120: sys_prctl: get_random_int(): da9bfff5
           <...>-23305 [001]   734.913938: sys_prctl: get_random_int(): beaef652
           <...>-23306 [000]   734.914731: sys_prctl: get_random_int(): 4ccf35fd
           <...>-23307 [001]   734.915501: sys_prctl: get_random_int(): 7f80a00f
           <...>-23308 [000]   734.916327: sys_prctl: get_random_int(): a73249ca
           <...>-23309 [001]   734.917150: sys_prctl: get_random_int(): b20a214d
           <...>-23310 [001]   734.917964: sys_prctl: get_random_int(): 067e9686
           <...>-23311 [000]   734.918724: sys_prctl: get_random_int(): f13d462f
           <...>-23312 [001]   734.919501: sys_prctl: get_random_int(): 765cb10e
           <...>-23313 [000]   734.920325: sys_prctl: get_random_int(): 01f9270a
           <...>-23314 [001]   734.921153: sys_prctl: get_random_int(): d047f8b8
           <...>-23315 [001]   734.921961: sys_prctl: get_random_int(): a03535ee
           <...>-23316 [000]   734.922722: sys_prctl: get_random_int(): 5fbadc9d
           <...>-23317 [001]   734.923494: sys_prctl: get_random_int(): 455cfc51
           <...>-23318 [000]   734.924324: sys_prctl: get_random_int(): 39db49a4
           <...>-23319 [001]   734.925152: sys_prctl: get_random_int(): f8a2ade6
           <...>-23320 [001]   734.925972: sys_prctl: get_random_int(): 42ef8040
           <...>-23321 [000]   734.926732: sys_prctl: get_random_int(): e0fc8cc3
           <...>-23322 [001]   734.927507: sys_prctl: get_random_int(): 272199d9
           <...>-23323 [000]   734.928335: sys_prctl: get_random_int(): e0ddda72
           <...>-23324 [001]   734.929167: sys_prctl: get_random_int(): ea380a40
           <...>-23325 [001]   734.929976: sys_prctl: get_random_int(): cd9d10b4
           <...>-23326 [000]   734.930738: sys_prctl: get_random_int(): de85cd17
           <...>-23327 [001]   734.931509: sys_prctl: get_random_int(): 90ac37b3
           <...>-23328 [000]   734.932300: sys_prctl: get_random_int(): 2303f763
           <...>-23329 [001]   734.933134: sys_prctl: get_random_int(): b67d8ffc
           <...>-23330 [001]   734.933963: sys_prctl: get_random_int(): f475a889
           <...>-23331 [000]   734.934755: sys_prctl: get_random_int(): 969d0d50
           <...>-23332 [001]   734.935527: sys_prctl: get_random_int(): d2a064c2
           <...>-23333 [000]   734.936307: sys_prctl: get_random_int(): 9336bec4
           <...>-23334 [001]   734.937137: sys_prctl: get_random_int(): 26e1c1f5
           <...>-23335 [001]   734.937960: sys_prctl: get_random_int(): 21a483c5
           <...>-23336 [000]   734.938755: sys_prctl: get_random_int(): 08a3e6e6
           <...>-23337 [001]   734.939522: sys_prctl: get_random_int(): ece48064
           <...>-23338 [000]   734.940311: sys_prctl: get_random_int(): 41ad055d
           <...>-23339 [001]   734.941137: sys_prctl: get_random_int(): 1344d886
           <...>-23340 [001]   734.941893: sys_prctl: get_random_int(): 0ad603db
           <...>-23341 [000]   734.942682: sys_prctl: get_random_int(): ce48c370
           <...>-23342 [001]   734.943455: sys_prctl: get_random_int(): d81e1039
           <...>-23343 [000]   734.944278: sys_prctl: get_random_int(): 7d819570
           <...>-23344 [001]   734.945116: sys_prctl: get_random_int(): d2b48464
           <...>-23345 [001]   734.945946: sys_prctl: get_random_int(): 85548a2f
           <...>-23346 [000]   734.946738: sys_prctl: get_random_int(): 5251e8db
           <...>-23347 [001]   734.947504: sys_prctl: get_random_int(): f5be1507
           <...>-23348 [000]   734.948291: sys_prctl: get_random_int(): be9a7219
           <...>-23349 [001]   734.949125: sys_prctl: get_random_int(): 79867990
           <...>-23350 [001]   734.949946: sys_prctl: get_random_int(): e9350b88
           <...>-23351 [000]   734.950739: sys_prctl: get_random_int(): f925fd54
           <...>-23352 [001]   734.951507: sys_prctl: get_random_int(): 00a61729
           <...>-23353 [000]   734.952293: sys_prctl: get_random_int(): 459ab040
           <...>-23354 [001]   734.953127: sys_prctl: get_random_int(): 91196a0f
           <...>-23355 [001]   734.953945: sys_prctl: get_random_int(): 7dd5289e
           <...>-23356 [000]   734.954741: sys_prctl: get_random_int(): 3d6f1ac8
           <...>-23357 [001]   734.955508: sys_prctl: get_random_int(): 20b03a0d
           <...>-23358 [000]   734.956295: sys_prctl: get_random_int(): b3e1a674
           <...>-23359 [001]   734.957123: sys_prctl: get_random_int(): ba47d73a
           <...>-23360 [001]   734.957951: sys_prctl: get_random_int(): 95507a47
           <...>-23361 [000]   734.958745: sys_prctl: get_random_int(): 756457f2
           <...>-23362 [001]   734.959517: sys_prctl: get_random_int(): 3753f20f
           <...>-23363 [000]   734.960300: sys_prctl: get_random_int(): cedda01d
           <...>-23364 [001]   734.961132: sys_prctl: get_random_int(): 0ae1c51f
           <...>-23365 [001]   734.961952: sys_prctl: get_random_int(): 2e7ddfa1
           <...>-23366 [000]   734.962747: sys_prctl: get_random_int(): 38288759
           <...>-23367 [001]   734.963516: sys_prctl: get_random_int(): c6eaf768
           <...>-23368 [000]   734.964303: sys_prctl: get_random_int(): 96fda3bd
           <...>-23369 [001]   734.965128: sys_prctl: get_random_int(): 3b7cefc7
           <...>-23370 [001]   734.965962: sys_prctl: get_random_int(): 1cd8b8f9
           <...>-23371 [000]   734.966752: sys_prctl: get_random_int(): 6ee92289
           <...>-23372 [001]   734.967522: sys_prctl: get_random_int(): ab0f8668
           <...>-23373 [000]   734.968303: sys_prctl: get_random_int(): 07c4ea86
           <...>-23374 [000]   734.969112: sys_prctl: get_random_int(): c9cab6ce
           <...>-23375 [001]   734.969906: sys_prctl: get_random_int(): a46cc75e
           <...>-23376 [000]   734.970694: sys_prctl: get_random_int(): 05a72274
           <...>-23377 [001]   734.971462: sys_prctl: get_random_int(): ba11a97c
           <...>-23378 [000]   734.972292: sys_prctl: get_random_int(): 230a8575
           <...>-23379 [001]   734.973126: sys_prctl: get_random_int(): 56405a19
           <...>-23380 [001]   734.973952: sys_prctl: get_random_int(): 6a7a746e
           <...>-23381 [000]   734.974747: sys_prctl: get_random_int(): 1216a03d
           <...>-23382 [001]   734.975518: sys_prctl: get_random_int(): a8b71c79
           <...>-23383 [000]   734.976300: sys_prctl: get_random_int(): f2b27bd0
           <...>-23384 [000]   734.977111: sys_prctl: get_random_int(): 58281a76
           <...>-23385 [001]   734.977902: sys_prctl: get_random_int(): 9fbb8459
           <...>-23386 [000]   734.978691: sys_prctl: get_random_int(): b5944da6
           <...>-23387 [001]   734.979460: sys_prctl: get_random_int(): c463a91d
           <...>-23388 [000]   734.980287: sys_prctl: get_random_int(): 19df0940
           <...>-23389 [001]   734.981121: sys_prctl: get_random_int(): e3b268ce
           <...>-23390 [001]   734.981938: sys_prctl: get_random_int(): 394a2be3
           <...>-23391 [000]   734.982730: sys_prctl: get_random_int(): 5a24e611
           <...>-23392 [001]   734.983506: sys_prctl: get_random_int(): f48b0c91
           <...>-23393 [000]   734.984291: sys_prctl: get_random_int(): bf3ff863
           <...>-23394 [001]   734.985123: sys_prctl: get_random_int(): 19ad52f8
           <...>-23395 [001]   734.985959: sys_prctl: get_random_int(): 57c2d7ae
           <...>-23396 [000]   734.986752: sys_prctl: get_random_int(): 2da8a420
           <...>-23397 [001]   734.987519: sys_prctl: get_random_int(): 6cd5173f
           <...>-23398 [000]   734.988304: sys_prctl: get_random_int(): dc1b5780
           <...>-23399 [001]   734.989123: sys_prctl: get_random_int(): 82ab2f5a
           <...>-23400 [001]   734.989935: sys_prctl: get_random_int(): 9ee47cf8
           <...>-23401 [000]   734.990699: sys_prctl: get_random_int(): a7fb8b54
           <...>-23402 [001]   734.991475: sys_prctl: get_random_int(): 5a8e48c3
           <...>-23403 [000]   734.992303: sys_prctl: get_random_int(): 8e8f76c1
           <...>-23404 [001]   734.993133: sys_prctl: get_random_int(): 04468eb0
           <...>-23405 [001]   734.993944: sys_prctl: get_random_int(): 22d5ec87
           <...>-23406 [000]   734.994705: sys_prctl: get_random_int(): a38348df
           <...>-23407 [001]   734.995476: sys_prctl: get_random_int(): a483d817
           <...>-23408 [000]   734.996304: sys_prctl: get_random_int(): db942580
           <...>-23409 [001]   734.997129: sys_prctl: get_random_int(): 72f6d65c
           <...>-23410 [001]   734.997940: sys_prctl: get_random_int(): 09aecf0f
           <...>-23411 [000]   734.998700: sys_prctl: get_random_int(): 3a7d8f9a
           <...>-23412 [001]   734.999476: sys_prctl: get_random_int(): 03d533de
           <...>-23413 [000]   735.000302: sys_prctl: get_random_int(): 8168696a
           <...>-23414 [001]   735.001130: sys_prctl: get_random_int(): bfc540fd
           <...>-23415 [001]   735.001937: sys_prctl: get_random_int(): 9f50863b
           <...>-23416 [000]   735.002701: sys_prctl: get_random_int(): e0c08242
           <...>-23417 [001]   735.003473: sys_prctl: get_random_int(): 01dc8ea5
           <...>-23418 [000]   735.004301: sys_prctl: get_random_int(): 64654c19
           <...>-23419 [001]   735.005126: sys_prctl: get_random_int(): ecddcffd
           <...>-23420 [001]   735.005943: sys_prctl: get_random_int(): fdeed1a1
           <...>-23421 [000]   735.006702: sys_prctl: get_random_int(): 5fddbb31
           <...>-23422 [001]   735.007476: sys_prctl: get_random_int(): 77efd6b6
           <...>-23423 [000]   735.008305: sys_prctl: get_random_int(): 08b5c928
           <...>-23424 [001]   735.009133: sys_prctl: get_random_int(): 71c6e260
           <...>-23425 [001]   735.009939: sys_prctl: get_random_int(): 79a1ce1c
           <...>-23426 [000]   735.010703: sys_prctl: get_random_int(): 454f5826
           <...>-23427 [001]   735.011477: sys_prctl: get_random_int(): d7824c98
           <...>-23428 [000]   735.012306: sys_prctl: get_random_int(): 58442212
           <...>-23429 [001]   735.013135: sys_prctl: get_random_int(): 787ebf1f
           <...>-23430 [001]   735.013947: sys_prctl: get_random_int(): 8f0f56aa
           <...>-23431 [000]   735.014709: sys_prctl: get_random_int(): 06947a9e
           <...>-23432 [001]   735.015485: sys_prctl: get_random_int(): 3cfb0efc
           <...>-23433 [000]   735.016310: sys_prctl: get_random_int(): 1c75ff4c
           <...>-23434 [001]   735.017139: sys_prctl: get_random_int(): eaae711c
           <...>-23435 [001]   735.017949: sys_prctl: get_random_int(): 3d0ff789
           <...>-23436 [000]   735.018711: sys_prctl: get_random_int(): 8accaae0
           <...>-23437 [001]   735.019483: sys_prctl: get_random_int(): 95bf4c82
           <...>-23438 [000]   735.020275: sys_prctl: get_random_int(): 4e42e1c9
           <...>-23439 [001]   735.021110: sys_prctl: get_random_int(): d604eef8
           <...>-23440 [001]   735.021934: sys_prctl: get_random_int(): 54484dcf
           <...>-23441 [000]   735.022729: sys_prctl: get_random_int(): 872fc3bc
           <...>-23442 [001]   735.023500: sys_prctl: get_random_int(): 98824c0a
           <...>-23443 [000]   735.024282: sys_prctl: get_random_int(): b7ed846a
           <...>-23444 [001]   735.025115: sys_prctl: get_random_int(): 16258dc9
           <...>-23445 [001]   735.025947: sys_prctl: get_random_int(): c94a4f29
           <...>-23446 [000]   735.026744: sys_prctl: get_random_int(): ee7392d8
           <...>-23447 [001]   735.027512: sys_prctl: get_random_int(): 5ec65878
           <...>-23448 [000]   735.028301: sys_prctl: get_random_int(): 493b4988
           <...>-23449 [001]   735.029121: sys_prctl: get_random_int(): f1266b57
           <...>-23450 [001]   735.029933: sys_prctl: get_random_int(): a59debaf
           <...>-23451 [000]   735.030693: sys_prctl: get_random_int(): 7c132ed5
           <...>-23452 [001]   735.031467: sys_prctl: get_random_int(): 11547e2d
           <...>-23453 [000]   735.032291: sys_prctl: get_random_int(): 4f858ff5
           <...>-23454 [001]   735.033120: sys_prctl: get_random_int(): c7110a7f
           <...>-23455 [001]   735.033927: sys_prctl: get_random_int(): 6e3b0e36
           <...>-23456 [000]   735.034691: sys_prctl: get_random_int(): 12f6bac0
           <...>-23457 [001]   735.035465: sys_prctl: get_random_int(): 4ed53f86
           <...>-23458 [000]   735.036293: sys_prctl: get_random_int(): ee29a241
           <...>-23459 [001]   735.037117: sys_prctl: get_random_int(): 953a79c5
           <...>-23460 [001]   735.037927: sys_prctl: get_random_int(): 9f729347
           <...>-23461 [000]   735.038686: sys_prctl: get_random_int(): f847a7b3
           <...>-23462 [001]   735.039460: sys_prctl: get_random_int(): f947ea8c
           <...>-23463 [000]   735.040282: sys_prctl: get_random_int(): 8336bf10
           <...>-23464 [000]   735.041096: sys_prctl: get_random_int(): 96799192
           <...>-23465 [001]   735.041882: sys_prctl: get_random_int(): 10c6d381
           <...>-23466 [000]   735.042670: sys_prctl: get_random_int(): b87b9ae5
           <...>-23467 [001]   735.043441: sys_prctl: get_random_int(): 80527aaa
           <...>-23468 [000]   735.044266: sys_prctl: get_random_int(): 2a7e63e9
           <...>-23469 [001]   735.045100: sys_prctl: get_random_int(): 72667100
           <...>-23470 [001]   735.045933: sys_prctl: get_random_int(): a887ca0c
           <...>-23471 [000]   735.046725: sys_prctl: get_random_int(): 50e5ac7d
           <...>-23472 [001]   735.047495: sys_prctl: get_random_int(): e5593464
           <...>-23473 [000]   735.048278: sys_prctl: get_random_int(): 5a4baff4
           <...>-23474 [001]   735.049106: sys_prctl: get_random_int(): 7806817c
           <...>-23475 [001]   735.049928: sys_prctl: get_random_int(): d14b3fd3
           <...>-23476 [000]   735.050721: sys_prctl: get_random_int(): ef44083e
           <...>-23477 [001]   735.051490: sys_prctl: get_random_int(): 13092404
           <...>-23478 [000]   735.052277: sys_prctl: get_random_int(): c90d50a5
           <...>-23479 [001]   735.053107: sys_prctl: get_random_int(): 95045a0e
           <...>-23480 [001]   735.053933: sys_prctl: get_random_int(): 972d7cdb
           <...>-23481 [000]   735.054726: sys_prctl: get_random_int(): 55caf453
           <...>-23482 [001]   735.055497: sys_prctl: get_random_int(): 4fda0c11
           <...>-23483 [000]   735.056283: sys_prctl: get_random_int(): f8e3ea70
           <...>-23484 [001]   735.057104: sys_prctl: get_random_int(): 16c2f90d
           <...>-23485 [001]   735.057914: sys_prctl: get_random_int(): 82e8de96
           <...>-23486 [000]   735.058678: sys_prctl: get_random_int(): e18cb667
           <...>-23487 [001]   735.059450: sys_prctl: get_random_int(): c421be39
           <...>-23488 [000]   735.060279: sys_prctl: get_random_int(): e76e99b6
           <...>-23489 [001]   735.061108: sys_prctl: get_random_int(): 5734c0d1
           <...>-23490 [001]   735.061866: sys_prctl: get_random_int(): 63130b88
           <...>-23491 [000]   735.062658: sys_prctl: get_random_int(): be4e7087
           <...>-23492 [001]   735.063433: sys_prctl: get_random_int(): d5a854ed
           <...>-23493 [000]   735.064256: sys_prctl: get_random_int(): c960ce66
           <...>-23494 [001]   735.065093: sys_prctl: get_random_int(): 02c31f24
           <...>-23495 [001]   735.065924: sys_prctl: get_random_int(): 6aca4b56
           <...>-23496 [000]   735.066719: sys_prctl: get_random_int(): bdb985ce
           <...>-23497 [001]   735.067490: sys_prctl: get_random_int(): d248e7fd
           <...>-23498 [000]   735.068277: sys_prctl: get_random_int(): 970f09e6
           <...>-23499 [001]   735.069101: sys_prctl: get_random_int(): 0888635b
           <...>-23500 [001]   735.069932: sys_prctl: get_random_int(): c15080b6
           <...>-23501 [000]   735.070724: sys_prctl: get_random_int(): 0b858d9e
           <...>-23502 [001]   735.071494: sys_prctl: get_random_int(): 342945ed
           <...>-23503 [000]   735.072274: sys_prctl: get_random_int(): 03adf881
           <...>-23504 [000]   735.073086: sys_prctl: get_random_int(): 65034d8d
           <...>-23505 [001]   735.073877: sys_prctl: get_random_int(): d9c16cb9
           <...>-23506 [000]   735.074664: sys_prctl: get_random_int(): 07e3c719
           <...>-23507 [001]   735.075431: sys_prctl: get_random_int(): 5cd3f586
           <...>-23508 [000]   735.076256: sys_prctl: get_random_int(): 6d2464e0
           <...>-23509 [001]   735.077090: sys_prctl: get_random_int(): f75751e9
           <...>-23510 [001]   735.077912: sys_prctl: get_random_int(): 35fb1e53
           <...>-23511 [000]   735.078712: sys_prctl: get_random_int(): dd582024
           <...>-23512 [001]   735.079486: sys_prctl: get_random_int(): 7ce66d42
           <...>-23513 [000]   735.080269: sys_prctl: get_random_int(): af53ec5d
           <...>-23514 [001]   735.081102: sys_prctl: get_random_int(): 42a0bb55
           <...>-23515 [001]   735.081920: sys_prctl: get_random_int(): f0ad05a9
           <...>-23516 [000]   735.082713: sys_prctl: get_random_int(): b6cd805b
           <...>-23517 [001]   735.083484: sys_prctl: get_random_int(): 6e4412d7
           <...>-23518 [000]   735.084271: sys_prctl: get_random_int(): b09f6954
           <...>-23519 [001]   735.085098: sys_prctl: get_random_int(): 225cd84b
           <...>-23520 [001]   735.085940: sys_prctl: get_random_int(): bb918e6f
           <...>-23521 [000]   735.086732: sys_prctl: get_random_int(): 8d6fea43
           <...>-23522 [001]   735.087505: sys_prctl: get_random_int(): f121f79f
           <...>-23523 [000]   735.088286: sys_prctl: get_random_int(): b9929ce5
           <...>-23524 [001]   735.089108: sys_prctl: get_random_int(): ac4c3c56
           <...>-23525 [001]   735.089919: sys_prctl: get_random_int(): 7649befe
           <...>-23526 [000]   735.090682: sys_prctl: get_random_int(): 0190d9a6
           <...>-23527 [001]   735.091455: sys_prctl: get_random_int(): b720e83c
           <...>-23528 [000]   735.092282: sys_prctl: get_random_int(): a437e32e
           <...>-23529 [001]   735.093105: sys_prctl: get_random_int(): 4793f742
           <...>-23530 [001]   735.093918: sys_prctl: get_random_int(): b205ede4
           <...>-23531 [000]   735.094681: sys_prctl: get_random_int(): 4507eb0d
           <...>-23532 [001]   735.095456: sys_prctl: get_random_int(): 8b7ca865
           <...>-23533 [000]   735.096278: sys_prctl: get_random_int(): 2eddd1e1
           <...>-23534 [001]   735.097106: sys_prctl: get_random_int(): 507754b5
           <...>-23535 [001]   735.097917: sys_prctl: get_random_int(): 57e24a43
           <...>-23536 [000]   735.098678: sys_prctl: get_random_int(): 4dd31c7f
           <...>-23537 [001]   735.099455: sys_prctl: get_random_int(): 25a0047f
           <...>-23538 [000]   735.100284: sys_prctl: get_random_int(): 87ce3636
           <...>-23539 [001]   735.101107: sys_prctl: get_random_int(): 172e6c5f
           <...>-23540 [001]   735.101918: sys_prctl: get_random_int(): a5f8c320
           <...>-23541 [000]   735.102680: sys_prctl: get_random_int(): 0e3d4632
           <...>-23542 [001]   735.103457: sys_prctl: get_random_int(): afa6b643
           <...>-23543 [000]   735.104281: sys_prctl: get_random_int(): 83043fcd
           <...>-23544 [001]   735.105107: sys_prctl: get_random_int(): 6a0f0232
           <...>-23545 [001]   735.105937: sys_prctl: get_random_int(): 19142bff
           <...>-23547 [001]   735.106777: sys_prctl: get_random_int(): 7a1e99a1
           <...>-23548 [001]   735.107587: sys_prctl: get_random_int(): 358dd65e
           <...>-23550 [001]   735.109218: sys_prctl: get_random_int(): 3e023054

--XsQoSWH+UP9D9v3l
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="trace.bin"
Content-Transfer-Encoding: base64

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
jTVUMAI+

--XsQoSWH+UP9D9v3l--
