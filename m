Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZJUVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZJUVUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZJUVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:20:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:32999 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZJUVUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iMOoKE6Ynp030RLDloQK5W9Fo5MoAIPdMI8VYVllcXTgW9TY9uq2tPfbM3lIhmeSFc
         opF9ozgW78S1HvASPV7RkIttb4WLaYEXSUO6Ts7Th0g1HpyAPkFK43Pmt18UALQjeBSG
         2HUt8ieGvXc68FnS95ZjK6XvXaqJ4DGMJgCpw=
Date: Wed, 21 Oct 2009 23:20:34 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: [PATCH] SLUB: Don't drop __GFP_NOFAIL completely from
	allocate_slab() (was: Re: [Bug #14265] ifconfig: page allocation
	failure. order:5,ode:0x8020 w/ e100)
Message-ID: <20091021212034.GB2987@bizet.domek.prywatny>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.rP.2MTxKB@chimera> <20091021200442.GA2987@bizet.domek.prywatny> <alpine.DEB.2.00.0910211400140.20010@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910211400140.20010@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 02:06:41PM -0700, David Rientjes wrote:
> On Wed, 21 Oct 2009, Karol Lewandowski wrote:
> 
> > commit d6849591e042bceb66f1b4513a1df6740d2ad762
> > Author: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> > Date:   Wed Oct 21 21:01:20 2009 +0200
> > 
> >     SLUB: Don't drop __GFP_NOFAIL completely from allocate_slab()
> >     
> >     Commit ba52270d18fb17ce2cf176b35419dab1e43fe4a3 unconditionally
> >     cleared __GFP_NOFAIL flag on all allocations.
> >     
> 
> No, it clears __GFP_NOFAIL from the first allocation of oo_order(s->oo).  
> If that fails (and it's easy to fail, it has __GFP_NORETRY), another 
> allocation is attempted with oo_order(s->min), for which __GFP_NOFAIL 
> would be preserved if that's the slab cache's allocflags.

Right, patch is junk.

However, I haven't been able to trigger failures since I've switched
to SLAB allocator.  That patch seemed related (and wrong), but it
wasn't.

> >  		 */
> > -		page = alloc_slab_page(flags, node, oo);
> > +		page = alloc_slab_page(flags | nofail, node, oo);
> >  		if (!page)
> >  			return NULL;
> >  
> > 
> 
> This does nothing.  You may have missed that the lower order allocation is 
> passing 'flags' (which is a union of the gfp flags passed to 
> allocate_slab() based on the allocation context and the cache's 
> allocflags), and not alloc_gfp where __GFP_NOFAIL is masked.

Right, I missed that.

> Nack.
> 
> Note: slub isn't going to be a culprit in order 5 allocation failures 
> since they have kmalloc passthrough to the page allocator.

However, it might change fragmentation somewhat I guess.  This might
make problem more/less visible.
