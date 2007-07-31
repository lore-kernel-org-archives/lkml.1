Return-Path: <linux-kernel-owner+w=401wt.eu-S939501AbXGaAuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939501AbXGaAuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXGaAur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:50:47 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:45049 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbXGaAup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:50:45 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 31 Jul 2007 06:37:45 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Denis Vlasenko <vda.linux@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/8] i386: bitops: Cleanup, sanitize, optimize
In-Reply-To: <1158166a0707301057w13db2d0ema88892a0091dda87@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707310623250.17972@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <1158166a0707301057w13db2d0ema88892a0091dda87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,


On Mon, 30 Jul 2007, Denis Vlasenko wrote:

> Hi Satyam,
> 
> On Monday 23 July 2007 17:05, Satyam Sharma wrote:
> > There was a lot of bogus stuff that include/asm-i386/bitops.h was doing,
> > that was unnecessary and not required for the correctness of those APIs.
> > All that superfluous stuff was also unnecessarily disallowing compiler
> > optimization possibilities, and making gcc generate code that wasn't as
> > beautiful as it could otherwise have been. Hence the following series
> > of cleanups (some trivial, some surprising, in no particular order):
> 
> [I did read entire thread]
> 
> Welcome to the minefield.
> 
> This bitops and barrier stuff is complicated. It's very easy to
> introduce bugs which are hard to trigger, or happen only with some
> specific gcc versions, or only on massively parallel SMP boxes.
> 
> You can also make technically correct changes which relax needlessly
> strict barrier semantics of some bitops and trigger latent bugs
> in code which was unknowingly depending on it.
> 
> How you can proceed:
> 
> Make a change which you believe is right. Recompile allyesconfig
> kernel with and without this change. Find a piece of assembly code
> which become different. Check that new code is correct (and smaller
> and/or faster). Post your patch together with example(s) of code
> fragments that got better. Be as verbose as needed.
> 
> Repeat for each change separately.
> 
> This can be painfully slow, but less likely to be rejected outright
> in fear of introducing difficult bugs.

Thanks for the tips, I'd remember these in the future :-)


> > * Marking "memory" as clobbered for no good reason
> 
> I vaguely remember that "memory" clobbers are needed in some rather
> obscure, non-obvious situations. Google for it - Linus wrote about it
> to lkml (a few years ago IIRC).
> 
> > * Volatile-casting of memory addresses
> >   (wholly unnecessary, makes gcc generate bad code)
> 
> Do you know any code difference resulting from this patch?
> 
> > * Unwarranted use of __asm__ __volatile__ even when those semantics
> >   are not required
> 
> ditto
> 
> > * Unnecessarily harsh definitions of smp_mb__{before, after}_clear_bit()
> >   (again, this was like *asking* gcc to generate bad code)
> 
> ditto

The problem with most of the patches in this series (other than the two
related to vague gcc docs), as you know, turned out to be the fact that
a lot of code/callers out there rely on the bitops as also being
lock/unlock functions -- and hence the need for disallowing both
compiler as well as CPU reordering / optimizations.

There were few valid changes in the patchset too, and probably I'll try
to look at them the way you described above (or probably it also makes
some sense to keep the bitops as-is, "it works" today after all, and
there are other avenues for optimizations/cleanups too).


Thanks again,
Satyam
