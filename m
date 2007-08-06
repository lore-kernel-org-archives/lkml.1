Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbXHFU2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbXHFU2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759214AbXHFU2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:28:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761551AbXHFU2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:28:40 -0400
Date: Mon, 6 Aug 2007 13:27:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Daniel Phillips <phillips@phunq.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Message-Id: <20070806132747.4b9cea80.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708061315510.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	<200708061121.50351.phillips@phunq.net>
	<Pine.LNX.4.64.0708061141511.3152@schroedinger.engr.sgi.com>
	<200708061148.43870.phillips@phunq.net>
	<Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
	<20070806201257.GG11115@waste.org>
	<Pine.LNX.4.64.0708061315510.7603@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007 13:19:26 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 6 Aug 2007, Matt Mackall wrote:
> 
> > > > Because a block device may have deadlocked here, leaving the system 
> > > > unable to clean dirty memory, or unable to load executables over the 
> > > > network for example.
> > > 
> > > So this is a locking problem that has not been taken care of?
> > 
> > No.
> > 
> > It's very simple:
> > 
> > 1) memory becomes full
> 
> We do have limits to avoid memory getting too full.
> 
> > 2) we try to free memory by paging or swapping
> > 3) I/O requires a memory allocation which fails because memory is full
> > 4) box dies because it's unable to dig itself out of OOM
> > 
> > Most I/O paths can deal with this by having a mempool for their I/O
> > needs. For network I/O, this turns out to be prohibitively hard due to
> > the complexity of the stack.
> 
> The common solution is to have a reserve (min_free_kbytes). The problem 
> with the network stack seems to be that the amount of reserve needed 
> cannot be predicted accurately.
> 
> The solution may be as simple as configuring the reserves right and 
> avoid the unbounded memory allocations. That is possible if one 
> would make sure that the network layer triggers reclaim once in a 
> while.

Such a simple fix would be attractive.  Some of the net drivers now have
remarkably large rx and tx queues.  One wonders if this is playing a part
in the problem and whether reducing the queue sizes would help.

I guess we'd need to reduce the queue size on all NICs in the machine
though, which might be somewhat of a performance problem.

I don't think we've seen a lot of justification for those large queues. 
I'm suspecting it's a few percent in carefully-chosen workloads (of the
microbenchmark kind?)

