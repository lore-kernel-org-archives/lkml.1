Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZFCW21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZFCW21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZFCW2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:28:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbZFCW2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:28:11 -0400
Date: Wed, 3 Jun 2009 15:26:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: npiggin@suse.de, a.p.zijlstra@chello.nl, riel@redhat.com, mel@csn.ul.ie,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Divy Le Ray <divy@chelsio.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090603152616.ec5ba9af.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0906031507400.16042@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>
	<20090601225602.3482cd0d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>
	<1243928095.23657.5633.camel@twins>
	<20090602075836.GB16201@wotan.suse.de>
	<alpine.DEB.2.00.0906020104480.27792@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0906031507400.16042@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009 15:10:38 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 2 Jun 2009, David Rientjes wrote:
> 
> > With my patch, we kill a memory hogging task that will free some memory so 
> > the allocation will succeed (or multiple tasks if insufficient contiguous 
> > memory is available).  Kernel allocations use __GFP_NOFAIL, so the fault 
> > of this memory freeing is entirely on the caller, not the page allocator.
> > 
> > My preference for handling this is to merge my patch (obviously :), and 
> > then hopefully deprecate __GFP_NOFAIL as much as possible although I don't 
> > suspect it could be eradicated forever.
> > 
> 
> I really hope this patch isn't getting dropped because it fixes the 
> possibility that a __GFP_NOFAIL allocation will fail when its definition 
> is to the contrary.  Depending on the size of the allocation, that can 
> cause a panic in at least the reiserfs, ntfs, cxgb3, and gfs2 cases.
> 
> As I mentioned before, it's a noble goal to deprecate __GFP_NOFAIL as much 
> as possible and (at the least) prevent it from trying high-order 
> allocation attempts.  The current implementation of the flag is 
> problematic, however, and this patch addresses it by attempting to free 
> some memory when direct reclaim fails.
> 

Sigh, all right, but we suck.

Divy, could we please at least remove __GFP_NOFAIL from
drivers/net/cxgb?  It's really quite inappropriate for a driver to
assume that core VM can do magic.  Drivers should test the return value
and handle the -ENOMEM in the old-fashioned way, please.

Ditto-in-spades cfq-iosched.c.  We discussed that recently but I forgot the
upshot.  The code and its comment are still in flagrant disagreement?

