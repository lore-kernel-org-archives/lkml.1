Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYDGVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYDGVRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYDGVR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:17:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbYDGVR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:17:26 -0400
Date: Mon, 7 Apr 2008 14:15:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Hugh Dickins <hugh@veritas.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <47FA8CB0.6070106@cs.helsinki.fi>
Message-ID: <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>  <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>  <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy> <Pine.LNX.4.64.0804072121320.28744@blonde.site>
 <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Apr 2008, Pekka Enberg wrote:
> 
> I wonder if we can get away with a SLAB_IO flag that you can use to annotate
> caches that participate in writeout and the allocator could keep some spare
> pages around that can be handed out for them in case of OOM...

Actually, I don't think this is SLAB-specific, since there are potentially 
the same issues for pages.

I suspect the right thing to do is not to mark them for "IO", but mark 
them for "short-lived", and allow short-lived allocations that don't have 
extended lifetimes to succeed even when a "real" allocation wouldn't.

When we are under memory pressure, a normal allocation generally needs to 
clear up enough memory from elsewhere to succeed. But a short-lived 
allocation without any long-term lifetimes would be known to release its 
memory back to the pool, so it can be allowed to go ahead when a normal 
memory allocation would not.

Examples of short-lived allocations:
 - IO requests
 - temporary network packets that don't get queued up (eg "ACK" packet) as 
   opposed to those that do get queued (incoming _or_ outgoing queues)
 - things like the temporary buffers for "getname()/putname()" etc.

That said, even a lot of temporary allocations can at times have issues. 
If your IO layer is dead, your IO request queues that _should_ have been 
very temporary may end up staying around for a long time. But I do think 
that it makes sense to prioritize allocations that are known to be short- 
lived.

(It might also allows us to allocate them from different pools and just 
generally have other heuristics for cache behaviour - short-lived 
allocations simply have different behaviour)

			Linus
