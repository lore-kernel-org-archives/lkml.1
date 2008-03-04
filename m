Return-Path: <linux-kernel-owner+w=401wt.eu-S1765501AbYCDQqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765501AbYCDQqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbYCDQq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:46:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759056AbYCDQq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:46:28 -0500
Date: Tue, 4 Mar 2008 17:46:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-ID: <20080304164605.GA16379@elte.hu>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu> <20080303145623.GA25697@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303145623.GA25697@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > Subject: x86: phase out forced inlining
> 
> Any particular reason you made the patch x86 specific?

to keep it simple for now. Some of the other 24 architectures are 
seriously under-tested and while we can make sure x86 works well, i dont 
test the others. If it works out fine on x86 it can be generalized.

> > +config OPTIMIZE_INLINING
> 
> Other (not all) config options that deal with gcc behaviour are named 
> CC_*. But they mostly impact gcc options. CC_OPTIMIZE_INLINING would 
> match the naming of CC_OPTIMIZE_SIZE, except in the latter OPTIMIZE 
> refer to the -O option.
> 
> CC_DEFAULT_INLINE may give the right associations?

i really wanted to name it 'optimize' - because that's what it does. We 
just lost 2 years of uninlining advantage due to CONFIG_FORCED_INLINING 
not working and nobody actually connecting the dots that the lack of 
'forced inlining' should have resulted in a 'smaller image' and report 
it as a bug.

> > + test gcc for this.
> 
> Would it be worth here to mention that stuff that really needs 
> inlining should use __always_inle and not inline?

i think people know that, but i'll add it.

> > + */
> > +#ifndef CONFIG_OPTIMIZE_INLINING
> > +# define inline		inline		__attribute__((always_inline))
> > +# define __inline__	__inline__	__attribute__((always_inline))
> > +# define __inline	__inline	__attribute__((always_inline))
> > +#endif
> 
> A quick google did not tell me the difference between inline, 
> __inline, __inline__. But it turned out the december 2005 thread where 
> there was a lenghty discussion about trusting gcc with respect to 
> inlining. It is not the subject of this patch but I just wondered why 
> we need all these variants.

i dont know why they there are so many variants, but all of them seem to 
be used throughout the kernel:

   inline    : 25648
 __inline__  : 1380
 __inline    : 368

so obviously the patch has to cover them.

a few stats about inlines btw:

- in v2.6.24 there were 26452 inlines in the kernel in 8083114 lines of 
  code - or one inline per 305.6 lines of code.

- in v2.6.25-rc3 there are 27396 inlines in the kernel in 8387992 lines 
  of code - or one inline per 308.2 lines of code.

at that rate, all inlines will be removed in about 117.5 kernel cycles - 
which, if we count with 90 day release cycles, will be finished in about 
29 years.

if we only look at include/linux/ files [which have the largest inlining 
effect], the rate of inline removal is in fact negative: in v2.6.24 we 
had one inline per 59.1 lines, in 2.6.25-to-be we have one inline per 
57.9 lines.

so i'm not holding my breath and i'm going for the much more immediate 
benefit of CONFIG_OPTIMIZE_INLINING=y.

	Ingo
