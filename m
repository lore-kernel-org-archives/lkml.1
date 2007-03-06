Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXCFW3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXCFW3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXCFW3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:29:47 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15036 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932408AbXCFW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:29:46 -0500
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-Reply-To: <E1HOhzG-0006bd-00@dorka.pomaz.szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu> <1173213151.4718.16.camel@lappy>
	 <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu> <1173217621.4718.27.camel@lappy>
	 <1173218843.4718.38.camel@lappy> <E1HOhzG-0006bd-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:28:21 +0100
Message-Id: <1173220101.6374.118.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 23:18 +0100, Miklos Szeredi wrote:
> > > None what so ever, but I always think of msync as a rare function
> > > (infrequent when compared to (minor) faults overall). But I don't have
> > > numbers backing that up either.
> > > 
> > > Also, the radix tree scan you do isn't exactly cheap either. 
> > > 
> > > So what I was wondering is whether its worth optimizing this at the cost
> > > of another rmap walker. (one with very dubious semantics at that - it
> > > clears the pte dirty bit but doesn't particularly care about that nor
> > > does it respect the PG_dirty / PTE dirty relation)
> > 
> > What this functionality requires is that MS_ASYNC is a full barrier wrt.
> > dirtyness. That is, we want to call set_page_dirty_mappig() as soon as
> > we touch a page in a dirtying fashion after MS_{,A}SYNC gets called.
> > 
> > Hence we need the full page_mkclean() functionality, otherwise we don't
> > set AS_CMTIME again in time.
> 
> AS_CMTIME is only for the case, when the "file modified since the last
> msync" info is lost from the ptes, e.g. because of page reclaim.
> 
> So it doesn't matter if AS_CMTIME is not set, is_page_modified() will
> provide the necessary barrier.

The trouble is, we went from a pull to a push model, and now you're
adding pull code again.

We have PG_dirty correct at all times, I think its no less reasonable to
have AS_CMTIME correct in the same fashion.

