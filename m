Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbXHFUT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbXHFUT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764427AbXHFUT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:19:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59855 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764200AbXHFUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:19:27 -0400
Date: Mon, 6 Aug 2007 13:19:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Daniel Phillips <phillips@phunq.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <20070806201257.GG11115@waste.org>
Message-ID: <Pine.LNX.4.64.0708061315510.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <200708061121.50351.phillips@phunq.net>
 <Pine.LNX.4.64.0708061141511.3152@schroedinger.engr.sgi.com>
 <200708061148.43870.phillips@phunq.net> <Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
 <20070806201257.GG11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Matt Mackall wrote:

> > > Because a block device may have deadlocked here, leaving the system 
> > > unable to clean dirty memory, or unable to load executables over the 
> > > network for example.
> > 
> > So this is a locking problem that has not been taken care of?
> 
> No.
> 
> It's very simple:
> 
> 1) memory becomes full

We do have limits to avoid memory getting too full.

> 2) we try to free memory by paging or swapping
> 3) I/O requires a memory allocation which fails because memory is full
> 4) box dies because it's unable to dig itself out of OOM
> 
> Most I/O paths can deal with this by having a mempool for their I/O
> needs. For network I/O, this turns out to be prohibitively hard due to
> the complexity of the stack.

The common solution is to have a reserve (min_free_kbytes). The problem 
with the network stack seems to be that the amount of reserve needed 
cannot be predicted accurately.

The solution may be as simple as configuring the reserves right and 
avoid the unbounded memory allocations. That is possible if one 
would make sure that the network layer triggers reclaim once in a 
while.
