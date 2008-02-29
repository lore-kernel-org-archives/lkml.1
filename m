Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbYB2UMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbYB2UMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbYB2UMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:12:47 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755742AbYB2UMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:12:46 -0500
Date: Fri, 29 Feb 2008 12:07:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, Geoff Clare <gwc@opengroup.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802291200580.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <1204305244.6243.111.camel@lappy>  <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
  <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>  <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org> <c49095e30802291149t7ad01f6bl59b9083bfb41c920@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Michael Kerrisk wrote:

> On Fri, Feb 29, 2008 at 7:39 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
> >  I agree. And clearly there _are_ relationships and always have been, but
> >  equally clearly they simply haven't been a big issue in practice, and
> >  nobody really cares.
> 
> Do we know that for sure?

We *do* know for sure that the relationship has always been there. At 
least in Linux, and I bet in 99% of all other Unixes too. The arguments 
simply have traditionally been counted as part of the stack size.

Or did you mean the latter part?

The fact is, we *also* know for sure that anybody that depends on 
_SC_ARG_MAX being exact has always - and will continue to be - broken. 
Again, because of not only older kernels but also because even with the 
patch in question, we don't count argument sizes exactly.

> In my initial reply, I pointed out one example where users *may* care:
> NPTL uses RLIMIT_STACK to determine the size of per-thread stacks.  It
> is conceivable that users might want to set RLIMIT_STACK < 512k, and
> that would have the effect of lowering the amount of space for
> argv+eviron below what the kernel has historically guaranteed.  That's
> an ABI change, though it's unclear whether it would impact anyone in
> practice.

I do agree that we should at least make the "MAX(stacksize/4, 128k)" 
change for backwards compatibility. That is actually a potential 
regression, but it has nothing to do with a new _SC_ARG_SIZE, because 
quite frankly, it's a regression *regardless* of whether we'd expose a new 
rlimit or not!

And one of the reasons I'm so down on new resource limits is that nobody 
then has the code to actually update them. You won't see it in "ulimit -a" 
until you have a newly compiled bash that cares etc etc, so as far as I'm 
concerned, I see hat RLIMIT_ARG_MAX as nothing but a pain. It actually 
makes the code more complex, makes it work less like we and others have 
*always* worked, and doesn't even help users - quite the reverse.

I don't like unnecessary complexity. If the RLIMGI_STACK/4 check is truly 
so troublesome, let's just *remove* it, rather than add more crap and 
complexity on top of it!

Problem solved.

		Linus
