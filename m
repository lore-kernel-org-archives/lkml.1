Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbYEEUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbYEEUTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYEEUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:19:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33692 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbYEEUTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:19:34 -0400
Date: Mon, 5 May 2008 22:19:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [rfc] the kernel workflow & trivial "global -> static" patches
	(was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505201906.GA900@elte.hu>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505182942.GA17139@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the following needlessly global code in kernel/sched.c  
> static:
> - sched_feat_names[]
> - sched_feat_open()

Adrian, you've been doing these "make needlessly global code static" 
patches for years meanwhile. I'm asking whether you have made any 
thoughts about going to the next level and automating (or at least 
half-automating) the generation of these trivial patches, so that they 
become less disruptive to our patch flow?

My opinion is that the technical benefit of these patches is positive to 
Linux: they make the kernel image a tiny bit smaller - for example this 
sched.c patch of yours i'm replying to makes the 64-bit kernel 8 bytes 
smaller. So i always applied your patches, and will do so in the future 
too.

But the per patch benefit is arguably extremely low: for example this 
particular patch saves 0.00016% from my particular vmlinux's size. Even 
on a Linux-Tiny kernel config, it's just 0.0008% of the vmlinux's size. 
We'd need more than 600 such patches (!) to make just 0.1% of a code 
size difference to my vmlinux, and even 0.1% is still very, very small. 
[ and many of these patches do not even trigger any savings on tiny 
  configs. ]

The point that many kernel developers make is that if we compare this 
small benefit to the disruption to the workflow this many small patches 
can cause, they could in fact become a net negative contribution (!). So 
it is extremely important to reduce the disruption, as much as we can.

And unlike other kernel developers, my opinion is not that we should 
eliminate this disruption by not doing these trivial patches _at all_. 
My opinion is that we should make it easier for maintainers to _avoid 
introducing_ these problems.

I.e. we need to fight the root of this problem (the steady introduction 
of needlessly global symbols), not its symptoms (the needlessly global 
symbols themselves).

Let me raise some thoughts about what we could do to achieve these 
goals.

Firstly, the methodology: you are using "make namespacecheck" on an 
allyesconfig kernel to find these 'needlessly global' sites, correct? Do 
you perhaps also generate them via Sparse, or via some other special 
scripting? Could you perhaps describe how you generate them? Do you 
create the patches manually perhaps?

We could extend "make namespacecheck" to emit a patch that just marks 
all symbols static that are needlessly global.

Firstly, the practical problem: today "make namespacecheck" emits way 
too many false positives even on an allyesconfig build - this is due to 
some symbols only being utilized on certain config variations and on 
certain architectures. A healthy set of false positives has accumulated 
during the past few years.

Nowhere do we truly document the symbols that are _purposefully_ global 
but "make namespacecheck" complains about them. If we documented them we 
could improve the documentation of the kernel.

The (rather trivial) annotation would look like this:

   __kernel_api int arch_reinit_sched_domains(void)

this marks the arch_reinit_sched_domains symbol in kernel/sched.c as 
"intentionally global" - and it would cause "make namespacecheck" to not 
emit warnings about that symbol by default. These annotations are for 
global symbols that are not always utilized in an allyesconfig build, 
but which we still want to keep global nevertheless.

( Note that because we'd only annotate the sites that trigger "make
  namespacecheck" on an allyesconfig build the overwhelming majority of 
  kernel-internal APIs would stay untouched. )

My estimation is that only about 1 out of 10 new symbols that "make 
namespacecheck" complains about in a new kernel release needs to be 
annotated this way. I.e. we could turn 10 trivial "global => static" 
patches into 1 trivial annotation patch => a 10x reduction in the rate 
of patches!

Secondly, we could introduce a new "make namespacecheck_fix" check 
method. Maintainers could (optionally) use it the following way:

    make namespacecheck_fix arch/x86/
    make namespacecheck_fix kernel/sched.c

this would take the namespacecheck output and would apply it to the 
source - basically emitting a patch.

Subsystem maintainers do not _have to_ run this, it's not in any way 
compulsory (they could just opt to wait for your patches), it's just an 
optional tool like the many other tools we have in the kernel today that 
make life easier for maintainers.

I can see five immediate benefits from all this:

- this way we can push back these trivial patches to the subsystem 
  maintainers who introduce them, and it would not pollute our global 
  workflow at all.

- due to the annotation multiple such trivial changes could be collapsed 
  into a single patch per subsystem - reducing the per patch maintenance 
  overhead even more. The maintainer only needs to check whether it 
  contains some new, intentionally-global symbol. (this is relatively 
  rare - the majority of new global symbols is accidental)

- we'd also document the kernel better, via those "purposefully global" 
  __kernel_api annotations.

- we could concentrate these changes to a single point in time during 
  the kernel cycle - just like we do documentation and typo patches in a 
  single point too. We'd do fewer patches and we'd do them less 
  frequently. That too reduces disruption and increases the net positive 
  effects of these patches.

- another benefit would be for newbies: they could run this tool and 
  could generate patches - saving you and kernel maintainers from having 
  to spend quality time on such trivial issues, and giving kernel 
  newbies an easy first introduction to Linux kernel modifications.

What do you think?

	Ingo
