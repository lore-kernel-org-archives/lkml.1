Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbXHFTos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbXHFTos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762788AbXHFToe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:44:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762708AbXHFTod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:44:33 -0400
Date: Mon, 6 Aug 2007 12:44:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, pj@sgi.com, Lee.Schermerhorn@hp.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
Message-Id: <20070806124408.16034ab8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708021343420.10244@schroedinger.engr.sgi.com>
References: <20070802172118.GD23133@skynet.ie>
	<Pine.LNX.4.64.0708021343420.10244@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 13:45:23 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 2 Aug 2007, Mel Gorman wrote:
> 
> > +#ifdef CONFIG_NUMA
> > +/*
> > + * Only custom zonelists like MPOL_BIND need to be filtered as part of
> > + * policies. As described in the comment for struct zonelist_cache, these
> > + * zonelists will not have a zlcache so zlcache_ptr will not be set. Use
> > + * that to determine if the zonelists needs to be filtered or not.
> > + */
> > +static inline int alloc_should_filter_zonelist(struct zonelist *zonelist)
> > +{
> > +	return !zonelist->zlcache_ptr;
> > +}
> 
> I guess Paul needs to have a look at this one.

Which Paul?

> Otherwise
> 
> Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> > @@ -1166,6 +1167,18 @@ zonelist_scan:
> >  	z = zonelist->zones;
> >  
> >  	do {
> > +		/*
> > +		 * In NUMA, this could be a policy zonelist which contains
> > +		 * zones that may not be allowed by the current gfp_mask.
> > +		 * Check the zone is allowed by the current flags
> > +		 */
> > +		if (unlikely(alloc_should_filter_zonelist(zonelist))) {
> > +			if (highest_zoneidx == -1)
> > +				highest_zoneidx = gfp_zone(gfp_mask);
> > +			if (zone_idx(*z) > highest_zoneidx)
> > +				continue;
> > +		}
> > +
> >  		if (NUMA_BUILD && zlc_active &&
> 
> Hotpath. Sigh.
