Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbZAHSeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbZAHSeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZAHSdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:33:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZAHSds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:33:48 -0500
Date: Thu, 8 Jan 2009 19:33:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090108183306.GA22916@elte.hu>
References: <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231366716.11687.377.camel@twins> <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Unrelated:
> 
> On Thu, 8 Jan 2009, Chris Mason wrote:
> >
> > RIP: 0010:[<ffffffff8024f4de>]  [<ffffffff8024f4de>] __cmpxchg+0x36/0x3f
> 
> Ouch. HOW THE HELL DID THAT NOT GET INLINED?
> 
> cmpxchg() is a _single_ instruction if it's inlined, but it's a horrible 
> mess of dynamic conditionals on the (constant - per call-site) size 
> argument if it isn't.
> 
> It looks like you probably enabled the "let gcc mess up inlining" config 
> option.
> 
> Ingo - I think we need to remove that crap again. Because gcc gets the 
> inlining horribly horribly wrong. As usual.

Apparently it messes up with asm()s: it doesnt know the contents of the 
asm() and hence it over-estimates the size [based on string heuristics] 
...

Which is bad - asm()s tend to be the most important entities to inline - 
all over our fastpaths .

Despite that messup it's still a 1% net size win:

      text    data     bss     dec     hex filename
   7109652 1464684  802888 9377224  8f15c8 vmlinux.always-inline
   7046115 1465324  802888 9314327  8e2017 vmlinux.optimized-inlining

That win is mixed in slowpath and fastpath as well.

I see three options:

 - Disable CONFIG_OPTIMIZE_INLINING=y altogether (it's already 
   default-off)

 - Change the asm() inline markers to something new like asm_inline, which
   defaults to __always_inline.

 - Just mark all asm() inline markers as __always_inline - realizing that 
   these should never ever be out of line.

We might still try the second or third options, as i think we shouldnt go 
back into the business of managing the inline attributes of ~100,000 
kernel functions.

I'll try to annotate the inline asms (there's not _that_ many of them), 
and measure what the size impact is.

	Ingo
