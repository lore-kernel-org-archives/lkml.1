Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZFIMLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZFIMLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZFIMK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:10:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbZFIMK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:10:59 -0400
Date: Tue, 9 Jun 2009 14:10:55 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Message-ID: <20090609121055.GA9158@wotan.suse.de>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609111719.GA4463@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 01:17:19PM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Thu, Jun 04, 2009 at 08:02:14AM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 4 Jun 2009, Rusty Russell wrote:
> > > > >
> > > > > Turn off HIGHMEM64G, please (and HIGHMEM4G too, for that matter - you
> > > > > can't compare it to a no-highmem case).
> > > > 
> > > > Thanks, your point is demonstrated below.  I don't think HIGHMEM4G is 
> > > > unreasonable for a distro tho, so I turned that on instead.
> > > 
> > > Well, I agree that HIGHMEM4G is a _reasonable_ thing to turn on.
> > > 
> > > The thing I disagree with is that it's at all valid to then compare to 
> > > some all-software feature thing. HIGHMEM doesn't expand any esoteric 
> > > capability that some people might use - it's about regular RAM for regular 
> > > users.
> > > 
> > > And don't get me wrong - I don't like HIGHMEM. I detest the damn thing. I 
> > > hated having to merge it, and I still hate it. It's a stupid, ugly, and 
> > > very invasive config option. It's just that it's there to support a 
> > > stupid, ugly and very annoying fundamental hardware problem.
> > 
> > I was looking forward to be able to get rid of it... unfortunately 
> > other 32-bit architectures are starting to use it again :(
> > 
> > I guess it is not incredibly intrusive for generic mm code. A bit 
> > of kmap sprinkled around which is actually quite a useful 
> > delimiter of where pagecache is addressed via its kernel mapping.
> > 
> > Do you hate more the x86 code? Maybe that can be removed?
> 
> IMHO what hurts most about highmem isnt even its direct source code 
> overhead, but three factors:
> 
>  - The buddy allocator allocates top down, with highmem pages first.
>    So a lot of critical apps (the first ones started) will have 
>    highmem footprint, and that shows up every time they use it for 
>    file IO or other ops. kmap() overhead and more.

Yeah this really sucks about it. OTOH, we have basically the same
thing today with NUMA allocations and task placement.
 

>  - Highmem is not really a 'solvable' problem in terms of good VM 
>    balancing. It gives conflicting constraints and there's no single 
>    'good VM' that can really work - just a handful of bad solutions 
>    that differ in their level and area of suckiness.

But we have other zones too. And you also run into similar (and
in some senses harder) choices with NUMA as well.

 
>  - The kmap() cache itself can be depleted,

Yeah, the rule is not allowed to do 2 nested ones.


> and using atomic kmaps 
>    is fragile and error-prone. I think we still have a FIXME of a 
>    possibly triggerable deadlock somewhere in the core MM code ...

Not that I know of. I fixed the last long standing known one
with the write_begin/write_end changes a year or two ago. It
wasn't exactly related to kmap of the pagecache (but page fault
of the user address in copy_from_user).


> OTOH, highmem is clearly a useful hardware enablement feature with a 
> slowly receding upside and a constant downside. The outcome is 
> clear: when a critical threshold is reached distros will stop 
> enabling it. (or more likely, there will be pure 64-bit x86 distros)

Well now lots of embedded type archs are enabling it... So the
upside is slowly increasing again I think.


> Highmem simply enables a sucky piece of hardware so the code itself 
> has an intrinsic level of suckage, so to speak. There's not much to 
> be done about it but it's not a _big_ problem either: this type of 
> hw is moving fast out of the distro attention span.

Yes but Linus really hated the code. I wonder whether it is
generic code or x86 specific. OTOH with x86 you'd probably
still have to support different page table formats, at least,
so you couldn't rip it all out.

