Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYBEGLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYBEGLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYBEGL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:11:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36379 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751496AbYBEGLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:11:25 -0500
Date: Mon, 4 Feb 2008 22:11:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
In-Reply-To: <20080205052525.GD7441@v2.random>
Message-ID: <Pine.LNX.4.64.0802042206200.6739@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131171806.GN7185@v2.random>
 <Pine.LNX.4.64.0801311207540.25477@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0801311508080.23624@schroedinger.engr.sgi.com>
 <20080131234101.GS7185@v2.random> <Pine.LNX.4.64.0801311738570.24297@schroedinger.engr.sgi.com>
 <20080201120955.GX7185@v2.random> <Pine.LNX.4.64.0802011118060.18163@schroedinger.engr.sgi.com>
 <20080203021704.GC7185@v2.random> <Pine.LNX.4.64.0802041106370.9656@schroedinger.engr.sgi.com>
 <20080205052525.GD7441@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Andrea Arcangeli wrote:

> On Mon, Feb 04, 2008 at 11:09:01AM -0800, Christoph Lameter wrote:
> > On Sun, 3 Feb 2008, Andrea Arcangeli wrote:
> > 
> > > > Right but that pin requires taking a refcount which we cannot do.
> > > 
> > > GRU can use my patch without the pin. XPMEM obviously can't use my
> > > patch as my invalidate_page[s] are under the PT lock (a feature to fit
> > > GRU/KVM in the simplest way), this is why an incremental patch adding
> > > invalidate_range_start/end would be required to support XPMEM too.
> > 
> > Doesnt the kernel in some situations release the page before releasing the 
> > pte lock? Then there will be an external pte pointing to a page that may 
> > now have a different use. Its really bad if that pte does allow writes.
> 
> Sure the kernel does that most of the time, which is for example why I
> had to use invalidate_page instead of invalidate_pages inside
> zap_pte_range. Zero problems with that (this is also the exact reason
> why I mentioned the tlb flushing code would need changes to convert
> some page in pages).

Zero problems only if you find having a single callout for every page 
acceptable. So the invalidate_range in your patch is only working 
sometimes. And even if it works then it has to be used on 2M range. Seems 
to be a bit fragile and needlessly complex.

"conversion of some page in pages"? A proposal to defer the freeing of the 
pages until after the pte_unlock?

