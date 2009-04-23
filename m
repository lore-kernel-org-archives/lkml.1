Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZDWHve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZDWHve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZDWHdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43807 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbZDWHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:39 -0400
Date: Thu, 23 Apr 2009 09:37:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: fresh data was Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
Message-ID: <20090423073709.GH13896@one.firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain> <20090422211501.GD13896@one.firstfloor.org> <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain> <20090422220428.GE13896@one.firstfloor.org> <87skjzoqah.fsf_-_@basil.nowhere.org> <20090423063625.GB9833@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423063625.GB9833@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:36:25AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Andi Kleen <andi@firstfloor.org> writes:
> > 
> > >> > Quick test here:
> > >> 
> > >> How about you just compile the kernel with gcc-3.2 and compare the number 
> > >> of calls to memcpy before-and-after instead? That's the real test.
> > >
> > > I waited over 10 minutes for the full vmlinux objdumps to finish. sorry lost
> > > patience. If someone has a fast disassembler we can try it. I'll leave
> > > them running over night, maybe there are exact numbers tomorrow.
> > >
> > > But from a quick check (find -name '*.o' | xargs nm | grep memcpy) there are
> > > very little files which call it with the patch, so there's some
> > > evidence that there isn't a dramatic increase.
> > 
> > I let the objdumps finish over night. [...]
> 
> objdump -d never took me more than a minute - let alone a full 

I use objdump -S. Maybe that's slower than -d.

Hmm quick test, yes -S seems to be much slower than -d. Thanks for
the hint. I guess I should switch to -d for these cases, unfortunately
-S seems to be hardcoded in my fingers and of course it gives much
nicer output if you have debug info.

> night. You must be doing something really wrong there. Looking at 
> objdump -d is an essential, unavoidable component of my workflow 
> with x86 architecture patches, you need to find a way to do it 

I do it all the time too, but only for specific functions, not
for full kernels. I have a objdump-symbol script for that that
looks up a symbol in the symbol table and only disassembles
the function I'm interested in 
(ftp://firstfloor.org/pub/ak/perl/objdump-symbol) 
I normally don't look at full listings of the complete kernel.

> > [...] On my setup (defconfig + some additions) there are actually 
> > less calls to out of line memcpy/__memcpy with the patch. I see 
> > only one for my defconfig, while there are ~10 without the patch. 
> > So it makes very little difference. The code size savings must 
> > come from more efficient code generation for the inline case. I 
> > haven't investigated that in detail though.
> > 
> > So the patch seems like a overall win.
> 
> It's a clear loss here with GCC 3.4, and it took me less than 5 
> minutes to figure that out.

Loss in what way?

> 
> With what precise compiler version did you test (please paste the 
> gcc -v output), and could you send me the precise .config you used, 

See the 2nd previous mail: 3.2.3

I didn't do tests with later versions, assuming there are no 
regressions.

> and describe the method you used to determine the number of 
> out-of-line memcpy calls? I'd like to double-check your numbers.

objdump -S ... | grep call.*memcpy         (gives some false positives,
you have to weed them out)

In addition I did a quick find -name '*.o' | xargs nm | grep 'U.*memcpy$'
to (under) estimate the calls  

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
