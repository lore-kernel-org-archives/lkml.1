Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbZEHOkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbZEHOkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZEHOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:39:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38621 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZEHOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:39:50 -0400
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
 allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, rientjes@google.com, xemul@openvz.org
In-Reply-To: <4A04438E.6090304@redhat.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>
	 <20090504131638.GJ4173@lenovo>
	 <alpine.DEB.1.10.0905040940490.9553@qirst.com>
	 <20090504115335.9bc08587.akpm@linux-foundation.org>
	 <20090504192117.GB31176@lenovo>
	 <20090504123453.d130a6cf.akpm@linux-foundation.org>
	 <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081018130.23875@qirst.com>
	 <1241792580.28600.41.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081026210.21690@qirst.com>
	 <1241793281.28600.43.camel@penberg-laptop>  <4A04438E.6090304@redhat.com>
Date: Fri, 08 May 2009 17:39:49 +0300
Message-Id: <1241793589.28600.44.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Fri, 2009-05-08 at 10:37 -0400, Rik van Riel wrote:
> > @@ -1556,7 +1556,8 @@ nofail_alloc:
> >  				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
> >  			if (page)
> >  				goto got_pg;
> > -			if (gfp_mask & __GFP_NOFAIL) {
> > +			/* GFP_PANIC sets both flags */
> > +			if ((gfp_mask & __GFP_NOFAIL) && !(gfp_mask & __GFP_NORETRY)) {
> >  				congestion_wait(WRITE, HZ/50);
> 
> Do you mean ((gfp_mask & GFP_PANIC) == GFP_PANIC))  ?

No, we only want to loop if __GFP_NOFAIL is set but __GFP_NORETRY is not
set.

> 
> > @@ -1670,6 +1671,9 @@ nopage:
> >  		dump_stack();
> >  		show_mem();
> >  	}
> > +	if (unlikely(gfp_mask & GFP_PANIC))
> > +		panic("Out of memory: %s order: %d, gfp_mask:0x%x\n",
> > +			p->comm, order, gfp_mask);
> 
> Ditto here.

Yes, indeed. Fixed up. Thanks!

