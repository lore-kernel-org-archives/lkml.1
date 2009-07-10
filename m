Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZGJUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZGJUDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZGJUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:03:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZGJUDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:03:17 -0400
Date: Fri, 10 Jul 2009 22:02:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20090710200259.GA2020@elte.hu>
References: <20090710162848.GA26862@elte.hu> <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain> <20090710193110.GA28281@elte.hu> <alpine.LFD.2.01.0907101249060.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907101249060.3352@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 10 Jul 2009, Ingo Molnar wrote:
> > > 
> > > but I really migth have done soemthing wrong there. It's a 
> > > simple function, but somebody needs to double-check that I 
> > > haven't made it worse.
> > 
> > Looks correct to me.
> 
> Note, I didn't look at how 'end' works, and it really does matter 
> if 'end' is an "inclusive" or "exclusive" end pointer address. So 
> my replacement overlap() function was written more as a conceptual 
> patch - I did not check the exact semantics of the arguments 
> passed in.
> 
> If 'end' is exclusive, then 'b1' should be calculated as 
> 'a1+size-1', because the ranges must have the same rules. And then 
> you should use the 'strict inequality' operators for testing the 
> ranges.

The ranges are inclusive in terms of non-overlap: we can have 
adjacent ranges with b1==a2 or b2==a1 that are still considered 
non-overlapping. Hence the sharp test you used (which is negated) 
looks correct to me.

The end-of-range symbols we use:

        if (overlap(addr, len, _text, _etext) ||
            overlap(addr, len, __start_rodata, __end_rodata))

Are all at the first byte outside of the to-be-avoided range:

        .text : {
                _text = .;      /* Text */
                *(.text)
                *(.text.*)
                _etext = . ;
        }

        ...

        __param : AT(ADDR(__param) - LOAD_OFFSET) {                     \
                VMLINUX_SYMBOL(__start___param) = .;                    \
                *(__param)                                              \
                VMLINUX_SYMBOL(__stop___param) = .;                     \
                . = ALIGN((align));                                     \
                VMLINUX_SYMBOL(__end_rodata) = .;                       \
        }                                                               \

        ...

I think ...

	Ingo
