Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZCVMJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZCVMJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZCVMI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:08:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48521 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZCVMIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:08:55 -0400
Date: Sun, 22 Mar 2009 13:08:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090322120811.GD19826@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321214852.GA5262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321214852.GA5262@redhat.com>
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


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -
> 
> On Sat, Mar 21, 2009 at 04:45:01PM +0100, Ingo Molnar wrote:
> > [...]
> > To me personally there are two big direct usability issues with 
> > SystemTap:
> > 
> >  1) It relies on DEBUG_INFO for any reasonable level of utility.
> >     Yes, it will limp along otherwise as well, but most of the
> >     actual novel capabilities depend on debuginfo. Which is an
> >     acceptable constraint for enterprise usage where kernels are
> >     switched every few months and having a debuginfo package is not
> >     a big issue. Not acceptable for upstream kernel development. 
> 
> In my own limited kernel-building experience, I find the debuginfo 
> data conveniently and instantly available after every "make".  Can 
> you elaborate how is it harder for you to incidentally make it 
> than for someone to download it?

Four reasons:

1)

I have CONFIG_DEBUG_INFO turned off in 99.9% of my kernel builds, 
because it slows down the kernel build times significantly:

  without:   4343.31 user 416.39 system 6:09.97 elapsed 1286%CPU 
  with:      4871.07 user 501.90 system 7:43.22 elapsed 1159 %CPU 

( x86 allyesconfig. On an obscenely overpowered Nehalem box
  with 12 GB of RAM. )

2)

When the kernel build becomes IO-bound, for example when i build 
over a distcc cluster (which is how i generally build my kernels) - 
or when others with less RAM build a debuginfo kernel, the ratio 
becomes even worse:

  without:   870.36 user 292.79 system 3:32.10 elapsed  548% CPU
  with:      929.65 user 384.55 system 8:28.70 elapsed  258% CPU

3)

Another metric. Here's an x86 defconfig (i.e. fairly regular config 
- not allyesconfig) build's size:

  with:     1645 MB
  without:   211 MB

Try to build 1.6 GB of dirty data on ext3 and run into an fsync() in 
your editor ... you'll sit there twiddling thumbs for a minute or 
more.

4)

Or yet another metric - Linux distro package overhead. Try 
installing a debuginfo package:

 # yum install kernel-debuginfo

 ==========================================
  Package                  Arch    Version
 ==========================================
 Installing:
  kernel-debuginfo         x86_64  2.6.29-0.258.rc8.git2.fc11   
 rawhide-debuginfo  294 M
 Installing for dependencies:
  kernel-debuginfo-common  x86_64  2.6.29-0.258.rc8.git2.fc11   
 rawhide-debuginfo   35 M

 Total download size: 329 M

That size of a _compressed_ debuginfo kernel package is obscene. We 
can fit 4 years of full Linux kernel Git history into that size - 
60,000+ commits, full metadata and full 20 million lines of code 
flux included!

Uncompressed it blows up to gigabytes of on-disk data.

And this download has to be repeated for _every_ minor kernel 
upgrade.

So when i come into a situation where i could use some debugging 
help ... i'd have to rebuild the kernel with DEBUG_INFO=y and i'll 
always notice when i have a debuginfo kernel because it's 
inconvenient.

The solution?)

Dunno - but i definitely think we should think bigger:

The fundamental disconnect i believe seems to come from the fact 
that most user-space projects are relatively small, so debuginfo 
bloat is a secondary issue there.

But for a project with the size of the kernel, even for moderate 
builds (not allyesconfig), it's a _much_ bigger deal. This has been 
known for a long time and the situation has become worse over the 
last two years, not better. (last time i checked the debuginfo 
package overhead it was below 150 MB)

A few random ideas:

Instead of trying to cache 2+GB of debuginfo for a 50 MB kernel 
source repo (+50 MB of genuine .o output) - just to be able to debug 
one or two source files [which is the typical scope of a debugging 
session], why not build debuginfo on the fly, when a debugging 
session requires it? Rarely do we need debuginfo for more than a 
fraction of the whole kernel.

( Yes, it needs a few smarts like knowing the SHA1 of the source
  code module that a particular kernel portion got built with, to 
  make sure the debuginfo is fresh and relevant - but nothing major. )

I mean, lets _use_ the fact that we have source code available, more 
intelligently. It takes zero time to build detailed debuginfo for a 
portion of a tree.

If 'download debuginfo' can be replaced with: 'have a recent Git 
repository of the distro kernel source', we'll have a _much_ more 
efficient use of resources all around.

	Ingo
