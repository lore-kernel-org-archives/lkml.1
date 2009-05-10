Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZEKMPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZEKMPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZEKMP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:15:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51418 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbZEKMP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:15:26 -0400
Date: Sun, 10 May 2009 07:37:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nicholas Miell <nmiell@comcast.net>,
       "Markus Gutschke (?????????)" <markus@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Message-ID: <20090510053700.GC1363@ucw.cz>
References: <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain> <904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com> <20090506212913.GC4861@elte.hu> <904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com> <20090506215450.GA9537@elte.hu> <904b25810905061508n6d9cb8dbg71de5b1e0332ede7@mail.gmail.com> <20090506221319.GA11493@elte.hu> <904b25810905061521v62b3ddd6l14deb614d203385a@mail.gmail.com> <1241670237.11500.7.camel@entropy> <20090507101129.GB5978@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507101129.GB5978@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-07 12:11:29, Ingo Molnar wrote:
> 
> * Nicholas Miell <nmiell@comcast.net> wrote:
> 
> > On Wed, 2009-05-06 at 15:21 -0700, Markus Gutschke (?????????) wrote:
> > > On Wed, May 6, 2009 at 15:13, Ingo Molnar <mingo@elte.hu> wrote:
> > > > doing a (per arch) bitmap of harmless syscalls and replacing the
> > > > mode1_syscalls[] check with that in kernel/seccomp.c would be a
> > > > pretty reasonable extension. (.config controllable perhaps, for
> > > > old-style-seccomp)
> > > >
> > > > It would probably be faster than the current loop over
> > > > mode1_syscalls[] as well.
> > > 
> > > This would be a great option to improve performance of our sandbox. I
> > > can detect the availability of the new kernel API dynamically, and
> > > then not intercept the bulk of the system calls. This would allow the
> > > sandbox to work both with existing and with newer kernels.
> > > 
> > > We'll post a kernel patch for discussion in the next few days,
> > > 
> > 
> > I suspect the correct thing to do would be to leave seccomp mode 1 
> > alone and introduce a mode 2 with a less restricted set of system 
> > calls -- the interface was designed to be extended in this way, 
> > after all.
> 
> Yes, that is what i alluded to above via the '.config controllable' 
> aspect.
> 
> Mode 2 could be implemented like this: extend prctl_set_seccomp() 
> with a bitmap pointer, and copy it to a per task seccomp context 
> structure.
> 
> a bitmap for 300 syscalls takes only about 40 bytes.
> 
> Please take care to implement nesting properly: if a seccomp context 
> does a seccomp call (which mode 2 could allow), then the resulting 
> bitmap should be the logical-AND of the parent and child bitmaps. 
> There's no reason why seccomp couldnt be used in hiearachy of 
> sandboxes, in a gradually less permissive fashion.

I don't think seccomp nesting (at kernel level) has any value.

First, syscalls are wrong level of abstraction for sandboxing. There
are multiple ways to read from file, for example.

If you wanted to do hierarchical sandboxes, asking your monitor to
restrict your seccomp mask would seem like a way to go...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
