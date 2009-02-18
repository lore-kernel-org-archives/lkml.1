Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZBRSTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZBRSTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZBRSS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:18:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZBRSS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:18:56 -0500
Date: Wed, 18 Feb 2009 19:16:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, xemul@openvz.org,
       Nathan Lynch <nathanl@austin.ibm.com>
Subject: Re: What can OpenVZ do?
Message-ID: <20090218181644.GD19995@elte.hu>
References: <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <20090213105302.GC4608@elte.hu> <1234817490.30155.287.camel@nimitz> <20090217222319.GA10546@elte.hu> <1234909849.4816.9.camel@nimitz> <20090218003217.GB25856@elte.hu> <1234917639.4816.12.camel@nimitz> <20090218051123.GA9367@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218051123.GA9367@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Feb 17, 2009 at 04:40:39PM -0800, Dave Hansen wrote:
> > On Wed, 2009-02-18 at 01:32 +0100, Ingo Molnar wrote:
> > > > > Uncheckpointable should be a one-way flag anyway. We want this 
> > > > > to become usable, so uncheckpointable functionality should be as 
> > > > > painful as possible, to make sure it's getting fixed ...
> > > > 
> > > > Again, as these patches stand, we don't support checkpointing 
> > > > when non-simple files are opened.  Basically, if a 
> > > > open()/lseek() pair won't get you back where you were, we 
> > > > don't deal with them.
> > > > 
> > > > init does non-checkpointable things.  If the flag is a one-way 
> > > > trip, we'll never be able to checkpoint because we'll always 
> > > > inherit init's ! checkpointable flag.
> > > > 
> > > > To fix this, we could start working on making sure we can 
> > > > checkpoint init, but that's practically worthless.
> > > 
> > > i mean, it should be per process (per app) one-way flag of 
> > > course. If the app does something unsupported, it gets 
> > > non-checkpointable and that's it.
> > 
> > OK, we can definitely do that.  Do you think it is OK to run through a
> > set of checks at exec() time to check if the app currently has any
> > unsupported things going on?  If we don't directly inherit the parent's
> > status, then we need to have *some* time when we check it.
> 
> Uncheckpointable is not one-way.
> 
> Imagine remap_file_pages(2) is unsupported. Now app uses 
> remap_file_pages(2), then unmaps interesting VMA. Now app is 
> checkpointable again.

But that's precisely the kind of over-design that defeats the 
common purpose: which would be to make everything 
checkpointable. (including weirdo APIs like fremap())

Nothing motivates more than app designers complaining about the 
one-way flag.

Furthermore, it's _far_ easier to make a one-way flag SMP-safe. 
We just set it and that's it. When we unset it, what do we about 
SMP races with other threads in the same MM installing another 
non-linear vma, etc.

> As for overloading LSM, I think, it would be horrible. Most 
> hooks are useless, there are config options expanding LSM 
> hooks, and CPT and LSM are just totally orthogonal.

Sure it would have to be adopted to the needs of CPT, but i can 
tell you one thing for sure: there's only one thing that is 
worse than every syscall annotated with an LSM hook (which is 
the current status quo): every syscall annotated with an LSM 
hook _and_ a separate CPT hook.

It's just bad design. CPT might be orthogonal, but it wants to 
hook into syscalls at roughly the same places where LSM hooks 
into, which pretty much settles the question.

If there's places that need new hooks then we can add them not 
as CPT hooks, but as security hooks. That way there's synergy: 
both LSM and CPT advances, on the shoulders of each other.

> Instead, just (no offence) get big enough coverage -- run 
> modern and past distros, run servers packaged with them, and 
> if you can checkpoint all of this, you're mostly fine.

That's definitely a good advice, just it doesnt give the kind of 
minimal environment from where productization efforts can be 
seeded from.

	Ingo
