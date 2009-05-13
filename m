Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbZEMWsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbZEMWsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761695AbZEMWru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:47:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760213AbZEMWrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:47:49 -0400
Date: Wed, 13 May 2009 15:47:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, nigel@tuxonice.net,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm, PM/Freezer: Disable OOM killer when tasks are
 frozen
Message-Id: <20090513154726.0786a27d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905131534530.25680@chino.kir.corp.google.com>
References: <200905070040.08561.rjw@sisk.pl>
	<200905101548.57557.rjw@sisk.pl>
	<200905131032.53624.rjw@sisk.pl>
	<200905131037.50011.rjw@sisk.pl>
	<alpine.DEB.2.00.0905131534530.25680@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 15:35:32 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 13 May 2009, Rafael J. Wysocki wrote:
> 
> > Index: linux-2.6/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_alloc.c
> > +++ linux-2.6/mm/page_alloc.c
> > @@ -175,6 +175,8 @@ static void set_pageblock_migratetype(st
> >  					PB_migrate, PB_migrate_end);
> >  }
> >  
> > +bool oom_killer_disabled __read_mostly;
> > +
> >  #ifdef CONFIG_DEBUG_VM
> >  static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
> >  {
> > @@ -1600,6 +1602,9 @@ nofail_alloc:
> >  		if (page)
> >  			goto got_pg;
> >  	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> > +		if (oom_killer_disabled)
> > +			goto nopage;
> > +
> >  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
> >  			schedule_timeout_uninterruptible(1);
> >  			goto restart;
> 
> This allows __GFP_NOFAIL allocations to fail.

I think that's OK - oom_killer_disable() and __GFP_NOFAIL are
fundamentally incompatible, and __GFP_NOFAIL is a crock.

