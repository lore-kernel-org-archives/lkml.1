Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXEJItl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXEJItl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759940AbXEJItb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:49:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbXEJIt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:49:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/utrace
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: utrace comments
In-Reply-To: Christoph Hellwig's message of  Monday, 30 April 2007 10:08:40 +0100 <20070430090840.GB31397@infradead.org>
X-Windows: more than enough rope.
Message-Id: <20070510084926.65D6558002@magilla.localdomain>
Date: Thu, 10 May 2007 01:49:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No need to renumber.  You remove TIF_SYSCALL_EMU which is six,
> so the newly added TIF_FORCED_TF could reuse that bit.

No, that would be incorrect.  As I mentioned earlier, there are magic
semantics to bits < 16, namely that they are in _TIF_ALLWORK_MASK (and
assembly code knows implicitly that these are in the low 16 bits).
TIF_FORCED_TF must not be in _TIF_ALLWORK_MASK, hence must be >= 16.

> > Ok.  The kerneldoc stuff is new and strange to me, and I've never
> > personally experienced its benefical features.  But I've read
> > Documentation/kernel-doc-nano-HOWTO.txt now and I will try to convert all
> > my documentary comments to that style.
> 
> Thanks.  If you need some help ping me or Randy.

I've converted the comments to kerneldoc style where I could figure out how
to.  I left some unmarked comments in places I couldn't see how to get them
extracted from.  I'd appreciate any specific advice you have for the
descriptive comments as they now stand.

> Current gcc (since 3.<something>) can optimize away code under if-branches
> that are determinable at compile time, so having each architecture
> define a (possible trivial) arch_has_single_step() should be fine.

What I had in mind was whole chunks of code you might not build, including
global symbols or whole modules.  In particular, I expect to have some
utility code for executing a single copied instruction (in the style of
kprobes), which can also be implemented for machines without single-step
(see kprobes ARM port).  That could be employed to simulate single-stepping
by a tracing engine (though not without complexities and caveats, which is
why it won't be built in as the UTRACE_ACTION_SINGLESTEP support).  An
engine could support this using only machine-independent interfaces to the
aforementioned utility code, and rely on arch_has_single_step() to know
whether it needs to.  That code might be costly to build in and would not
all be dropped at compile time even if always dead at runtime, or perhaps
isn't there at all for a particular machine.  But if on that machine you
know at compile time that arch_has_single_step() will never return 0, you
don't need it.  I don't want to get too bogged down in those specifics,
because they aren't the point right now.  The only point I'm making here is
that #if really is going to be useful.

> Btw, is there a fundamental reason why an architecture would not support
> single-stepping except for a transition period of porting, i.e. are there
> real hardware limitation in any of our ports?

As I understand it, Alpha and ARM hardware in fact have no single-step feature.
There may be others.  

> > utrace_native_view is expected to be the only user of the *_view symbols.
> > I inlined it because on single-arch platforms it's just a constant return
> > and I didn't want to add another useless call frame.  I admit this is undue
> > microoptimization.  Perhaps utrace_native_view should just be non-inlined
> > and exported.
> 
> Yeah, the latter probably makes sense.

I've changed it that way now.


Thanks,
Roland
