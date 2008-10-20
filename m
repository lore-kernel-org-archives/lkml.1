Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbYJTKKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbYJTKKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYJTKKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:10:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYJTKKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:10:40 -0400
Date: Mon, 20 Oct 2008 12:10:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081020101011.GA30037@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019175320.GA6442@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> very nice!
> 
> I think we need a somewhat different abstraction though.
> 
> Firstly, regarding drivers/gpu/drm/i915/io_reserve.h, that needs to 
> move to generic code.
> 
> Secondly, wouldnt the right abstraction be to attach this 
> functionality to 'struct resource' ? [or at least create a second 
> struct that embedds struct resource]
> 
> this abstraction is definitely not a PCI thing and not a 
> detached-from-everything thing, it's an IO resource thing. We could 
> make it a property of struct resource:
> 
> struct resource {
>         resource_size_t start;
>         resource_size_t end;
>         const char *name;
>         unsigned long flags;
>         struct resource *parent, *sibling, *child;
> +       void *mapping;
> };
> 
> The APIs would be:
> 
>   int   io_resource_init_mapping(struct resource *res);
>  void   io_resource_free_mapping(struct resource *res);
>  void * io_resource_map(struct resource *res, pfn_t pfn, unsigned long offset);
>  void   io_resource_unmap(struct resource *res, void *kaddr);
> 
> Note how simple and consistent it all gets: IO resources already know 
> their physical location and their size limits. Being able to cache an 
> ioremap in a mapping [and being able to use atomic kmaps on 32-bit] is 
> a relatively simple and natural extension to the concept.
> 
> i think that would be quite acceptable - and the APIs could just 
> transparently work on it. This would also allow the PCI code to 
> automatically unmap any cached mappings from resources, when the 
> driver deinitializes.
> 
> Linus, Jesse, what do you think?

the downsize would be that we'd attach a runtime property to the 
IORESOURCE_MEM resource tree - which is a fairly static thing right now, 
after the point where we finalize the resource tree. (modulo 
device/bridge hotplug variances)

Another downside is that we might not want to map the whole thing. I.e. 
the structure of the IO memory space we want to map by drivers might be 
different from how it looks like in the resource tree.

the concept of introducing resource->mapping does not feel _that_ wrong 
though and has a couple of upsides: it could act as a natural mapping 
type serializer for example and drivers wouldnt have to explicitly 
manage ioremap results - they could just use the resource descriptor 
directly and "read" and "write" to/from it. readl/writel could be 
extended to operate on the resource descriptor transparently, getting 
rid of a source of resource mismatches and overmapping, etc. etc. We 
could even safety check IO space accesses this way.

and we'd get rid of the complication that your APIs introduced, the need 
to introduce a separate io_mapping type, etc.

Dunno, i might be missing some obvious downside why this wasnt done like 
that until now.

	Ingo
