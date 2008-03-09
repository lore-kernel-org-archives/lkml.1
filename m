Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYCIUKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYCIUKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYCIUKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:10:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37001 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYCIUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:10:34 -0400
Date: Sun, 9 Mar 2008 21:10:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
Message-ID: <20080309201016.GA28454@elte.hu>
References: <20080309200103.GA895@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309200103.GA895@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> x86: Change x86 to use the generic find_next_bit implementation
> 
> The versions with inline assembly are in fact slower on the machines I 
> tested them on (in userspace) (Athlon XP 2800+, p4-like Xeon 2.8GHz, 
> AMD Opteron 270). The i386-version needed a fix similar to 06024f21 to 
> avoid crashing the benchmark.
> 
> Benchmark using: gcc -fomit-frame-pointer -Os. For each bitmap size 
> 1...512, for each possible bitmap with one bit set, for each possible 
> offset: find the position of the first bit starting at offset. If you 
> follow ;). Times include setup of the bitmap and checking of the 
> results.
> 
> 		Athlon		Xeon		Opteron 32/64bit
> x86-specific:	0m3.692s	0m2.820s	0m3.196s / 0m2.480s
> generic:	0m2.622s	0m1.662s	0m2.100s / 0m1.572s

ok, that's rather convincing.

the generic version in lib/find_next_bit.c is open-coded C which gcc can 
optimize pretty nicely.

the hand-coded assembly versions in arch/x86/lib/bitops_32.c mostly use 
the special x86 'bit search forward' (BSF) instruction - which i know 
from the days when the scheduler relied on it has some non-trivial setup 
costs. So especially when there's _small_ bitmasks involved, it's more 
expensive.

> If the bitmap size is not a multiple of BITS_PER_LONG, and no set 
> (cleared) bit is found, find_next_bit (find_next_zero_bit) returns a 
> value outside of the range [0,size]. The generic version always 
> returns exactly size. The generic version also uses unsigned long 
> everywhere, while the x86 versions use a mishmash of int, unsigned 
> (int), long and unsigned long.

i'm not surprised that the hand-coded assembly versions had a bug ...

[ this means we have to test it quite carefully though, as lots of code 
  only ever gets tested on x86 so code could have built dependency on 
  the buggy behavior. ]

> Using the generic version does give a slightly bigger kernel, though.
> 
> defconfig:	   text    data     bss     dec     hex filename
> x86-specific:	4738555  481232  626688 5846475  5935cb vmlinux (32 bit)
> generic:	4738621  481232  626688 5846541  59360d vmlinux (32 bit)
> x86-specific:	5392395  846568  724424 6963387  6a40bb vmlinux (64 bit)
> generic:	5392458  846568  724424 6963450  6a40fa vmlinux (64 bit)

i'd not worry about that too much. Have you tried to build with:

  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
  CONFIG_OPTIMIZE_INLINING=y

(the latter only available in x86.git)

> Patch is against -x86#testing. It compiles.

i've picked it up into x86.git, lets see how it goes in practice.

	Ingo
