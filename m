Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXKGCk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXKGCk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXKGCks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:40:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410AbXKGCkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:40:47 -0500
Date: Tue, 6 Nov 2007 18:40:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/10] split anon and file LRUs
In-Reply-To: <20071106212305.6aa3a4fe@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711061834340.5424@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <Pine.LNX.4.64.0711061808460.5249@schroedinger.engr.sgi.com>
 <20071106212305.6aa3a4fe@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Rik van Riel wrote:

> Also, a factor 16 increase in page size is not going to help
> if memory sizes also increase by a factor 16, since we already 
> have trouble with today's memory sizes.

Note that a factor 16 increase usually goes hand in hand with
more processors. The synchronization of multiple processors becomes a 
concern. If you have an 8p and each of them tries to get the zone locks 
for reclaim then we are already in trouble. And given the immaturity
of the handling of cacheline contention in current commodity hardware this 
is likely to result in livelocks and/or starvation on some level.

> > I think that is the most urgent issue at hand. At least for us.
> 
> For some workloads this is the most urgent change, indeed.
> Since the patches for this already exist, integrating them
> is at the top of my list.  Expect this to be integrated into
> the split VM patch series by the end of this week.

Good to hear.
 
> > > - switch to SEQ replacement for the anon LRU lists, so the
> > >   worst case number of pages to scan is reduced greatly.
> > 
> > No idea what that is?
> 
> See http://linux-mm.org/PageReplacementDesign

A bit sparse but limiting the scanning if we cannot do much is certainly 
the right thing to do. The percentage of memory taken up by anonymous 
pages varies depending on the load. HPC applications may consume all of 
memory with anonymous pages. But there the pain is already so bad that 
many users go to huge pages already which bypasses the VM.

> > We do not have an accepted standard load. So how would we figure that one 
> > out?
> 
> The current worst case is where we need to scan all of memory, 
> just to find a few pages we can swap out.  With the effects of
> lock contention figured in, this can take hours on huge systems.

Right but I think this looks like a hopeless situation regardless of the 
algorithm if you have a couple of million pages and are trying to free 
one. Now image a series of processors going on the hunt for the few pages 
that can be reclaimed.
