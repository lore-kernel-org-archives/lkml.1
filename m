Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbXLTU5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbXLTU5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXLTU4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:56:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbXLTU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:56:52 -0500
Date: Thu, 20 Dec 2007 15:56:27 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Message-ID: <20071220155627.6872b0e6@bree.surriel.com>
In-Reply-To: <1198080267.5333.22.camel@localhost>
References: <20071218211539.250334036@redhat.com>
	<20071218211550.186819416@redhat.com>
	<200712191156.48507.nickpiggin@yahoo.com.au>
	<20071219084534.4fee8718@bree.surriel.com>
	<1198080267.5333.22.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 11:04:26 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> On Wed, 2007-12-19 at 08:45 -0500, Rik van Riel wrote:
> > On Wed, 19 Dec 2007 11:56:48 +1100
> > Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > Hmm, I still don't know (or forgot) why you don't just use the
> > > old scheme of having an mlock count in the LRU bit, and removing
> > > the mlocked page from the LRU completely.
> > 
> > How do we detect those pages reliably in the lumpy reclaim code?
> 
> I wanted to try to treat nonreclaimable pages, whatever the reason,
> uniformly.  Lumpy reclaim wasn't there when I started on this, but we've
> been able to handle them.  I was more interested in page migration.  The
> act of isolating the page from the LRU [under zone lru_lock] arbitrates
> between racing tasks attempting to migrate the same page.  That and we
> keep the isolated pages on a list using the LRU links.  We can't migrate
> pages that we can't successfully isolate from the LRU list.

Good point.

Lets keep the nonreclaimable pages on a list, so we can keep
the migration code (and other code) consistent.

We can deal with lazily moving pages back to the nonreclaim
list if we find that, after one munlock, there are other
mlocking users of that page.

> I also agree they don't need to be scanned.  And, altho' having them on
> an LRU list has other uses, I suppose that having mlocked pages on the
> noreclaim list could be considered "clutter" if we did want to scan the
> noreclaim list for other types of non-reclaimable pages that might have
> become reclaimable.  

If we ever want to do that, we can always introduce separate
lists for those pages.
