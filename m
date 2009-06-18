Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZFRGBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZFRGBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZFRGBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:01:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37266 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbZFRGBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:01:06 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <1245295452.21602.42.camel@pasglop>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
	 <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
	 <1245101567.12400.38.camel@pasglop>
	 <alpine.DEB.1.10.0906161104480.26093@gentwo.org>
	 <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
	 <alpine.DEB.1.10.0906161522370.29941@gentwo.org>
	 <alpine.LFD.2.01.0906161231020.3282@localhost.localdomain>
	 <1245215916.5604.5.camel@penberg-laptop>
	 <alpine.LFD.2.01.0906170941490.16802@localhost.localdomain>
	 <1245290413.21602.40.camel@pasglop>  <1245295452.21602.42.camel@pasglop>
Date: Thu, 18 Jun 2009 09:01:03 +0300
Message-Id: <1245304863.12010.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, 2009-06-18 at 13:24 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-06-18 at 12:00 +1000, Benjamin Herrenschmidt wrote:
> > > So I'm very much ok with the whole "use magic gfp_mask to indicate what 
> > > works at what stage". And yes, I think it makes sense to extend it to the 
> > > page allocator and might_sleep too, because GFP_KERNEL has all the same 
> > > issues regardless of whether it's about page allocation or about slab 
> > > allocators. And any "might_sleep" suppression really does tend to be about 
> > > the exact same thing.
> > 
> > Argh... still broken.
> > 
> > In fact, my initial patch added it to the page allocator, which worked
> > for me. Pekka patch removed that and made it slab-only. So I'm blowing
> > up at boot in lockdep or so because I'm allocating page tables on
> > ppc32 with __get_free_pages() and GFP_KERNEL.
> > 
> > I'll cook up a patch.
> 
> Here it is:
> 
> mm: Extend gfp masking to the page allocator
> 
> The page allocator also needs the masking of gfp flags during boot,
> so this moves it out of slab/slub and uses it with the page allocator
> as well.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> This will also make it easier to use it for limiting allocations that
> can block during suspend/resume, though doing this really fool-proof
> will require some kind of synchronization in set_gfp_allowed_mask()
> vs. allocations that have already started sleeping waiting for IOs.
> 
> Index: linux-work/include/linux/gfp.h
> ===================================================================
> --- linux-work.orig/include/linux/gfp.h	2009-06-18 12:03:14.000000000 +1000
> +++ linux-work/include/linux/gfp.h	2009-06-18 12:08:21.000000000 +1000
> @@ -99,7 +99,7 @@ struct vm_area_struct;
>  			__GFP_NORETRY|__GFP_NOMEMALLOC)
>  
>  /* Control slab gfp mask during early boot */
> -#define SLAB_GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
> +#define GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
>  
>  /* Control allocation constraints */
>  #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
> @@ -348,4 +348,11 @@ static inline void oom_killer_enable(voi
>  	oom_killer_disabled = false;
>  }
>  
> +extern gfp_t gfp_allowed_mask;
> +
> +static inline void set_gfp_allowed_mask(gfp_t mask)
> +{
> +	gfp_allowed_mask = mask;
> +}

The only thing I don't like about this patch is that the caller gets to
decide which bits should be masked. I really think this should be a
mm_late_init() function that sets the mask _internally_ in the page
allocator.

But anyway, I am about to go completely off-line until Sunday or so
consider the approach:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka

