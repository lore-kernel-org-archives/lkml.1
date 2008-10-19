Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYJSRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYJSRyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYJSRyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:54:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYJSRyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:54:07 -0400
Date: Sun, 19 Oct 2008 19:53:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: io resources and cached mappings (was: [git pull] drm patches for
	2.6.27-rc1)
Message-ID: <20081019175320.GA6442@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224398496.5303.7.camel@koto.keithp.com>
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


* Keith Packard <keithp@keithp.com> wrote:

> On Sat, 2008-10-18 at 21:14 -0700, Keith Packard wrote:
> > On Sun, 2008-10-19 at 00:32 +0200, Ingo Molnar wrote:
> > 
> > > Mind sending patches for this? :-)
> 
> Here's a patch for the i915 driver that includes the new API. Tested 
> on x86_32+HIGHMEM and x86_64. I stuck a new 'io_reserve.h' header in 
> the i915 directory for this patch, but it should go elsewhere.
> 
> The new APIs are:
> 
> io_reserve_create_wc
> io_reserve_free
> io_reserve_map_atomic_wc
> io_reserve_unmap_atomic
> io_reserve_map_wc
> io_reserve_unmap

very nice!

I think we need a somewhat different abstraction though.

Firstly, regarding drivers/gpu/drm/i915/io_reserve.h, that needs to move 
to generic code.

Secondly, wouldnt the right abstraction be to attach this functionality 
to 'struct resource' ? [or at least create a second struct that embedds 
struct resource]

this abstraction is definitely not a PCI thing and not a 
detached-from-everything thing, it's an IO resource thing. We could make 
it a property of struct resource:

struct resource {
        resource_size_t start;
        resource_size_t end;
        const char *name;
        unsigned long flags;
        struct resource *parent, *sibling, *child;
+       void *mapping;
};

The APIs would be:

  int   io_resource_init_mapping(struct resource *res);
 void   io_resource_free_mapping(struct resource *res);
 void * io_resource_map(struct resource *res, pfn_t pfn, unsigned long offset);
 void   io_resource_unmap(struct resource *res, void *kaddr);

Note how simple and consistent it all gets: IO resources already know 
their physical location and their size limits. Being able to cache an 
ioremap in a mapping [and being able to use atomic kmaps on 32-bit] is a 
relatively simple and natural extension to the concept.

i think that would be quite acceptable - and the APIs could just 
transparently work on it. This would also allow the PCI code to 
automatically unmap any cached mappings from resources, when the driver 
deinitializes.

Linus, Jesse, what do you think?

i think we need to finalize the API names and their abstraction level, 
and then could even merge those APIs into v2.6.28 on a fast path, to 
enable you to use it. It does not interact with anything else so it 
should be safe to do.

(i'd not suggest to merge the i915 bits just yet - but that's obviously 
not my call.)

	Ingo
