Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYDHVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYDHVl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYDHVlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:41:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57992 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYDHVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:41:06 -0400
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47FBDF9E.90102@cs.helsinki.fi>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
	 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0804072000410.18591@blonde.site>
	 <1207598115.29991.23.camel@lappy>
	 <Pine.LNX.4.64.0804072121320.28744@blonde.site>
	 <47FA8B5A.5090104@cs.helsinki.fi> <47FA8CB0.6070106@cs.helsinki.fi>
	 <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org>
	 <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi>
	 <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0804082340120.11104@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0804081344280.30874@schroedinger.engr.sgi.com>
	 <47FBDF9E.90102@cs.helsinki.fi>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 23:40:07 +0200
Message-Id: <1207690807.29991.50.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 00:11 +0300, Pekka Enberg wrote:
> Christoph Lameter wrote:
> > Hmmmm... Peter has the most experience with these issues. Maybe the best 
> > would be to have this sort of logic in a more general way in the page 
> > allocator? Similar issues surely exist with the page allocator and a fix 
> > there would fix it for all users.
> 
> This needs some support in the slab allocator anyway. Keep in mind that 
> the patch is specifically addressing writeback in OOM conditions so we 
> must (1) prioritize GFP_TEMPORARY allocations over everyone else (which 
> just get NULL) and (2) use the remaining available memory as efficiently 
> as possible for _all_ GFP_TEMPORARY allocations.
> 
> Peter is, however, bringing up a good point that my patch doesn't 
> actually _guarantee_ anything so I'm still wondering if this approach 
> makes any sense... But I sure do like Linus' ideas of marking 
> short-lived allocations and trying harder for them in OOM.

Also, this scheme so far does not provide for a means to detect the end
of pressure situation.

I need both triggers, enter pressure and exit pressure. Enter pressure
is easy enough, that's when normal allocations start failing. Exit
pressure however is more difficult - that is basically when allocations
start succeeding again. You'll see that my patches basically always
attempt a regular allocation as long as we're in the emergency state.

Also, the requirement for usage of emergency memory (GFP_MEMALLOC,
PF_MEMALLOC) is that it will be freed without external conditions. So
while it might be delayed for a while (it might sit in the fragment
assembly cache for a while) it doesn't need any external input to get
freed again:
  - it will either get reclaimed from this cache;
  - it will exit the cache as a full packet and:
    - get dropped, or
    - get processed.



