Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZEMWft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZEMWft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZEMWfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:35:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZEMWfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:35:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yDjw2q91mYmcV9oM6pIm/aAVvCBlyhkbJu6linvFa2FA2D7WhaKCAi1X3+Kj1XPSH
	w34r5cN0bql4fif9Xc9rQ==
Date: Wed, 13 May 2009 15:35:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] mm, PM/Freezer: Disable OOM killer when tasks are
 frozen
In-Reply-To: <200905131037.50011.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905131534530.25680@chino.kir.corp.google.com>
References: <200905070040.08561.rjw@sisk.pl> <200905101548.57557.rjw@sisk.pl> <200905131032.53624.rjw@sisk.pl> <200905131037.50011.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Rafael J. Wysocki wrote:

> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -175,6 +175,8 @@ static void set_pageblock_migratetype(st
>  					PB_migrate, PB_migrate_end);
>  }
>  
> +bool oom_killer_disabled __read_mostly;
> +
>  #ifdef CONFIG_DEBUG_VM
>  static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
>  {
> @@ -1600,6 +1602,9 @@ nofail_alloc:
>  		if (page)
>  			goto got_pg;
>  	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> +		if (oom_killer_disabled)
> +			goto nopage;
> +
>  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
>  			schedule_timeout_uninterruptible(1);
>  			goto restart;

This allows __GFP_NOFAIL allocations to fail.
