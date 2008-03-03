Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYCCM3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYCCM3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYCCM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:29:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:45087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYCCM27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:28:59 -0500
Date: Mon, 3 Mar 2008 13:28:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
Message-ID: <20080303122857.GA13138@wotan.suse.de>
References: <20080303093449.GA15091@wotan.suse.de> <84144f020803030144v17544936ybe222e8f4850dfa2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020803030144v17544936ybe222e8f4850dfa2@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 11:44:07AM +0200, Pekka Enberg wrote:
> Hi Nick,
> 
> On Mon, Mar 3, 2008 at 11:34 AM, Nick Piggin <npiggin@suse.de> wrote:
> >  SLUB should pack even small objects nicely into cachelines if that is what
> >  has been asked for. Use the same algorithm as SLAB for this.
> 
> The patches look good but this changelog is missing context. Why do we
> want to do this?

You're right, the changelog should be improved if/when it is merged.
Actually the context is discussed in another thread just now on lkml
if you are interested ("alloc_percpu() fails to allocate percpu data").

> 
> On Mon, Mar 3, 2008 at 11:34 AM, Nick Piggin <npiggin@suse.de> wrote:
> >  @@ -1896,12 +1896,15 @@ static unsigned long calculate_alignment
> >          * specified alignment though. If that is greater
> >          * then use it.
> >          */
> 
> You might want to fix the above comment too.

Yes.

> 
> >  -       if ((flags & SLAB_HWCACHE_ALIGN) &&
> >  -                       size > cache_line_size() / 2)
> >  -               return max_t(unsigned long, align, cache_line_size());
> >  +       if (flags & SLAB_HWCACHE_ALIGN) {
> >  +               unsigned long ralign = cache_line_size();
> >  +               while (size <= ralign / 2)
> >  +                       ralign /= 2;
> >  +               align = max(align, ralign);
> >  +       }
