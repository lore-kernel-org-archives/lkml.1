Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYBHWGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYBHWGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYBHWGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:06:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbYBHWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:06:13 -0500
Date: Fri, 8 Feb 2008 14:04:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
In-Reply-To: <20080208135154.ccdac0c1.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
References: <1202417543.31361.5.camel@brick> <20080208135154.ccdac0c1.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Feb 2008, Andrew Morton wrote:
> >  #ifdef CONFIG_HIGHMEM
> > -	int zone_idx = zone - zone->zone_pgdat->node_zones;
> > -	return zone_idx == ZONE_HIGHMEM ||
> > -		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
> > +	const int highmem_off = ZONE_HIGHMEM * sizeof(*zone);
> > +	const int movable_off = ZONE_MOVABLE * sizeof(*zone);
> > +
> > +	int zone_off = (unsigned long)zone - (unsigned long)zone->zone_pgdat->node_zones;
> > +	return zone_off == highmem_off ||
> > +		(zone_off == movable_off && zone_movable_is_highmem());
> 
> hrm.  For my i386 build (and that's where CONFIG_HIGHMEM really matters)
> this patch makes mm/page_alloc.o six bytes larger, and I don't think the
> change did much for readability.

Heh, yeah. That's a very odd way to write it.

It would probably make more sense to just write it as something like

	struct zone *base = zone->zone_pgdat->node_zones;

	if (zone == base + ZONE_HIGHMEM ||
		(zone == base + ZONE_MOVABLE && zone_movable_is_highmem());

instead.

The above is totally untested, of course.

		Linus
