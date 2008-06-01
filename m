Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYFAIZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYFAIZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYFAIZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:25:03 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:27117 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751881AbYFAIZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:25:00 -0400
Date: Sun, 1 Jun 2008 17:22:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080601082249.GB25429@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	akpm@linux-foundation.org, mpm@selenic.com
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI> <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com> <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com> <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi> <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484256AA.3000709@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 10:58:34AM +0300, Pekka Enberg wrote:
> Paul Mundt wrote:
> >Not until the page->index bits are killed, otherwise you aren't fixing
> >anything. SLOB on nommu with those page->index tests will automatically
> >oops today, before or after your patches. Until that's resolved, there's
> >no point in pretending like kobjsize() has been "fixed". As no one has
> >come up with a valid reason for those tests existing in the first place,
> >simply having your patches and killing the BUG_ON()'s seems ok.
> 
> Sorry if I'm starting to sound like a broken record, but can you explain 
> why removing the ->index bits are safe? I mean, if removing them is 
> really okay, that means we don't hit that code path with SLAB at all?
> 
I thought I already had several times, but I'll attempt to summarize again..

I would expect the only reason those BUG_ON()'s haven't been triggered in
the non-SLOB case is due to the fact PageSlab() takes a different path
out.

The page->index bits look like they are being used for determining
compound order, which is _completely_ bogus, and only happens to "work"
in a few cases. Christoph and I have repeatedly asked for someone to
explain what the hell those tests are there for, as right now they not
only look completely bogus, but they also stop us from booting on SLOB.
So far no one has provided any input on why those page->index BUG_ON()'s
have any right to exist.

So while having 2 out of 3 SLAB allocators in a bootable state might seem
like progress, I'd rather see kobjsize() fixed correctly. Even my initial
patches worked for all 3.

If no one can speak up to defend those bits, they should be killed off
before 2.6.26. Whether this is done in combination with your patch or
Christoph's patch or whatever else doesn't matter.
