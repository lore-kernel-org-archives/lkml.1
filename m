Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXCFWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXCFWTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030348AbXCFWTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:19:20 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:33466 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030302AbXCFWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:19:19 -0500
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-reply-to: <1173218843.4718.38.camel@lappy> (message from Peter Zijlstra on
	Tue, 06 Mar 2007 23:07:23 +0100)
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu> <1173213151.4718.16.camel@lappy>
	 <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu> <1173217621.4718.27.camel@lappy> <1173218843.4718.38.camel@lappy>
Message-Id: <E1HOhzG-0006bd-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Mar 2007 23:18:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > None what so ever, but I always think of msync as a rare function
> > (infrequent when compared to (minor) faults overall). But I don't have
> > numbers backing that up either.
> > 
> > Also, the radix tree scan you do isn't exactly cheap either. 
> > 
> > So what I was wondering is whether its worth optimizing this at the cost
> > of another rmap walker. (one with very dubious semantics at that - it
> > clears the pte dirty bit but doesn't particularly care about that nor
> > does it respect the PG_dirty / PTE dirty relation)
> 
> What this functionality requires is that MS_ASYNC is a full barrier wrt.
> dirtyness. That is, we want to call set_page_dirty_mappig() as soon as
> we touch a page in a dirtying fashion after MS_{,A}SYNC gets called.
> 
> Hence we need the full page_mkclean() functionality, otherwise we don't
> set AS_CMTIME again in time.

AS_CMTIME is only for the case, when the "file modified since the last
msync" info is lost from the ptes, e.g. because of page reclaim.

So it doesn't matter if AS_CMTIME is not set, is_page_modified() will
provide the necessary barrier.

Thanks,
Miklos
