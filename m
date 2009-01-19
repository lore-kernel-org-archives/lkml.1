Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZASAO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZASAO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZASAOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:14:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZASAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:14:13 -0500
Date: Mon, 19 Jan 2009 01:13:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
	implement adaptive spinning
Message-ID: <20090119001345.GA9880@elte.hu>
References: <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BBE27.2020206@t-online.de>
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


* Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> Linus Torvalds wrote:
> > But you'll need some background to it:
> 
> You paint a somewhat one-sided picture bordering on FUD.
> 
> > Type-based aliasing is _stupid_.
> 
> Type-based aliasing is simply an application of the language definition, 
> and depending on the compiled application and/or target architecture, it 
> can be essential for performance.
> [...]
>
> So, to summarize: strict aliasing works for nearly every application 
> these days, there's a compiler switch for the rest to turn it off, it 
> can be a serious performance improvement, and the compiler warns about 
> dangerous constructs.  That makes the issue a little less black and 
> white than "type based aliasing is stupid".

i did some size measurements. Latest kernel, gcc 4.3.2, x86 defconfig, 
vmlinux built with strict-aliasing optimizations and without.

The image sizes are:

     text    data     bss     dec     hex filename
  6997984 1635900 1322376 9956260  97eba4 vmlinux.gcc.-fno-strict-aliasing
  6985962 1635884 1322376 9944222  97bc9e vmlinux.gcc.strict-aliasing

that's 0.17% of a size win only.

The cost? More than _300_ new "type-punned" warnings during the kernel 
build (3000 altogether, including duplicates that trigger in multiple 
object files) - more than _1000_ new warnings (more than 10,000 total) in 
an allyesconfig build.

That is a _ton_ of effort for a ~0.1% category win. Often in historic code 
that has been working well and now got broken by gcc.

I think this feature has been over-sold while it under-performs. You also 
significantly weakened the utility of the C language for lowlevel 
hardware-conscious programming as a result (which is the strongest side of 
C by far).

Type based aliasing should at most have been an opt-in for code that 
cares, not a turned-on-by-default feature for everyone.

You already dismissed concerns in this thread by suggesting that Linux is 
just one of many projects, but that way you dismiss 1) the largest OSS 
project by linecount 2) one of the most performance-optimized pieces of 
OSS software in existence.

I.e. you dismiss what should have been GCC's strongest supporter, ally, 
test-field and early prototype tester. A lot of folks in the kernel look 
at the assembly level on a daily basis, they run the latest hardware and 
they see where GCC messes up. By dismissing Linux you cut yourself off 
from a lot of development power, you cut yourself off from a lot of 
enthusiasm and you miss out on a lot of dynamism that would naturally help 
GCC too.

I.e. almost by definition you cannot possibly be interested in writing the 
best compiler on the planet.

	Ingo
