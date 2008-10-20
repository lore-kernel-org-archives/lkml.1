Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYJTL4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYJTL4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYJTL4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:56:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYJTL4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:56:01 -0400
Date: Mon, 20 Oct 2008 13:55:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Anholt <eric@anholt.net>
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081020115533.GB10594@elte.hu>
References: <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu> <1224443274.5526.39.camel@vonnegut.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224443274.5526.39.camel@vonnegut.anholt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Anholt <eric@anholt.net> wrote:

> > The APIs would be:
> > 
> >   int   io_resource_init_mapping(struct resource *res);
> >  void   io_resource_free_mapping(struct resource *res);
> >  void * io_resource_map(struct resource *res, pfn_t pfn, unsigned long offset);
> >  void   io_resource_unmap(struct resource *res, void *kaddr);
> > 
> > Note how simple and consistent it all gets: IO resources already 
> > know their physical location and their size limits. Being able to 
> > cache an ioremap in a mapping [and being able to use atomic kmaps on 
> > 32-bit] is a relatively simple and natural extension to the concept.
> > 
> > i think that would be quite acceptable - and the APIs could just 
> > transparently work on it. This would also allow the PCI code to 
> > automatically unmap any cached mappings from resources, when the 
> > driver deinitializes.
> > 
> > Linus, Jesse, what do you think?
> > 
> > i think we need to finalize the API names and their abstraction 
> > level, and then could even merge those APIs into v2.6.28 on a fast 
> > path, to enable you to use it. It does not interact with anything 
> > else so it should be safe to do.
> 
> This API needs the cacheability control, which I don't see in it 
> currently. [...]

yes, these two should do the trick:

 int   io_resource_init_mapping_wc(struct resource *res);
 int   io_resource_init_mapping_wb(struct resource *res);

> Second, we need to know when we're doing a mapping whether we're 
> affected by atomic scheduling restrictions.  Right now our plan has 
> been to try doing page-by-page 
> io_map_atomic_wc()/copy_from_user_inatomic()/io_unmap_atomic(), and if 
> we fail at that at some point (map returns NULL or we get a partial 
> completion from copy_from_user_inatomic) then fall back to io_map_wc() 
> and copy_from_user() the whole thing at once.  That gets us good 
> performance on both x86 with highmem and x86-64, and not too shabby 
> performance on x86 non-highmem.

that gets ugly very fast. I think we should not use atomic kmaps but 
NR_CPUS _fixmaps_ with a per CPU array of mutexes (this is basically 
atomic kmaps but without the preemption restrictions). We could 
take/drop the mutex and statistically you'll stay on the same CPU and 
wont ever contend on that lock in practice.

> Also, while it's rare, there have been graphics cards (looking at you, 
> S3) where BARs were expensive for some reason and they stuffed both 
> the framebuffer and registers into one PCI BAR, where you want the FB 
> to be WC and the registers to be UC.  Not sure if they would be 
> supportable with this API or not.  And if it's not, I'm not sure how 
> much we care to design for them, but it's something to potentially 
> consider.

yes, this is a weakness of this API - you cannot mix multiple 
cachability domains within the same BAR.

and that can happen on non-graphics as well: some storage controller 
that has regular control registers in one portion of the BAR, which all 
need to be consistently accessed via UC and properly POST-ed - while it 
could also have some large mailbox structure at the end of the BAR, 
which could be mapped both cacheable or perhaps WC.

So ... i guess we can go back to the io_mapping API proposed by Keith, 
but not make it atomic kmap based but fixmap + mutex based - for good 
32-bit performance. (and the fixmap would not be used on 64-bit at all)

> Finally, I'm confused by the pfn and offset args to io_resource_map, 
> when I expected something parallel to ioremap but with our resource 
> arg added.

ok.

	Ingo
