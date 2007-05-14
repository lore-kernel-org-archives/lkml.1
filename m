Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbXENWsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbXENWsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXENWr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:47:59 -0400
Received: from mail13.syd.optusnet.com.au ([211.29.132.194]:60200 "EHLO
	mail13.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbXENWr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:47:58 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: swap prefetch more improvements
Date: Tue, 15 May 2007 08:43:35 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ck@vds.kolivas.org
References: <200705141050.55038.kernel@kolivas.org> <20070514150032.d3ef6bb1.akpm@linux-foundation.org>
In-Reply-To: <20070514150032.d3ef6bb1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705150843.36721.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 08:00, Andrew Morton wrote:
> On Mon, 14 May 2007 10:50:54 +1000
>
> Con Kolivas <kernel@kolivas.org> wrote:
> > akpm, please queue on top of "mm: swap prefetch improvements"
> >
> > ---
> > Failed radix_tree_insert wasn't being handled leaving stale kmem.
> >
> > The list should be iterated over in the reverse order when prefetching.
> >
> > Make the yield within kprefetchd stronger through the use of
> > cond_resched.
>
> hm.
>
> > -		might_sleep();
> > -		if (!prefetch_suitable())
> > +		/* Yield to anything else running */
> > +		if (cond_resched() || !prefetch_suitable())
> >  			goto out_unlocked;
>
> So if cond_resched() happened to schedule away, we terminate this
> swap-tricking attempt.  It's not possible to determine the reasons for this
> from the code or from the changelog (==bad).
>
> How come?

Hmm I thought the line above that says "yield to anything else running" was 
explicit enough. The idea is kprefetchd shouldn't run if any other real 
activity is happening just about anywhere, and a positive cond_resched would 
indicate likely activity so we just put kprefetchd back to sleep.

-- 
-ck
